import UIKit

protocol LandingScreenView: BaseView {
    var onLogInButtonTap: (() -> Void)? { get set }
    var onSignUpButtonTap: (() -> Void)? { get set }
}

class LandingScreenViewController: UIViewController, LandingScreenView {
    
    var onLogInButtonTap: (() -> Void)?
    var onSignUpButtonTap: (() -> Void)?
    
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "1024px_pocket_icon")
        imageView.tintColor = LandingScreenViewController.tintColor
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = titleFont
        titleLabel.text = "PocketTube"
        titleLabel.textColor = UIColor.mainTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = subtitleFont
        label.text = "Save your favorite media in Pocket."
        label.textColor = UIColor.mainTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.configure(color: .white,
                         font: buttonFont,
                         cornerRadius: 55/2,
                         backgroundColor: LandingScreenViewController.tintColor)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.configure(color: signUpButtonColor,
                         font: buttonFont,
                         cornerRadius: 55/2,
                         borderColor: signUpButtonBorderColor,
                         backgroundColor: UIColor.white,
                         borderWidth: 1)
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.mainThemeBackgroundColor
        layout()
    }
    
    private func layout() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 12),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 23),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 50),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.trailingAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.trailingAnchor, constant: 50),
            
            view.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 50),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 45.5),
            loginButton.heightAnchor.constraint(equalToConstant: 55),
            
            view.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor, constant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 23),
            signUpButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func didTapLoginButton() {
        onLogInButtonTap?()
    }
    
    @objc private func didTapSignUpButton() {
        onSignUpButtonTap?()
    }
}

extension LandingScreenViewController {
    private static let tintColor = UIColor(red: 255/255, green: 90/255, blue: 102/255, alpha: 1)
    private static let subtitleColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
    private static let signUpButtonColor = UIColor(red: 65/255, green: 70/255, blue: 101/255, alpha: 1)
    private static let signUpButtonBorderColor = UIColor(red: 176/255, green: 179/255, blue: 198/255, alpha: 1)
    
    private static let backgroundColor: UIColor = .white
    
    private static let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private static let subtitleFont = UIFont.boldSystemFont(ofSize: 18)
    private static let buttonFont = UIFont.boldSystemFont(ofSize: 24)
}
