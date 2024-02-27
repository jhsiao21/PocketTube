//
//  NaviBarConfiguration.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/12/25.
//

import UIKit

protocol SearchViewControllerPresentDelegate: AnyObject {
    func pushSearchVC()
}

class NaviBarConfigView: UIView {
    
    weak var pushSearchViewDelegate: SearchViewControllerPresentDelegate?
        
    private let hStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .lastBaseline
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
                
        button.setImage(UIImage(named: "userIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        posterImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func airplayButtonTapped() {
        print("airplay button is pressed")
    }
        
    @objc func searchButtonTapped() {
        
        pushSearchViewDelegate?.pushSearchVC()
        
//        DispatchQueue.main.async {
//            let vc = SearchViewController.shared
//            
//            //按下搜尋後隱藏標籤列
//            vc.hidesBottomBarWhenPushed = true
//            UINavigationController().pushViewController(vc, animated: true)
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @objc func userButtonTapped() {
        print("user button is pressed")
    }

}
