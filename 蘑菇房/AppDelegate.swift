
//
//  AppDelegate.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cadiridris.coreDataTemplate" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "DataBase", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    //数码测色说明：
    //统一使用“普通RGB”数值进行测色
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GLOBAL_deviceModel = UIDevice().modelName
        //获取设备型号
        
        print(NSHomeDirectory())
        
        
        let userInfoDefault = UserDefaults()
        if (userInfoDefault.object(forKey: "UserInfoModel")) != nil{
            let userInfoModelData = userInfoDefault.object(forKey: "UserInfoModel") as! NSData
            let userInfoModel = NSKeyedUnarchiver.unarchiveObject(with: userInfoModelData as Data) as! UserProfiles
            GLOBAL_UserProfile = UserProfiles(face: userInfoModel.face as NSData, nickName: userInfoModel.nickName!, id: userInfoModel.id!, sex: userInfoModel.sex!, province: userInfoModel.province!, city: userInfoModel.city!, password: userInfoModel.password,root: userInfoModel.root!, allowPushingNotification: userInfoModel.allowPushingNotification!, allowPushingNewMessageToMobile: userInfoModel.allowPushingNewMessageToMobile!, latitude: userInfoModel.latitude!, longitude: userInfoModel.longitude!)
            print("用户数据读取成功\n")
            print("用户名:\(GLOBAL_UserProfile.nickName!)")
            print("用户ID:\(GLOBAL_UserProfile.id!)")
            print("密码（MD5）:\(GLOBAL_UserProfile.password!)\n")

        }
        else{
            //预留测试数据，未来功能是弹出登陆页面 2016.10.19
            let staticFace = UIImage(named: "2")
            let staticFaceData = UIImageJPEGRepresentation(staticFace!, 100)
            let id = arc4random()
            let passwordNum = arc4random()
            let password = String(passwordNum).hmac(algorithm: .MD5, key: String(id))
            //随机密钥
            let root = 2
            
            GLOBAL_UserProfile = UserProfiles(face: staticFaceData! as NSData, nickName: "芒果君", id: Int(id), sex: 1, province: "广西", city: "南宁",password:password, root: root,allowPushingNotification: false,allowPushingNewMessageToMobile: false,latitude: 0,longitude:0)
            let userInfoModelData = NSKeyedArchiver.archivedData(withRootObject: GLOBAL_UserProfile)
            userInfoDefault.set(userInfoModelData, forKey: "UserInfoModel")
            userInfoDefault.synchronize()
            print("用户数据保存成功")
            print("用户名:\(GLOBAL_UserProfile.nickName!)")
            print("用户ID:\(GLOBAL_UserProfile.id!)")
            print("密码（明文）:\(passwordNum)")
            print("密码（MD5）:\(GLOBAL_UserProfile.password!)")
        }

        GLOBAL_appFont = "PingFangSC-Regular"
        
        //设置app字体
        
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        //#409720

        
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
        
        UITabBar.appearance().tintColor = UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1)
//        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabitem-selected")?.withRenderingMode(.alwaysOriginal)
        
//        UITabBar.appearance().barTintColor = UIColor.clear
        
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
        let userInfoDefault = UserDefaults()
        let saveData = NSKeyedArchiver.archivedData(withRootObject: GLOBAL_UserProfile)
        userInfoDefault.set(saveData, forKey: "UserInfoModel")
        userInfoDefault.synchronize()
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
        let userInfoDefault = UserDefaults()
        let saveData = NSKeyedArchiver.archivedData(withRootObject: GLOBAL_UserProfile)
        userInfoDefault.set(saveData, forKey: "UserInfoModel")
        userInfoDefault.synchronize()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//说明:获取设备的型号
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

