//
//  ProfileViewController.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/1/25.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit
import SDWebImage
import MessageUI

private enum ProfileSection: Int, CaseIterable {
    case info, support, logout
}

private enum ProfileInfoContent: Int, CaseIterable {
    case userName, email
}

private enum ProfileSupportContent: Int, CaseIterable {
    case info, privacy, contactDeveloper
}

private enum ProfileLogoutContent: Int, CaseIterable {
    case logout
}

final class ProfileViewController: UIViewController {
    
    private var userName: String? = nil
    private var email: String? = nil
    
    private var headerView : UIView?
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
        
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        
        return table
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
                
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        title = "個人頁面"
        
        layout()
        setupInfo()
        setupProfileImage()
        
        NotificationCenter.default.addObserver(forName: .didRefresh, object: nil, queue: nil) { [weak self] _ in
            self?.setupInfo()
            self?.setupProfileImage()
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth() //Register後跳回此視圖時，會再次觸發viewDidAppear來執行這行
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LandingScreenViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
            
        }
        else {
            
        }
    }
    
    private func setupProfileImage() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "profile_images/\(fileName)"
        
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                self?.profileImageView.sd_setImage(with: url, completed: nil)
            case .failure(let failure):
                self?.profileImageView.image = UIImage(systemName: "person.circle")?.withTintColor(.gray, renderingMode: .alwaysTemplate)
                print("Failed to get download url: \(failure)")
            }
        }
    }
    
    private func setupInfo() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,
              let username = UserDefaults.standard.value(forKey: "name") as? String else {
                  return
              }
        self.email = email
        self.userName = username
    }
    
    @objc private func didTapChangeProfilePicture() {
        print("Change pic called")
        presentPhotoActionSheet()
    }
    
    private func layout() {
        
        let size = view.width / 2
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: size))
        headerView!.addSubview(profileImageView)
        tableView.tableHeaderView = headerView
        
        // remove bottom blank cells in the table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: size),
            profileImageView.widthAnchor.constraint(equalToConstant: size),
            profileImageView.centerXAnchor.constraint(equalTo: headerView!.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: headerView!.centerYAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds

        let size = view.width/2
        profileImageView.frame.size = CGSize(width: size, height: size)
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePicture))
        profileImageView.addGestureRecognizer(gesture)
    }
    
}
    
// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = ProfileSection(rawValue: section) else {
            return nil
        }
        switch sectionType {
        case .info:
            return "User Info"
        case .support:
            return "Support"
        case .logout:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = ProfileSection(rawValue: section) else {
            return 0
        }
        switch sectionType {
        case .info:
            return ProfileInfoContent.allCases.count
        case .support:
            return ProfileSupportContent.allCases.count
        case .logout:
            return ProfileLogoutContent.allCases.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        guard let sectionType = ProfileSection(rawValue: indexPath.section) else { return cell }
        switch sectionType {
        case .info:
            guard let contentType = ProfileInfoContent(rawValue: indexPath.row) else { return cell }
            switch contentType {
            case .userName:
                cell.imageView?.image = UIImage(systemName: "person.text.rectangle")
                cell.textLabel?.text = userName
            case .email:
                cell.imageView?.image = UIImage(systemName: "envelope")
                cell.textLabel?.text = email
            }
            cell.type = .plain
        case .support:
            guard let contentType = ProfileSupportContent(rawValue: indexPath.row) else { return cell }
            switch contentType {
            case .info:
                cell.imageView?.image = UIImage(systemName: "info.circle")
                cell.textLabel?.text = "Info"
            case .privacy:
                cell.imageView?.image = UIImage(systemName: "lock.doc")
                cell.textLabel?.text = "Privacy"
            case .contactDeveloper:
                cell.imageView?.image = UIImage(systemName: "envelope")
                cell.textLabel?.text = "Contact developer"
            }
            cell.type = .selectable
        case .logout:
            guard let contentType = ProfileLogoutContent(rawValue: indexPath.row) else { return cell }
            switch contentType {
            case .logout:
                cell.imageView?.image = nil
                cell.textLabel?.text = "Log Out"
            }
            cell.type = .action
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = ProfileSection(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .info:
            break
        case .support:
            guard let cellType = ProfileSupportContent(rawValue: indexPath.row) else { return }
            switch cellType {
            case .info:
                print("info")
                AppInfo()
            case .privacy:
                print("privacy")
                Privacy()
            case .contactDeveloper:
                print("contactDeveloper")
                sendMail()
            }
            break
        case .logout:
            let actionSheet = UIAlertController(title: "Confirm",
                                                message: "",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {_ in
                
                // remove name and email from UserDefault
                UserDefaults.standard.setValue(nil, forKey: "name")
                UserDefaults.standard.setValue(nil, forKey: "email")
                
                // Facebook log out
                FBSDKLoginKit.LoginManager().logOut()
                
                // Google log out
                GIDSignIn.sharedInstance.signOut()
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    
                    let vc = LandingScreenViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }
                catch {
                    print("Failed to log out")
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))
            
            present(actionSheet, animated: true)
        }
    }
    
    private func AppInfo() {
        let infoVC = AppInfoViewController()
        present(infoVC, animated: true)
    }
    
    private func Privacy() {
        let urlString = "https://www.privacypolicies.com/live/adc06b0a-c158-427e-8886-fdbd610c28e9"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

    
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a pticure?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { _ in
            self.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { _ in
            self.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self  //如果沒這行不會觸發didFinishPickingMediaWithInfo
        vc.allowsEditing = true //對應：editedImage
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil) //?
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.profileImageView.image = selectedImage
        
        guard let data = selectedImage.pngData(),
              let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = "\(safeEmail)_profile_picture.png"
                
        StorageManager.shared.uploadProfilePicture(with: data,
                                                   fileName: fileName) { result in
            switch result {
            case .success(let downloadUrl):
                print(downloadUrl)
            case .failure(let error):
                print("Storage manager error: \(error)")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.delegate = self
            vc.setSubject("About PocketTube")
            vc.setToRecipients(["logan.hsiao@icloud.com"])
            vc.setMessageBody("<h3>Hi!</h3>", isHTML: true)
            present(vc, animated: true)
        }
        else {
            print("Mail services are not available")
            
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
