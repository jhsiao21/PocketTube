//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 01/12/2021.
//

import UIKit
import Firebase

class AdHeaderUIView: UIView {
    
    private var media: Media?
    
    weak var showAlertDelegate: ShowAlertDelegate?
    weak var contentActionButtonDelegate: ContentActionButtonDelegate?
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let tvButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .large
        configuration.attributedTitle = AttributedString("節目", attributes: AttributeContainer())
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(tvButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
        
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return button
    }()

    private let movieButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .large
        configuration.attributedTitle = AttributedString("電影", attributes: AttributeContainer())
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(movieButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
        
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return button
    }()

    //類別按鈕
    private let typeButton:UIButton = {
        var configuration = UIButton.Configuration.plain()
//        configuration.cornerStyle = .capsule
//        configuration.baseBackgroundColor = UIColor.systemBackground
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .large
        configuration.attributedTitle = AttributedString("類別", attributes: AttributeContainer())
        configuration.imagePadding = 5
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14)
        configuration.imagePlacement = .trailing
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(typeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
        
//        // 約束寬度
//        button.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        // 約束高度
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return button
    }()
        
    private let playButton: UIButton = {
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 14)
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .small
        configuration.background.cornerRadius = 2
        configuration.baseBackgroundColor = UIColor.white
        configuration.baseForegroundColor = UIColor.black
        configuration.buttonSize = .large
        configuration.attributedTitle = AttributedString("播放", attributes: container)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)

        configuration.imagePadding = 10
        configuration.image = UIImage(systemName: "play.fill")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        configuration.imagePlacement = .leading
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(playBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        
        // 約束寬度
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2 - 40).isActive = true
        // 約束高度
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return button
    }()

    private let myWatchistButton: UIButton = {
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 14)
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .small
        configuration.background.cornerRadius = 2
        configuration.baseBackgroundColor = UIColor.gray
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .large
        configuration.attributedTitle = AttributedString("我的口袋名單", attributes: container)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)

        configuration.imagePadding = 10
        configuration.image = UIImage(systemName: "plus")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        configuration.imagePlacement = .leading
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(myWatchListBtnTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        
        // 約束寬度
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2 - 40).isActive = true
        // 約束高度
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return button
    }()

    //電影海報
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //在AspectFill模式下，圖片視圖縮放圖片符合視圖尺寸。長寬比保持不變，所以圖片有一部份可能無法顯示．當圖片以這模式來縮放，它會與底下的表格視圖Cell重疊
        imageView.contentMode = .scaleAspectFill
        //設定clipsToBounds（修剪至邊界），可以避免圖片延伸到表格視圖Cell
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.white.cgColor
        
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
//    let apiClient: APIManagerProtocol

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configureHeroHeaderView()
    }
    
    private func layout() {
        
//        hStackView.addArrangedSubview(tvButton)
//        hStackView.addArrangedSubview(movieButton)
//        hStackView.addArrangedSubview(typeButton)
//        hStackView.addArrangedSubview(UIView())

//        vStackView.addArrangedSubview(hStackView)
        
        
        vStackView.addArrangedSubview(posterImageView)
        addSubview(vStackView)
        addSubview(playButton)
        addSubview(myWatchistButton)
        
        NSLayoutConstraint.activate([
            
            playButton.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 15),
            playButton.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -15),
            
            myWatchistButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -15),
            myWatchistButton.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -15),
            
            vStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    @objc func tvButtonTapped() {
        print("Tv button is pressed")
    }
    
    @objc func movieButtonTapped() {
        print("Movie button is pressed")
    }
    
    @objc func typeButtonTapped() {
        print("Type button is pressed")
    }
    
    @objc private func myWatchListBtnTapped() {
        print("myWatchListBtnTapped")
        
        guard let uid = Auth.auth().currentUser?.uid,
              let mediaTitle = media?.original_title ?? media?.original_name,
              let imageUrl = media?.poster_path,
              let overview = media?.overview else {
            return
        }
        
        let media = FMedia(ownerUid: uid, caption: mediaTitle, timestamp: Timestamp(), imageUrl: imageUrl, overview: overview, mId: NSUUID().uuidString)
        
        contentActionButtonDelegate?.didTappedWatchListBtn(uid: uid, media: media)
    }
    
    @objc private func playBtnTapped() {
        print("playBtnTapped")
        
        guard let media = self.media,
              let mediaTitle = media.original_title ?? media.original_name else { return }
                
        contentActionButtonDelegate?.didTappedPlayBtn(mediaName: "\(mediaTitle)", mediaOverview: media.overview)
    }
    
    private func configureHeroHeaderView() {

        APIManager.shared.fetchTrendingMovies { [weak self] result in
            switch result {
            case .success(let medias):
                if let media = medias.randomElement() {
                    self?.media = media
                    
                    guard let posterUrl = self?.media?.poster_path else { return }
                    let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterUrl)")
                    self?.posterImageView.sd_setImage(with: url, completed: nil)
                } else {
                    self?.showAlertDelegate?.showAlert(msg: APIError.failedToGetData.errorDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlertDelegate?.showAlert(msg: error.localizedDescription)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        posterImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
