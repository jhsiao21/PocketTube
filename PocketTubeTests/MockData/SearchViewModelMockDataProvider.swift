//
//  SearchViewModelMockDataProvider.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/29.
//

import Foundation
@testable import PocketTube
typealias SearchResult = Result<[Media], Error>

class SearchViewModelMockDataProvider: SearchViewModelDataProvider {
    private let searchResult: SearchResult
    
    init(result: SearchResult) {
        self.searchResult = result
    }
    
    func fetchDiscoverMedia(completion: @escaping (SearchResult) -> Void) {
        completion(searchResult)
    }
    
    func searchFor(with mediaName: String, completion: @escaping (SearchResult) -> Void) {
        completion(searchResult)
    }
}
