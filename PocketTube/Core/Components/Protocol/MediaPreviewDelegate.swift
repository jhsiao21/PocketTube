//
//  MediaPreviewDelegate.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/25.
//

import Foundation

protocol MediaPreviewDelegate: AnyObject {
    func didPreview(mediaName: String, mediaOverview: String?)
}
