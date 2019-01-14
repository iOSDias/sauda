//
//  MainTabBarController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    static let shared = MainTabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}

extension MainTabBarController {
    func setupTabBar() {
        tabBar.tintColor = UIColor.purple1
        tabBar.unselectedItemTintColor = .gray
        
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        firstVC.tabBarItem.image = #imageLiteral(resourceName: "home-black")
        firstVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "home-white")
        
        let secondVC = UINavigationController(rootViewController: CategoriesViewController())
        secondVC.tabBarItem.image = #imageLiteral(resourceName: "category-black")
        secondVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "category-white")


        let thirdVC = UINavigationController(rootViewController: HistoryViewController())
        thirdVC.tabBarItem.image = #imageLiteral(resourceName: "history-black")
        thirdVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "history-white")
        
        let fourthVC = UINavigationController(rootViewController: FavouritesViewController())
        fourthVC.tabBarItem.image = #imageLiteral(resourceName: "like-black")
        fourthVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "like-white")
        
        let fifthVC = UINavigationController(rootViewController: ProfileViewController())
        fifthVC.tabBarItem.image = #imageLiteral(resourceName: "profile-black")
        fifthVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile-white")
        
        let array = [firstVC, secondVC, thirdVC, fourthVC, fifthVC]
        array.forEach({
            $0.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
            $0.navigationBar.tintColor = .white
        })
        viewControllers = array
    }
}
