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
    private(set) var capturedFData: [FMedia]?
    private(set) var capturedItem: [HotNewReleaseViewModelItem]?
    private(set) var capturedSearchItem: [SearchResultViewModelItem]?
    private(set) var capturedError: Error?
    
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

// MARK: - FavoriteViewModel Delegate
extension SpyDelegate: FavoriteViewModelDelegate {
    func favoriteViewModel(didReceiveData data: [PocketTube.FMedia]) {
        capturedFData = data
    }
    
    func favoriteViewModel(didReceiveError error: Error) {
        capturedError = error
    }
}

// MARK: - SearchViewModelDelegate
extension SpyDelegate: SearchViewModelDelegate {
    func searchViewModel(didReceiveData data: [SearchResultViewModelItem]) {
        capturedSearchItem = data
    }
    
    func searchViewModel(didReceiveSearchData data: [SearchResultViewModelItem]) {
        capturedSearchItem = data
    }
    
    func searchViewModel(didReceiveError error: Error) {
        capturedError = error
    }
}
