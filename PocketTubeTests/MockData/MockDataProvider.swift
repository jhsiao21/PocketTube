//
//  MockDataProvider.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/29.
//

import Foundation
@testable import PocketTube

typealias MediaResult = Result<[String : [Media]], Error>

class MockDataProvider: HomeViewModelDataProvider {
    
    private let mediaResult: MediaResult
    
    init(result: MediaResult) {
        self.mediaResult = result
    }
    
    func fetchMediaData(completion: @escaping (MediaResult) -> Void) {
        completion(mediaResult)
    }
}
