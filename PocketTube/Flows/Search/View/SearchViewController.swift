import UIKit
import JGProgressHUD

protocol SearchView: BaseView {
    var onMediaSelected: ((YoutubePreviewModel) -> Void)? { get set }
}

final class SearchViewController: UIViewController, SearchView {
    var onMediaSelected: ((YoutubePreviewModel) -> Void)?
    
    private lazy var viewModel : SearchViewModel = {
        let vm = SearchViewModel(dataProvider: APIManager.shared)
        vm.delegate = self
        return vm
    }()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    static let shared = SearchViewController()
    private let spinner = JGProgressHUD(style: .dark)
        
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for a Movie or TV show"
        controller.searchBar.searchBarStyle = .minimal
        controller.hidesNavigationBarDuringPresentation = false
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        setupTableView()
        
        viewModel.isLoading = { [unowned self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.spinner.show(in: self.view)
                } else {
                    self.spinner.dismiss()
                }
            }
        }
        
        viewModel.fetchDiscoverMovies()
    }
    
    private func style() {
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        navigationController?.navigationBar.tintColor = .white
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    private func layout() {
        view.addSubview(tableView)
        navigationItem.titleView = searchController.searchBar
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - SearchViewModel Delegate
extension SearchViewController: SearchViewModelDelegate {
    func searchViewModel(didPlayMedia model: YoutubePreviewModel) {
        onMediaSelected?(model)
    }
    
    func searchViewModel(didReceiveData data: [Media]) {
        viewModel.defaultItems = data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchViewModel(didReceiveSearchData data: [Media]) {
        viewModel.searchedItems = data
        let _ = print("searchedItems: \(viewModel.searchedItems.count)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchViewModel(didReceiveError error: Error) {
        viewModel.delegate?.searchViewModel(didReceiveError: error)
    }
}

//MARK: - TableView delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                        
        return searchController.isActive ? viewModel.searchedItems.count : viewModel.defaultItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return SearchTableViewCell()
        }
        
        let media = (searchController.isActive) ? viewModel.searchedItems[indexPath.row] : viewModel.defaultItems[indexPath.row]
        
        cell.configure(with: media)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
                
        let headerView = CustomCellHeaderView()

        if searchController.isActive {
            headerView.titleLabel.text = "搜尋結果"
        } else {
            headerView.titleLabel.text = "節目與電影推薦"
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let media = searchController.isActive ? viewModel.searchedItems[indexPath.row] : viewModel.defaultItems[indexPath.row]
        
        viewModel.fetchMedia(media: media)
        
        //選取時此列會以灰色來突出顯示，並保持在被選取狀態
        //加入取消列的選取
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - SearchBar delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        //每次點搜尋框時都清空上一次搜尋結果
        if searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            viewModel.searchedItems.removeAll()
        }
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        viewModel.searchedItems.removeAll()
        self.tableView.reloadData()
    }
}

//MARK: - Search result update
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        //至少一個字元才改變搜尋結果
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 1 else {
            return
        }
        
        viewModel.search(with: query)
        
    }
}
