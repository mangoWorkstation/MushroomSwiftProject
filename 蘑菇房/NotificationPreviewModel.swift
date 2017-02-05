//
//  NotificationPreviewModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
class NotificationPreview: NSObject {
    var messageID : Int?
    var preImage : String?
    var prelabel : String?
    var isRead : Bool? = false
    var timestamp : String?    // 时间戳 注意！输入是整型，输出是字符串！ 2016.7.17/7:50
    
    init(messageID:Int,preImage:String,prelabel:String,isRead:Bool,timestamp:Int) {
        self.messageID = messageID
        self.preImage = preImage
        self.prelabel = prelabel
        self.isRead = isRead
        self.timestamp = NSString(format: "%d",timestamp) as String
    }
    
    init(coder aDecoder:NSCoder!){
        self.messageID = aDecoder.decodeObject(forKey: "messageID") as? Int
        self.preImage = aDecoder.decodeObject(forKey: "preImage") as? String
        self.prelabel = aDecoder.decodeObject(forKey: "prelabel") as? String
        self.isRead = aDecoder.decodeObject(forKey: "isRead") as? Bool
        self.timestamp = aDecoder.decodeObject(forKey: "timestamp") as? String
    }
    
    func encodeWithCoder(_ aCoder:NSCoder!){
        aCoder.encode(messageID, forKey: "messageID")
        aCoder.encode(preImage,forKey:"preImage")
        aCoder.encode(prelabel,forKey:"prelabel")
        aCoder.encode(isRead,forKey:"isRead")
        aCoder.encode(timestamp,forKey:"timestamp")
    }

    
}
