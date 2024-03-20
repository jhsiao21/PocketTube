import UIKit

final class PersonalInfoCoordinator: BaseCoordinator {
    
    private let factory: AuthSceneFactoryProtocol
    private let coordinator: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(factory: AuthSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, router: Routerable) {
        self.factory = factory
        self.coordinator = coordinatorFactory
        self.router = router
    }
    
    func start(email: String?, name: String?) {
        showPersonalInfoView(email: email, name: name)
    }
}

extension PersonalInfoCoordinator {
    func showPersonalInfoView(email: String?, name: String?) {
        let personalInfoView = factory.makePersonalInfoView(email: email, name: name)
        
        personalInfoView.onCompleteAuth = { [unowned self] email, name in
            self.recordUserInfo(email: email, name: name)
            self.removeDependency(self)
            self.finishFlow?()
        }
                
        router.push(personalInfoView, hideBottomBar: true)
    }
    
    func recordUserInfo(email: String, name: String) {
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set("\(name)", forKey: "name")
        
        NotificationCenter.default.post(name: .didRefresh, object: nil)
    }
}
