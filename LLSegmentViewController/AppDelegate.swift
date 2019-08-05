//
//  AppDelegate.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.white
        
        let tabCtl = UITabBarController.init()
        setUpChildController(tabBarCtl: tabCtl)
        window?.rootViewController = tabCtl
        return true
    }
    
    func setUpChildController(tabBarCtl:UITabBarController) {
        let test1 = ViewController()
        test1.title = "LLSegmentViewController"
        let nav1 = UINavigationController(rootViewController: test1)
        
        let test2 = HomeTestViewController()
        test2.title = "如果在首页"
        let nav2 = UINavigationController(rootViewController: test2)
        
        tabBarCtl.setViewControllers([nav1,nav2], animated: false)
    }
}

