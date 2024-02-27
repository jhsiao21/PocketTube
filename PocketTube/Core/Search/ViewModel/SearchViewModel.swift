//
//  SearchViewModel.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/18.
//

import Foundation
import UIKit

enum SearchResultType: Int, Codable {
    case MoviesAndTVs = 0
    case SearchChampion = 1
}

protocol SearchResultViewModelItem {
    var type: SearchResultType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class SearchViewModel : NSObject {
    
    var defaultItems: [SearchResultViewModelItem] = []
    var searchedItems: [SearchResultViewModelItem] = []
    
    override init() {
        super.init()
        //        fetchDiscoverMovies()
    }
    
    // MARK: - API request
    func fetchDiscoverMovies(completion: @escaping (Result<Bool, Error>) -> Void) {
        APIManager.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let media):
                let mediaItem = MoviesAndTVsItem(medias: media) //這裡決定預設要顯示什麼內容
                self?.defaultItems.append(mediaItem)
                completion(.success(true))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func search(with query: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        APIManager.shared.search(with: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let media):
                    self?.searchedItems.removeAll()
                    let mediaItem = MoviesAndTVsItem(medias: media)
                    self?.searchedItems.append(mediaItem)
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
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

