import Foundation
import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func searchViewModel(didReceiveData data: [Media])
    func searchViewModel(didReceiveSearchData data: [Media])
    func searchViewModel(didReceiveError error: Error)
    func searchViewModel(didPlayMedia model: YoutubePreviewModel)
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
    var isLoading: ((Bool) -> Void)?
    
    var defaultItems: [Media] = []
    var searchedItems: [Media] = []
    
    init(dataProvider: SearchViewModelDataProvider) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - API request
    func fetchDiscoverMovies() {
        isLoading?(true)
        
        dataProvider.fetchDiscoverMedia { [weak self] result in
            switch result {
            case .success(let data):
                self?.delegate?.searchViewModel(didReceiveData: data)
            case .failure(let failure):
                self?.delegate?.searchViewModel(didReceiveError: failure)
            }
            self?.isLoading?(false)
        }
    }
    
    func search(with mediaName: String) {
        isLoading?(true)
        
        dataProvider.searchFor(with: mediaName) { [weak self] result in
            switch result {
            case .success(let data):
                self?.delegate?.searchViewModel(didReceiveSearchData: data)
            case .failure(let error):
                self?.delegate?.searchViewModel(didReceiveError: error)
            }
            self?.isLoading?(false)
        }
    }
    
    func fetchMedia(media: Media) {
        isLoading?(true)
        
        APIManager.shared.fetchYouTubeMedia(with: "\(media.displayTitle) trailer") { [weak self] result in
            
            switch result {
            case .success(let videoElement):
                let model = YoutubePreviewModel(title: media.displayTitle, youtubeView: videoElement, titleOverview: media.overview ?? "")
                self?.delegate?.searchViewModel(didPlayMedia: model)
            case .failure(let error):
                self?.delegate?.searchViewModel(didReceiveError: error)
            }
            self?.isLoading?(false)
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

