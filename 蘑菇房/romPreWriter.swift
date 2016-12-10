//
//  romPreWriter.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//MARK: - 固件预置数据库读写

class romWriter: NSObject {
    
    //MARK: - 基地表100段
    func insertNewRecordForBases(){
        var main_user : [Int64] = []
        var main_base : [Int64] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        
        let currentUser_ID = GLOBAL_UserProfile.id!
        let currentBase_ID = arc4random()
        main_user.append(Int64(currentUser_ID))
        main_base.append(Int64(currentBase_ID))
        let current_base_entity = NSEntityDescription.insertNewObject(forEntityName: "Base", into: context) as! BaseManagedObject
        current_base_entity.user_ID = Int64(currentUser_ID)
        current_base_entity.base_ID = Int64(currentBase_ID)
        do {
            try context.save()
            print("当前用户与基地ID成功写入缓存")
        } catch let error{
            print("context can't save!, Error: \(error)")
        }
        
        
        for _ in 0..<100 {
            var temp_user_ID = Int64(arc4random())
            for temp in main_user{
                while temp == temp_user_ID {
                    temp_user_ID = Int64(arc4random())
                }
            }
            var temp_base_ID = Int64(arc4random())
            for temp in main_base{
                while temp == temp_base_ID {
                    temp_base_ID = Int64(arc4random())
                }
            }
            main_user.append(temp_user_ID)
            main_base.append(temp_base_ID)
            
            let temp_base_entity = NSEntityDescription.insertNewObject(forEntityName: "Base", into: context) as! BaseManagedObject
            temp_base_entity.user_ID = temp_user_ID
            temp_base_entity.base_ID = temp_base_ID
            
            do {
                try context.save()
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
        }
        print("成功写入基地表\n")
        
    }
    
    
    //MARK: - 农作物表4段
    func insertNewRecordForCrops(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        var mainKeys : [Int64] = []
        let cropsTypeName = ["蘑菇","芒果","甘蔗","葡萄"]
        for i in 0..<4 {
            var crops_ID = Int64(arc4random())
            for temp in mainKeys {
                while temp == crops_ID{
                    crops_ID = Int64(arc4random())
                }
            }
            mainKeys.append(crops_ID)
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Crops", into: context) as! CropsManagedObject
            entity.crops_ID = crops_ID
            entity.crops_name = cropsTypeName[i]
            do {
                try context.save()
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
        }
        print("成功写入农作物表")
    }
    
    
    //MARK: - 空气湿度表100段
    func insertNewRecordForAirHumidity(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        
        //取基地表
        var entity = NSEntityDescription.entity(forEntityName: "Base", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        let Base = try? context.fetch(fetchRequest) as! [NSManagedObject]
        var baseManageObjectArr : [MonitoringDataSource] = []
        for tempBase in Base as! [BaseManagedObject]{
            let baseManageObjectArrTemp = MonitoringDataSource(baseID: 0,userID: 0,time: 0,value: 0,dataID: 0,cropsID: 0)
            baseManageObjectArrTemp.baseID = tempBase.base_ID
            baseManageObjectArrTemp.userID = tempBase.user_ID
            baseManageObjectArr.append(baseManageObjectArrTemp)
        }
        
        //取农作物表
        entity = NSEntityDescription.entity(forEntityName: "Crops", in: context)
        fetchRequest.entity = entity
        let Crops = try? context.fetch(fetchRequest) as! [NSManagedObject]
        var tempCropsArr : [MonitoringDataSource] = []
        for tempCrop in Crops as! [CropsManagedObject] {
            let cropsManageObjectArrTemp = MonitoringDataSource(baseID: 0,userID: 0,time: 0,value: 0,dataID: 0,cropsID: 0)
            cropsManageObjectArrTemp.cropsID = tempCrop.crops_ID
            tempCropsArr.append(cropsManageObjectArrTemp)
        }
        
        
        var dataIDExisted : [Int64] = []
        var timeExisted : [Int64] = []
        var valueExisted : [Double] = []
        for i in 0..<100 {
            //数据ID
            var data_ID = Int64(arc4random())
            for temp in dataIDExisted {
                while temp == data_ID{
                    data_ID = Int64(arc4random())
                }
            }
            dataIDExisted.append(data_ID)
            //时间
            var time = Int64(arc4random_uniform(1500000000)+1400000000)
            for temp in timeExisted {
                while temp == time{
                    time = Int64(arc4random_uniform(1500000000)+1400000000)
                }
            }
            timeExisted.append(time)
            //数值
            var value = Double(arc4random_uniform(50))
            for temp in valueExisted {
                while temp == value{
                    value = Double(arc4random_uniform(50))
                }
            }
            valueExisted.append(Double(value))
            
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Humidity", into: context) as! HumidityManagedObject
            if i<(Base?.count)! {
                entity.base_ID = baseManageObjectArr[i].baseID
                entity.user_ID = baseManageObjectArr[i].userID
            }
            else{
                entity.base_ID = (baseManageObjectArr.first?.baseID)!
                entity.user_ID = (baseManageObjectArr.first?.userID)!
            }
            
            if i<(Crops?.count)! {
                entity.crops_ID = tempCropsArr[i].cropsID
            }
            else{
                entity.crops_ID = (tempCropsArr.first?.cropsID)!
            }
            
            entity.data_ID = data_ID
            entity.time = time
            entity.value = Double(value)
            
            
            do {
                try context.save()
                print("\(i)段数据写入成功")
                print("基地ID：\(entity.base_ID)   用户ID：\(entity.user_ID)   农作物种类ID：\(entity.crops_ID) ")
                print("时间戳：\(entity.time)   数值：\(entity.value)      数据标识ID：\(entity.data_ID)\n")
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
        }
        print("成功写入空气湿度表")
    }
    
    //MARK: - 写入用户数据100段
    
    func insertNewRecordForUserProperties(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        //获取省份表
        let filePath_1 = Bundle.main.url(forResource: "provinces", withExtension: "plist")
        let content_1 = NSArray(contentsOf: filePath_1!)
        let provinces = content_1 as! [String]
        //获取城市字典
        let filePath_2 = Bundle.main.url(forResource: "provinces_dic", withExtension: "plist")
        let content_2 = NSDictionary(contentsOf: filePath_2!)
        let dic = content_2 as! Dictionary<String, [String]>
        
        
        var mainKeys : [Int64] = []
        for i in 0..<100{
            let entity = NSEntityDescription.insertNewObject(forEntityName: "UserProperties", into: context) as! UserPropertiesManagedObject
            
            //生成id
            var id = Int64(arc4random())
            for temp in mainKeys {
                while temp == id{
                    id = Int64(arc4random())
                }
            }
            mainKeys.append(id)
            
            //密码
            let password = String(arc4random())
            let root = Int64(arc4random_uniform(1))
            let sex = Int64(arc4random_uniform(1))
            let province = provinces[Int((arc4random_uniform(30)))]
            let city = dic[province]?[0]
            let allowPushingNewMessageToMobile:Bool!
            let allowPushingNotification : Bool!
            if i%2 == 0 {
                allowPushingNewMessageToMobile = true
                allowPushingNotification = false
            }
            else{
                allowPushingNewMessageToMobile = false
                allowPushingNotification = true
            }
            
            entity.id = id
            entity.password = password
            entity.root = root
            entity.sex = sex
            entity.province = province
            entity.city = city
            entity.allowPushingNewMessageToMobile = allowPushingNewMessageToMobile
            entity.allowPushingNotification = allowPushingNotification
            
            do {
                try context.save()
                print("UID : \(id)  password : \(password)\n")
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
        }
        print("成功写入预置用户数据库")
    }
    
    //MARK: - 输出对应实体表数据
    func displayEntity(name:String!)->Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)
        if entity != nil{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = entity
            do{
                let data = try? context.fetch(fetchRequest) as! [NSManagedObject]
                for temp in data! {
                    print(temp)
                }
            }
            return true
        }
        return false
        
    }
    
    
    //MARK:- 删除指定实体下所有字段
    func removeAllRecordInExplictEntity(_ EntityName:String)->Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        if entity != nil{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = entity
            do{
                let data = try? context.fetch(fetchRequest)
                for temp in data! {
                    context.delete(temp as! NSManagedObject)
                    do {
                        try context.save()
                    } catch let error{
                        print("context can't save!, Error: \(error)")
                    }
                }
            }
            print("成功删除\(EntityName)表\n")
            return true
        }
        return false
        
        
    }
    
    
}
