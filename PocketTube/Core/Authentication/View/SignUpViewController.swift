//
//  ATCClassicSignUpViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/10/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit
import JGProgressHUD

class SignUpViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
        
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "Sign Up"
        label.textColor = tintColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow-back-icon"), for: .normal)
        button.tintColor = UIColor(red: 40/255, green: 46/255, blue: 79/255, alpha: 1)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var nameTextField: ATCTextField = {
        let textField = ATCTextField()
        textField.configure(color: SignUpViewController.textFieldColor,
                            font: SignUpViewController.textFieldFont,
                            cornerRadius: 40/2,
                            borderColor: SignUpViewController.textFieldBorderColor,
                            backgroundColor: SignUpViewController.backgroundColor,
                            borderWidth: 1.0)
        textField.placeholder = "User Name"
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var phoneNumberTextField: ATCTextField = {
        let textField = ATCTextField()
        textField.configure(color: SignUpViewController.textFieldColor,
                            font: SignUpViewController.textFieldFont,
                            cornerRadius: 40/2,
                            borderColor: SignUpViewController.textFieldBorderColor,
                            backgroundColor: SignUpViewController.backgroundColor,
                            borderWidth: 1.0)
        textField.placeholder = "Phone Number"
        textField.keyboardType = .phonePad
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var passwordTextField: ATCTextField = {
        let textField = ATCTextField()
        textField.configure(color: SignUpViewController.textFieldColor,
                            font: SignUpViewController.textFieldFont,
                            cornerRadius: 40/2,
                            borderColor: SignUpViewController.textFieldBorderColor,
                            backgroundColor: SignUpViewController.backgroundColor,
                            borderWidth: 1.0)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var emailTextField: ATCTextField = {
        let textField = ATCTextField()
        textField.configure(color: SignUpViewController.textFieldColor,
                            font: SignUpViewController.textFieldFont,
                            cornerRadius: 40/2,
                            borderColor: SignUpViewController.textFieldBorderColor,
                            backgroundColor: SignUpViewController.backgroundColor,
                            borderWidth: 1.0)
        textField.placeholder = "E-mail Address"
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        button.configure(color: SignUpViewController.backgroundColor,
                         font: SignUpViewController.buttonFont,
                               cornerRadius: 40/2,
                               backgroundColor: UIColor(red: 51/255, green: 77/255, blue: 146/255, alpha: 1))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SignUpViewController.backgroundColor

        self.hideKeyboardWhenTappedAround()
        layout()
    }
    
    private func layout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(phoneNumberTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50),
            
            view.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            view.trailingAnchor.constraint(equalTo: phoneNumberTextField.trailingAnchor, constant: 40),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            phoneNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            
            view.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            view.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            
            view.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor, constant: 60),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            signUpButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 25),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
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

    @objc func didTapSignUpButton() {
        spinner.show(in: view)
        
        if let email = emailTextField.text,
            let password = passwordTextField.text,
           let userName = nameTextField.text,
           let phone = phoneNumberTextField.text {
            AuthService.shared.createUser(withEmail: email, password: password, userName: userName, phone: phone ) { [unowned self] result in
                var message: String = ""
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                switch result {
                case .success(_):
                    message = "User was sucessfully created."
                    self.showUIHint(message: message)
                case .failure(let failure):
                    message = failure.localizedDescription
                    self.showUIAlert(message: message)
                }
            }
        }
    }

    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SignUpViewController {
    private static let tintColor = UIColor(red: 255/255, green: 90/255, blue: 102/255, alpha: 1)
    private static let backgroundColor: UIColor = UIColor.mainThemeBackgroundColor
    private static let textFieldColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    private static let textFieldBorderColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    
    private static let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private static let textFieldFont = UIFont.systemFont(ofSize: 16)
    private static let buttonFont = UIFont.boldSystemFont(ofSize: 20)
}
