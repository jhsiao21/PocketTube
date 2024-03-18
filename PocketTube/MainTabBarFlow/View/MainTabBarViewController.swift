//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 04/11/2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        launchScreenAnimation()
                
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: HotNewReleaseViewController())
        let vc3 = UINavigationController(rootViewController: FavoritesViewController())
        let vc4 = UINavigationController(rootViewController: ProfileViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.rectangle.on.rectangle")
        vc3.tabBarItem.image = UIImage(systemName: "heart.circle")
        vc4.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        vc1.title = "首頁"
        vc2.title = "熱播新片"
        vc3.title = "口袋名單"
        vc4.title = "個人頁面"
        
        //適應dark mode and light mode
        tabBar.tintColor = .label
        tabBar.isTranslucent = false
        
        tabBar.shadowImage = UIImage()
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)

//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func launchScreenAnimation()
    {
        guard let launchScreen = UIStoryboard (name: "LaunchScreen", bundle:nil).instantiateInitialViewController() else { return }
        self.view.addSubview(launchScreen.view)
        if let label = launchScreen.view.viewWithTag(1) as? UILabel {
            UIView.animate(withDuration: 3,
                           delay: 0,
                           options: .curveEaseInOut ,
                           animations: {
                label.transform = CGAffineTransform (rotationAngle: .pi)
                label.transform = .identity
                launchScreen.view.alpha = 0
            }) { (finished) in
                launchScreen.view.removeFromSuperview()
            }
        }
    }
}
