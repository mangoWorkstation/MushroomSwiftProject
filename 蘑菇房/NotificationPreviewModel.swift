//
//  NotificationPreviewModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
class NotificationPreview: NSObject {
    var messageID : Int
    var preImage : String?
    var prelabel : String?
    var isRead : Bool = false
    var timestamp : String?    // 时间戳 注意！输入是整型，输出是字符串！ 2016.7.17/7:50
    
    init(messageID:Int,preImage:String,prelabel:String,isRead:Bool,timestamp:Int) {
        self.messageID = messageID
        self.preImage = preImage
        self.prelabel = prelabel
        self.isRead = isRead
        self.timestamp = NSString(format: "%d",timestamp) as String
    }
    
//    func markAsReadMessage() {
//        self.isRead = true
//    }
    
}
/**
 * @Description 过滤出未读消息 2016.7.17
 * @Param rawDataArray : [NotificationPreview]
 * @Return [NotificationPreview]
 */
func unreadMessageFilter(rawDataArray:[NotificationPreview])->[NotificationPreview]{
    var filterData : [NotificationPreview] = []
    for(var i=0;i<rawDataArray.count;i += 1){
        let info = rawDataArray[i]
        let isRead = info.isRead
        if(isRead == false){
            filterData.append(NotificationPreview(messageID: info.messageID,preImage: info.preImage!, prelabel: info.prelabel!, isRead: false, timestamp: Int(info.timestamp!)!))
        }
    }
    return filterData
}

/**
 * @Description 清空所有未读消息（将所有信息设为已读） 2016.7.17
 * @Param rawDataArray : [NotificationPreview]
 * @Return [NotificationPreview]
 */
func clearAllUnreadMessage(rawDataArray:[NotificationPreview])->[NotificationPreview]{
    var allData : [NotificationPreview] = []
    for (var i=0;i<rawDataArray.count;i+=1){
        let info = rawDataArray[i]
        let isRead = info.isRead
        if(isRead == false){
            allData.append(NotificationPreview(messageID: info.messageID,preImage: info.preImage!, prelabel: info.prelabel!, isRead: true, timestamp: Int(info.timestamp!)!))
        }
        else{
            allData.append(NotificationPreview(messageID: info.messageID,preImage: info.preImage!, prelabel: info.prelabel!, isRead: true, timestamp: Int(info.timestamp!)!))
        }
    }
    return allData
}
