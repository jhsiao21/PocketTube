//
//  MockCoordinator.swift
//  ApplicationCoordinatorTests
//
//  Created by LoganMacMini on 2024/3/21.
//

import Foundation
@testable import PocketTube

final class MockCoordinator: Coordinatorable {

    var finishFlow: (() -> Void)?
    var startCalled = false
    
    func start() {
        startCalled = true
    }
    
}
