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
        
        searchView.onMediaSelected = { [unowned self] model in
            self.showMediaPreviewView(with: model)
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
