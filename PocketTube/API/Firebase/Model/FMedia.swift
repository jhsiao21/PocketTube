//
//  FMedia.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FMedia: Codable, Hashable, Equatable {
//    @DocumentID private var mediaId: String?
    let ownerUid: String
    let caption: String
    let timestamp: Timestamp
    var imageUrl: String?
    let overview: String?
    let mId: String
    
//    var id: String {
//        return mediaId ?? NSUUID().uuidString
//    }
}

enum FavoriteResponse: CaseIterable {
    case exists
    case added
    
    var caseDescription: String {
        switch self {
        case .added:
            return "已加入"
        case .exists:
            return "已存在"
        }
    }
}
