import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth

final class ProfileCoordinator: BaseCoordinator {
    private let factory: ProfileSceneFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(factory: ProfileSceneFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol, router: Routerable) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }

    override func start() {
        showProfileView()
    }
}

extension ProfileCoordinator {
    func showProfileView() {
        let profileView = factory.makeProfileView()
        
        profileView.onSignOutTap = { [unowned self] in
            
            let actionSheet = UIAlertController(title: "Do you want to sign out?",
                                                message: "",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [unowned self] _ in
                
                // remove name and email from UserDefault
                UserDefaults.standard.setValue(nil, forKey: "name")
                UserDefaults.standard.setValue(nil, forKey: "email")
                
                // Facebook log out
                FBSDKLoginKit.LoginManager().logOut()
                
                // Google log out
                GIDSignIn.sharedInstance.signOut()
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    
                    self.removeDependency(self)
                    self.finishFlow?()
                }
                catch {
                    print("Failed to log out")
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
            
//            present(actionSheet, animated: true)
            router.present(actionSheet, animated: true)
        }
        
        profileView.onDeleteAccountTap = {  [unowned self] in
            let actionSheet = UIAlertController(title: "Deleting your account is permanent. Do you want to delete your account?", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Delete Account", style: .destructive, handler: { [unowned self] _ in
                    Task {
                        let result = await ProfileViewModel.deleteAccount()
                        DispatchQueue.main.async {
                            if result {
                                self.showUIHint(message: "Bye Bye!") { _ in
                                    self.removeDependency(self)
                                    self.finishFlow?()
                                }
                            } else {
                                self.showUIAlert(message: "Delete account failed.")
                            }
                        }
                    }
                }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//            present(actionSheet, animated: true)
            router.present(actionSheet, animated: true)
        }
        
        
        
        router.setRootModule(profileView)
    }
    
    func showUIHint(title: String = "提示", message: String, actionTitle: String = "確定", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
//        DispatchQueue.main.async {
//            self.present(alert, animated: true, completion: nil)
//        }
        router.present(alert, animated: true)
    }
    
    func showUIAlert(title: String = "錯誤", message: String, actionTitle: String = "確定") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
//        DispatchQueue.main.async {
//            self.present(alert, animated: true, completion: nil)
//        }
        router.present(alert, animated: true)
    }
}
