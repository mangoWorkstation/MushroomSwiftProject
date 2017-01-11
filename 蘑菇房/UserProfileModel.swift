//
//  UserProfileModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation

class UserProfiles: NSObject {
    //    var face:Data?
    var facePath:String?
    var nickName:String?
    var id:Int?
    var sex:Int?
    var province:String?
    var city:String?
    var password : String?
    var root:Int?
    //root 0:普通用户 1:农场主
    
    var allowPushingNotification:Bool?
    var allowPushingNewMessageToMobile:Bool?
    var latitude:Double?
    var longitude:Double?
    
    init(facePath:String?,nickName:String?,id:Int,sex:Int,province:String?,city:String?,password: String,root: Int,allowPushingNotification:Bool?,allowPushingNewMessageToMobile:Bool?,latitude:Double?,longitude:Double?) {
        //        self.face = face! as Data
        self.facePath = facePath
        self.nickName = nickName
        self.id = id
        self.sex = sex
        self.province = province
        self.city = city
        self.password = password
        self.root = root
        self.allowPushingNewMessageToMobile = allowPushingNewMessageToMobile
        self.allowPushingNotification = allowPushingNotification
        if latitude != nil || longitude != nil{
            self.latitude = latitude
            self.longitude = longitude
        }
        else{
            self.latitude = nil
            self.longitude = nil
        }
    }
    
    init(coder aDecoder:NSCoder!){
        //        self.face = (aDecoder.decodeObject(forKey: "face") as! Data)
        self.facePath = aDecoder.decodeObject(forKey: "facePath") as? String
        self.nickName = aDecoder.decodeObject(forKey: "nickName") as? String
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.sex = aDecoder.decodeObject(forKey: "sex") as? Int
        self.province = aDecoder.decodeObject(forKey: "province") as? String
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.root = aDecoder.decodeObject(forKey: "root") as? Int
        self.allowPushingNotification = aDecoder.decodeObject(forKey: "allowPushingNotification") as? Bool
        self.allowPushingNewMessageToMobile = aDecoder.decodeObject(forKey: "allowPushingNewMessageToMobile") as? Bool
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? Double
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? Double
    }
    
    func encodeWithCoder(_ aCoder:NSCoder!){
        //        aCoder.encode(face,forKey:"face")
        aCoder.encode(facePath, forKey: "facePath")
        aCoder.encode(nickName,forKey:"nickName")
        aCoder.encode(id,forKey:"id")
        aCoder.encode(sex,forKey:"sex")
        aCoder.encode(province,forKey:"province")
        aCoder.encode(city,forKey:"city")
        aCoder.encode(password,forKey:"password")
        aCoder.encode(root,forKey:"root")
        aCoder.encode(allowPushingNotification,forKey:"allowPushingNotification")
        aCoder.encode(allowPushingNewMessageToMobile,forKey:"allowPushingNewMessageToMobile")
        aCoder.encode(latitude,forKey:"latitude")
        aCoder.encode(longitude,forKey:"longitude")
        
    }
}
