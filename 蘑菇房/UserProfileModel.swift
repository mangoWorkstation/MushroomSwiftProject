//
//  UserProfileModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation

class UserProfiles: NSObject {
    var face:String?
    var nickName:String?
    var id:Int?
    var sex:Int?
    var province:String?
    var city:String?
    
    var allowPushingNotification:Bool?
    var allowPushingNewMessageToMobile:Bool?
    var latitude:Double?
    var longitude:Double?
    
    init(face:String,nickName:String,id:Int,sex:Int,province:String,city:String?,allowPushingNotification:Bool,allowPushingNewMessageToMobile:Bool?,latitude:Double,longitude:Double) {
        self.face = face
        self.nickName = nickName
        self.id = id
        self.sex = sex
        self.province = province
        self.city = city
        self.allowPushingNewMessageToMobile = allowPushingNewMessageToMobile
        self.allowPushingNotification = allowPushingNotification
        self.latitude = latitude
        self.longitude = longitude
    }
}