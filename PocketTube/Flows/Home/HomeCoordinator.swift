//
//  HomeCoordinator.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/17.
//

import UIKit

class HomeCoordinator: BaseCoordinator {
    
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
        
        homeView.onMediaSelected = { [weak self] media in
            
            APIManager.shared.fetchYouTubeMedia(with: "\(media.displayTitle) trailer") { result in
                
                switch result {
                case .success(let videoElement):
                    let model = YoutubePreviewModel(title: media.displayTitle, youtubeView: videoElement, titleOverview: media.overview ?? "")
                    self?.showMediaPreviewView(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.showUIAlert(message: error.localizedDescription)
                }
            }
        }
        
        homeView.onSearchButtonTap = { [unowned self] in
            self.runSearchFlow()
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