import Foundation

protocol HotNewReleaseSceneFactoryProtocol: MediaPreviewSceneProtocol, SearchSceneFactoryProtocol {
    func makeHotNewReleaseView() -> HotNewReleaseView
}
