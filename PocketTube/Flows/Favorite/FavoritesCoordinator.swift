import Foundation
import UIKit

final class FavoritesCoordinator: BaseCoordinator {
    private let factory: FavoritesSceneFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(factory: FavoritesSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, router: Routerable) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showFavoritesView()
    }
}

extension FavoritesCoordinator {
    
    func showFavoritesView() {
        let favoritesView = factory.makeFavoritesView()
        
        favoritesView.onMediaSelected = { [weak self] model in
            self?.showMediaPreviewView(with: model)
        }
        
        router.setRootModule(favoritesView)
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
