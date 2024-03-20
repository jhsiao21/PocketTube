//
//  SignUpCoordinator.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/20.
//

import UIKit

class SignUpCoordinator: BaseCoordinator {
    
    private let factory: AuthSceneFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(factory: AuthSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, router: Routerable) {
        self.factory = factory       
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showSignUpView()
    }
}

extension SignUpCoordinator {
    
    func showSignUpView() {
        let signUpView = factory.makeSignUpView()
        
        signUpView.onCompleteSignUp = { [unowned self] in
            self.finishFlow?()
        }
        
        router.push(signUpView)
    }
}


