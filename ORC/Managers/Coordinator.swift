//
//  Coordinator.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class Coordinator {
    
    // MARK: - Constants
    private enum Constant {
        enum Attributes {
            static let navigationTitleText: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        }
    }
    
    // MARK: - Properties
    static let shared = Coordinator()
    
    // MARK: - Methods
    private func getHomeNC() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = Constant.Attributes.navigationTitleText
        navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "home-black"), selectedImage: UIImage(named: "home-white"))
        navigationController.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
        return navigationController
    }
    
    private func getCategoriesNC() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: CategoriesViewController())
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = Constant.Attributes.navigationTitleText
        navigationController.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
        navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "category-black"), selectedImage: UIImage(named: "category-white"))
        return navigationController
    }
    
    private func getHistoryNC() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: HistoryViewController())
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = Constant.Attributes.navigationTitleText
        navigationController.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
        navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "history-black"), selectedImage: UIImage(named: "history-white"))
        return navigationController
    }
    
    private func getFavouritesNC() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: FavouritesViewController())
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
        navigationController.navigationBar.titleTextAttributes = Constant.Attributes.navigationTitleText
        navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "like-black"), selectedImage: UIImage(named: "like-white"))
        return navigationController
    }
    
    private func getProfileNC() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: ProfileViewController())
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
        navigationController.navigationBar.titleTextAttributes = Constant.Attributes.navigationTitleText
        navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profile-black"), selectedImage: UIImage(named: "profile-white"))
        return navigationController
    }
    
    func presentMainTabBarScreen(on window: UIWindow = UIApplication.shared.window) {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([getHomeNC(), getCategoriesNC(), getHistoryNC(), getFavouritesNC(), getProfileNC()], animated: false)
        tabBarController.tabBar.tintColor = .purple1
        tabBarController.tabBar.unselectedItemTintColor = .gray
        tabBarController.selectedIndex = 0
        
        UIApplication.shared.window.rootViewController = tabBarController
    }
    
    func presentTutorialScreen(on window: UIWindow = UIApplication.shared.window) {
        UIApplication.shared.window.rootViewController = TutorialViewController()
    }
    
    func presentAuthorizationScreen(on window: UIWindow = UIApplication.shared.window) {
        let navigationController = UINavigationController(rootViewController: AuthorizationViewController())
        UIApplication.shared.window.rootViewController = navigationController
    }
    
    func presentInitialScreen(on window: UIWindow = UIApplication.shared.window) {
        if TutorialManager().isViewed {
            presentMainTabBarScreen()
        } else {
            presentTutorialScreen()
        }
//
//        if Constants.User.hasToken() {
//            presentMainTabBarScreen()
//        } else if TutorialManager().isViewed {
//            presentAuthorizationScreen()
//        } else {
//            presentTutorialScreen()
//        }
    }
}
