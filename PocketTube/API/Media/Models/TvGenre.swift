//
//  TvGenre.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/7.
//

import Foundation

enum TVShowGenre: Int, Codable {
    case actionAndAdventure = 10759
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case kids = 10762
    case mystery = 9648
    case news = 10763
    case reality = 10764
    case sciFiAndFantasy = 10765
    case soap = 10766
    case talk = 10767
    case warAndPolitics = 10768
    case western = 37
    
    var name: String {
        switch self {
        case .actionAndAdventure: return "動作冒險"
        case .animation: return "動畫"
        case .comedy: return "喜劇"
        case .crime: return "犯罪"
        case .documentary: return "紀錄"
        case .drama: return "劇情"
        case .family: return "家庭"
        case .kids: return "兒童"
        case .mystery: return "懸疑"
        case .news: return "新聞"
        case .reality: return "真人秀"
        case .sciFiAndFantasy: return "科幻"
        case .soap: return "肥皂劇"
        case .talk: return "脫口秀"
        case .warAndPolitics: return "戰爭 政治"
        case .western: return "西部"
        }
    }
}

func getTvGenreNames(for ids: [Int]) -> String {
    let genreNames = ids.compactMap { id in
        if let genre = TVShowGenre(rawValue: id) {
            return genre.name
        } else {
            return nil
        }
    }
    
    return genreNames.joined(separator: "．")
}
