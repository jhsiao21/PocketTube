import UIKit

protocol TabBarCoordinatorProtocol {
    var tabBarView: TabBarView { get set }

    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorProtocol {

    private let coordinatorFactory: CoordinatorFactoryProtocol

    init(tabBarView: TabBarView, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.tabBarView = tabBarView
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage]
        pages = [.home, .hotNewRelease, .favorite, .profile]
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages
            .sorted(by: { $0.pageOrderNumber < $1.pageOrderNumber })
            .map({ getTabController($0) })

        prepareTabBarController(withTabControllers: controllers)
    }

    // MARK: - TabBarCoordinatorProtocol
    var tabBarView: TabBarView

    func currentPage() -> TabBarPage? {TabBarPage(index: tabBarView.selectedIndex)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarView.selectedIndex = page.pageOrderNumber
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        tabBarView.selectedIndex = page.pageOrderNumber
    }
}

private extension TabBarCoordinator {

    func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Assign page's controllers
        tabBarView.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarView.selectedIndex = TabBarPage.home.pageOrderNumber
    }

    func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        navController.tabBarItem = UITabBarItem(title: page.pageTitleValue,
                                                image: page.pageIconImage,
                                                tag: page.pageOrderNumber)
        
        switch page {
        case .home:
            let coordinator = coordinatorFactory.makeHomeCoordinator(
                navigationController: navController
            ) as! HomeCoordinator
            addDependency(coordinator)
            coordinator.onUserIconTap = { [weak self] in
                self?.selectPage(.profile)
            }
            coordinator.start()
        case .hotNewRelease:
            let coordinator = coordinatorFactory.makeHotNewReleaseCoordinator(
                navigationController: navController
            ) as! HotNewReleaseCoordinator
            addDependency(coordinator)
            coordinator.transitToProfileView = { [weak self] in
                self?.selectPage(.profile)
            }
            coordinator.start()
        case .favorite:
            let coordinator = coordinatorFactory.makeFavoritesCoordinator(
                navigationController: navController
            )
            addDependency(coordinator)
            coordinator.start()
        case .profile:
            let coordinator = coordinatorFactory.makeProfileCoordinator(navigationController: navController)
            addDependency(coordinator)
            (coordinator as? ProfileCoordinator)?.finishFlow = { [unowned self] () in
                removeDependency(self)
                self.finishFlow?() // tab bar's finish flow
            }
            coordinator.start()
        }
        return navController
    }
}
