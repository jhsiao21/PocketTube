//
//  UserService.swift
//  Threads
//
//  Created by Stephan Dowless on 7/17/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    var currentUser: User?
    
    static let shared = UserService()
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
    
    static func fetchUser(withUid uid: String) async throws -> User {
        if let nsData = userCache.object(forKey: uid as NSString) {
            if let user = try? JSONDecoder().decode(User.self, from: nsData as Data) {
                return user
            }
        }
        
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        
        if let userData = try? JSONEncoder().encode(user) {
            userCache.setObject(userData as NSData, forKey: uid as NSString)
        }
        
        return user
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
    
    static func fetchUsers() async throws -> [User] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await FirestoreConstants.UserCollection.getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        return users.filter({ $0.id != uid })
    }
}

// MARK: - Feed Updates

extension UserService {
    func updateUserFeedAfterFollow(followedUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let threadsSnapshot = try await FirestoreConstants.MediaCollection.whereField("ownerUid", isEqualTo: followedUid).getDocuments()
        
        for document in threadsSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(currentUid)
                .collection("user-feed")
                .document(document.documentID)
                .setData([:])
        }
    }
    
    func updateUserFeedAfterUnfollow(unfollowedUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let threadsSnapshot = try await FirestoreConstants.MediaCollection.whereField("ownerUid", isEqualTo: unfollowedUid).getDocuments()
        
        for document in threadsSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(currentUid)
                .collection("user-feed")
                .document(document.documentID)
                .delete()
        }
    }
}

// MARK: - Helpers 

extension UserService {
    private static func fetchUsers(_ snapshot: QuerySnapshot?) async throws -> [User] {
        var users = [User]()
        guard let documents = snapshot?.documents else { return [] }
        
        for doc in documents {
            let user = try await UserService.fetchUser(withUid: doc.documentID)
            users.append(user)
        }
        
        return users
    }
}


public enum ServiceErrors: Error {
    case failedToFetch
    case failedToGetDownloadUrl
    case failedToCreate
    case failedToLogin
    case encodingError
    
}
