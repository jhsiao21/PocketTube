import UIKit

protocol LinkedBtnTappedDelegate: AnyObject {
    func buttonIsPressed(tag: Int)
}

class HotNewReleaseHeaderView: UIView {
    
    let buttonWidth: CGFloat = 150
    let buttonSpacing: CGFloat = 10
    
    weak var linkedBtnTappedDelegate: LinkedBtnTappedDelegate?
        
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let popularButton: UIButton = {
        
        let button = UIButton()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        button.setAttributedTitle(NSAttributedString(string: "大家都在看", attributes: titleAttributes), for: .normal)
        
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.tag = 0
        
        // 載入圖像
        if let iconImage = UIImage(named: "fire") {
            // 調整圖像大小
            let newSize = CGSize(width: 22, height: 24) // 調整圖像大小為 40x40，您可以根據需要調整大小
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            iconImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let resizedIconImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // 設定圖像在按鈕上的位置和大小
            button.setImage(resizedIconImage, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // 調整圖像位置，如果需要
        }
        
        button.addTarget(self, action: #selector(LinkedBtTapped), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return button
    }()
    
    private let upcomingButton: UIButton = {
        let button = UIButton()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        button.setAttributedTitle(NSAttributedString(string: "即將上線", attributes: titleAttributes), for: .normal)
        
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.tag = 1
        
        // 載入圖像
        if let iconImage = UIImage(named: "popcorn") {
            // 調整圖像大小
            let newSize = CGSize(width: 22, height: 24)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            iconImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let resizedIconImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // 設定圖像在按鈕上的位置和大小
            button.setImage(resizedIconImage, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // 調整圖像位置，如果需要
        }
        
        button.addTarget(self, action: #selector(LinkedBtTapped), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 130).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return button
    }()

    private let top10TVsButton: UIButton = {
        let button = UIButton()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        button.setAttributedTitle(NSAttributedString(string: "Top 10節目", attributes: titleAttributes), for: .normal)
        
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.tag = 2
        
        // 載入圖像
        if let iconImage = UIImage(named: "Top10") {
            // 調整圖像大小
            let newSize = CGSize(width: 32, height: 32)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            iconImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let resizedIconImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // 設定圖像在按鈕上的位置和大小
            button.setImage(resizedIconImage, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // 調整圖像位置，如果需要
        }
        
        button.addTarget(self, action: #selector(LinkedBtTapped), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return button
    }()

    private let top10MoviesButton: UIButton = {
        let button = UIButton()
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .underlineStyle: NSUnderlineStyle.Element().rawValue,
        ]
        
        button.setAttributedTitle(NSAttributedString(string: "Top 10電影", attributes: titleAttributes), for: .normal)
        
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 22
        button.tag = 3
        
        // 載入圖像
        if let iconImage = UIImage(named: "Top10") {
            // 調整圖像大小
            let newSize = CGSize(width: 32, height: 32)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            iconImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let resizedIconImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // 設定圖像在按鈕上的位置和大小
            button.setImage(resizedIconImage, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // 調整圖像位置，如果需要
        }
        
        button.addTarget(self, action: #selector(LinkedBtTapped), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return button
    }()
    
    private var buttons : [UIButton] {
        let buttons = [upcomingButton, popularButton, top10TVsButton, top10MoviesButton]
        return buttons
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        selectButton(0)
    }
    
    private func layout() {
        hStackView.addArrangedSubview(popularButton)
        hStackView.addArrangedSubview(upcomingButton)
        hStackView.addArrangedSubview(top10TVsButton)
        hStackView.addArrangedSubview(top10MoviesButton)
        
        scrollView.addSubview(hStackView)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            hStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
        
    // 快速連結按鈕handler
    @objc private func LinkedBtTapped(_ sender: UIButton) {
        selectButton(sender.tag)
        linkedBtnTappedDelegate?.buttonIsPressed(tag: sender.tag)
        
        let offset = sender.tag > 1 ? sender.tag : 0
        
        // 按鈕偏移量
        let contentOffsetX = CGFloat(offset) * (buttonWidth + buttonSpacing)
        
        // scrollView的最大可移動偏移量
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        
        // 實際偏移量
        // 如果點選的按鈕對應的偏移量超過了最大偏移量，就使用最大偏移量maxOffsetX，否則使用contentOffsetX
        let actualOffsetX = min(contentOffsetX, maxOffsetX)
        
        scrollView.setContentOffset(CGPoint(x: actualOffsetX, y: 0), animated: true)
        
    }
    
    private func selectButton(_ selected: Int) {
        //        print("selected:\(selected)")
        for button in buttons {
            
            button.backgroundColor = .systemBackground
            button.setTitleColor(UIColor.white, for: .normal)
            
            if button.tag == selected {
                button.backgroundColor = .white
                button.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    
    func linkToSelectionBtn(btnIdx: Int) {
        print("btnIdx:\(btnIdx)")
        
        selectButton(btnIdx)
        
        let offset = btnIdx > 1 ? btnIdx : 0
        
        // 按鈕偏移量
        let contentOffsetX = CGFloat(offset) * (buttonWidth + buttonSpacing)
        
        // scrollView的最大可移動偏移量
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        
        // 實際偏移量
        // 如果點選的按鈕對應的偏移量超過了最大偏移量，就使用最大偏移量maxOffsetX，否則使用contentOffsetX
        let actualOffsetX = min(contentOffsetX, maxOffsetX)
        
        scrollView.setContentOffset(CGPoint(x: actualOffsetX, y: 0), animated: true)
    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        scrollView.isHidden = true
//        print("x:\(scrollView.contentOffset.x)")
//    }
}
