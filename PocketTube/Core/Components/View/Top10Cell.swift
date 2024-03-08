//
//  Top10.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/7.
//

import UIKit
import FirebaseAuth
import Firebase

class Top10Cell: UITableViewCell {
    
    weak var contentActionButtonDelegate: ContentActionButtonDelegate?
        
    static let identifier = "Top10Cell"
    
    private var media: Media?
    
    private let horizontalStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top // 设置对齐方式
        stackView.spacing = 8 // 设置视图之间的间隔
        
        return stackView
    }()
    
    private let verticalStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical // 设置垂直方向布局
        stackView.alignment = .trailing // 设置对齐方式为居中
        stackView.spacing = 10 // 设置视图之间的间隔
        
        return stackView
    }()
    
    private let horizontalStackViewUnderPosterImage : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 0
        
        return stackView
    }()
    
    private let indexHeaderLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = .label
        textLabel.font = UIFont.boldSystemFont(ofSize: 28)
        return textLabel
    }()
        
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //設定clipsToBounds（修剪至邊界），可以避免圖片延伸到其他表格視圖Cell
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        return imageView
    }()
    
    private let shareBtn: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        
        // 建立一個屬性字典來設置按鈕內文字的樣式，移除下底線
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        let attributedTitle = NSAttributedString(string: "分享", attributes: titleAttributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
        
        return button
    }()

    private let watchListBtn: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        
        // 建立一個屬性字典來設置按鈕內文字的樣式，移除下底線
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        let attributedTitle = NSAttributedString(string: "加入口袋名單", attributes: titleAttributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(myWatchListBtnTapped), for: .touchUpInside)
        
        return button
    }()

    private let playBtn: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        
        // 建立一個屬性字典來設置按鈕內文字的樣式，移除下底線
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        let attributedTitle = NSAttributedString(string: "播放", attributes: titleAttributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(playBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = .label
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return textLabel
    }()
    
    private let overviewLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.lightGray
        textLabel.font = UIFont.systemFont(ofSize: 14)
        return textLabel
    }()
    
    private let genreLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 12)
        return textLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }

    private func layout() {
        
        horizontalStackView.addArrangedSubview(indexHeaderLabel)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        horizontalStackViewUnderPosterImage.addArrangedSubview(shareBtn)
        horizontalStackViewUnderPosterImage.addArrangedSubview(watchListBtn)
        horizontalStackViewUnderPosterImage.addArrangedSubview(playBtn)
        
        verticalStackView.addArrangedSubview(posterImageView)
        verticalStackView.addArrangedSubview(horizontalStackViewUnderPosterImage)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(overviewLabel)
        verticalStackView.addArrangedSubview(genreLabel)
        
        contentView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            //與下一個cell的距離
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            
            // horizontalStackView 在 cell 内的约束
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // posterImageView 的宽度和高度约束
            posterImageView.widthAnchor.constraint(equalToConstant: 350),
            posterImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // dateHeaderLabel 的约束
            indexHeaderLabel.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: 0.1), // Adjust as needed
            
            // horizontalStackViewUnderPosterImage 的约束
            horizontalStackViewUnderPosterImage.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            horizontalStackViewUnderPosterImage.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            
            // shareBtn
            shareBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 170),
            
            // titleLabel 的约束
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: horizontalStackViewUnderPosterImage.leadingAnchor),
            
            // overviewLabel 的约束
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -10),
            overviewLabel.leadingAnchor.constraint(equalTo: horizontalStackViewUnderPosterImage.leadingAnchor),
            
            //genreLabel
            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor)
            
        ])
    }

    
    public func configure(with media: Media, index: Int) {

        guard let url = media.poster_path,
              let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(url)"),
              let overview = media.overview,
              let genre = media.genre_ids else {
            return
        }
        
        self.media = media
        indexHeaderLabel.text = String(index + 1)
        posterImageView.sd_setImage(with: posterUrl, completed: nil)
        titleLabel.text = media.displayTitle
        overviewLabel.text = overview.briefOverview()
        genreLabel.text = getMovieGenreNames(for: genre)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .systemBackground
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func shareBtnTapped() {
        print("shareBtnTapped")
        
        guard let mediaTitle = media?.displayTitle,
              let image = posterImageView.image else {
            return
        }
                
        contentActionButtonDelegate?.didTappedShareBtn(mediaName: mediaTitle, image: image)
    }
    
    @objc private func myWatchListBtnTapped() {
        print("myWatchListBtnTapped")
        
        guard let uid = Auth.auth().currentUser?.uid,
              let mediaTitle = media?.displayTitle,
              let imageUrl = media?.poster_path,
              let overview = media?.overview else {
            return
        }        
        
        let media = FMedia(ownerUid: uid, caption: mediaTitle, timestamp: Timestamp(), imageUrl: imageUrl, overview: overview, mId: NSUUID().uuidString)
        
        contentActionButtonDelegate?.didTappedWatchListBtn(uid: uid, media: media)        
    }
    
    @objc private func playBtnTapped() {
        print("playBtnTapped")
                
        guard let mediaTitle = media?.displayTitle,
              let mediaOverview = media?.overview else {
            return
        }
                
        contentActionButtonDelegate?.didTappedPlayBtn(mediaName: mediaTitle, mediaOverview: mediaOverview)
    }
}
