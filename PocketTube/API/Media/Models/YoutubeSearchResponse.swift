//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 06/01/2022.
//

// for API正常回應
struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
    
    var videoElementsWithVideoId: VideoElement? {        
        return items.first { $0.id.videoId != nil } ?? nil
    }
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String?
    let channelId: String?
    let playlistId: String?
}

// for API超過使用量
struct YoutubeErrorResponse: Codable {
    let error: YoutubeError
}

struct YoutubeError: Codable {
    let code: Int
    let message: String
    let errors: [YoutubeErrorDetail]
}

struct YoutubeErrorDetail: Codable {
    let message: String
    let domain: String
    let reason: String
}
