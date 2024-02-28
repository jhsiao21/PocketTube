//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/28.
//

import Foundation
import UIKit

final class HomeViewModel  {
    var mediaData: [String : [Media]] = [:]
    
    public func fetchData(completion: @escaping (Result<Bool, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        APIManager.shared.fetchMandarinMedia { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.MandarinMedia.caseDescription))"] = medias
                print("MandarinMedia finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.fetchPlayingMedia { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.NowPlaying.caseDescription))"] = medias
                print("PlayingMedia finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.fetchMediaFromUrl(Constants.TrendingMoviesUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.TrendingMovies.caseDescription))"] = medias
                print("TrendingMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.fetchMediaFromUrl(Constants.TrendingTVsUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(describing: Sections.TrendingTVs.caseDescription))"] = medias
                print("TrendingTVs finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.fetchMediaFromUrl(Constants.PopularMoviesUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.PopularMovies.caseDescription))"] = medias
                print("PopularMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.fetchMediaFromUrl(Constants.UpcomingMoviesUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.UpcomingMovies.caseDescription))"] = medias
                print("UpcomingMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.fetchMediaFromUrl(Constants.TopRatedMoviesUrl) { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                self?.mediaData["\(String(Sections.Top10Movies.caseDescription))"] = medias
                print("TopRatedMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(true))
        }
    }
}
