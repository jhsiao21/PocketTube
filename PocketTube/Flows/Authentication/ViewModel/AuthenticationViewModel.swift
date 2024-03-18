//
//  AuthenticationViewModel.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/13.
//

import Foundation
import FirebaseAuth

// For Sign in with Apple
import AuthenticationServices
import CryptoKit

class AuthenticationViewModel {
    
    private var errorMessage = ""
    
    func deleteAccount() async -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
      guard let lastSignInDate = user.metadata.lastSignInDate else { return false }
      let needsReauth = !lastSignInDate.isWithinPast(minutes: 5)

      let needsTokenRevocation = user.providerData.contains { $0.providerID == "apple.com" }

      do {
        if needsReauth || needsTokenRevocation {
          let signInWithApple = SignInWithApple()
          let appleIDCredential = try await signInWithApple()

          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetdch identify token.")
            return false
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
            return false
          }

          let nonce = randomNonceString()
          let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)

          if needsReauth {
            try await user.reauthenticate(with: credential)
          }
          if needsTokenRevocation {
            guard let authorizationCode = appleIDCredential.authorizationCode else { return false }
            guard let authCodeString = String(data: authorizationCode, encoding: .utf8) else { return false }

            try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
          }
        }

        try await user.delete()
        errorMessage = ""
        return true
      }
      catch {
        print(error)
        errorMessage = error.localizedDescription
        return false
      }
    }
}

class SignInWithApple: NSObject, ASAuthorizationControllerDelegate {

  private var continuation : CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?

  func callAsFunction() async throws -> ASAuthorizationAppleIDCredential {
    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.performRequests()
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
      continuation?.resume(returning: appleIDCredential)
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    continuation?.resume(throwing: error)
  }
}

func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: [Character] =
  Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}

private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()

  return hashString
}
