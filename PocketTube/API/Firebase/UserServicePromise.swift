//
//  UserServicePromise.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/5.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Alamofire
import SwiftyJSON
import PromiseKit

class UserServicePromise {
    
    var currentUser: User?
    
    static let shared = UserServicePromise()
    private init() { }
    private static let userCache = NSCache<NSString, NSData>()
    
    func fetchCurrentUser() -> Promise<User> {
        
        return Promise<User> { seal in
            guard let uid = Auth.auth().currentUser?.uid else {
                seal.reject(ServiceErrors.notLoggedIn)
                return
            }
            
            FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    seal.reject(ServiceErrors.failedToFetch)
                    return
                }
                
                if let user = try? snapshot.data(as: User.self) {
                    self.currentUser = user
                    seal.fulfill(user)
                }
            }
        }
    }
}
