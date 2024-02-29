//
//  HotNewReleaseViewModelMockDataProvider.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/29.
//

import Foundation
@testable import PocketTube

typealias ItemResult = Result<[HotNewReleaseViewModelItem], Error>

class HotNewReleaseViewModelMockDataProvider: HotNewReleaseViewModelDataProvider {
    
    private let itemResult: ItemResult
    
    init(result: ItemResult) {
        self.itemResult = result
    }
    
    func fetchMediaData(completion: @escaping (ItemResult) -> Void) {
        completion(itemResult)
    }
}
