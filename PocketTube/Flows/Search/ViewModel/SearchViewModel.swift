import Foundation
import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func searchViewModel(didReceiveData data: [Media])
    func searchViewModel(didReceiveSearchData data: [Media])
    func searchViewModel(didReceiveError error: Error)
}

protocol SearchViewModelDataProvider {
    func fetchDiscoverMedia(completion: @escaping (Result<[Media], Error>) -> Void)
    func searchFor(with mediaName: String, completion: @escaping (Result<[Media], Error>) -> Void)
}

protocol SearchResultViewModelItem {
    var type: SearchResultType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
    var medias: [Media] { get }
}

class SearchViewModel {
    
    weak var delegate: SearchViewModelDelegate?
    private let dataProvider: SearchViewModelDataProvider
    
    var defaultItems: [Media] = []
    var searchedItems: [Media] = []
    
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

struct SearchResultItem: SearchResultViewModelItem {
    var type: SearchResultType {
        return .SearchResult
    }
    
    var sectionTitle: String {
        return "搜尋結果"
    }
    
    var rowCount: Int {
        return medias.count
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

struct MoviesAndTVsItem: SearchResultViewModelItem {
    var type: SearchResultType {
        return .MoviesAndTVs
    }
    
    var sectionTitle: String {
        return "節目與電影推薦"
    }
    
    // set to 20, because API return 20
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

