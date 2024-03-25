import Foundation
import Firebase

protocol FavoriteViewModelDelegate: AnyObject {
    func favoriteViewModel(didReceiveData data: [FMedia])
    func favoriteViewModel(didReceiveError error: Error)
    func favoriteViewModel(didPlayMedia model: YoutubePreviewModel)
}

protocol FavoriteViewModelDataProvider {
    func fetchFMediaData(completion: @escaping (Result<[FMedia], Error>) -> Void)
}

class FavoritesViewModel {
    
    weak var delegate: FavoriteViewModelDelegate?
    private let dataProvider: FavoriteViewModelDataProvider
    var medias: [FMedia] = [FMedia]()
    var isLoading: ((Bool) -> Void)?
    
    init(dataProvider: FavoriteViewModelDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchData() {
        isLoading?(true)
        
        dataProvider.fetchFMediaData { [weak self] result in
            switch result {
            case .success(let data):
                self?.delegate?.favoriteViewModel(didReceiveData: data)
            case .failure(let failure):
                self?.delegate?.favoriteViewModel(didReceiveError: failure)
            }
            self?.isLoading?(false)
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
    
    func fetchMedia(media: FMedia) {
        isLoading?(true)
        
        APIManager.shared.fetchYouTubeMedia(with: "\(media.caption) trailer") { [weak self] result in
            
            switch result {
            case .success(let videoElement):
                let model = YoutubePreviewModel(title: media.caption, youtubeView: videoElement, titleOverview: media.overview ?? "")
                self?.delegate?.favoriteViewModel(didPlayMedia: model)
            case .failure(let error):
                self?.delegate?.favoriteViewModel(didReceiveError: error)
            }
            self?.isLoading?(false)
        }
    }
}
