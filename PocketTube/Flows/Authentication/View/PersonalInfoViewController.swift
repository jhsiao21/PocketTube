//
//  PersonalInfoViewController.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/15.
//

import UIKit
import FirebaseAuth

protocol PersonalInfoView: BaseView {
    
}

final class PersonalInfoViewController: UIViewController, PersonalInfoView {
    
    private var name: String?
    private var email: String?

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "完成個人資訊"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameTextField: ATCTextField = {
        let textField = ATCTextField()
        textField.configure(color: PersonalInfoViewController.textFieldColor,
                            font: PersonalInfoViewController.textFieldFont,
                            cornerRadius: 40/2,
                            backgroundColor: .secondarySystemBackground,
                            borderWidth: 1.0)
        textField.placeholder = "Enter a user name"
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var addAccountBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.configure(color: .white,
                         font: buttonFont,
                         cornerRadius: 55/4,
                         backgroundColor: PersonalInfoViewController.tintColor)
        button.addTarget(self, action: #selector(didTapAddAccountButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func didTapAddAccountButton() {
        print("didTapAddAccountButton")
        
        guard let uid = Auth.auth().currentUser?.uid,
              let name = nameTextField.text,
              let email = email else {
            self.showUIAlert(message: "Can not get user name.")
            return
        }
        
        print("uid: \(Auth.auth().currentUser?.uid)")
        print("name: \(name)")
        print("email: \(email)")
        
        AuthService.shared.uploadUserData(email: email, userName: name, id: uid) { [unowned self] result in
            switch result {
            case .success(_):
                self.loginSuccess(email: email, name: name)
            case .failure(let failure):
                self.showUIAlert(message: failure.localizedDescription)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    init(name: String?, email: String?) {
        self.name = name
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    
    override func viewDidLayoutSubviews() {
        if let name = self.name {
            nameTextField.text = name
        }
    }
    
    private func layout() {
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(addAccountBtn)
        
        
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        
            nameTextField.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 3),
            nameTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nameTextField.trailingAnchor, multiplier: 2),
            nameTextField.heightAnchor.constraint(equalToConstant: 55),
            
            addAccountBtn.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: addAccountBtn.trailingAnchor, multiplier: 2),
            addAccountBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: addAccountBtn.bottomAnchor, multiplier: 10),
            addAccountBtn.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
}

extension PersonalInfoViewController {
    private static let tintColor = UIColor(red: 255/255, green: 90/255, blue: 102/255, alpha: 1)
    private static let backgroundColor: UIColor = UIColor.mainThemeBackgroundColor
    private static let textFieldColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    private static let textFieldBorderColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    
    private static let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private static let textFieldFont = UIFont.systemFont(ofSize: 16)
    private static let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    
    func loginSuccess(email: String, name: String) {
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set("\(name)", forKey: "name")
        
        NotificationCenter.default.post(name: .didRefresh, object: nil)
        let home = HomeViewController()
        self.navigationController?.pushViewController(home, animated: true)
    }
}
