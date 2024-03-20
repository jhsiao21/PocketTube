import UIKit
import JGProgressHUD

protocol HotNewReleaseView: BaseView {
    var onSearchButtonTap: (() -> Void)? { get set }
    var onMediaSelected: ((Media) -> Void)? { get set }
}

class HotNewReleaseViewController: UIViewController, HotNewReleaseView {
    var onSearchButtonTap: (() -> Void)?
    var onMediaSelected: ((Media) -> Void)?
    
    private let naviBarConfigView = NaviBarConfigView()
    private let hotNewReleaseHeaderView = HotNewReleaseHeaderView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var viewModel : HotNewReleaseViewModel = {
        let vm = HotNewReleaseViewModel(dataProvider: APIManager.shared)
        vm.delegate = self
        return vm
    }()
    
    private let spinner = JGProgressHUD(style: .dark)
            
    override func viewDidLoad() {
        super.viewDidLoad()
                
        style()
        layout()
        setupTableView()
        
        naviBarConfigView.pushSearchViewDelegate = self
        
        spinner.show(in: view)
        viewModel.fetchData()
    }
    
    private func style() {
        naviBarConfigView.pageTitleLabel.text = "熱播新片"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PopularCell.self, forCellReuseIdentifier: PopularCell.identifier)
        tableView.register(UpcomingCell.self, forCellReuseIdentifier: UpcomingCell.identifier)
        tableView.register(Top10Cell.self, forCellReuseIdentifier: Top10Cell.identifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
                
        hotNewReleaseHeaderView.translatesAutoresizingMaskIntoConstraints = false
        hotNewReleaseHeaderView.linkedBtnTappedDelegate = self
    }
    
    private func layout() {
        view.addSubview(tableView)
        navigationItem.titleView = naviBarConfigView
        view.addSubview(hotNewReleaseHeaderView)
        
        // 設定約束
        NSLayoutConstraint.activate([
            naviBarConfigView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            hotNewReleaseHeaderView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            hotNewReleaseHeaderView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: hotNewReleaseHeaderView.trailingAnchor, multiplier: 2),
            hotNewReleaseHeaderView.heightAnchor.constraint(equalToConstant: 45),
            
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: hotNewReleaseHeaderView.bottomAnchor, multiplier: 4),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 0.5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func scrollTableViewToSection(_ sectionType: SectionType) {
        let sectionIndex = sectionType.rawValue
        let indexPath = IndexPath(row: 0, section: sectionIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
        
    @objc func searchButtonTapped() {
        onSearchButtonTap?()
//        DispatchQueue.main.async {
//            let vc = SearchViewController.shared
//            
//            //按下搜尋後隱藏標籤列
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

// MARK: - HotNewReleaseViewModel Delegate
extension HotNewReleaseViewController: HotNewReleaseViewModelDelegate {
    func hotNewReleaseViewModel(didReceiveItem data: [HotNewReleaseViewModelItem]) {
        viewModel.items = data
        self.spinner.dismiss()
        self.tableView.reloadData()
    }
    
    func hotNewReleaseViewModel(didReceiveError error: Error) {
        self.spinner.dismiss()
        self.showUIAlert(message: error.localizedDescription)
    }
}

// MARK: - Table view delegate
extension HotNewReleaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section:\(viewModel.items[section].type),rowCount:\(viewModel.items[section].rowCount)")
        return viewModel.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let item = viewModel.items[indexPath.section]
//        print("indexPath.section: \(indexPath.section)")
//        hotNewReleaseHeaderView.linkToSelectionBtn(sectionIdx: indexPath.section)
                
        switch item.type {
            
        case .Popular:
            if let item = item as? HotNewReleaseViewModelPopularItem, let cell = tableView.dequeueReusableCell(withIdentifier: PopularCell.identifier, for: indexPath) as? PopularCell {
                let media = item.medias[indexPath.row]
                cell.configure(media)
                cell.contentActionButtonDelegate = self
                
                return cell
            }
        case .Upcoming:
            if let item = item as? HotNewReleaseViewModelUpcomingItem, let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingCell.identifier, for: indexPath) as? UpcomingCell {
                
                let media = item.medias[indexPath.row]
                cell.configure(with: media)
                cell.contentActionButtonDelegate = self
                
                return cell
            }
        case .Top10TVs:
            if let item = item as? HotNewReleaseViewModelTop10TVsItem, let cell = tableView.dequeueReusableCell(withIdentifier: Top10Cell.identifier, for: indexPath) as? Top10Cell {
                
                let media = item.medias[indexPath.row]
                cell.configure(with: media, index: indexPath.row)
                cell.contentActionButtonDelegate = self
                
                return cell
            }
        case .Top10Movies:
            if let item = item as? HotNewReleaseViewModelTop10MoviesItem, let cell = tableView.dequeueReusableCell(withIdentifier: Top10Cell.identifier, for: indexPath) as? Top10Cell {
                
                let media = item.medias[indexPath.row]
                cell.configure(with: media, index: indexPath.row)
                cell.contentActionButtonDelegate = self
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return 700
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "\(viewModel.items[section].sectionImageName)")
        headerView.addSubview(icon)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "\(viewModel.items[section].sectionTitle)"
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            icon.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 28), // 調整 icon 的寬度
            icon.heightAnchor.constraint(equalToConstant: 28) // 調整 icon 的高度
        ])
        
        // 添加 label 的约束
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: icon.centerYAnchor)
        ])
        
        print("section: \(section)")
        hotNewReleaseHeaderView.linkToSelectionBtn(sectionIdx: section)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = viewModel.items[indexPath.section]
        var media : Media? = nil
        
        switch item.type {
            
        case .Popular:
            if let item = item as? HotNewReleaseViewModelPopularItem {
                media = item.medias[indexPath.row]
            }
        case .Upcoming:
            if let item = item as? HotNewReleaseViewModelUpcomingItem {
                media = item.medias[indexPath.row]
            }
        case .Top10TVs:
            if let item = item as? HotNewReleaseViewModelTop10TVsItem {
                media = item.medias[indexPath.row]
            }
        case .Top10Movies:
            if let item = item as? HotNewReleaseViewModelTop10MoviesItem {
                media = item.medias[indexPath.row]
            }
        }
        
