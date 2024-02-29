//
//  HotNewReleaseViewModelTest.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/29.
//

import XCTest
@testable import PocketTube

final class HotNewReleaseViewModelTest: XCTestCase {

    override func setUp() {
        super.setUp()
        
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testInitAndNotNil() {
        // Arrange
        let mockDataProvider = HotNewReleaseViewModelMockDataProvider(result: .success(MockData.fakeItems))
        let sut = HotNewReleaseViewModel(dataProvider: mockDataProvider)
        
        // Action
        
        // Assert
        XCTAssertNotNil(sut)
    }
    
    func testFetchSuccess() {
        // Arrange
        let mockDataProvider = HotNewReleaseViewModelMockDataProvider(result: .success(MockData.fakeItems))
        let sut = HotNewReleaseViewModel(dataProvider: mockDataProvider)
        
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
            XCTAssertNotNil(spy.capturedItem)
            XCTAssertNil(spy.capturedError)
        }
    }
    
    func testFetchFailure() {
        // Arrange
        let mockDataProvider = HotNewReleaseViewModelMockDataProvider(result: .failure(NSError(domain: "", code: 0)))
        let sut = HotNewReleaseViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.fetchData()的callback結果
        let spy = SpyDelegate()
        sut.delegate = spy
        
        // Action
        sut.fetchData()
        
        // Assert
        XCTAssertNil(spy.capturedItem)
        XCTAssertNotNil(spy.capturedError)
    }
}
