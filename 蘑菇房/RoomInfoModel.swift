//
//  RoomInfoModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/18.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation

class RoomInfoModel : NSObject{
    var districtIdentifier : Int?
    var name: String?
    var preImage: String?
    var address: String?
    var roomID: String?
    var latitude: Double?
    var longitude: Double?
    
    init(district:Int,name:String,preImage:String,address:String,roomID:String,latitude:Double,longitude:Double) {
        self.districtIdentifier = district
        self.name = name
        self.preImage = preImage
        self.address = address
        self.roomID = roomID
        self.latitude = latitude
        self.longitude = longitude
    }
    
    //Identifier Dictionary
//    0:"西乡塘区"
//    1: "兴宁区"
//    2: "青秀区"
//    3: "江南区"
//    4: "邕宁区"
//    5: "良庆区"
//    6: "武鸣区"
//    7: "横县"
//    8: "隆安县"
//    9: "马山县"
//    10: "上林县"
//    11: "宾阳县"
    
    
}