import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    static let identifier = "FavoritesTableViewCell"
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        Style()
        layout()
    }
    
    private func Style() {
        contentView.backgroundColor = .systemBackground
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func layout() {
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            posterImage.widthAnchor.constraint(equalToConstant: 150),
            posterImage.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: playButton.leadingAnchor),
            
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 30),
            playButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func configure(with model: FMedia) {

        guard let url = model.imageUrl, let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(url)") else {
            return
        }
        posterImage.sd_setImage(with: posterUrl, completed: nil)
        titleLabel.text = model.caption
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
