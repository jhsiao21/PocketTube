//
//  AuthServicePromise.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/5.
//

import Firebase
import Alamofire
import SwiftyJSON
import PromiseKit
import FirebaseAuth

final class AuthServicePromise {
    
    static let shared = AuthServicePromise()
    
    /// login by email and password
    func login(email: String, password: String) -> Promise<Bool> {
        
        return Promise<Bool> { seal in
            Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
                if let error = error {
                    seal.reject(error)
                } else if let user = authDataResult?.user {
                    print(user)
                    seal.fulfill(true)
                } else {
                    seal.reject(error!)
                }
            }
        }
    }
}
