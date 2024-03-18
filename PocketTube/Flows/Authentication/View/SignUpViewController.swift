//
//  ATCClassicSignUpViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/10/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol SignUpView: BaseView {
    
}

class SignUpViewController: UIViewController, SignUpView {
    
    private let spinner = JGProgressHUD(style: .dark)
    private var validEmail = false
    private var validPassword = false
        
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
                            backgroundColor: .secondarySystemBackground,
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
                            backgroundColor: .secondarySystemBackground,
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
                            backgroundColor: .secondarySystemBackground,
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
                            backgroundColor: .secondarySystemBackground,
                            borderWidth: 1.0)
        textField.placeholder = "E-mail Address"
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailValidationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .red
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordValidationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .red
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.isHidden = true
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
        setupTextField()
    }
    
    private func layout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
//        view.addSubview(phoneNumberTextField)
        view.addSubview(emailTextField)
        view.addSubview(emailValidationLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordValidationLabel)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 25),
                        
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            view.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 40),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
//            phoneNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
//            phoneNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
//            view.trailingAnchor.constraint(equalTo: phoneNumberTextField.trailingAnchor, constant: 40),
//            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
                        
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            view.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailValidationLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0),
            emailValidationLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailValidationLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            view.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordValidationLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 0),
            passwordValidationLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordValidationLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            view.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor, constant: 60),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
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
                
        if let email = emailTextField.text,
            let password = passwordTextField.text,
           let userName = nameTextField.text,
//           let phone = phoneNumberTextField.text,
           validEmail, validPassword {
            spinner.show(in: view)
            AuthService.shared.createUser(withEmail: email, password: password, userName: userName) { [unowned self] result in
                var message: String = ""
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                switch result {
                case .success(_):
                    message = "User was sucessfully created."
                    self.showUIHint(message: message, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                case .failure(let failure):
                    message = failure.localizedDescription
                    self.showUIAlert(message: message)
                }
            }
        } else {
            showUIAlert(message: "Something went wrong.\nPlease check your information.")
        }
    }
    
    // MARK: Format Check
    private func setupTextField() {
        emailTextField.textValidation { [weak self] text in
            guard let strongSelf = self else {
                return
            }
            let isValidEmail = text.emailValidation()
            strongSelf.emailValidationLabel.isHidden = false
            if isValidEmail {
                self?.emailValidationLabel.text = ""
                strongSelf.validEmail = true
            }
            else {
                self?.emailValidationLabel.text = "Email is not valid"
                strongSelf.validEmail = false
            }
        }
        
        passwordTextField.textValidation { [weak self] text in
            guard let strongSelf = self else {
                return
            }
            let isValidPassword = text.passwordValidation()
            self?.passwordValidationLabel.isHidden = false
            if isValidPassword {
                self?.passwordValidationLabel.text = ""
                strongSelf.validPassword = true
            }
            else {
                self?.passwordValidationLabel.text = "At least 8 characters"
                strongSelf.validPassword = false
            }
        }
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
