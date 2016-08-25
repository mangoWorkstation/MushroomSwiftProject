
//
//  AppDelegate.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        //设置标题栏的字体 2016.8.25
        if let barFont = UIFont(name: "FZQKBYSJW--GB1-0", size: 17.5) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSForegroundColorAttributeName:UIColor.whiteColor(),
                 NSFontAttributeName:barFont]
        }
        
        //设置选项卡的字体 2016.8.25
        if let barFont = UIFont(name: "FZQKBYSJW--GB1-0", size: 12.0){
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1),NSFontAttributeName:barFont], forState: .Normal)
        }
        //方正清刻本悦宋简体 字体编号:FZQKBYSJW--GB1-0
        
//        UITabBar.appearance().tintColor = UIColor(red: 242/255, green: 116/255, blue: 119/255, alpha: 1)
        
        application.statusBarStyle = .LightContent
        
//        let fontFamilyNames = UIFont.familyNames()
//        for familyName in fontFamilyNames{
//            let fontNames = UIFont.fontNamesForFamilyName(familyName)
//            for fontName in fontNames {
//                print("\tFont : "+"\(fontName.utf8)"+" \n")
//            }
//        }
//        用来查找自定义字体编号 2016.8.25
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

