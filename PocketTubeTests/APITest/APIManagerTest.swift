//
//  APIManagerTest.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/28.
//

import XCTest
@testable import PocketTube

final class APIManagerTest: XCTestCase {

    private var apiManager: APIManagerProtocol!
    
    override func setUp() {
        super.setUp()
        apiManager = APIManager()
    }
    
    override func tearDown() {
        super.tearDown()
        apiManager = nil
    }
    
    func testFetchMandrainMedia() {
        apiManager.fetchMandarinMedia { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 40)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchPlayingMedia() {
        apiManager.fetchPlayingMedia { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 40)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchTrendingMovies() {
        apiManager.fetchTrendingMovies { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchTrendingTvs() {
        apiManager.fetchTrendingTvs { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchUpcomingMovies() {
        apiManager.fetchUpcomingMovies { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchPopularMovies() {
        apiManager.fetchPopularMovies { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchTop10Movies() {
        apiManager.fetchTop10Movies { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchTop10TVs() {
        apiManager.fetchTop10TVs { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchDiscoverMovies() {
        apiManager.fetchDiscoverMovies { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchMediaFromUrl() {
        apiManager.fetchMediaFromUrl(Constants.TrendingMoviesUrl) { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testSearchMedia() {
        apiManager.searchMedia(with: "Marvel") { result in
            switch result {
            case .success(let medias):
                XCTAssertNotNil(medias)
//                XCTAssert(medias.count == 20)
            case .failure:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchYouTubeMedia() {
        let mediaName = "Land of Bad"
        apiManager.fetchYouTubeMedia(with: "\(mediaName) trailer") { result in
            switch result {
            case .success(let videoElement):
                XCTAssertNotNil(videoElement)
            case .failure:
                XCTAssert(false)
            }
        }
    }

}
