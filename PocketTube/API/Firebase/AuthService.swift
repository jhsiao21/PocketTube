//
//  AuthService.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/23.
//

import Firebase

class AuthService {
    
    var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
        
    private init() {
        self.userSession = Auth.auth().currentUser
        UserService.shared.fetchCurrentUser { result in
            switch result {
            case .success(let user):
                print("Current user: \(user)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// login by credential
    func login(credential: AuthCredential, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { authDataResult, error in
            guard let user = authDataResult?.user, error == nil else {
                completion(.failure(error!))
                return
            }
            
            print(user)
            completion(.success(true))            
        }
    }
    
    /// login by email and password
    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            guard let user = authDataResult?.user, error == nil else {
                completion(.failure(ServiceErrors.failedToLogin))
                return
            }
            
            print(user)
            completion(.success(true))
        }
    }
        
    /// create user data to firebase database
    func createUser(withEmail email: String, password: String, userName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                completion(.failure(ServiceErrors.failedToCreate))
                return
            }
            
            self.uploadUserData(email: email, userName: userName, id: user.uid) { result in
                switch result {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
        
    func uploadUserData(email: String, userName: String, id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let user = User(userName: userName, email: email, id: id)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {
            completion(.failure(ServiceErrors.encodingError))
            return
        }
        
        FirestoreConstants.UserCollection.document(id).setData(encodedUser) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func sendPasswordResetEmail(toEmail email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
