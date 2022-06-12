//
//  AppDelegate.swift
//  Restaurant
//
//  Created by Владимир Ладыгин on 11.06.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orderTabBarItem: UITabBarItem!
    
    @objc func updateOrderBadge() {
        let count = OrderManager.shared.order.menuItems.count
        orderTabBarItem.badgeValue = 0 < count ? "\(count)" : nil
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
        
        let tabBarController = window!.rootViewController as! UITabBarController
        orderTabBarItem = tabBarController.viewControllers![1].tabBarItem
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateOrderBadge),
            name: OrderManager.orderUpdateNotification,
            object: nil)
        
        return true
    }
}
