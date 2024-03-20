import UIKit

protocol HomeSceneFactoryProtocol: MediaPreviewSceneProtocol, SearchSceneFactoryProtocol {
    func makeHomeView() -> HomeView
}
