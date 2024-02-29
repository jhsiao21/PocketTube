//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/18.
//

import Foundation
import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func searchViewModel(didReceiveData data: [SearchResultViewModelItem])
    func searchViewModel(didReceiveSearchData data: [SearchResultViewModelItem])
    func searchViewModel(didReceiveError error: Error)
}

protocol SearchViewModelDataProvider {
    typealias SearchResult = Result<[SearchResultViewModelItem], Error>
    
    func fetchDiscoverMedia(completion: @escaping (SearchResult) -> Void)
    func searchFor(with mediaName: String, completion: @escaping (SearchResult) -> Void)
}

protocol SearchResultViewModelItem {
    var type: SearchResultType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class SearchViewModel {
    
    weak var delegate: SearchViewModelDelegate?
    private let dataProvider: SearchViewModelDataProvider
    
    var defaultItems: [SearchResultViewModelItem] = []
    var searchedItems: [SearchResultViewModelItem] = []
    
    init(dataProvider: SearchViewModelDataProvider) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - API request
    func fetchDiscoverMovies() {
        dataProvider.fetchDiscoverMedia { [weak self] result in
            switch result {
            case .success(let data):
                self?.delegate?.searchViewModel(didReceiveData: data)
            case .failure(let failure):
                self?.delegate?.searchViewModel(didReceiveError: failure)
            }
        }
    }
    
    func search(with mediaName: String) {
        dataProvider.searchFor(with: mediaName) { [weak self] result in
            switch result {
            case .success(let data):
                self?.delegate?.searchViewModel(didReceiveSearchData: data)
            case .failure(let error):
                self?.delegate?.searchViewModel(didReceiveError: error)
            }
        }
    }
}

class SearchChampionItem: SearchResultViewModelItem {
    var type: SearchResultType {
        return .SearchChampion
    }
    
    var sectionTitle: String {
        return "搜尋冠軍"
    }
    
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

class MoviesAndTVsItem: SearchResultViewModelItem {
    var type: SearchResultType {
        return .MoviesAndTVs
    }
    
    var sectionTitle: String {
        return "節目與電影推薦"
    }
    
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

