//
//  DatabaseManagerTest.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/28.
//

import XCTest
@testable import PocketTube

final class DatabaseManagerTest: XCTestCase {
    
    private var databaseManager: DatabaseManagerProtocol!
    
    override func setUp() {
        super.setUp()
        databaseManager = DatabaseManager()
    }
    
    override func tearDown() {
        super.tearDown()
        databaseManager = nil
    }
    
    func testSafeEmail() {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: "logan.hsiao.jk@gmail.com")
        
        XCTAssertEqual(safeEmail, "logan-hsiao-jk@gmail-com")
    }
    
    func testFavoriteMediaFail() {
        
        // 1. Arrange
        let expectation = self.expectation(description: "Completion handler invoked")
        var result: (Result<FavoriteResponse, Error>)?
        
        // 2. Action
        databaseManager.favoriteMedia(uid: realUid, media: MockData.realFMedia) { res in
            result = res
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Assert
        switch result {
        case .success(let response):
            XCTAssertEqual(response, .exists)
        case .failure:
            XCTAssert(false)
        default:
            XCTFail("Expected success, got \(String(describing: result)), instead")
        }
    }
    
    //    func testRecordMediaSuccess() {
    //
    //        // 1. Arrange
    //        let expectation = self.expectation(description: "Completion handler invoked")
    //        var result: (Result<FavoriteResponse, Error>)?
    //
    //        // 2. Action
    //
    //        databaseManager.recordMedia(uid: fakeUid, media: FakeMedia.testData) { res in
    //            result = res
    //            expectation.fulfill()
    //        }
    //
    //        waitForExpectations(timeout: 5, handler: nil)
    //
    //        // 3. Assert
    //        switch result {
    //        case .success(let response):
    //            XCTAssertEqual(response, .added)
    //        case .failure:
    //            XCTAssert(false)
    //        default:
    //            XCTFail("Expected success, got \(String(describing: result)), instead")
    //        }
    //    }
    
    func testMediaExists() {
        
        // 1. Arrange
        let expectation = self.expectation(description: "Completion handler invoked")
        var result: Result<Bool, Error>?
        
        // 2. Action
        databaseManager.isFavoriteMediaExists(with: MockData.realFMedia.caption, uid: realUid) { res in
            result = res
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Assert
        switch result {
        case .success(let exists):
            XCTAssertTrue(exists)
        default:
            XCTFail("Expected success, got \(String(describing: result)), instead")
        }
    }
    
    func testMediaNotExists() {
        
        // 1. Arrange
        let expectation = self.expectation(description: "Completion handler invoked")
        var result: Result<Bool, Error>?
        
        // 2. Action
        databaseManager.isFavoriteMediaExists(with: MockData.fakeFMedia.caption, uid: realUid) { res in
            result = res
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Assert
        switch result {
        case .success(let exists):
            XCTAssertFalse(exists)
        default:
            XCTFail("Expected success, got \(String(describing: result)), instead")
        }
    }
    
    func testFetchMedias() {
        // 1. Arrange
        let expectation = self.expectation(description: "Completion handler invoked")
        var result: Result<[FMedia], Error>?
        
        // 2. Action
        databaseManager.fetchMedias(uid: realUid) { res in
            result = res
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // 3. Assert
        switch result {
        case .success(let medias):
            XCTAssertNotEqual(medias, nil)
        default:
            XCTFail("Expected success, got \(String(describing: result)), instead")
        }
    }
    
    //    func testMediaDelete() {
    //        // 1. Arrange
    //        let expectation = self.expectation(description: "Completion handler invoked")
    //        var result: Result<Bool, Error>?
    //
    //        // 2. Action
    //        databaseManager.mediaDelete(mediaId: FakeMedia.testData.mId) { res in
    //            result = res
    //            expectation.fulfill()
    //        }
    //
    //        waitForExpectations(timeout: 5, handler: nil)
    //
    //        // 3. Assert
    //        switch result {
    //        case .success(let success):
    //            XCTAssertTrue(success)
    //        default:
    //            XCTFail("Expected success, got \(String(describing: result)), instead")
    //        }
    //    }
    
    func testFavoriteMediaThenDelete() {
        let recordExpectation = expectation(description: "recordMedia completion")
        let deleteExpectation = expectation(description: "mediaDelete completion")
        
        databaseManager.favoriteMedia(uid: fakeUid, media: MockData.fakeFMedia) { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                recordExpectation.fulfill()
                
                // 如果recordMedia成功，接著測試delete
                self.databaseManager.mediaDelete(mediaId: MockData.fakeFMedia.mId) { deleteResult in
                    switch deleteResult {
                    case .success(let success):
                        XCTAssertTrue(success)
                    case .failure(let error):
                        XCTFail("Deletion failed with error: \(error)")
                    }
                    deleteExpectation.fulfill()
                }
                
            case .failure(let error):
                XCTFail("Recording failed with error: \(error)")
                recordExpectation.fulfill()
            }
        }
        
        wait(for: [recordExpectation, deleteExpectation], timeout: 10.0)
    }
}
