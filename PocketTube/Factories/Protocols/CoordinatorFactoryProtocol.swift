//
//  CoordinatorFactoryProtocol.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    func makeTabbarCoordinator() -> (coordinator: Coordinatorable, toPresent: Presentable?)
//    func makeAuthCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeAuthCoordinator(router: Routerable) -> Coordinatorable
    func makeHomeCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeHotNewReleaseCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeFavoritesCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeProfileCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeSearchCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    
}
