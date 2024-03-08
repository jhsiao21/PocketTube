//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 06/01/2022.
//

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
