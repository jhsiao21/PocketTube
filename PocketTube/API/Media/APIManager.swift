//
//  APIManager.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/28.
//

import Foundation

final class APIManager {
        
    static let shared: APIManager = APIManager()
    
    init(){
        print("APICaller init()")
    }    
}

extension APIManager : APIManagerProtocol {
    
    func fetchMandarinMedia(completion: @escaping (Result<[Media], Error>) -> Void) {
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
        fetchMediaFromUrl(Constants.MandarinMoviesURL, completion: completion)
    }

    func getMandarinTVs(completion: @escaping (Result<[Media], Error>) -> Void) {
        fetchMediaFromUrl(Constants.MandarinTVsURL, completion: completion)
    }
    
    /// 取得熱播的電影跟節目
    func fetchPlayingMedia(completion: @escaping (Result<[Media], Error>) -> Void) {
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
        fetchMediaFromUrl(Constants.NowPlayingMoviesUrl, completion: completion)
    }

    func getOnTheAirTVs(completion: @escaping (Result<[Media], Error>) -> Void) {
        fetchMediaFromUrl(Constants.OnTheAirTVsURL, completion: completion)
    }

    func fetchMediaFromUrl(_ url: String, completion: @escaping (Result<[Media], Error>) -> Void) {
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
    func fetchTrendingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
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
            
    
    func fetchTrendingTvs(completion: @escaping (Result<[Media], Error>) -> Void) {
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
    
    
    func fetchUpcomingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
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
    
    func fetchPopularMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
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
    
    func fetchTop10Movies(completion: @escaping (Result<[Media], Error>) -> Void) {
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
    
    func fetchTop10TVs(completion: @escaping (Result<[Media], Error>) -> Void) {
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
    
    
    func fetchDiscoverMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
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
    
    
    func searchMedia(with query: String, completion: @escaping (Result<[Media], Error>) -> Void) {
        
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
    
    
    func fetchYouTubeMedia(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // 嘗試解析正常的搜索結果
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                guard let youtubeMedia = results.videoElementsWithVideoId else {
                    completion(.failure(NSError(domain: "There are no \(query) data on Youtube.", code: -1)))
                    return
                }
                completion(.success(youtubeMedia))
            } catch {
                // 解析失敗時，嘗試解析為錯誤回應模型
                do {
                    let errorResponse = try JSONDecoder().decode(YoutubeErrorResponse.self, from: data)
                    let errorMessage = errorResponse.error.errors.first?.message ?? "Unknown error"
                    completion(.failure(NSError(domain: "YoutubeError", code: errorResponse.error.code, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } catch {
                    // 如果錯誤回應也無法解析，則返回原始解析錯誤
                    completion(.failure(error))
                }
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}

// MARK: - HomeViewModel Data Provider
extension APIManager: HomeViewModelDataProvider {
    
    /// implenting fetchMediaData method
    func fetchMediaData(completion: @escaping (Result<[String : [Media]], Error>) -> Void) {
        var mediaData : [String : [Media]] = [:]
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchMandarinMedia { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                mediaData["\(String(Sections.MandarinMedia.caseDescription))"] = medias
                print("MandarinMedia finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        fetchPlayingMedia { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                mediaData["\(String(Sections.NowPlaying.caseDescription))"] = medias
                print("PlayingMedia finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        fetchMediaFromUrl(Constants.TrendingMoviesUrl) { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                mediaData["\(String(Sections.TrendingMovies.caseDescription))"] = medias
                print("TrendingMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        fetchMediaFromUrl(Constants.TrendingTVsUrl) { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                mediaData["\(String(describing: Sections.TrendingTVs.caseDescription))"] = medias
                print("TrendingTVs finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        fetchMediaFromUrl(Constants.PopularMoviesUrl) { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                mediaData["\(String(Sections.PopularMovies.caseDescription))"] = medias
                print("PopularMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        fetchMediaFromUrl(Constants.UpcomingMoviesUrl) { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                mediaData["\(String(Sections.UpcomingMovies.caseDescription))"] = medias
                print("UpcomingMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        fetchMediaFromUrl(Constants.TopRatedMoviesUrl) { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let medias):
                mediaData["\(String(Sections.Top10Movies.caseDescription))"] = medias
                print("TopRatedMovies finish")
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(mediaData))
        }
    }
}


// MARK: - HotNewReleaseViewModel DataProvider
extension APIManager: HotNewReleaseViewModelDataProvider {
    
    func fetchMediaData(completion: @escaping (Result<[HotNewReleaseViewModelItem], Error>) -> Void) {
        var items: [HotNewReleaseViewModelItem] = []
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchUpcomingMovies { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let media):
                let mediaItem = HotNewReleaseViewModelUpcomingItem(medias: media)
                items.append(mediaItem)
                
                items = items.sorted { (item1, item2) -> Bool in
                    return item1.type.rawValue < item2.type.rawValue
                }
                
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch upcoming movies: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.enter()
        fetchPopularMovies { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let media):
                let mediaItem = HotNewReleaseViewModelPopularItem(medias: media)
                items.append(mediaItem)
                items = items.sorted { (item1, item2) -> Bool in
                    return item1.type.rawValue < item2.type.rawValue
                }
            case .failure(let error):
                print("Failed to fetch popular movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        fetchTop10TVs { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let media):
                let mediaItem = HotNewReleaseViewModelTop10TVsItem(medias: media)
                items.append(mediaItem)
                items = items.sorted { (item1, item2) -> Bool in
                    return item1.type.rawValue < item2.type.rawValue
                } 
            case .failure(let error):
                print("Failed to fetch Top 10 TVs movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        dispatchGroup.enter()
        fetchTop10Movies { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let media):
                let mediaItem = HotNewReleaseViewModelTop10MoviesItem(medias: media)
                items.append(mediaItem)
                items = items.sorted { (item1, item2) -> Bool in
                    return item1.type.rawValue < item2.type.rawValue
                }
            case .failure(let error):
                print("Failed to fetch Top10 Movies movies: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(items))
        }
    }
}

//MARK: - SearchViewModelDataProvider
extension APIManager: SearchViewModelDataProvider {
    
    func fetchDiscoverMedia(completion: @escaping (Result<[Media], Error>) -> Void) {
        
        fetchDiscoverMovies { result in
            switch result {
            case .success(let media):
                completion(.success(media))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func searchFor(with mediaName: String, completion: @escaping (Result<[Media], Error>) -> Void) {
        
        searchMedia(with: mediaName) { result in
            switch result {
            case .success(let media):
                completion(.success(media))
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
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
