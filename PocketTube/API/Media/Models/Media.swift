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
}

