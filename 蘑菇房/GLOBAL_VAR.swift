//
//  GLOBAL_VAR.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/17.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//  存储全局变量 2016.7.17

import Foundation
import CoreData
import UIKit

//系统字体
var GLOBAL_appFont:String? = "PingFangSC-Regular"

//寄存当前登录用户资料
var GLOBAL_UserProfile : UserProfiles!

var GLOBAL_NotificationCache : [NotificationPreview] = [
    NotificationPreview(messageID: 123456,preImage: "http://tupian.enterdesk.com/uploadfile/2014/0121/20140121030016577.jpg", prelabel:"南宁市未来三天高温将继续持续",isRead: true,timestamp: 1468682458),
    NotificationPreview(messageID: 123457,preImage: "http://tupian.enterdesk.com/uploadfile/2014/0121/20140121030041478.jpg", prelabel:"您的蘑菇房高温警报",isRead: false,timestamp: 1468682459),
    NotificationPreview(messageID: 123458,preImage: "http://tupian.enterdesk.com/uploadfile/2016/0224/20160224100157906.jpg", prelabel:"您的蘑菇房二氧化碳浓度偏高",isRead: false,timestamp: 1469682458),
    NotificationPreview(messageID: 123459,preImage: "http://tupian.enterdesk.com/uploadfile/2016/0217/20160217103425634.jpg", prelabel:"每日提醒：您的蘑菇房运行正常",isRead: true,timestamp: 1478682458),
    NotificationPreview(messageID: 123460,preImage: "http://tupian.enterdesk.com/uploadfile/2016/0125/20160125103555696.jpg", prelabel:"监控系统故障停机，请及时联系维修人员",isRead: false,timestamp: 1468782458),
    NotificationPreview(messageID: 123461,preImage: "http://tupian.enterdesk.com/uploadfile/2016/0107/20160107104012198.jpg", prelabel:"本周蘑菇房的监测分析报告出来啦！快点开瞧瞧吧～",isRead: false,timestamp: 1468882458)]
