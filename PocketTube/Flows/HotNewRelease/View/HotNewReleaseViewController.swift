import UIKit
import JGProgressHUD

protocol HotNewReleaseView: BaseView {
    var onAirPlayButtonTap: (() -> Void)? { get set }
    var onSearchButtonTap: (() -> Void)? { get set }
    var onUserIconButtonTap: (() -> Void)? { get set }
    var onMediaShare: ((String, URL, UIImage) -> Void)? { get set }
    var onMediaPlay: ((YoutubePreviewModel) -> Void)? { get set }
    var onRemindeMeButtonTap: (() -> Void)? { get set }
    var onInfoButtonTap: (() -> Void)? { get set }
}

class HotNewReleaseViewController: UIViewController, HotNewReleaseView {
    var onAirPlayButtonTap: (() -> Void)?
    var onSearchButtonTap: (() -> Void)?
    var onUserIconButtonTap: (() -> Void)?
    var onMediaShare: ((String, URL, UIImage) -> Void)?
    var onMediaPlay: ((YoutubePreviewModel) -> Void)?
    var onRemindeMeButtonTap: (() -> Void)?
    var onInfoButtonTap: (() -> Void)?
    
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
        
        naviBarConfigView.naviBarDelegate = self
                        
        viewModel.isLoading = { [unowned self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.spinner.show(in: view)
                } else {
                    self.spinner.dismiss()
                }
            }
        }
        
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
}

// MARK: - HotNewReleaseViewModel Delegate
extension HotNewReleaseViewController: HotNewReleaseViewModelDelegate {
    func hotNewReleaseViewModel(didRemindeMe media: Media?) {
        onRemindeMeButtonTap?()
    }
    
    func hotNewReleaseViewModel(didMediaInfo media: Media?) {
        onInfoButtonTap?()
    }
    
    func hotNewReleaseViewModel(didPlayMedia model: YoutubePreviewModel) {
        onMediaPlay?(model)
    }    
    
    func hotNewReleaseViewModel(didShareMedia name: String, youtubeUrl: URL, posterImg: UIImage) {
        onMediaShare?(name, youtubeUrl, posterImg)
    }
    
    func hotNewReleaseViewModel(didFavoriteMediaResponse response:FavoriteResponse) {
        self.showUIHint(message: response.caseDescription)
    }
    
    func hotNewReleaseViewModel(didReceiveItem data: [HotNewReleaseViewModelItem]) {
        viewModel.items = data
        self.tableView.reloadData()
    }
    
    func hotNewReleaseViewModel(didReceiveError error: Error) {
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
                
        switch item.type {
            
        case .Popular:
            if let item = item as? HotNewReleaseViewModelPopularItem, let cell = tableView.dequeueReusableCell(withIdentifier: PopularCell.identifier, for: indexPath) as? PopularCell {
                let media = item.medias[indexPath.row]
                cell.configure(media)
                cell.contentActionButtonDelegate = viewModel
                
                return cell
            }
        case .Upcoming:
            if let item = item as? HotNewReleaseViewModelUpcomingItem, let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingCell.identifier, for: indexPath) as? UpcomingCell {
                
                let media = item.medias[indexPath.row]
                cell.configure(with: media)
                cell.contentActionButtonDelegate = viewModel
                
                return cell
            }
        case .Top10TVs:
            if let item = item as? HotNewReleaseViewModelTop10TVsItem, let cell = tableView.dequeueReusableCell(withIdentifier: Top10Cell.identifier, for: indexPath) as? Top10Cell {
                
                let media = item.medias[indexPath.row]
                cell.configure(with: media, index: indexPath.row)
                cell.contentActionButtonDelegate = viewModel
                
                return cell
            }
        case .Top10Movies:
            if let item = item as? HotNewReleaseViewModelTop10MoviesItem, let cell = tableView.dequeueReusableCell(withIdentifier: Top10Cell.identifier, for: indexPath) as? Top10Cell {
                
                let media = item.medias[indexPath.row]
                cell.configure(with: media, index: indexPath.row)
                cell.contentActionButtonDelegate = viewModel
                
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
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: icon.centerYAnchor)
        ])
        
//        print("section: \(section)")
//        hotNewReleaseHeaderView.linkToSelectionBtn(btnIdx: section)
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
        
        guard let media = media else { return }
        
        viewModel.didTappedPlayBtn(media: media)
                
        //選取時此列會以灰色來突出顯示，並保持在被選取狀態
        //加入取消列的選取
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - LinkedBtnTapped Delegate
extension HotNewReleaseViewController: LinkedBtnTappedDelegate  {
    
    func buttonIsPressed(tag: Int) {
        if let sectionType = SectionType(rawValue: tag) {
            scrollTableViewToSection(sectionType)
            Haptic.shared.vibrate(feedbackStyle: .medium)
            print(tag)
        }
    }
}

// MARK: - NaviBar Delegate
extension HotNewReleaseViewController : NaviBarDelegate {
    func airPlayBtnTap() {
        onAirPlayButtonTap?()
    }
    
    func searchBtnTap() {
        onSearchButtonTap?()
    }
    
    func userIconBtnTap() {
        onUserIconButtonTap?()
    }
}

//MARK: - UIScrollViewDelegate
extension HotNewReleaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = tableView.visibleCells
        for cell in visibleCells {
            if let indexPath = tableView.indexPath(for: cell) {
                print("This cell is in section \(indexPath.section)")
                hotNewReleaseHeaderView.linkToSelectionBtn(btnIdx: indexPath.section)
            }
        }
    }
}
