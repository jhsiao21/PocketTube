//
//  Popular.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/7.
//

import UIKit
import Firebase
import FirebaseAuth

class PopularCell: UITableViewCell {
    
    weak var contentActionButtonDelegate: ContentActionButtonDelegate?
        
    static let identifier = "PopularCell"
    
    private var media: Media?
            
    private let vStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //設定clipsToBounds（修剪至邊界），可以避免圖片延伸到其他表格視圖Cell
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        
//        imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        return imageView
    }()
    
    private let hStackViewUnderPosterImage : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 0
        
        return stackView
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

    private let vStackViewMargin : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.sizeToFit()
        textLabel.textColor = .label
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return textLabel
    }()
    
    private let overviewLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.lightGray
        textLabel.font = UIFont.systemFont(ofSize: 16)
        return textLabel
    }()
    
    private let genreLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 14)
        return textLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        vStackView.addArrangedSubview(posterImageView)
        
        hStackViewUnderPosterImage.addArrangedSubview(UIView())
        hStackViewUnderPosterImage.addArrangedSubview(shareBtn)
        hStackViewUnderPosterImage.addArrangedSubview(watchListBtn)
        hStackViewUnderPosterImage.addArrangedSubview(playBtn)
        
        
        vStackView.addArrangedSubview(hStackViewUnderPosterImage)
        vStackView.addArrangedSubview(vStackViewMargin)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(overviewLabel)
        vStackView.addArrangedSubview(genreLabel)
        
        contentView.addSubview(vStackView)
        
        applyConstraints()
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            //與下一個cell的距離
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
                        
            posterImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            posterImageView.heightAnchor.constraint(equalToConstant: 250),
            
        ])
    }

    
    public func configure(_ media: Media) {

        guard let url = media.poster_path,
              let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(url)"),
              let overview = media.overview,
              let genre = media.genre_ids else {
            return
        }
        
        self.media = media
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
