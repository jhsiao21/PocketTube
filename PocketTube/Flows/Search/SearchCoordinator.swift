import UIKit

class SearchCoordinator: BaseCoordinator {
    
    private let factory: SearchSceneFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(factory: SearchSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, router: Routerable) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showSearchView()
    }
}

extension SearchCoordinator {
    
    func showSearchView() {
        let searchView = factory.makeSearchView()
        
        searchView.onMediaSelected = { [unowned self] media in
            
            APIManager.shared.fetchYouTubeMedia(with: "\(media.displayTitle) trailer") { result in
                
                switch result {
                case .success(let videoElement):
                    let model = YoutubePreviewModel(title: media.displayTitle, youtubeView: videoElement, titleOverview: media.overview ?? "")
                    self.showMediaPreviewView(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.showUIAlert(message: error.localizedDescription)
                }
            }
        }
        
        router.push(searchView, animated: true, hideBottomBar: true) { [weak self] in
            self?.finishFlow?()
        }
    }
    
    func showMediaPreviewView(with model: YoutubePreviewModel) {
        
        DispatchQueue.main.async { [unowned self] in
            let mediaPreviewView = factory.makeMediaPreviewView(withModel: model)
            let nav = UINavigationController(rootViewController: mediaPreviewView as! UIViewController)
            nav.modalPresentationStyle = .fullScreen
            self.router.present(nav)
//            self.router.push(mediaPreviewView, hideBottomBar: true)
        }
    }
}
