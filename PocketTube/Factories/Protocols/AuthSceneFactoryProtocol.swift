import UIKit

protocol AuthSceneFactoryProtocol {
    func makeLoginView() -> LoginView
    func makeSignUpView() -> SignUpView
    func makeLandingScreenView() -> LandingScreenView
    func makePersonalInfoView(email: String?, name: String?) -> PersonalInfoView
    func makeForgotPasswordView() -> ForgotPasswordView
}
