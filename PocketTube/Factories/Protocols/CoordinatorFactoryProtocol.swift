import UIKit

protocol CoordinatorFactoryProtocol {
    func makeTabbarCoordinator() -> (coordinator: Coordinatorable, toPresent: Presentable?)
    func makeAuthCoordinator(router: Routerable) -> Coordinatorable
    func makeHomeCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeHotNewReleaseCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeFavoritesCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeProfileCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeSearchCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makePersonalInfoCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeForgotPasswordCoordinator(navigationController: UINavigationController?) -> Coordinatorable
}
