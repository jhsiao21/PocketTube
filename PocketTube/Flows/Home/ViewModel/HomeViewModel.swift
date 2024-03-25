import Foundation
import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func homeViewModel(didReceiveData mediaData: [String : [Media]])
    func homeViewModel(didReceiveError error: Error)
    func homeViewModel(didFavoriteMediaResponse response: FavoriteResponse)
    func homeViewModel(didPlayMedia model: YoutubePreviewModel)
    func homeViewModel(didShareMedia name: String, youtubeUrl: URL, posterImg: UIImage)    
}

protocol HomeViewModelDataProvider {
    func fetchMediaData(completion: @escaping (Result<[String : [Media]], Error>) -> Void)
}

final class HomeViewModel  {
    
    private let dataProvider: HomeViewModelDataProvider
    weak var delegate: HomeViewModelDelegate?
    var mediaData: [String : [Media]] = [:]
    var isLoading: ((Bool) -> Void)?
        
    init(dataProvider: HomeViewModelDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchData() {
        isLoading?(true)
        
        dataProvider.fetchMediaData { [self] result in
            switch result {
            case .success(let medias):
                delegate?.homeViewModel(didReceiveData: medias)
            case .failure(let error):
                delegate?.homeViewModel(didReceiveError: error)
            }
            isLoading?(false)
        }
    }
}

// MARK: - Content Action Button Delegate
extension HomeViewModel: ContentActionButtonDelegate {
    func didTappedShareBtn(mediaName: String, image: UIImage) {
        // there's no share function in HomeView
    }
    
    func didTappedWatchListBtn(uid: String, media: FMedia) {
        Haptic.shared.vibrate(feedbackStyle: .light)
                
        isLoading?(true)
        
        DatabaseManager.shared.favoriteMedia(uid: uid, media: media) { [weak self] result in
            switch result {
            case .success(let response):
                switch response {
                case .exists:
                    self?.delegate?.homeViewModel(didFavoriteMediaResponse: .exists)
                case .added:
                    self?.delegate?.homeViewModel(didFavoriteMediaResponse: .added)
                    NotificationCenter.default.post(name: .didFavorite, object: nil)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.delegate?.homeViewModel(didReceiveError: failure)
            }
            self?.isLoading?(false)
        }
    }
    
    func didTappedPlayBtn(media: Media) {
        isLoading?(true)
        
        APIManager.shared.fetchYouTubeMedia(with: "\(media.displayTitle) trailer") { [weak self] result in
            
            switch result {
            case .success(let videoElement):
                let model = YoutubePreviewModel(title: media.displayTitle, youtubeView: videoElement, titleOverview: media.overview ?? "")
                self?.delegate?.homeViewModel(didPlayMedia: model)
            case .failure(let error):
                self?.delegate?.homeViewModel(didReceiveError: error)
            }
            self?.isLoading?(false)
        }
    }
}

