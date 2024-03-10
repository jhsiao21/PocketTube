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
        let mockDataProvider = SearchViewModelMockDataProvider(result: .success(MockData.fakeMedias))
        let sut = SearchViewModel(dataProvider: mockDataProvider)
        
        // Action
        
        // Assert
        XCTAssertNotNil(sut)
    }
    
    func testFetchSuccess() {
        // Arrange
        let mockDataProvider = SearchViewModelMockDataProvider(result: .success(MockData.fakeMedias))
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
            XCTAssertNotNil(spy.capturedSearchData)
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
        XCTAssertNil(spy.capturedSearchData)
        XCTAssertNotNil(spy.capturedError)
    }
    
    func testSearchSuccess() {
        // Arrange
        let mockDataProvider = SearchViewModelMockDataProvider(result: .success(MockData.fakeMedias))
        let sut = SearchViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.search()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        let query = MockData.fakeMedias[0].displayTitle
        
        // Action
        sut.search(with: query)
        
        // Assert
        XCTAssertEqual(spy.capturedSearchData?[0].displayTitle, query)
        XCTAssertNil(spy.capturedError)
    }

    func testSearchFail() {
        // Arrange
        let mockDataProvider = SearchViewModelMockDataProvider(result: .success(MockData.fakeMedias))
        let sut = SearchViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.search()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        let query = MockData.fakeMedias[0].displayTitle //指定query內容是第一筆假資料
        
        // Action
        sut.search(with: query)
        
        // Assert
        XCTAssertNotEqual(spy.capturedSearchData?[1].displayTitle, query) //期望不相等：第二筆假資料displayTitle比對假資料第一筆displayTitle
        XCTAssertNil(spy.capturedError)
    }
}
