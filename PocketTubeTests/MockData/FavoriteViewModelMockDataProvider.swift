//
//  FavoriteViewModelMockDataProvider.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/29.
//

import Foundation
@testable import PocketTube

typealias FMediaResult = Result<[FMedia], Error>

class FavoriteViewModelMockDataProvider: FavoriteViewModelDataProvider {
    
    private let fmediaResult: FMediaResult
    
    init(result: FMediaResult) {
        self.fmediaResult = result
    }
    
    func fetchFMediaData(completion: @escaping (FMediaResult) -> Void) {
        completion(fmediaResult)
    }
}
