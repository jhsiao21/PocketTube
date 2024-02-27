//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 09/11/2023.
//

import UIKit
import JGProgressHUD

final class SearchViewController: UIViewController {
    
    private var viewModel = SearchViewModel()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    static let shared = SearchViewController()
    private let spinner = JGProgressHUD(style: .dark)
    
    private init()
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        spinner.show(in: view)
        viewModel.fetchDiscoverMovies { [weak self] result in
            switch result {
            case .success(_):
                self?.spinner.dismiss()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let failure):
                self?.spinner.dismiss()
                self?.showUIAlert(message: failure.localizedDescription)
            }
        }
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

//MARK: - TableView delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive {
            return viewModel.searchedItems.count
        } else {
            return viewModel.defaultItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return viewModel.searchedItems[section].rowCount
        } else {
            return viewModel.defaultItems[section].rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var item : SearchResultViewModelItem
        if searchController.isActive, viewModel.searchedItems.count > 0 {
            item = viewModel.searchedItems[indexPath.section]
        } else {
            item = viewModel.defaultItems[indexPath.section]
        }
        
        if let item = item as? MoviesAndTVsItem, let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell {
            if item.medias.count > indexPath.row {
                let media = item.medias[indexPath.row]
                cell.configure(with: media)
                return cell
            }
        }
        
        return SearchTableViewCell()
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
        
        let headerView = UIView()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        var item : SearchResultViewModelItem
        if searchController.isActive, viewModel.searchedItems.count > 0 {
            item = viewModel.searchedItems[section]
        } else {
            item = viewModel.defaultItems[section]
        }
        
//        print("\(item.sectionTitle)")
        label.text = "\(item.sectionTitle)" // 設置每個section的Header
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = searchController.isActive ? viewModel.searchedItems[indexPath.section] : viewModel.defaultItems[indexPath.section]
        
        var media : Media? = nil
        
        switch item.type {
            
        case .SearchChampion:
            if let item = item as? SearchChampionItem {
                media = item.medias[indexPath.row]
            }
        case .MoviesAndTVs:
            if let item = item as? MoviesAndTVsItem {
                media = item.medias[indexPath.row]
            }
        }
        
        guard let mediaTitle = media?.original_title ?? media?.original_name else {
            return
        }
        
        previewMedia(mediaName: mediaTitle, mediaOverview: media?.overview)
        
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
        //        tableViewReloadDelegate?.reload()
        tableView.reloadData()
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
        
        viewModel.search(with: query) { [weak self] result in
            switch result {
            case .success(_):
                self?.tableView.reloadData()
            case .failure(let failure):
                self?.showUIAlert(message: failure.localizedDescription)
            }
        }
    }
}
