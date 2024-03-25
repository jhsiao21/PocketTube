import UIKit
import WebKit

protocol MediaPreviewView: BaseView {}

class MediaPreviewViewController: UIViewController, UIScrollViewDelegate, MediaPreviewView {
    
    private let mediaModel: YoutubePreviewModel
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry potter"
        return label
    }()
    
    private let overviewLabel: UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "This is the best movie ever to watch as a kid!"
        return label
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    private func configureNavbar() {
        let xmarkBtn = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(closeButtonTapped))
        xmarkBtn.tintColor = .label
        
        navigationItem.rightBarButtonItems = [
            xmarkBtn
        ]
        
        //適應dark mode or light mode
//        navigationController?.navigationBar.tintColor = .label
        
    }
    
    // 关闭按钮的动作方法
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    init(mediaModel: YoutubePreviewModel) {
        self.mediaModel = mediaModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
                
        layout()
        
        DispatchQueue.main.async {
            self.show()
        }
        
    }
    
    func layout() {
                
        view.addSubview(scrollView)
        scrollView.addSubview(webView)
        scrollView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(overviewLabel)
        configureNavbar()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: scrollView.trailingAnchor, multiplier: 1),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        
            webView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            webView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            
            verticalStackView.topAnchor.constraint(equalTo: webView.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
    }
    
    public func show() {
        titleLabel.text = self.mediaModel.title
        overviewLabel.text = self.mediaModel.titleOverview
        
        guard let videoId = self.mediaModel.youtubeView.id.videoId,
              let url = URL(string: "https://www.youtube.com/embed/\(videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }

}
