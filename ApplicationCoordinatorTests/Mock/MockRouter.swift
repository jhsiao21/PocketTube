//
//  MockRouter.swift
//  ApplicationCoordinatorTests
//
//  Created by LoganMacMini on 2024/3/21.
//

import UIKit
@testable import PocketTube

final class MockRouter: Routerable {
    
    
    // in test cases router store the rootController referense
    private(set) var navigationStack: [UIViewController] = []
    private(set) var presented: UIViewController?
    private var completions: [UIViewController : () -> Void] = [:]
    var setRootModuleCalled: Bool = false
    
    func toPresent() -> UIViewController? {
        return nil
    }
    
    //all of the actions without animation
    func present(_ module: Presentable?) {
        present(module, animated: false)
    }
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        presented = controller
    }
    
    func push(_ module: Presentable?)  {
        push(module, animated: false)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }

    func push(_ module: Presentable?, hideBottomBar: Bool) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        controller.hidesBottomBarWhenPushed = hideBottomBar

        push(module, animated: false)
    }

    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {

        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationStack.append(controller)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        navigationStack.append(controller)
    }
    
    func popModule()  {
        popModule(animated: false)
    }
    
    func popModule(animated: Bool)  {
        let controller = navigationStack.removeLast()
        runCompletion(for: controller)
    }
    
    func dismissModule() {
        dismissModule(animated: false, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        presented = nil
    }
    
    func setRootModule(_ module: Presentable?) {
        guard let controller = module?.toPresent() else { return }
        navigationStack.append(controller)
        setRootModuleCalled = true
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        assertionFailure("This method is not used.")
    }
    
    func setRootModule(_ module: PocketTube.Presentable?, hideBar: Bool, animated: Bool) {
        
    }

    func popToRootModule(animated: Bool) {
        guard let first = navigationStack.first else { return }
        
        navigationStack.forEach { controller in
            runCompletion(for: controller)
        }
        navigationStack = [first]
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