//        guard let mediaTitle = media?.displayTitle else {
//            return
//        }
        
        guard let media = media else { return }
        
        onMediaSelected?(media)
        
//        previewMedia(mediaName: mediaTitle, mediaOverview: media.overview)
                
        //選取時此列會以灰色來突出顯示，並保持在被選取狀態
        //加入取消列的選取
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HotNewReleaseViewController: LinkedBtnTappedDelegate  {
    
    func buttonIsPressed(tag: Int) {
        if let sectionType = SectionType(rawValue: tag) {
            scrollTableViewToSection(sectionType)
            Haptic.shared.vibrate(feedbackStyle: .medium)
            print(tag)
        }
    }
}

// MARK: - 搜尋按鈕按下的觸發
extension HotNewReleaseViewController : SearchViewControllerPresentDelegate {
    
    func pushSearchVC() {
        onSearchButtonTap?()
//        DispatchQueue.main.async {
//            let vc = SearchViewController.shared
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

// MARK: - ContentActionButton Delegate
extension HotNewReleaseViewController: ContentActionButtonDelegate {
    func didTappedShareBtn(mediaName: String, image: UIImage) {
        spinner.show(in: view)
        
        APIManager.shared.fetchYouTubeMedia(with: "\(mediaName) trailer") { [weak self] result in

            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    self?.spinner.dismiss()
                }
                
                guard let videoId = (videoElement as VideoElement).id.videoId,
                      let youtubeUrl = URL(string: "https://www.youtube.com/watch?v=\(videoId)") else {
                    return
                }
                let shareMsg = "我看到了一個超棒的影片！片名：\(mediaName)"
                let activityVC = UIActivityViewController(activityItems: [shareMsg, image, youtubeUrl], applicationActivities: nil)
                
                activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in

                    if let error = error {
                        self?.showUIAlert(message: error.localizedDescription)
                        return
                    }
                    
                    if completed {
                        self?.showUIHint(message: "Share success")
                    }
                }
                
                DispatchQueue.main.async {
                    self?.present(activityVC, animated: true, completion: nil)
                }                
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.spinner.dismiss()
                }
                print(error.localizedDescription)
                self?.showUIAlert(message: error.localizedDescription)
            }
        }
    }
    
    func didTappedWatchListBtn(uid: String, media: FMedia) {
        Haptic.shared.vibrate(feedbackStyle: .light)
        
        spinner.show(in: view)
                
        DatabaseManager.shared.favoriteMedia(uid: uid, media: media) { [weak self] result in
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
    
    func didTappedPlayBtn(media: Media) {
        onMediaSelected?(media)
    }
}
