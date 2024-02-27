//
//  HotNewReleaseViewModel.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/6.
//

import Foundation
import UIKit

enum SectionType: Int, Codable {
    case Popular = 0
    case Upcoming = 1
    case Top10TVs = 2
    case Top10Movies = 3
}

protocol HotNewReleaseViewModelItem {
    var type: SectionType { get }
    var sectionTitle: String { get }
    var sectionImageName: String { get }
    var rowCount: Int { get }
}

class HotNewReleaseViewModel: NSObject {
    
    var items: [HotNewReleaseViewModelItem] = []
    
    override init() {
        super.init()
//        fetchData()
    }
    
    func fetchData(completion: @escaping (Result<Bool, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        APIManager.shared.getUpcomingMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let media):
                let mediaItem = HotNewReleaseViewModelUpcomingItem(medias: media)
                self?.items.append(mediaItem)
                
                self?.items = self?.items.sorted { (item1, item2) -> Bool in
                    return item1.type.rawValue < item2.type.rawValue
                } ?? []
                
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch upcoming movies: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.getPopularMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let media):
                let mediaItem = HotNewReleaseViewModelPopularItem(medias: media)
                self?.items.append(mediaItem)
                self?.items = self?.items.sorted { (item1, item2) -> Bool in
                    return item1.type.rawValue < item2.type.rawValue
                } ?? []
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch popular movies: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.getTop10TVs { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let media):
                let mediaItem = HotNewReleaseViewModelTop10TVsItem(medias: media)
                self?.items.append(mediaItem)
                self?.items = self?.items.sorted { (item1, item2) -> Bool in
                    return item1.type.rawValue < item2.type.rawValue
                } ?? []
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch Top 10 TVs movies: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.enter()
        APIManager.shared.getTop10Movies { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let media):
                let mediaItem = HotNewReleaseViewModelTop10MoviesItem(medias: media)
                self?.items.append(mediaItem)
                self?.items = self?.items.sorted { (item1, item2) -> Bool in
                    return item1.type.rawValue < item2.type.rawValue
                } ?? []
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch Top10 Movies movies: \(error.localizedDescription)")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(true))
        }
    }
}

class HotNewReleaseViewModelPopularItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Popular
    }
    
    var sectionTitle: String {
        return "大家都在看"
    }
    
    var sectionImageName: String {
        return "fire"
    }
    
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

class HotNewReleaseViewModelUpcomingItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Upcoming
    }
    
    var sectionTitle: String {
        return "即將上線"
    }
    
    var sectionImageName: String {
        return "popcorn"
    }
    
    var rowCount: Int {
        return 20
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}

class HotNewReleaseViewModelTop10MoviesItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Top10Movies
    }
    
    var sectionTitle: String {
        return "Top 10 電影"
    }
    
    var sectionImageName: String {
        return "Top10"
    }
    
    var rowCount: Int {
        return 10
    }

    var medias: [Media]

    init(medias: [Media]) {
        self.medias = medias
    }
}

class HotNewReleaseViewModelTop10TVsItem: HotNewReleaseViewModelItem {
    var type: SectionType {
        return .Top10TVs
    }
    
    var sectionTitle: String {
        return "Top 10 節目"
    }
    
    var sectionImageName: String {
        return "Top10"
    }
    
    var rowCount: Int {
        return 10
    }
    
    var medias: [Media]
    
    init(medias: [Media]) {
        self.medias = medias
    }
}
