//
//  APIManager.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/28.
//

import Foundation

final class APIManager: APIManagerProtocol {
    
    func fetchMedia(completion: @escaping (Result<[Media], Error>) -> Void) {
        completion(.failure(NSError(domain: "", code: 0)))
    }
    
    static let shared: APIManager = APIManager()
    
    private init(){
        print("APICaller init()")
    }
    
    func getMandarinMedia(completion: @escaping (Result<[Media], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var combinedMedia: [Media] = []
        
        dispatchGroup.enter()
        getMandarinMovies { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let titles):
                combinedMedia.append(contentsOf: titles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        getMandarinTVs { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let titles):
                combinedMedia.append(contentsOf: titles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(combinedMedia))
        }
    }

    func getMandarinMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        getMediaFromUrl(Constants.MandarinMoviesURL, completion: completion)
    }

    func getMandarinTVs(completion: @escaping (Result<[Media], Error>) -> Void) {
        getMediaFromUrl(Constants.MandarinTVsURL, completion: completion)
    }
    
    /// 取得熱播的電影跟節目
    func getPlayingMedia(completion: @escaping (Result<[Media], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var combinedMedia: [Media] = []
        
        // 電影
        dispatchGroup.enter()
        getNowPlayingMovies { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let titles):
                combinedMedia.append(contentsOf: titles)
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        
        // 節目
        dispatchGroup.enter()
        getOnTheAirTVs { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let titles):
                combinedMedia.append(contentsOf: titles)
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        
        // 完成資料合併
        dispatchGroup.notify(queue: .main) {
            completion(.success(combinedMedia))
        }
    }
    
    func getNowPlayingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        getMediaFromUrl(Constants.NowPlayingMoviesUrl, completion: completion)
    }

    func getOnTheAirTVs(completion: @escaping (Result<[Media], Error>) -> Void) {
        getMediaFromUrl(Constants.OnTheAirTVsURL, completion: completion)
    }

    func getMediaFromUrl(_ url: String, completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.httpError(error!)))
                return
            }

            do {
                let results = try JSONDecoder().decode(MediaList.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
        //getTrendingMoveis函數接受一個逃逸閉包作為參數，該閉包在異步操作完成後被呼叫，並傳遞數據給閉包，以供後續使用．使用escaping屬性可以確保閉包在異步操作完成後仍然有效
    func getTrendingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
            guard let url = URL(string: "\(Constants.TmdbBaseURL)/3/trending/movie/day?api_key=\(Constants.TmdbAPI_KEY)&language=zh-TW&page=1") else {return}
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }

                do {
                    let results = try JSONDecoder().decode(MediaList.self, from: data)
                    completion(.success(results.results))
                    
                } catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            
            task.resume()
        }
            
    
    func getTrendingTvs(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.TmdbBaseURL)/3/trending/tv/day?api_key=\(Constants.TmdbAPI_KEY)&language=zh-TW&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(MediaList.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.TmdbBaseURL)/3/movie/upcoming?api_key=\(Constants.TmdbAPI_KEY)&language=zh-TW&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MediaList.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.TmdbBaseURL)/3/movie/popular?api_key=\(Constants.TmdbAPI_KEY)&language=zh-TW&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MediaList.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getTop10Movies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.TmdbBaseURL)/3/movie/top_rated?api_key=\(Constants.TmdbAPI_KEY)&language=zh-TW&page=1") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MediaList.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    func getTop10TVs(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.TmdbBaseURL)/3/tv/top_rated?api_key=\(Constants.TmdbAPI_KEY)&language=zh-TW&page=1") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MediaList.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    
    func getDiscoverMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.TmdbBaseURL)/3/discover/movie?api_key=\(Constants.TmdbAPI_KEY)&language=zh-TW&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MediaList.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    
    func search(with query: String, completion: @escaping (Result<[Media], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.TmdbBaseURL)/3/search/movie?api_key=\(Constants.TmdbAPI_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MediaList.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    
    func getYouTubeMedia(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)                
                completion(.success(results.items[0]))

            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    
}

struct Constants {
    static let TmdbBaseURL = "https://api.themoviedb.org"
    static let TmdbAPI_KEY = "f1abd94ce3b0a5aea156019431888aeb"
    static let YoutubeAPI_KEY = "AIzaSyD5N-z3eEAaGpzyHtIJAeWxPyOvxGTfqeM" //myself
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    
    static let MandarinMoviesURL = "\(TmdbBaseURL)/3/discover/movie?api_key=\(TmdbAPI_KEY)&include_adult=false&include_video=false&language=zh-TW&page=1&sort_by=popularity.desc&with_original_language=zh"
    
    static let MandarinTVsURL = "\(TmdbBaseURL)/3/discover/tv?api_key=\(TmdbAPI_KEY)&include_adult=false&include_video=false&language=zh-TW&page=1&sort_by=popularity.desc&with_original_language=zh"
    
    static let NowPlayingMoviesUrl = "\(TmdbBaseURL)/3/movie/now_playing?api_key=\(TmdbAPI_KEY)&language=zh-TW&page=1"
    
    static let OnTheAirTVsURL = "\(TmdbBaseURL)/3/tv/on_the_air?api_key=\(TmdbAPI_KEY)&language=zh-TW&page=1&timezone=Asia%2FTaipei"
    
    static let TrendingMoviesUrl = "\(TmdbBaseURL)/3/trending/movie/day?api_key=\(TmdbAPI_KEY)&language=zh-TW&page=1"
    
    static let TrendingTVsUrl = "\(TmdbBaseURL)/3/trending/tv/day?api_key=\(TmdbAPI_KEY)&language=zh-TW&page=1"
    
    static let PopularMoviesUrl = "\(TmdbBaseURL)/3/movie/popular?api_key=\(TmdbAPI_KEY)&language=zh-TW&page=1"
    
    static let UpcomingMoviesUrl = "\(TmdbBaseURL)/3/movie/upcoming?api_key=\(TmdbAPI_KEY)&language=zh-TW&page=1"
    
    static let TopRatedMoviesUrl = "\(TmdbBaseURL)/3/movie/top_rated?api_key=\(TmdbAPI_KEY)&language=zh-TW&page=1"
        
}
