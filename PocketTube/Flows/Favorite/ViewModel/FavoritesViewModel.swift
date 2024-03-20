import Foundation
import Firebase

protocol FavoriteViewModelDelegate: AnyObject {
    func favoriteViewModel(didReceiveData data: [FMedia])
    func favoriteViewModel(didReceiveError error: Error)
}

protocol FavoriteViewModelDataProvider {
    func fetchFMediaData(completion: @escaping (Result<[FMedia], Error>) -> Void)
}

class FavoritesViewModel {
    
    weak var delegate: FavoriteViewModelDelegate?
    private let dataProvider: FavoriteViewModelDataProvider
    var medias: [FMedia] = [FMedia]()
    
    init(dataProvider: FavoriteViewModelDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchData() {
        dataProvider.fetchFMediaData { [weak self] result in
            switch result {
            case .success(let data):
                self?.delegate?.favoriteViewModel(didReceiveData: data)
            case .failure(let failure):
                self?.delegate?.favoriteViewModel(didReceiveError: failure)
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
