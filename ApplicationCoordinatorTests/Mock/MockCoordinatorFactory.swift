//
//  MockCoordinatorFactory.swift
//  ApplicationCoordinatorTests
//
//  Created by LoganMacMini on 2024/3/21.
//

import UIKit
@testable import PocketTube

final class MockCoordinatorFactory: CoordinatorFactoryProtocol {
    
    var makeTabbarCoordinatorCalled = false
    var makeAuthCoordinatorCalled = false
    var makeHomeCoordinatorCalled = false
    var makeHotNewReleaseCoordinatorCalled = false
    var makeFavoritesCoordinatorCalled = false
    var makeProfileCoordinatorCalled = false
    var makeSearchCoordinatorCalled = false
    var makePersonalInfoCoordinatorCalled = false
    var makeForgotPasswordCoordinatorCalled = false
    var makeSignUpCoordinatorCalled = false
    
    var mockAuthCoordinator: Coordinatorable?
    
    func makeTabbarCoordinator() -> (coordinator: PocketTube.Coordinatorable, toPresent: PocketTube.Presentable?) {
        makeTabbarCoordinatorCalled = true
        return (MockCoordinator(), nil)
    }
    
    func makeAuthCoordinator(router: PocketTube.Routerable) -> PocketTube.Coordinatorable {
        makeAuthCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
    
    func makeHomeCoordinator(navigationController: UINavigationController?) -> PocketTube.Coordinatorable {
        makeHomeCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
    
    func makeHotNewReleaseCoordinator(navigationController: UINavigationController?) -> PocketTube.Coordinatorable {
        makeHotNewReleaseCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
    
    func makeFavoritesCoordinator(navigationController: UINavigationController?) -> PocketTube.Coordinatorable {
        makeFavoritesCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
    
    func makeProfileCoordinator(navigationController: UINavigationController?) -> PocketTube.Coordinatorable {
        makeProfileCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
    
    func makeSearchCoordinator(navigationController: UINavigationController?) -> PocketTube.Coordinatorable {
        makeSearchCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
    
    func makePersonalInfoCoordinator(navigationController: UINavigationController?) -> PocketTube.Coordinatorable {
        makePersonalInfoCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
    
    func makeForgotPasswordCoordinator(navigationController: UINavigationController?) -> PocketTube.Coordinatorable {
        makeForgotPasswordCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
    
    func makeSignUpCoordinator(navigationController: UINavigationController?) -> PocketTube.Coordinatorable {
        makeSignUpCoordinatorCalled = true
        return mockAuthCoordinator ?? MockCoordinator()
    }
}

