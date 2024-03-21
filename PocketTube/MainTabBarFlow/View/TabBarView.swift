import UIKit

protocol TabBarView: AnyObject {
    var selectedIndex: Int { get set }
    func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool)
}
