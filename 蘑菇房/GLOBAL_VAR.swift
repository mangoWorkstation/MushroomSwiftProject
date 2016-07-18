//
//  GLOBAL_VAR.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/17.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//  存储全局变量 2016.7.17

import Foundation

var GLOBAL_NotificationCache : [NotificationPreview] = [NotificationPreview(messageID: 123456,preImage: "Hello", prelabel:"南宁市未来三天高温将继续持续",isRead: true,timestamp: 1468682458),
                                                        NotificationPreview(messageID: 123457,preImage: "MyName", prelabel:"您的蘑菇房高温警报",isRead: false,timestamp: 1468682459),
                                                        NotificationPreview(messageID: 123458,preImage: "IsNot", prelabel:"您的蘑菇房二氧化碳浓度偏高",isRead: false,timestamp: 1469682458),
                                                        NotificationPreview(messageID: 123459,preImage: "XiJinping", prelabel:"每日提醒：您的蘑菇房运行正常",isRead: true,timestamp: 1478682458),
                                                        NotificationPreview(messageID: 123460,preImage: "IM", prelabel:"监控系统故障停机，请及时联系维修人员",isRead: false,timestamp: 1468782458),
                                                        NotificationPreview(messageID: 123461,preImage: "LiKeqiang", prelabel:"本周蘑菇房的监测分析报告出来啦！快点开瞧瞧吧～",isRead: false,timestamp: 1468882458)]

var GLOBAL_UnreadMessage : [NotificationPreview] = unreadMessageFilter(GLOBAL_NotificationCache)