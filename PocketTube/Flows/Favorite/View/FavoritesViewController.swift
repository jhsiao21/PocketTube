import UIKit
import JGProgressHUD

protocol FavoritesView: BaseView {
    var onMediaSelected: ((YoutubePreviewModel) -> Void)? { get set }
}

class FavoritesViewController: UIViewController, FavoritesView {
    var onMediaSelected: ((YoutubePreviewModel) -> Void)?
    
    private lazy var viewModel : FavoritesViewModel = {
        let vm = FavoritesViewModel(dataProvider: DatabaseManager.shared)
        vm.delegate = self
        return vm
    }()
    
    private let favoritesTable: UITableView = {
       
        let table = UITableView()
        table.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        return table
    }()
    
    private let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "口袋名單"
        view.addSubview(favoritesTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
        
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
        
        setupNotificationObservers()
    }
        
    /// 設定通知
    func setupNotificationObservers() {
        let observerAction: (Notification) -> Void = { [weak self] _ in
            self?.updateFavorites()
        }
        NotificationCenter.default.addObserver(forName: .didFavorite, object: nil, queue: nil, using: observerAction)
        NotificationCenter.default.addObserver(forName: .didRefresh, object: nil, queue: nil, using: observerAction)
    }
    
    func updateFavorites() {
        viewModel.fetchData()
    }
            
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesTable.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
}

// MARK: - FavoriteViewModel Delegate
extension FavoritesViewController: FavoriteViewModelDelegate {
    func favoriteViewModel(didPlayMedia model: YoutubePreviewModel) {
        onMediaSelected?(model)
    }    
    
    func favoriteViewModel(didReceiveData data: [FMedia]) {
        viewModel.medias = data
        self.favoritesTable.reloadData()
    }
    
    func favoriteViewModel(didReceiveError error: Error) {
        self.showUIAlert(message: error.localizedDescription)
    }
}

// MARK: - TableView Delegate, TableView Data Source
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        
        let media = viewModel.medias[indexPath.row]
        cell.configure(with: media)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let media = viewModel.medias[indexPath.row]
        switch editingStyle {
        case .delete:
            
            viewModel.deleteMedia(mediaId: media.mId) { [weak self] result in
                switch result {
                case .success(_):
                    print("Deleted at row: \(indexPath.row)")
                    self?.viewModel.medias.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let failure):
                    self?.showUIAlert(message: failure.localizedDescription)
                }
            }
            
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let media = viewModel.medias[indexPath.row]
        
        viewModel.fetchMedia(media: media)
    }
}
