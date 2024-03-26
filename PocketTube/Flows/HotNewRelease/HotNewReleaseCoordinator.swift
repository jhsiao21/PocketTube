import UIKit

class HotNewReleaseCoordinator: BaseCoordinator {
    var transitToProfileView: (() -> Void)?
    
    private let factory: HotNewReleaseSceneFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(factory: HotNewReleaseSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, router: Routerable) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showHotNewReleaseView()
    }
}

extension HotNewReleaseCoordinator {
    
    func showHotNewReleaseView() {
        let hotNewReleaseView = factory.makeHotNewReleaseView()
        
        hotNewReleaseView.onAirPlayButtonTap = { [unowned self] in
            self.showUIHint(message: "Coming soon")
        }
        
        hotNewReleaseView.onSearchButtonTap = { [unowned self] in
            self.runSearchFlow()
        }
        
        hotNewReleaseView.onUserIconButtonTap = { [unowned self] in
            self.transitToProfileView?()
        }
        
        hotNewReleaseView.onMediaShare = { [unowned self] name, youtubeUrl, posterImg in
            self.share(name: name, youtubeUrl: youtubeUrl, posterImg: posterImg)
        }
        
        hotNewReleaseView.onMediaPlay = { [unowned self] model in
            self.showMediaPreviewView(with: model)
        }
        
        hotNewReleaseView.onRemindeMeButtonTap = { [unowned self] in
            self.showUIHint(message: "Coming soon")
        }
        
        hotNewReleaseView.onInfoButtonTap = { [unowned self] in
            self.showUIHint(message: "Coming soon")
        }
        
        router.setRootModule(hotNewReleaseView)
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

extension HotNewReleaseCoordinator {
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
    
    func share(name: String, youtubeUrl: URL, posterImg: UIImage) {
        let shareMsg = "我看到了一個超棒的影片！片名：\(name)"
        let activityVC = UIActivityViewController(activityItems: [shareMsg, posterImg, youtubeUrl], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in

            if let error = error {
                self.showUIAlert(message: error.localizedDescription)
                return
            }
            
            if completed {
                self.showUIHint(message: "Share success")
            }
        }
        
        DispatchQueue.main.async {
            self.router.present(activityVC, animated: true)
        }
    }
}
