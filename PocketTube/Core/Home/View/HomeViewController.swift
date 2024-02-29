//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 04/11/2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class HomeViewController: UIViewController {

    private lazy var viewModel: HomeViewModel = {
        let vm = HomeViewModel(dataProvider: APIManager.shared)
        vm.delegate = self
        return vm
    }()
    
    private var advertisingView : AdHeaderUIView?
    private var naviBarConfigView = NaviBarConfigView()
    private let spinner = JGProgressHUD(style: .dark)
        
    /*
    定義一個constant的閉包，並且透過()立即執行閉包
    let constant = {
        //closure content
    }()
     
     定義一個constant的閉包，稍後可透過constant()執行閉包
     let constant = {
         //closure content
     }
     
     constant()
    */
    
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
        naviBarConfigView.pushSearchViewDelegate = self
        
        spinner.show(in: view)
        viewModel.fetchData()
        
//        spinner.show(in: view)
//        viewModel.fetchData { [weak self] result in
//            switch result {
//            case .success(_):
//                self?.spinner.dismiss()
//                self?.homeFeedTable.reloadData()
//            case .failure(let error):
//                self?.spinner.dismiss()
//                self?.showUIAlert(message: error.localizedDescription)
//            }
//        }
        
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
        advertisingView?.contentActionButtonDelegate = self
        homeFeedTable.tableHeaderView = advertisingView
        
        NSLayoutConstraint.activate([
            naviBarConfigView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
//            homeFeedTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            homeFeedTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            homeFeedTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            homeFeedTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func searchButtonTapped() {
        DispatchQueue.main.async {
            let vc = SearchViewController.shared
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //只有一個UITableView，所以設定frame為view.bounds
        homeFeedTable.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        validateAuth() //Register後跳回此視圖時，會再次觸發viewDidAppear來執行這行
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LandingScreenViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
        else {
            //登入後發送didLogInNotification通知
//            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func homeViewModel(didReceiveData mediaData: [String : [Media]]) {
        viewModel.mediaData = mediaData
        self.spinner.dismiss()
        self.homeFeedTable.reloadData()
    }
    
    func homeViewModel(didReceiveError error: Error) {
        self.spinner.dismiss()
        showUIAlert(message: error.localizedDescription)
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
        
//        let cell = TableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCell.identifier)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.contentActionButtonDelegate = self
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

//MARK: - Media Preview delegate
extension HomeViewController: MediaPreviewDelegate {
       
    func didPreview(mediaName: String, mediaOverview: String?) {
        previewMedia(mediaName: mediaName, mediaOverview: mediaOverview)
    }
}

//MARK: - TabBarController delegate
extension HomeViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Haptic.shared.vibrate(feedbackStyle: .light)
    }
}
// MARK: - 搜尋按鈕按下的觸發
extension HomeViewController : SearchViewControllerPresentDelegate {
    
    func pushSearchVC() {
        DispatchQueue.main.async {
            let vc = SearchViewController.shared
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Content Action Button Delegate
extension HomeViewController: ContentActionButtonDelegate {
    func didTappedShareBtn(mediaName: String, image: UIImage) {
        print("didTappedShareBtn")
    }
    
    func didTappedWatchListBtn(uid: String, media: FMedia) {
        Haptic.shared.vibrate(feedbackStyle: .light)
        
        spinner.show(in: view)
                
        DatabaseManager.shared.recordMedia(uid: uid, media: media) { [weak self] result in
            switch result {
            case .success(let response):
                self?.spinner.dismiss()
                var msg = ""
                switch response {
                case .exists:
                    msg = "已經存在！"
                    print(msg)
                case .added:
                    msg = "加入成功！"
                    print(msg)
                }
                NotificationCenter.default.post(name: .didFavorite, object: nil)
                self?.showUIHint(message: msg)
            case .failure(let failure):
                self?.spinner.dismiss()
                print(failure.localizedDescription)
                self?.showUIAlert(message: failure.localizedDescription)
            }
        }
    }
    
    func didTappedPlayBtn(mediaName: String, mediaOverview: String?) {
        previewMedia(mediaName: mediaName, mediaOverview: mediaOverview)
    }
}

// MARK: - Show alert delegate
extension HomeViewController: ShowAlertDelegate {
    func showAlert(msg: String) {
        showUIAlert(message: msg)
    }
}
