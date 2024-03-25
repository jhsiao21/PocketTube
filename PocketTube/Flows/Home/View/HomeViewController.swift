import UIKit
import FirebaseAuth
import JGProgressHUD

protocol HomeView: BaseView {
    var onAirPlayButtonTap: (() -> Void)? { get set }
    var onSearchButtonTap: (() -> Void)? { get set }
    var onUserIconButtonTap: (() -> Void)? { get set }
    var onMediaPlay: ((YoutubePreviewModel) -> Void)? { get set }
}

class HomeViewController: UIViewController, HomeView {
    var onAirPlayButtonTap: (() -> Void)?
    var onSearchButtonTap: (() -> Void)?
    var onUserIconButtonTap: (() -> Void)?
    var onMediaPlay: ((YoutubePreviewModel) -> Void)?
    
    private lazy var viewModel: HomeViewModel = {
        let vm = HomeViewModel(dataProvider: APIManager.shared)
        vm.delegate = self
        return vm
    }()
    
    private var advertisingView : AdHeaderUIView?
    private var naviBarConfigView = NaviBarConfigView()
    private let spinner = JGProgressHUD(style: .dark)
    private let sections: [String] = Sections.allCases.map { $0.caseDescription }
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        tabBarController?.delegate = self
        naviBarConfigView.naviBarDelegate = self
        
        viewModel.isLoading = { [unowned self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.spinner.show(in: self.view)
                } else {
                    self.spinner.dismiss()
                }
            }
        }
        
        viewModel.fetchData()
        
        /// 監聽didRefresh通知
        NotificationCenter.default.addObserver(forName: .didRefresh, object: nil, queue: nil) { [weak self] _ in
            self?.style()
        }
    }
    
    private func style() {
        guard let name = UserDefaults.standard.value(forKey: "name") as? String else { return }
        naviBarConfigView.pageTitleLabel.text = "\(name)，歡迎您"
    }
    
    private func layout() {
        view.addSubview(homeFeedTable)
        navigationItem.titleView = naviBarConfigView
                
        //表格視圖頭部設置AdHeaderUIView
        advertisingView = AdHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        advertisingView?.showAlertDelegate = self
        advertisingView?.contentActionButtonDelegate = viewModel
        homeFeedTable.tableHeaderView = advertisingView
        
        NSLayoutConstraint.activate([
            naviBarConfigView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //只有一個UITableView，所以設定frame為view.bounds
        homeFeedTable.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - HomeViewModel Delegate
extension HomeViewController: HomeViewModelDelegate {
    func homeViewModel(didPlayMedia model: YoutubePreviewModel) {
        onMediaPlay?(model)
    }
    
    func homeViewModel(didShareMedia name: String, youtubeUrl: URL, posterImg: UIImage) {
        // there's no share function in home view
    }
    
    func homeViewModel(didFavoriteMediaResponse response: FavoriteResponse) {
        showUIHint(message: response.caseDescription)
    }
    
    func homeViewModel(didReceiveData mediaData: [String : [Media]]) {
        viewModel.mediaData = mediaData
        self.homeFeedTable.reloadData()
    }
    
    func homeViewModel(didReceiveError error: Error) {
        viewModel.delegate?.homeViewModel(didReceiveError: error)
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    //每個section（主題）內只有一列，用來放collectionView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let media = viewModel.mediaData["\(sections[indexPath.section])"] else
        {
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.contentActionButtonDelegate = viewModel
        cell.configure(with: media)
        print("cell section:\(indexPath.section)")
                        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "\(sections[section])" // 設置每個section的Header
        headerView.addSubview(label)
        
        // 添加 label 的約束
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
}

//MARK: - TabBarController delegate
extension HomeViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Haptic.shared.vibrate(feedbackStyle: .light)
    }
}
// MARK: - 搜尋按鈕按下的觸發
extension HomeViewController: NaviBarDelegate {
    func airPlayBtnTap() {
        onAirPlayButtonTap?()
    }
    
    func searchBtnTap() {
        onSearchButtonTap?()
    }
    
    func userIconBtnTap() {
        onUserIconButtonTap?()
    }
    
    func pushSearchVC() {
        onSearchButtonTap?()
    }
}

// MARK: - Show alert delegate
extension HomeViewController: ShowAlertDelegate {
    func showAlert(error: Error) {
        viewModel.delegate?.homeViewModel(didReceiveError: error)
        print(error.localizedDescription)
    }
}
