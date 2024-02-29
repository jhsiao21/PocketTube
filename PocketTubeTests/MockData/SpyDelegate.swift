//
//  SpyDelegate.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/29.
//

import Foundation
@testable import PocketTube

class SpyDelegate {
    private(set) var capturedData: [String : [Media]]?
    private(set) var capturedItem: [HotNewReleaseViewModelItem]?
    private(set) var capturedError: Error?
    private(set) var capturedFData: [FMedia]?
}

// MARK: - HomeViewModel Delegate
extension SpyDelegate: HomeViewModelDelegate {
        
    func homeViewModel(didReceiveData mediaData: [String : [Media]]) {
        capturedData = mediaData
    }
    
    func homeViewModel(didReceiveError error: Error) {
        capturedError = error
    }
}

// MARK: - HotNewReleaseViewModel Delegate
extension SpyDelegate: HotNewReleaseViewModelDelegate {
    func hotNewReleaseViewModel(didReceiveItem item: [HotNewReleaseViewModelItem]) {
        capturedItem = item
    }
    
    func hotNewReleaseViewModel(didReceiveError error: Error) {
        capturedError = error
    }
}

extension SpyDelegate: FavoriteViewModelDelegate {
    func favoriteViewModel(didReceiveData data: [PocketTube.FMedia]) {
        capturedFData = data
    }
    
    func favoriteViewModel(didReceiveError error: Error) {
        capturedError = error
    }
}
