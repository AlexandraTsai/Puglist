//
//  AppDelegate.swift
//  puglist
//
//  Created by ST20991 on 2019/08/28.
//  Copyright © 2019 fengyi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        var mockAPI = API()
        // 1. Empty
//        mockAPI.getPugList = { callback in
//            callback(nil, [])
//        }
        
        // 2. Error
//        mockAPI.getPugList = { callback in
//            callback(NSError.init(domain: "", code: 0, userInfo: nil), nil)
//        }
        
        // 3. Loading
//        mockAPI.getPugList = { callback in
//
//        }
        
        // 4. Normal
        mockAPI.getPugList = { callback in
            callback(nil,
                     [.init(pugId: "tedthepug0810",
                            name: "小巴哥",
                            photo: "https://fengyi-line.github.io/Puglist/api/image/ted.jpg")])
        }
        
        window?.rootViewController  = UINavigationController(rootViewController: PugListViewController(api: mockAPI))
        window?.makeKeyAndVisible()
        
        return true
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
    }


}

