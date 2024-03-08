//
//  HotNewReleaseTableViewCell.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/8/18.
//

import UIKit

class UpcomingCell: UITableViewCell {
    
    weak var contentActionButtonDelegate: ContentActionButtonDelegate?
    
    static let identifier = "UpcomingCell"
    
    private var media: Media?
    
    private let vStackViewDate : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        
        return stackView
    }()
    
    private let hStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let vStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let hStackViewUnderPosterImage : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 0
        
        return stackView
    }()
    
    private let monthLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = .label
        textLabel.font = UIFont.systemFont(ofSize: 12)
        return textLabel
    }()
    
    private let dayLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = .label
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return textLabel
    }()
    
    private let dateLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textColor = .label
        textLabel.font = UIFont.systemFont(ofSize: 15)
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
        
    private let reminderBtn: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "bell", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        let attributedTitle = NSAttributedString(string: "提醒我", attributes: titleAttributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(remindMeBtnTapped), for: .touchUpInside)
        
        return button
    }()

    private let infoBtn: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "info.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        let attributedTitle = NSAttributedString(string: "資訊", attributes: titleAttributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(infoBtnTapped), for: .touchUpInside)
        
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
        
        vStackViewDate.addArrangedSubview(monthLabel)
        vStackViewDate.addArrangedSubview(dayLabel)
        hStackView.addArrangedSubview(vStackViewDate)
        
        hStackView.addArrangedSubview(vStackView)
        
        hStackViewUnderPosterImage.addArrangedSubview(reminderBtn)
        hStackViewUnderPosterImage.addArrangedSubview(infoBtn)
        
        vStackView.addArrangedSubview(posterImageView)
        vStackView.addArrangedSubview(hStackViewUnderPosterImage)
        vStackView.addArrangedSubview(dateLabel)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(overviewLabel)
        vStackView.addArrangedSubview(genreLabel)
        
        contentView.addSubview(hStackView)
        
        applyConstraints()
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            //與下一個cell的距離
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            
            // horizontalStackView 在 cell 内的约束
            hStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // posterImageView 的宽度和高度约束
            posterImageView.widthAnchor.constraint(equalToConstant: 350),
            posterImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // dateHeaderLabel 的约束
            monthLabel.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.1), // Adjust as needed
            
            // horizontalStackViewUnderPosterImage 的约束
            hStackViewUnderPosterImage.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            hStackViewUnderPosterImage.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            
            // shareBtn
            reminderBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 220),
            
            // dateLabel 的约束
//            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            dateLabel.leadingAnchor.constraint(equalTo: hStackViewUnderPosterImage.leadingAnchor),
            
            // titleLabel 的约束
            
            titleLabel.leadingAnchor.constraint(equalTo: hStackViewUnderPosterImage.leadingAnchor),
            
            // overviewLabel 的约束
//            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -10),
            overviewLabel.leadingAnchor.constraint(equalTo: hStackViewUnderPosterImage.leadingAnchor),
            
            //genreLabel
            genreLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor)
        ])
    }

    
    public func configure(with media: Media) {

        guard let url = media.poster_path,
              let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(url)"),
              let date = media.release_date,
              let overview = media.overview,
              let genre = media.genre_ids else {
            return
        }
        
        self.media = media
        posterImageView.sd_setImage(with: posterUrl, completed: nil)
        monthLabel.text = date.getMonth()
        dayLabel.text = date.getDay()
        dateLabel.text = date.formatDate()
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
    
    @objc private func remindMeBtnTapped() {
        print("remindMeBtnTapped")
    }
    
    @objc private func infoBtnTapped() {
        print("infoBtnTapped")
    }
}
