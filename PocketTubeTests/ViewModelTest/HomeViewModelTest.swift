//
//  HomeViewModelTest.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/28.
//

import XCTest
@testable import PocketTube

final class HomeViewModelTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    func testInitAndNotNil() {
        // Arrange
        let mockDataProvider = HomeViewModelMockDataProvider(result: .success(MockData.fakeMediaDic))
        let sut = HomeViewModel(dataProvider: mockDataProvider)
        
        // Action
        
        // Assert
        XCTAssertNotNil(sut)
    }
    
    func testFetchSuccess() {
        // Arrange
        let mockDataProvider = HomeViewModelMockDataProvider(result: .success(MockData.fakeMediaDic))
        let sut = HomeViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.fetchData()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        let expectation = self.expectation(description: "FetchDataSuccess")
 
        // Action
        sut.fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // 給予足夠時間以等待非同步調用
            expectation.fulfill()
        }

        // Assert
        waitForExpectations(timeout: 5) { error in
            XCTAssertNotNil(spy.capturedData)
            XCTAssertNil(spy.capturedError)
        }
    }
    
    func testFetchFailure() {
        // Arrange
        let provider = HomeViewModelMockDataProvider(result: .failure(NSError(domain: "", code: 0)))
        let sut = HomeViewModel(dataProvider: provider)
        
        //Spy去接sut.fetchData()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        
        // Action
        sut.fetchData()
        
        // Assert
        XCTAssertNil(spy.capturedData)
        XCTAssertNotNil(spy.capturedError)
    }
}
