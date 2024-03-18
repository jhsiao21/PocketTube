//
//  SearchSceneFactoryProtocol.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/17.
//

import Foundation

protocol SearchSceneFactoryProtocol: MediaPreviewSceneProtocol {
    func makeSearchView() -> SearchView
}
