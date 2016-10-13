
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

    //数码测色说明：
    //统一使用“普通RGB”数值进行测色
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GLOBAL_deviceModel = UIDevice().modelName
        //获取设备型号
        

        GLOBAL_appFont = "PingFangSC-Regular"
        //设置app字体
        //编号如下:
        //Hanzipen - HanziPenSC-W3/HanziPenSC-W5
        //Hannotate - HannotateSC-W5/HannotateSC-W7
        //站酷快乐体 字体编号:HappyZcool-2016
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white

        
        //设置标题栏的字体 2016.8.25
        if let barFont = UIFont(name: GLOBAL_appFont!, size: 17.5) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor.white,
                NSFontAttributeName:barFont
            ]
        }
        
        //设置选项卡的字体 2016.8.25
        if let barFont = UIFont(name: "PingFangSC-Regular", size: 10){
            UITabBarItem.appearance().setTitleTextAttributes(
                [
//                    NSForegroundColorAttributeName:UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1),
//                    NSBackgroundColorAttributeName:UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1),
                    NSFontAttributeName:barFont
                ],
                for: UIControlState()
            )
        }
        
        
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabitem-selected")
        
        application.statusBarStyle = .lightContent
        
        Thread.sleep(forTimeInterval: 1.0)
        //设置启动页的停留时间
        
//        用来查找自定义字体编号,需要时取消注释状态 2016.8.25
//        let fontFamilyNames = UIFont.familyNames()
//        for familyName in fontFamilyNames{
//            let fontNames = UIFont.fontNamesForFamilyName(familyName)
//            for fontName in fontNames {
//                print("\tFont : "+"\(fontName.utf8)"+" \n")
//            }
//        }
//        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//extension说明:获取设备的型号
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

