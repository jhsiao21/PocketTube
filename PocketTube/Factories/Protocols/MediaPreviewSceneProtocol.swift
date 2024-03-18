//
//  MediaPreviewSceneProtocol.swift
//  PocketTube
//
//  Created by LoganMacMini on 2024/3/18.
//

import Foundation

protocol MediaPreviewSceneProtocol {
    func makeMediaPreviewView(withModel model: YoutubePreviewModel) -> MediaPreviewView
}
