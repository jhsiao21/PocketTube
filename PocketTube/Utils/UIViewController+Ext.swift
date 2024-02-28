//
//  UIViewController+Ext.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/12.
//

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
    
    func showUIHint(title: String = "提示", message: String, actionTitle: String = "確定") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presnt(model: YoutubePreviewModel) {
        DispatchQueue.main.async {
            let vc = MediaPreviewViewController()
            vc.configure(with: model)
            let pvc = UINavigationController(rootViewController: vc)
            pvc.modalPresentationStyle = .fullScreen
            pvc.navigationController?.isNavigationBarHidden = false
            DispatchQueue.main.async {
                self.present(pvc, animated: true, completion: nil)
            }
        }
    }
    
    func previewMedia(mediaName: String, mediaOverview: String?) {
        let spinner = JGProgressHUD(style: .dark)
        spinner.show(in: view)
        APIManager.shared.fetchYouTubeMedia(with: "\(mediaName) trailer") { [weak self] result in
            DispatchQueue.main.async {
                spinner.dismiss()
            }
            switch result {
            case .success(let videoElement):
                
                guard let mediaOverview = mediaOverview else {
                    return
                }
                
                let viewModel = YoutubePreviewModel(title: mediaName, youtubeView: videoElement, titleOverview: mediaOverview)
                self?.presnt(model: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
                self?.showUIAlert(message: error.localizedDescription)
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
