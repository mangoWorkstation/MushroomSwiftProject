//
//  PublicStaticMethods.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/21.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//  各类静态方法

import Foundation
/**
 * @Description 时间戳转日期📅 2016.7.17
 * @Param timeStamp : String
 * @Return String
 */
public func timeStampToString(timeStamp:String)->String {
    
    let string = NSString(string: timeStamp)
    
    let timeSta:NSTimeInterval = string.doubleValue
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat="yyyy年MM月dd日"
    
    let date = NSDate(timeIntervalSince1970: timeSta)
    
    //    print(dfmatter.stringFromDate(date))
    return dfmatter.stringFromDate(date)
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

/**
 * @Description 筛选地区 2016.8.2
 * @Param rawDataArray : [RoomInfoModel]
 * @Return [RoomInfoModel]
 */
func regionFilter(chosenArea:String,rawDataArray: [RoomInfoModel])->[RoomInfoModel]{
    var filter : [RoomInfoModel] = []
    var tempIdentifier:Int?
    switch chosenArea {
    case "西乡塘区":tempIdentifier = 0
    case "兴宁区":tempIdentifier = 1
    case "青秀区":tempIdentifier = 2
    case "江南区":tempIdentifier = 3
    case "邕宁区":tempIdentifier = 4
    case "良庆区":tempIdentifier = 5
    case "武鸣区":tempIdentifier = 6
    case "横县":tempIdentifier = 7
    case "隆安县":tempIdentifier = 8
    case "马山县":tempIdentifier = 9
    case "上林县":tempIdentifier = 10
    case "宾阳县":tempIdentifier = 11
    default:tempIdentifier = nil
    }
    for(var i = 0;i<rawDataArray.count;i+=1){
        let tempElement = rawDataArray[i]
        if (tempIdentifier == tempElement.districtIdentifier){
            filter.append(tempElement)
        }
    }
    return filter
}