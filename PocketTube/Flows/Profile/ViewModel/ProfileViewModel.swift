//
//  ProfileViewModel.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/9.
//

import FirebaseAuth

// For Sign in with Apple
import AuthenticationServices
import CryptoKit


class ProfileViewModel {
    static func deleteAccount() async -> Bool {
        print("Account")
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
//          errorMessage = ""
          return true
        }
        catch {
          print(error)
//          errorMessage = error.localizedDescription
          return false
        }
    }
}

extension Date {
  func isWithinPast(minutes: Int) -> Bool {
    let now = Date.now
    let timeAgo = Date.now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
    let range = timeAgo...now
    return range.contains(self)
  }
}
