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


/**
 * @Description 由基地名称获取基地信息
 * @Param name: String 基地名称
 * @Return RoomInfoModel 基地信息
 */
func acquireRoomInfoByName(name:String)->RoomInfoModel{
    var foundOut = RoomInfoModel(district: 0, name: "0", preImage: "0", address: "0", roomID: "0",latitude: 0.0,longitude:0.0)
    for(var i = 0;i<GLOBAL_RoomInfo.count;i+=1){
        let temp = GLOBAL_RoomInfo[i]
        if (temp.name == name){
            foundOut = temp
            break
        }
    }
    return foundOut
}

/**
 * @Description 由基地ID获取基地信息
 * @Param roomID: String 基地ID
 * @Return RoomInfoModel 基地信息
 */
func acquireRoomInfoByRoomID(roomID:String)->RoomInfoModel{
    var foundOut = RoomInfoModel(district: 0, name: "0", preImage: "0", address: "0", roomID: "0",latitude: 0.0,longitude:0.0)
    for(var i = 0;i<GLOBAL_RoomInfo.count;i+=1){
        let temp = GLOBAL_RoomInfo[i]
        if (temp.roomID == roomID){
            foundOut = temp
            break
        }
    }
    return foundOut
}


/**
 * @Description 根据两地的经纬度，计算两地直线距离
 * @Param lat_1: Double 地点1纬度
 * @Param lat_2: Double 地点2纬度
 * @Param lng_1: Double 地点1经度
 * @Param lng_2: Double 地点1精度
 * @Return Double 两地直线距离
 */
func distanceCalc(lat_1:Double,lng_1:Double,lat_2:Double,lng_2:Double)->Double{
    let EARTH_RADIUS = 6378.137
    func rad(d:Double)->Double{
        return d * M_PI / 180.0
    }
    let radLat_1 = rad(lat_1)
    let radLat_2 = rad(lat_2)
    let a = radLat_1 - radLat_2
    let b = rad(lng_1)-rad(lng_2)
    var s = 2 * asin(sqrt(pow(sin(a/2), 2))) + cos(radLat_1) * cos(radLat_2) * pow(sin(b / 2), 2)
    s *= EARTH_RADIUS
    s = round(s * 10000) / 10
    return s
}

func nearbyRoomFilter(rawData:[RoomInfoModel])->[RoomInfoModel]{
    var filterData :[RoomInfoModel] = []
    var differences : Dictionary<String,Double> = [:]
    for(var i = 0;i<GLOBAL_RoomInfo.count;i+=1){
        let roomID = GLOBAL_RoomInfo[i].roomID
        let lat_1 = GLOBAL_RoomInfo[i].latitude
        let lng_1 = GLOBAL_RoomInfo[i].longitude
        let lat_2 = GLOBAL_UserProfile.latitude
        let lng_2 = GLOBAL_UserProfile.longitude
        differences[roomID!] = distanceCalc(lat_1!, lng_1: lng_1!, lat_2: lat_2!, lng_2: lng_2!)
    }
    let dicArray = differences.sort{
        $0.1<$1.1
    }
    for(var i = 0;i<5;i += 1){
        let temp = dicArray[i]
        let roomID = temp.0
        let tempElement = acquireRoomInfoByRoomID(roomID)
        filterData.append(tempElement)
    }
    return filterData
}