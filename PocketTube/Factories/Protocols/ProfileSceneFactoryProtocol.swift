import Foundation

protocol ProfileSceneFactoryProtocol: AuthSceneFactoryProtocol {
    func makeProfileView() -> ProfileView
}
