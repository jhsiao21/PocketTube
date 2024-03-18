//
//  FavoritesSceneFactoryProtocol.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/18.
//

import Foundation

protocol FavoritesSceneFactoryProtocol: MediaPreviewSceneProtocol {    
    func makeFavoritesView() -> FavoritesView
}
