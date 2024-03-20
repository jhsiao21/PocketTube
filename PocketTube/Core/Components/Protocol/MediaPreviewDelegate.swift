import Foundation

protocol MediaPreviewDelegate: AnyObject {
    func didPreview(mediaName: String, mediaOverview: String?)
}
