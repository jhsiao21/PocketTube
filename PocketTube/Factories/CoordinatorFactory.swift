//
//  CoordinatorFactory.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class CoordinatorFactory: CoordinatorFactoryProtocol {

    func makeTabbarCoordinator() -> (coordinator: Coordinatorable, toPresent: Presentable?) {
        let controller = TabBarController()
        let coordinator = TabBarCoordinator(tabBarView: controller, coordinatorFactory: CoordinatorFactory())
        return (coordinator, controller)
    }

    func makeHomeCoordinator(
        navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = HomeCoordinator(factory: SceneFactory(),
                                          coordinatorFactory: CoordinatorFactory(),
                                          router: router(navigationController))
        return coordinator
    }

    func makeHotNewReleaseCoordinator(
        navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = HotNewReleaseCoordinator(factory: SceneFactory(),
                                          coordinatorFactory: CoordinatorFactory(),
                                          router: router(navigationController))
        return coordinator
    }

    func makeFavoritesCoordinator(
        navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = FavoritesCoordinator(factory: SceneFactory(),
                                          coordinatorFactory: CoordinatorFactory(),
                                          router: router(navigationController))
        return coordinator
    }

    func makeAuthCoordinator(router: Routerable) -> Coordinatorable {
        let coordinator = AuthCoordinator(factory: SceneFactory(),
                                          coordinatorFactory: CoordinatorFactory(),
                                          router: router)
        return coordinator
    }
    
    func makeSearchCoordinator(
        navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = SearchCoordinator(factory: SceneFactory(),
                                          coordinatorFactory: CoordinatorFactory(),
                                          router: router(navigationController))
        return coordinator
    }
    
    func makeProfileCoordinator(
        navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = ProfileCoordinator(factory: SceneFactory(),
                                             coordinatorFactory: CoordinatorFactory(),
                                             router: router(navigationController))
        return coordinator
    }
}

private extension CoordinatorFactory {

    func router(_ navigationController: UINavigationController?) -> Routerable {
        return Router(rootController: self.navigationController(navigationController))
    }

    func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController {
            return navController
        } else {
            return UINavigationController()
        }
    }
}
