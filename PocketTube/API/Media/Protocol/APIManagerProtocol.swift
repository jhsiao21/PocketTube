//
//  APIManagerProtocol.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/15.
//

protocol APIManagerProtocol {
    typealias MediaResult = Result<[Media], Error>
        
    func fetchMandarinMedia(completion: @escaping (MediaResult) -> Void)
    func fetchPlayingMedia(completion: @escaping (MediaResult) -> Void)
    func fetchTrendingMovies(completion: @escaping (MediaResult) -> Void)
    func fetchTrendingTvs(completion: @escaping (MediaResult) -> Void)
    func fetchUpcomingMovies(completion: @escaping (MediaResult) -> Void)
    func fetchPopularMovies(completion: @escaping (MediaResult) -> Void)
    func fetchTop10Movies(completion: @escaping (MediaResult) -> Void)
    func fetchTop10TVs(completion: @escaping (MediaResult) -> Void)
    func fetchDiscoverMovies(completion: @escaping (MediaResult) -> Void)
    func fetchMediaFromUrl(_ url: String, completion: @escaping (MediaResult) -> Void)
    func searchMedia(with query: String, completion: @escaping (MediaResult) -> Void)
    func fetchYouTubeMedia(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void)
}
