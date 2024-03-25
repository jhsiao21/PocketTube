import UIKit

class HomeCoordinator: BaseCoordinator {
    var onUserIconTap: (() -> Void)?
    
    private let factory: HomeSceneFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(factory: HomeSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, router: Routerable) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showHomeView()
    }
}

extension HomeCoordinator {    
    
    func showHomeView() {
        let homeView = factory.makeHomeView()
        
        homeView.onAirPlayButtonTap = { [unowned self] in
            self.showUIHint(message: "Coming soon")
        }
        
        homeView.onSearchButtonTap = { [unowned self] in
            self.runSearchFlow()
        }
        
        homeView.onUserIconButtonTap = { [unowned self] in
            self.onUserIconTap?()
        }
        
        homeView.onMediaPlay = { [unowned self] model in
            showMediaPreviewView(with: model)
        }        
        
        router.setRootModule(homeView)
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
    
    func runSearchFlow() {
        let coordinator = SearchCoordinator(factory: factory, coordinatorFactory: coordinatorFactory, router: router)
        
        coordinator.finishFlow = { [unowned self] in
            self.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
}

extension HomeCoordinator {
    func showUIAlert(title: String = "錯誤", message: String, actionTitle: String = "確定") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.router.present(alert)
        }
    }
        
    func showUIHint(title: String = "提示", message: String, actionTitle: String = "確定", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        DispatchQueue.main.async {
            self.router.present(alert)
        }
    }
}
