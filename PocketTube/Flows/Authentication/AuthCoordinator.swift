//
//  AuthCoordinator.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/18.
//

import UIKit

final class AuthCoordinator: BaseCoordinator {
    private let factory: AuthSceneFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(factory: AuthSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, router: Routerable) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showLandingScreenView()
    }
}

extension AuthCoordinator {
    
    func showLandingScreenView() {
        
        let landingScreenView = factory.makeLandingScreenView()
        
        landingScreenView.onLogInButtonTap = { [unowned self] in
            self.showLoginView()
        }
        
        landingScreenView.onSignUpButtonTap = { [unowned self] in
            self.showSignUpView()
        }
        
        router.setRootModule(landingScreenView)
    }
    
    func showLoginView() {
        let loginView = factory.makeLoginView()
        
        loginView.onCompleteAuth = { [unowned self] in
            print("onCompleteAuth")
            finishFlow?()
        }
        
        router.push(loginView)
    }
    
    func showSignUpView() {
        let signUpView = factory.makeSignUpView()
        router.push(signUpView)
    }
}
