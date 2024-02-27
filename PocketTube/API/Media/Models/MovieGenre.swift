//
//  MovieGenre.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/7.
//

import Foundation

enum MovieGenre: Int, Codable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37
    
    var name: String {
        switch self {
        case .action: return "動作"
        case .adventure: return "冒險"
        case .animation: return "動畫"
        case .comedy: return "喜劇"
        case .crime: return "犯罪"
        case .documentary: return "紀錄"
        case .drama: return "劇情"
        case .family: return "家庭"
        case .fantasy: return "奇幻"
        case .history: return "歷史"
        case .horror: return "恐怖"
        case .music: return "音樂"
        case .mystery: return "懸疑"
        case .romance: return "愛情"
        case .scienceFiction: return "科幻"
        case .tvMovie: return "電視電影"
        case .thriller: return "驚悚"
        case .war: return "戰爭"
        case .western: return "西部"
        }
    }
}

func getMovieGenreNames(for ids: [Int]) -> String {
    let genreNames = ids.compactMap { id in
        if let genre = MovieGenre(rawValue: id) {
            return genre.name
        } else {
            return nil
        }
    }
    
    return genreNames.joined(separator: "．")
}
