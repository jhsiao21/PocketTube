import UIKit
import JGProgressHUD

extension UIViewController {
    
    func showUIAlert(title: String = "錯誤", message: String, actionTitle: String = "確定") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
        
    func showUIHint(title: String = "提示", message: String, actionTitle: String = "確定", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: handler))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
//    func previewMedia(mediaName: String, mediaOverview: String?) {
//        let spinner = JGProgressHUD(style: .dark)
//        spinner.show(in: view)
//        APIManager.shared.fetchYouTubeMedia(with: "\(mediaName) trailer") { [weak self] result in
//            DispatchQueue.main.async {
//                spinner.dismiss()
//            }
//            switch result {
//            case .success(let videoElement):
//                
//                guard let mediaOverview = mediaOverview else {
//                    return
//                }
//                
//                let viewModel = YoutubePreviewModel(title: mediaName, youtubeView: videoElement, titleOverview: mediaOverview)
//                self?.presnt(model: viewModel)
//            case .failure(let error):
//                print(error.localizedDescription)
//                self?.showUIAlert(message: error.localizedDescription)
//            }
//        }
//    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
