//
//  SearchViewModelTest.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/29.
//

import XCTest
@testable import PocketTube

final class SearchViewModelTest: XCTestCase {

    func testInitAndNotNil() {
        // Arrange
        let mockDataProvider = SearchViewModelMockDataProvider(result: .success(MockData.fakeSearchItems))
        let sut = SearchViewModel(dataProvider: mockDataProvider)
        
        // Action
        
        // Assert
        XCTAssertNotNil(sut)
    }
    
    func testFetchSuccess() {
        // Arrange
        let mockDataProvider = SearchViewModelMockDataProvider(result: .success(MockData.fakeSearchItems))
        let sut = SearchViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.fetchDiscoverMovies()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        let expectation = self.expectation(description: "FetchDiscoverMovies")
 
        // Action
        sut.fetchDiscoverMovies()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // 給予足夠時間以等待非同步調用
            expectation.fulfill()
        }

        // Assert
        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(spy.capturedSearchItem)
            XCTAssertNil(spy.capturedError)
        }
    }
    
    func testFetchFailure() {
        // Arrange
        let mockDataProvider = SearchViewModelMockDataProvider(result: .failure(NSError(domain: "", code: 0)))
        let sut = SearchViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.fetchData()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        
        // Action
        sut.fetchDiscoverMovies()
        
        // Assert
        XCTAssertNil(spy.capturedSearchItem)
        XCTAssertNotNil(spy.capturedError)
    }
    
    func testSearchSuccess() {
        // Arrange
        let mockDataProvider = SearchViewModelMockDataProvider(result: .success(MockData.fakeSearchItems))
        let sut = SearchViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.search()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        let query = (MockData.fakeSearchItems[0] as? MoviesAndTVsItem)?.medias[0].original_title
        
        // Action
        sut.search(with: query!)
        
        // Assert
        XCTAssertEqual((spy.capturedSearchItem?[0] as? MoviesAndTVsItem)?.medias[0].original_title, query!)
        XCTAssertNil(spy.capturedError)
    }

    func testSearchFail() {
        // Arrange
        let mockDataProvider = SearchViewModelMockDataProvider(result: .success(MockData.fakeSearchItems))
        let sut = SearchViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.search()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        let query = (MockData.fakeSearchItems[0] as? MoviesAndTVsItem)?.medias[0].original_title
        
        // Action
        sut.search(with: query!)
        
        // Assert
        XCTAssertNotEqual((spy.capturedSearchItem?[0] as? MoviesAndTVsItem)?.medias[1].original_title, query!)
        XCTAssertNil(spy.capturedError)
    }
}
