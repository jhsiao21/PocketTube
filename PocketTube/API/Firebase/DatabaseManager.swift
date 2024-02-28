//
//  DatabaseManager.swift
//  Messenger
//
//  Created by LoganMacMini on 2024/1/25.
//

import Foundation
import Firebase

/// Manage object to read and write data to real time firebase database
final class DatabaseManager {
    
    let timeoutInterval = 8.0
    
    /// Shared instance of class
    public static let shared = DatabaseManager()
    
    init() {}
    
    private let database = Database.database().reference()
}

extension DatabaseManager: DatabaseManagerProtocol {
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    func recordMedia(uid: String, media: FMedia, completion: @escaping (Result<FavoriteResponse, Error>) -> Void) {
        guard let mediaData = try? Firestore.Encoder().encode(media) else { return }
        
        //指定文檔ID
        let documentRef = FirestoreConstants.MediaCollection.document(media.mId)
       
        // 先檢查media是否已經存在，用caption, uid判斷
        self.mediaExists(with: media.caption, uid: uid) { result in
                    switch result {
                    case .success(let exist):
                        if exist {
                            print("media exists.")
                            completion(.success(.exists))
                        } else {
                            // 添加media數據
                            documentRef.setData(mediaData) { error in
                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    print("media uploaded")
                                    completion(.success(.added))
                                }
                            }
                        }
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                }
        
//        self.mediaExists(with: media.caption, uid: uid) { result in
//            switch result {
//            case .success(let exist):
//                if exist {
//                    print("media exists.")
//                } else {
//                    // 添加media數據
//                    documentRef.setData(mediaData) { error in
//                        if let error = error {
//                            completion(.failure(error))
//                        } else {
//                            FirestoreConstants.MediaCollection.document(documentRef.documentID).collection("media-likes").document(uid).setData([:]) { error in
//                                if let error = error {
//                                    completion(.failure(error))
//                                } else {
//                                    print("media uploaded")
//                                    completion(.success(true))
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let failure):
//                completion(.failure(failure))
//            }
//        }
    }
    
    /// 依據caption跟ownerUid判斷media是否存在
    func mediaExists(with caption: String, uid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let query = FirestoreConstants.MediaCollection
            .whereField("caption", isEqualTo: caption)
            .whereField("ownerUid", isEqualTo: uid)
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(ServiceErrors.failedToFetch))
            } else if let snapshot = snapshot, !snapshot.isEmpty {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }
    
    /// 依據mediaId刪除media
    func mediaDelete(mediaId mid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        FirestoreConstants.MediaCollection.document(mid).delete { error in
            if let error = error {
                print("\(mid) delete fail")
                completion(.failure(error))
            } else {
                print("\(mid) delete success")
                completion(.success(true))
            }
        }
    }
    
    /// 抓取特定uid的media
    func fetchMedias(uid: String, completion: @escaping (Result<[FMedia], Error>) -> Void) {
        let query = FirestoreConstants.MediaCollection
            .whereField("ownerUid", isEqualTo: uid)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let medias = snapshot.documents.compactMap { document -> FMedia? in
                    try? document.data(as: FMedia.self)
                }
                completion(.success(medias))
            }
        }
        
        //搜尋media文檔內media-likes內含有uid
//        FirestoreConstants.MediaCollection.getDocuments { snapshot, error in
//               if let error = error {
//                   completion(.failure(error))
//                   return
//               }
//
//               guard let documents = snapshot?.documents else {
//                   completion(.success([]))
//                   return
//               }
//
//               var medias: [FMedia] = []
//               
//               let group = DispatchGroup()
//               
//            for document in documents {
//                group.enter()
//                let mediaId = document.documentID
//                let likesCollection = document.reference.collection("media-likes")
//                likesCollection.document(uid).getDocument { (doc, error) in
//                    if let doc = doc, doc.exists {
//                        guard let media = try? document.data(as: FMedia.self) else {
//                            return
//                        }
//                        print(media.caption)
//                        medias.append(media)
//                    }
//                    group.leave()
//                }
//            }
//               
//               group.notify(queue: .main) {
//                   completion(.success(medias))
//               }
//           }
    }
}
