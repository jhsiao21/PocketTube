import Foundation
import UIKit

final class SceneFactory: AuthSceneFactoryProtocol,
                          HomeSceneFactoryProtocol,
                          HotNewReleaseSceneFactoryProtocol,
                          FavoritesSceneFactoryProtocol,
                          ProfileSceneFactoryProtocol,
                          SearchSceneFactoryProtocol {
    
    func makeMediaPreviewView(withModel model: YoutubePreviewModel) -> MediaPreviewView {
        let mediaPreviewViewController = MediaPreviewViewController(mediaModel: model)
        return mediaPreviewViewController
    }
    
    func makeLoginView() -> LoginView {
        let loginViewController = LoginViewController()
        return loginViewController
    }

    func makeSignUpView() -> SignUpView {
        let signUpViewController = SignUpViewController()
        return signUpViewController
    }

    func makeLandingScreenView() -> LandingScreenView {
        let landingScreenViewController = LandingScreenViewController()
        return landingScreenViewController
    }
    
    func makePersonalInfoView(email: String?, name: String?) -> PersonalInfoView {
        let personalInfoViewController = PersonalInfoViewController(name: name, email: email)
        return personalInfoViewController
    }
    
    func makeForgotPasswordView() -> ForgotPasswordView {
        let forgotPasswordViewController = ForgotPasswordViewController()
        return forgotPasswordViewController
    }

    func makeHomeView() -> HomeView {
        return HomeViewController()
    }

    func makeHotNewReleaseView() -> HotNewReleaseView {
        return HotNewReleaseViewController()
    }
    
    func makeFavoritesView() -> FavoritesView {
        return FavoritesViewController()
    }
    
    func makeProfileView() -> ProfileView {
        return ProfileViewController()
    }
    
    func makeSearchView() -> SearchView {
        return SearchViewController.shared
    }
}
