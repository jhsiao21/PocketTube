import UIKit
import FirebaseAuth

protocol NaviBarDelegate: AnyObject {
    func airPlayBtnTap()
    func searchBtnTap()
    func userIconBtnTap()
}

class NaviBarConfigView: UIView {
    
    weak var naviBarDelegate: NaviBarDelegate?
        
    private let hStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    public let pageTitleLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor.label
        label.sizeToFit() // 依據內容調整label大小
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
        
    //投影
    private let airplayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let originalImage = UIImage(systemName: "airplayvideo")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 26, height: 26)).image { _ in
            originalImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 26, height: 26)))
        }.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)    //resizedImage再次指定渲染模式，不然圖片不會出現
        
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(airplayButtonTapped), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 26).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        return button
    }()
    
    //搜尋
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let originalImage = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
        let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 26, height: 26)).image { _ in
            originalImage?.draw(in: CGRect(origin: .zero, size: CGSize(width: 26, height: 26)))
        }.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)    //resizedImage再次指定渲染模式，不然圖片不會出現
        
        button.setImage(resizedImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 26).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        return button
    }()
    
    //用戶
    private let userButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
                
//        button.setImage(UIImage(named: "userIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(userButtonTapped), for: .touchUpInside)
        button.tintColor = .clear //因為是用圖片
        
        button.widthAnchor.constraint(equalToConstant: 26).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("NaviBarConfigView init()")
        style()
        layout()
        setupProfileImage()
        
        /// 監聽didRefresh通知
        NotificationCenter.default.addObserver(forName: .didRefresh, object: nil, queue: nil) { [weak self] _ in
            self?.setupProfileImage()
        }
    }
    
    private func style() {
        
    }
    
    private func layout() {
        
        hStackView.addArrangedSubview(pageTitleLabel)
        hStackView.addArrangedSubview(UIView()) //spacer
        hStackView.addArrangedSubview(airplayButton)
        hStackView.addArrangedSubview(searchButton)
        hStackView.addArrangedSubview(userButton)

        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ])
    }
    
    private func setupProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid as? String else {
            return
        }
        
        if let profileURL = UserDefaults.standard.value(forKey: "profileURL") as? String {
            let url = URL(string: profileURL)
            let profileImg = UIImageView()
            profileImg.sd_setImage(with: url, placeholderImage: UIImage(named: "userIcon")) { [weak self] image, error, _, _ in
                self?.userButton.setImage(profileImg.image, for: .normal)
            }
        } else {
            let path = "profile_images/\(uid)-pic.png"
            
            StorageManager.shared.downloadURL(for: path) { [weak self] result in
                
                switch result {
                case .success(let url):
                    let profileImg = UIImageView()
                    profileImg.sd_setImage(with: url) { [weak self] image, error, _, _ in
                        self?.userButton.setImage(profileImg.image, for: .normal)
                    }
                case .failure(let failure):
                    print("Failed to get download url: \(failure)")
                    self?.userButton.setImage(UIImage(named: "userIcon"), for: .normal)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        posterImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func airplayButtonTapped() {
        print("airplay button is pressed")
        naviBarDelegate?.airPlayBtnTap()
    }
        
    @objc func searchButtonTapped() {
        print("search button is pressed")
        naviBarDelegate?.searchBtnTap()
    }
    
    @objc func userButtonTapped() {
        print("user button is pressed")
        naviBarDelegate?.userIconBtnTap()
    }
}
