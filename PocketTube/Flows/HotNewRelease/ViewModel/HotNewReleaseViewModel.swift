import Foundation
import UIKit

protocol HotNewReleaseViewModelDelegate: AnyObject {
    func hotNewReleaseViewModel(didReceiveItem item: [HotNewReleaseViewModelItem])
    func hotNewReleaseViewModel(didFavoriteMediaResponse response: FavoriteResponse)
    func hotNewReleaseViewModel(didShareMedia name: String, youtubeUrl: URL, posterImg: UIImage)
    func hotNewReleaseViewModel(didPlayMedia model: YoutubePreviewModel)
    func hotNewReleaseViewModel(didRemindeMe media: Media?)
    func hotNewReleaseViewModel(didMediaInfo media: Media?)
    func hotNewReleaseViewModel(didReceiveError error: Error)
}

protocol HotNewReleaseViewModelDataProvider {
    func fetchMediaData(completion: @escaping (Result<[HotNewReleaseViewModelItem], Error>) -> Void)
}

protocol HotNewReleaseViewModelItem {
    var type: SectionType { get }
    var sectionTitle: String { get }
    var sectionImageName: String { get }
    var rowCount: Int { get }
}

final class HotNewReleaseViewModel {
    var isLoading: ((Bool) -> Void)?
    var onMediaSelected: ((Media) -> Void)?
    private let dataProvider: HotNewReleaseViewModelDataProvider
    weak var delegate: HotNewReleaseViewModelDelegate?
    var items: [HotNewReleaseViewModelItem] = []
        
    init(dataProvider: HotNewReleaseViewModelDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchData() {
        isLoading?(true)
        
        dataProvider.fetchMediaData { [weak self] result in
            switch result {
            case .success(let item):
                self?.delegate?.hotNewReleaseViewModel(didReceiveItem: item)
            case .failure(let error):
                self?.delegate?.hotNewReleaseViewModel(didReceiveError: error)
            }
            self?.isLoading?(false)
        }
    }
}

// MARK: - ContentActionButton Delegate
extension HotNewReleaseViewModel: ContentActionButtonDelegate {
    
    func didTappedRemindeMeBtn() {
        delegate?.hotNewReleaseViewModel(didRemindeMe: nil)
    }
    
    func didTappedInfoBtn() {
        delegate?.hotNewReleaseViewModel(didMediaInfo: nil)
    }
    
    func didTappedShareBtn(mediaName: String, image: UIImage) {
        
        isLoading?(true)
        
        APIManager.shared.fetchYouTubeMedia(with: "\(mediaName) trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                guard let videoId = (videoElement as VideoElement).id.videoId,
                      let youtubeUrl = URL(string: "https://www.youtube.com/watch?v=\(videoId)") else {
                    return
                }
                self?.delegate?.hotNewReleaseViewModel(didShareMedia: mediaName, youtubeUrl: youtubeUrl, posterImg: image)
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.hotNewReleaseViewModel(didReceiveError: error)
            }
            self?.isLoading?(false)
        }        
    }
    
    func didTappedWatchListBtn(uid: String, media: FMedia) {
        Haptic.shared.vibrate(feedbackStyle: .light)
        
        isLoading?(true)
        
        DatabaseManager.shared.favoriteMedia(uid: uid, media: media) { [weak self] result in
            switch result {
            case .success(let response):
                switch response {
                case .exists:
                    self?.delegate?.hotNewReleaseViewModel(didFavoriteMediaResponse: .exists)
                case .added:
                    self?.delegate?.hotNewReleaseViewModel(didFavoriteMediaResponse: .added)
                    NotificationCenter.default.post(name: .didFavorite, object: nil)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.delegate?.hotNewReleaseViewModel(didReceiveError: failure)
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
                self?.delegate?.hotNewReleaseViewModel(didPlayMedia: model)
            case .failure(let error):
                self?.delegate?.hotNewReleaseViewModel(didReceiveError: error)
            }
            self?.isLoading?(false)
        }
    }
}

struct HotNewReleaseViewModelPopularItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Popular
    }
    
    var sectionTitle: String {
        return "大家都在看"
    }
    
    var sectionImageName: String {
        return "fire"
    }
    
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

struct HotNewReleaseViewModelUpcomingItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Upcoming
    }
    
    var sectionTitle: String {
        return "即將上線"
    }
    
    var sectionImageName: String {
        return "popcorn"
    }
    
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

struct HotNewReleaseViewModelTop10MoviesItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Top10Movies
    }
    
    var sectionTitle: String {
        return "Top 10 電影"
    }
    
    var sectionImageName: String {
        return "Top10"
    }
    
    var rowCount: Int {
        return 10
    }

    var medias: [Media]

    init(medias: [Media]) {
        self.medias = medias
    }
}

struct HotNewReleaseViewModelTop10TVsItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Top10TVs
    }
    
    var sectionTitle: String {
        return "Top 10 節目"
    }
    
    var sectionImageName: String {
        return "Top10"
    }
    
    var rowCount: Int {
        return 10
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}
