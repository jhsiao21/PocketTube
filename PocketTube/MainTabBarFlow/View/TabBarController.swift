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
    }
}
