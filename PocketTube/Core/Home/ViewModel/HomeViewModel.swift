//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/28.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func homeViewModel(didReceiveData mediaData: [String : [Media]])
    
    func homeViewModel(didReceiveError error: Error)
}

final class HomeViewModel  {
    
    private let dataProvider: APIManagerProtocol
    weak var delegate: HomeViewModelDelegate?
    var mediaData: [String : [Media]] = [:]
        
    init(dataProvider: APIManagerProtocol) {
        self.dataProvider = dataProvider
    }
    
    public func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        dataProvider.fetchMandarinMedia { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.MandarinMedia.caseDescription))"] = medias
                print("MandarinMedia finish")
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.homeViewModel(didReceiveError: error)
            }
        }
                        
        dispatchGroup.enter()
        dataProvider.fetchPlayingMedia { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.NowPlaying.caseDescription))"] = medias
                print("PlayingMedia finish")
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.homeViewModel(didReceiveError: error)
            }
        }
        
        dispatchGroup.enter()
        dataProvider.fetchMediaFromUrl(Constants.TrendingMoviesUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.TrendingMovies.caseDescription))"] = medias
                print("TrendingMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.homeViewModel(didReceiveError: error)
            }
        }
        
        dispatchGroup.enter()
        dataProvider.fetchMediaFromUrl(Constants.TrendingTVsUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(describing: Sections.TrendingTVs.caseDescription))"] = medias
                print("TrendingTVs finish")
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.homeViewModel(didReceiveError: error)
            }
        }
        
        dispatchGroup.enter()
        dataProvider.fetchMediaFromUrl(Constants.PopularMoviesUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.PopularMovies.caseDescription))"] = medias
                print("PopularMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.homeViewModel(didReceiveError: error)
            }
        }
        
        dispatchGroup.enter()
        dataProvider.fetchMediaFromUrl(Constants.UpcomingMoviesUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.UpcomingMovies.caseDescription))"] = medias
                print("UpcomingMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.homeViewModel(didReceiveError: error)
            }
        }
        
        dispatchGroup.enter()
        dataProvider.fetchMediaFromUrl(Constants.TopRatedMoviesUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.Top10Movies.caseDescription))"] = medias
                print("TopRatedMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.homeViewModel(didReceiveError: error)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.delegate?.homeViewModel(didReceiveData: self.mediaData)
        }
    }
}
