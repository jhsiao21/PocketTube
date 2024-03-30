//
//  UserService.swift
//  Threads
//
//  Created by Stephan Dowless on 7/17/23.
//

import Foundation
import Firebase

class UserService {
    
    var currentUser: User?
    
    static let shared = UserService()
    private init() { }
    private static let userCache = NSCache<NSString, NSData>()
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(ServiceErrors.failedToFetch))
                return
            }
            
            if let user = try? snapshot.data(as: User.self) {
                self.currentUser = user
                completion(.success(user))
            }
        }
    }
        
    static func fetchUser(withUid uid: String, completion: @escaping (User?, Error?) -> Void) {
        if let nsData = userCache.object(forKey: uid as NSString) {
            if let user = try? JSONDecoder().decode(User.self, from: nsData as Data) {
                completion(user, nil)
                return
            }
        }
        
        FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists, let userData = snapshot.data() else {
                completion(nil, NSError(domain: "Error snapshot does not exist", code: 404, userInfo: nil))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                if let userData = try? JSONEncoder().encode(user) {
                    userCache.setObject(userData as NSData, forKey: uid as NSString)
                }
                completion(user, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
    }
    
}

public enum ServiceErrors: Error {
    case failedToFetch
    case failedToGetDownloadUrl
    case failedToCreate
    case failedToLogin
    case encodingError
    
}
