//
//  Movie.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 08/12/2021.
//

import Foundation

enum Sections: CaseIterable {
    case MandarinMedia
    case NowPlaying
    case TrendingMovies
    case TrendingTVs
    case PopularMovies
    case UpcomingMovies
    case Top10Movies
    
    var caseDescription: String {
        switch self {
        case .MandarinMedia:
            return "華語電影與節目"
        case .NowPlaying:
            return "現正熱播"
        case .TrendingMovies:
            return "熱門電影"
        case .TrendingTVs:
            return "熱門節目"
        case .PopularMovies:
            return "受歡迎電影"
        case .UpcomingMovies:
            return "即將上線"
        case .Top10Movies:
            return "Top 評分"
        }
    }
}

struct MediaList: Codable {
    let results: [Media]
}

struct Media: Codable {
    let id: Int
    let genre_ids: [Int]?
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    let source: SectionType? // 添加 source 屬性
    
    // 自定義初始化方法，初始化時同時設置 source 屬性
    init(id: Int, genre_ids:[Int]?, media_type: String?, original_name: String?, original_title: String?, poster_path: String?, overview: String?, vote_count: Int, release_date: String?, vote_average: Double, source: SectionType?) {
        self.id = id
        self.genre_ids = genre_ids
        self.media_type = media_type
        self.original_name = original_name
        self.original_title = original_title
        self.poster_path = poster_path
        self.overview = overview
        self.vote_count = vote_count
        self.release_date = release_date
        self.vote_average = vote_average
        self.source = source
    }
}

