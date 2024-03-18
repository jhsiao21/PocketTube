//
//  ForgotPasswordViewController.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/27.
//

import UIKit
import JGProgressHUD

protocol ForgotPasswordView {
    
}

class ForgotPasswordViewController: UIViewController {

    private let spinner = JGProgressHUD(style: .dark)
    
    private let viewModel = ForgotPasswordViewModel()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow-back-icon"), for: .normal)
        button.tintColor = UIColor(red: 40/255, green: 46/255, blue: 79/255, alpha: 1)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = titleFont
        label.text = "Reset"
        label.textColor = tintColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var emailTextField: ATCTextField = {
        let textField = ATCTextField()
        textField.configure(color: textFieldColor,
                            font: textFieldFont,
                            cornerRadius: 55/2,
                            borderColor: textFieldBorderColor,
                            backgroundColor: backgroundColor,
                            borderWidth: 1.0)
        textField.placeholder = "Enter your e-mail"
        textField.textContentType = .emailAddress
        textField.clipsToBounds = true
        textField.returnKeyType = .continue
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset Password", for: .normal)
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        button.configure(color: backgroundColor,
                         font: buttonFont,
                         cornerRadius: 55/2,
                         backgroundColor: tintColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ForgotPasswordViewController.backgroundColor
        
        self.hideKeyboardWhenTappedAround()
        layout()
    }
    
    private func layout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50),
            
            view.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 25),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.5),
            emailTextField.heightAnchor.constraint(equalToConstant: 55),
                        
            view.trailingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 50),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            resetButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            resetButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapResetButton() {
        spinner.show(in: view)
        guard let email = emailTextField.text else {
            self.showUIAlert(message: "Invalid email address")
            return
        }
        viewModel.sendPasswordResetEmail(toEmail: email) { [unowned self] result in
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            switch result {
            case .success(_):
                self.showUIHint(message: "已經發送重置密碼至：\(email)")
            case .failure(let failure):
                self.showUIAlert(message: failure.localizedDescription)
            }
        }
    }
}

extension ForgotPasswordViewController {
    private static let backgroundColor = UIColor.mainThemeBackgroundColor
    private static let tintColor = UIColor(red: 255/255, green: 90/255, blue: 102/255, alpha: 1)
    
    private static let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private static let buttonFont = UIFont.boldSystemFont(ofSize: 18)
    
    private static let textFieldFont = UIFont.systemFont(ofSize: 16)
    private static let textFieldColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    private static let textFieldBorderColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    
}
