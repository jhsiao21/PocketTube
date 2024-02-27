//
//  APIManagerProtocol.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/15.
//

import Foundation

protocol APIManagerProtocol {
    typealias FetchMedia = Result<[Media], Error>
        
    func getMandarinMedia(completion: @escaping (FetchMedia) -> Void)
    func getPlayingMedia(completion: @escaping (FetchMedia) -> Void)
    func getTrendingMovies(completion: @escaping (FetchMedia) -> Void)
    func getTrendingTvs(completion: @escaping (FetchMedia) -> Void)
    func getUpcomingMovies(completion: @escaping (FetchMedia) -> Void)
    func getPopularMovies(completion: @escaping (FetchMedia) -> Void)
    func getTop10Movies(completion: @escaping (FetchMedia) -> Void)
    func getTop10TVs(completion: @escaping (FetchMedia) -> Void)
    func getDiscoverMovies(completion: @escaping (FetchMedia) -> Void)
    func getMediaFromUrl(_ url: String, completion: @escaping (FetchMedia) -> Void)
    func search(with query: String, completion: @escaping (FetchMedia) -> Void)
    func getYouTubeMedia(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void)
}
