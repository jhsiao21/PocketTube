import Foundation

protocol SearchSceneFactoryProtocol: MediaPreviewSceneProtocol {
    func makeSearchView() -> SearchView
}
