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
            self.runSignUpFlow()
        }
        
        router.setRootModule(landingScreenView)
    }
    
    func showLoginView() {
        let loginView = factory.makeLoginView()
        
        loginView.onCompleteAuth = { [unowned self] email, name, profileURL in
            self.recordUserInfo(email: email, name: name, profileURL: profileURL)
            self.finishFlow?()
        }
        
        loginView.onTransitToPersonal = { [unowned self] email, name in
            self.runPersonalInfoFlow(email: email, name: name)            
        }
        
        loginView.onTransitToForgotPWD = { [unowned self] in
            let forgotPwdView = factory.makeForgotPasswordView()
            router.push(forgotPwdView, hideBottomBar: true)
        }
        
        router.push(loginView)
    }
    
    func runSignUpFlow() {
        let coordinator = SignUpCoordinator(factory: factory, coordinatorFactory: coordinatorFactory, router: router)
        
        coordinator.finishFlow = { [unowned self] in
            self.removeDependency(coordinator)
            self.showLoginView()    //註冊後，跳轉登入頁面
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    func runPersonalInfoFlow(email: String?, name: String?) {
        let coordinator = PersonalInfoCoordinator(factory: factory, coordinatorFactory: coordinatorFactory, router: router)
        
        coordinator.finishFlow = { [unowned self] in
            self.removeDependency(coordinator)            
            self.finishFlow?()  //結束AuthCoordinator，這時已是登入狀態會跳轉到主頁
        }
        
        addDependency(coordinator)
        coordinator.start(email: email, name: name)
    }
    
    func recordUserInfo(email: String, name: String, profileURL: String?) {
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(profileURL, forKey: "profileURL")
        NotificationCenter.default.post(name: .didRefresh, object: nil)
    }
}
