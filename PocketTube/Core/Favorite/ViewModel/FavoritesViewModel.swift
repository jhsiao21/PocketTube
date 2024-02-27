//
//  FavoritesViewModel.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/24.
//

import Foundation
import Firebase

class FavoritesViewModel {
    var medias: [FMedia] = [FMedia]()
    
    func fetchData(completion: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        DatabaseManager.shared.fetchMedias(uid: uid) { result in
            switch result {
            case .success(let medias):
                self.medias = medias.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }) //按照時間排序
//                self.medias = medias //沒排序
                completion(.success(true))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(ServiceErrors.failedToFetch))
            }
        }
    }
    
    func deleteMedia(mediaId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        DatabaseManager.shared.mediaDelete(mediaId: mediaId) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
