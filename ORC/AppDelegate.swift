//
//  AppDelegate.swift
//  ORC
//
//  Created by Dias Ermekbaev on 02.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import CoreData
import DeviceKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var tabbarController: MainTabBarController!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.statusBarBackgroundColor = UIColor.blue1
        getRequiredFontSize()
        setupKeyboardSettings()
        Coordinator.shared.presentInitialScreen()
        UINavigationBar.appearance().isTranslucent = false
        window?.makeKeyAndVisible()
        return true
    }
    
    func setupKeyboardSettings() {
        let km = IQKeyboardManager.shared
        km.enable = true
        km.toolbarDoneBarButtonItemImage = #imageLiteral(resourceName: "keyboard")
        km.previousNextDisplayMode = .alwaysShow
        km.keyboardDistanceFromTextField = 20
    }
    
    func getRequiredFontSize() {
        let device = Device()
        let group58: [Device] = [.iPhoneX, .simulator(.iPhoneX)]
        let group55: [Device] = [.iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6sPlus, .simulator(.iPhone8Plus), .simulator(.iPhone7Plus), .simulator(.iPhone6Plus), .simulator(.iPhone6sPlus)]
        let group47: [Device] = [.iPhone8, .iPhone7, .iPhone6s, .iPhone6, .simulator(.iPhone8), .simulator(.iPhone7), .simulator(.iPhone6s), .simulator(.iPhone6)]
        let group4: [Device] = [.iPhone5, .iPhone5s, .iPhoneSE, .simulator(.iPhone5), .simulator(.iPhone5s), .simulator(.iPhoneSE), .iPhone5c, .simulator(.iPhone5c)]
        let groupPad: [Device] = [.iPad2, .iPad3, .iPad4, .iPad5, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro9Inch, .iPadPro10Inch, .iPadPro12Inch, .iPadPro12Inch2]
        let groupSimulatorPad = Device.allSimulatorPads
        
        if device.isOneOf(group58) {
            Constants.fontSize = 19
        } else if device.isOneOf(group55) {
            Constants.fontSize = 18
        } else if device.isOneOf(group47) {
            Constants.fontSize = 17
        } else if device.isOneOf(group4) {
            Constants.fontSize = 15
        } else if device.isOneOf(groupPad) || device.isOneOf(groupSimulatorPad) {
            Constants.fontSize = 19
        } else {
            Constants.fontSize = 17
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ORC")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

