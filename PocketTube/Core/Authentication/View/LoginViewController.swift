//
//  LoginViewController.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/1/25.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
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
        label.text = "Log In"
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
        textField.placeholder = "E-mail"
        textField.textContentType = .emailAddress
        textField.clipsToBounds = true
        textField.returnKeyType = .continue
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var passwordTextField: ATCTextField = {
        let textField = ATCTextField()
        textField.configure(color: textFieldColor,
                            font: textFieldFont,
                            cornerRadius: 55/2,
                            borderColor: textFieldBorderColor,
                            backgroundColor: backgroundColor,
                            borderWidth: 1.0)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var forgotButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.addTarget(self, action: #selector(didTapForgotButton), for: .touchUpInside)
        button.configure(color: textFieldColor,
                         font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                         cornerRadius: 0,
                         backgroundColor: LoginViewController.backgroundColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.configure(color: LoginViewController.backgroundColor,
                         font: buttonFont,
                         cornerRadius: 55/2,
                         backgroundColor: tintColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var separatorLabel: UILabel = {
        let label = UILabel()
        label.font = separatorFont
        label.textColor = separatorTextColor
        label.text = "OR"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var facebookButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue With Facebook", for: .normal)
        button.setImage(UIImage(named: "facebook"), for: .normal)
        button.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
        button.configure(color: textFieldColor,
                         font: buttonFont,
                         cornerRadius: 55/2,
                         backgroundColor: UIColor(red: 51/255, green: 77/255, blue: 146/255, alpha: 1))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var googleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue With Google", for: .normal)
        button.setImage(UIImage(named: "google"), for: .normal)
        button.addTarget(self, action: #selector(didTapGoogleButton), for: .touchUpInside)
        button.configure(color: textFieldColor,
                         font: buttonFont,
                         cornerRadius: 55/2,
                         backgroundColor: UIColor(red: 51/255, green: 77/255, blue: 146/255, alpha: 1))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LoginViewController.backgroundColor
        
        self.hideKeyboardWhenTappedAround()
        layout()
    }
    
    private func layout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(forgotButton)
        view.addSubview(loginButton)
        view.addSubview(separatorLabel)
        view.addSubview(facebookButton)
        view.addSubview(googleButton)
        
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
            
            view.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 25),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 55),
            
            view.trailingAnchor.constraint(equalTo: forgotButton.trailingAnchor, constant: 30),
            forgotButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgotButton.heightAnchor.constraint(equalToConstant: 32),
            
            view.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 50),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 55),
            
            separatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 55),
            
            view.trailingAnchor.constraint(equalTo: facebookButton.trailingAnchor, constant: 50),
            facebookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            facebookButton.topAnchor.constraint(equalTo: separatorLabel.bottomAnchor, constant: 38),
            facebookButton.heightAnchor.constraint(equalToConstant: 55),
            
            view.trailingAnchor.constraint(equalTo: googleButton.trailingAnchor, constant: 50),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            googleButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 10),
            googleButton.heightAnchor.constraint(equalToConstant: 55),
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
    
    @objc func didTapForgotButton() {
        let forgotPwdVC = ForgotPasswordViewController()
        self.navigationController?.pushViewController(forgotPwdVC, animated: true)
    }
    
    @objc func didTapLoginButton() {
        spinner.show(in: view)
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        AuthService.shared.login(email: email, password: password) { [unowned self] result in
            switch result {
            case .success(let success):
                
                UserService.shared.fetchCurrentUser { [unowned self] result in
                    DispatchQueue.main.async {
                        self.spinner.dismiss()
                    }
                    switch result {
                    case .success(let user):
                        guard let user = user as? User else { return }
                        
                        UserDefaults.standard.set(user.email, forKey: "email")
                        UserDefaults.standard.set(user.userName, forKey: "name")
                        self.loginSuccess()
                        
                    case .failure(let error):
                        self.showUIAlert(message: error.localizedDescription)
                    }
                }
                
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                self.showUIAlert(message: error.localizedDescription)
            }
        }
    }
    
    @objc func didTapFacebookButton() {
        spinner.show(in: view)
        let loginManager = LoginManager()
        // 添加 public_profile 到請求的權限中，以便獲取姓名和頭像
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { [unowned self] (result, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                self.showUIAlert(message: error.localizedDescription)
                return
            }
            guard let token = AccessToken.current else {
                print("Failed to get access token")
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                self.showUIAlert(message: "Failed to get access token")
                return
            }
            
            // 使用Graph API獲取用戶資訊
            let fbRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                       parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
                                                       tokenString: token.tokenString,
                                                       version: nil,
                                                       httpMethod: .get)
            // execute request
            fbRequest.start { _, result, error in
                guard let result = result as? [String : Any], error == nil else {
                    print("Failed to make facebook graph request")
                    return
                }
                
                print(result)
                
                /*
                 ["picture": {
                 data =     {
                 height = 200;
                 "is_silhouette" = 0;
                 url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10221311206604346&height=200&width=200&ext=1709036862&hash=AfrfPeu_ZxQ22YY0yuqSYna06coTMyG04g-3QWAHpfMvHA";
                 width = 200;
                 };
                 }, "first_name": Logan, "last_name": Hsiao, "email": jhsiao1121@gmail.com, "id": 10221311206604346]
                 */
                
                guard let firstName = result["first_name"] as? String,
                      let email = result["email"] as? String,
                      let picture = result["picture"] as? [String: Any],
                      let data = picture["data"] as? [String: Any],
                      let pictureUrl = data["url"] as? String else {
                    print("Failed to get email and name from fb result")
                    return
                }
                
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set("\(firstName)", forKey: "name")
                
                AuthService.shared.login(credential: FacebookAuthProvider.credential(withAccessToken: token.tokenString)) { [unowned self] result in
                    switch result {
                    case .success(_):
                        
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        UserService.fetchUser(withUid: uid) { [unowned self] user, error in
                            DispatchQueue.main.async {
                                self.spinner.dismiss()
                            }
                            
                            if let user = user, error == nil {
                                // user exists
                                print("user data: \(user)")
                                self.loginSuccess()
                            }
                            else { // user does not exists
                                AuthService.shared.uploadUserData(email: email, userName: "\(firstName)", phone: "N/A", id: uid) { [unowned self] result in
                                    switch result {
                                    case .success(_):
                                        print("upload user data to firestore database success")
                                        self.loginSuccess()
                                    case .failure(let failure):
                                        self.showUIAlert(message: failure.localizedDescription)
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.spinner.dismiss()
                        }
                        self.showUIAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @objc private func didTapGoogleButton() {
        spinner.show(in: view)
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                self.showUIAlert(message: error.localizedDescription)
                return
            }
            
            //unwrap the token from Google
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("User failed to log in with google")
                return
            }
            
            print("Did sign in with Google: \(user)")
            
            guard let email = user.profile?.email,
                  let firstName = user.profile?.givenName,
                  let lastName = user.profile?.familyName  else { return }
            
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set("\(firstName)", forKey: "name")
            
            AuthService.shared.login(credential: GoogleAuthProvider.credential(withIDToken: idToken,
                                                                               accessToken: user.accessToken.tokenString)) { [unowned self] result in
                switch result {
                case .success(_):
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    UserService.fetchUser(withUid: uid) { user, error in
                        DispatchQueue.main.async {
                            self.spinner.dismiss()
                        }
                        
                        if let user = user, error == nil {
                            // user exists
                            print("user data: \(user)")
                            self.loginSuccess()
                        }
                        else { // user does not exists
                            AuthService.shared.uploadUserData(email: email, userName: "\(firstName)", phone: "N/A", id: uid) { [unowned self] result in
                                switch result {
                                case .success(_):
                                    print("upload user data to firestore database success")
                                    self.loginSuccess()
                                case .failure(let failure):
                                    self.showUIAlert(message: failure.localizedDescription)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.spinner.dismiss()
                    }
                    self.showUIAlert(message: error.localizedDescription)
                }
            }
        }
    }
}
extension LoginViewController {
    
    func showPopup(isSuccess: Bool) {
        let successMessage = "User was sucessfully logged in."
        let errorMessage = "Something went wrong. Please try again"
        let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { [unowned self] action in
            NotificationCenter.default.post(name: .didRefresh, object: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginSuccess() {
        NotificationCenter.default.post(name: .didRefresh, object: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController {
    private static let backgroundColor = UIColor.mainThemeBackgroundColor
    private static let tintColor = UIColor(red: 255/255, green: 90/255, blue: 102/255, alpha: 1)
    
    private static let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private static let buttonFont = UIFont.boldSystemFont(ofSize: 18)
    
    private static let textFieldFont = UIFont.systemFont(ofSize: 16)
    private static let textFieldColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    private static let textFieldBorderColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    
    private static let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private static let separatorTextColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
}
