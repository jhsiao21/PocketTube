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
        let mockDataProvider = MockDataProvider(result: .success(FakeMedia.fakeMediaData))
        let viewModel = HomeViewModel(dataProvider: mockDataProvider)
        
        // Action
        
        // Assert
        XCTAssertNotNil(viewModel)
    }
    
    func testFetchSuccess() {
        // Arrange
        let mockDataProvider = MockDataProvider(result: .success(FakeMedia.fakeMediaData))
        let viewModel = HomeViewModel(dataProvider: mockDataProvider)
        
        //Spy去接sut.fetchData()的callback結果
        let spy = SpyDelegate()
        viewModel.delegate = spy
        let expectation = self.expectation(description: "FetchDataSuccess")
 
        // Action
        viewModel.fetchData()
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
        let provider = MockDataProvider(result: .failure(NSError(domain: "", code: 0)))
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

class SpyDelegate: HomeViewModelDelegate {
    private(set) var capturedData: [String : [PocketTube.Media]]?
    private(set) var capturedError: Error?
    
    func homeViewModel(didReceiveData mediaData: [String : [PocketTube.Media]]) {
        capturedData = mediaData
    }
    
    func homeViewModel(didReceiveError error: Error) {
        capturedError = error
    }
}
