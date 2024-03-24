import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate, TabBarView {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        if let controller = customizableViewControllers?.first as? UINavigationController {
            if #available(iOS 11.0, *) {
                controller.navigationBar.prefersLargeTitles = true
            }
        }
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground() // 使用不透明背景
            tabBarAppearance.backgroundColor = .systemBackground
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }

    }
}
