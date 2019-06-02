//
//  AppDelegate.swift
//  HeadacheTracker2
//
//  Created by Morgan Davison on 4/21/19.
//  Copyright © 2019 Morgan Davison. All rights reserved.
//

import UIKit
import CoreData
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "HeadacheTracker2")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard
            let tabBarController = window?.rootViewController as? UITabBarController,
            
            let headacheNav = tabBarController.viewControllers?[0] as? UINavigationController,
            let headacheViewController = headacheNav.viewControllers[0] as? HeadacheTableViewController,
            
            let calendarNav = tabBarController.viewControllers?[1] as? UINavigationController,
            let calendarViewController = calendarNav.viewControllers[0] as? CalendarCollectionViewController,
            
            let settingsNav = tabBarController.viewControllers?[2] as? UINavigationController,
            let settingsViewController = settingsNav.viewControllers[0] as? SettingsTableViewController
        else {
            os_log("App Delegate: Could not initialize all the view controllers", type: .error)
            return true
        }
        
        headacheViewController.coreDataStack = coreDataStack
        calendarViewController.coreDataStack = coreDataStack
        settingsViewController.coreDataStack = coreDataStack
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        coreDataStack.saveContext()
    }


}

