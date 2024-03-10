//
//  DatabaseManagerProtocol.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/2/28.
//

protocol DatabaseManagerProtocol {
    
    static func safeEmail(emailAddress: String) -> String
    func isFavoriteMediaExists(with caption: String, uid: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func favoriteMedia(uid: String, media: FMedia, completion: @escaping (Result<FavoriteResponse, Error>) -> Void)
    func fetchMedias(uid: String, completion: @escaping (Result<[FMedia], Error>) -> Void)
    func mediaDelete(mediaId mid: String, completion: @escaping (Result<Bool, Error>) -> Void)    
}
