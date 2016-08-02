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

var GLOBAL_UserProfile = UserProfiles(face: "User", nickName: "芒果君", id: 123456, sex: 1, province: "广西", city: "南宁",allowPushingNotification: false,allowPushingNewMessageToMobile: false)


var GLOBAL_RoomInfo  : [RoomInfoModel] = [
RoomInfoModel(district: 0, name: "广西大学", preImage: "1", address: "南宁市西乡塘区大学路100号", roomID: "00000"),
RoomInfoModel(district: 0, name: "广西民族大学", preImage: "2", address: "南宁市西乡塘区", roomID: "00001"),
RoomInfoModel(district: 0, name: "广西药用植物园", preImage: "3", address: "南宁市西乡塘区", roomID: "00002"),
RoomInfoModel(district: 1, name: "兴宁区蘑菇基地1", preImage: "1", address: "南宁市兴宁区", roomID: "10000"),
RoomInfoModel(district: 1, name: "兴宁区蘑菇基地2", preImage: "2", address: "南宁市兴宁区", roomID: "10001"),
RoomInfoModel(district: 1, name: "兴宁区蘑菇基地3", preImage: "3", address: "南宁市兴宁区", roomID: "10002"),
RoomInfoModel(district: 2, name: "青秀区蘑菇基地1", preImage: "1", address: "南宁市青秀区", roomID: "20000"),
RoomInfoModel(district: 2, name: "青秀区蘑菇基地2", preImage: "2", address: "南宁市青秀区", roomID: "20001"),
RoomInfoModel(district: 2, name: "青秀区蘑菇基地3", preImage: "3", address: "南宁市青秀区", roomID: "20002"),
RoomInfoModel(district: 3, name: "江南区蘑菇基地1", preImage: "1", address: "南宁市江南区", roomID: "30000"),
RoomInfoModel(district: 3, name: "江南区蘑菇基地2", preImage: "2", address: "南宁市江南区", roomID: "30001"),
RoomInfoModel(district: 3, name: "江南区蘑菇基地3", preImage: "3", address: "南宁市江南区", roomID: "30002"),
RoomInfoModel(district: 4, name: "邕宁区蘑菇基地1", preImage: "1", address: "南宁市邕宁区", roomID: "40000"),
RoomInfoModel(district: 4, name: "邕宁区蘑菇基地2", preImage: "2", address: "南宁市邕宁区", roomID: "40001"),
RoomInfoModel(district: 4, name: "邕宁区蘑菇基地3", preImage: "3", address: "南宁市邕宁区", roomID: "40002"),
RoomInfoModel(district: 5, name: "良庆区蘑菇基地1", preImage: "1", address: "南宁市良庆区", roomID: "50000"),
RoomInfoModel(district: 5, name: "良庆区蘑菇基地2", preImage: "2", address: "南宁市良庆区", roomID: "50001"),
RoomInfoModel(district: 5, name: "良庆区蘑菇基地3", preImage: "3", address: "南宁市良庆区", roomID: "50002"),
RoomInfoModel(district: 6, name: "武鸣区蘑菇基地1", preImage: "1", address: "南宁市武鸣区", roomID: "60000"),
RoomInfoModel(district: 6, name: "武鸣区蘑菇基地2", preImage: "3", address: "南宁市武鸣区", roomID: "60001"),
RoomInfoModel(district: 6, name: "武鸣区蘑菇基地3", preImage: "1", address: "南宁市武鸣区", roomID: "60002"),
RoomInfoModel(district: 7, name: "横县蘑菇基地1", preImage: "2", address: "南宁市横县", roomID: "70000"),
RoomInfoModel(district: 7, name: "横县蘑菇基地2", preImage: "1", address: "南宁市横县", roomID: "70001"),
RoomInfoModel(district: 7, name: "横县蘑菇基地3", preImage: "1", address: "南宁市横县", roomID: "70002"),
RoomInfoModel(district: 8, name: "隆安县蘑菇基地1", preImage: "2", address: "南宁市隆安县", roomID: "80000"),
RoomInfoModel(district: 8, name: "隆安县蘑菇基地2", preImage: "1", address: "南宁市隆安县", roomID: "80001"),
RoomInfoModel(district: 8, name: "隆安县蘑菇基地3", preImage: "3", address: "南宁市隆安县", roomID: "80002"),
RoomInfoModel(district: 9, name: "马山县蘑菇基地1", preImage: "2", address: "南宁市马山县", roomID: "90000"),
RoomInfoModel(district: 9, name: "马山县蘑菇基地2", preImage: "1", address: "南宁市马山县", roomID: "90001"),
RoomInfoModel(district: 9, name: "马山县蘑菇基地3", preImage: "2", address: "南宁市马山县", roomID: "90002"),
RoomInfoModel(district: 10, name: "上林县蘑菇基地1", preImage: "2", address: "南宁市上林县", roomID: "A0000"),
RoomInfoModel(district: 10, name: "上林县蘑菇基地2", preImage: "2", address: "南宁市上林县", roomID: "A0001"),
RoomInfoModel(district: 10, name: "上林县蘑菇基地3", preImage: "1", address: "南宁市上林县", roomID: "A0002"),
RoomInfoModel(district: 11, name: "宾阳县蘑菇基地1", preImage: "2", address: "南宁市宾阳县", roomID: "B0000"),
RoomInfoModel(district: 11, name: "宾阳县蘑菇基地2", preImage: "1", address: "南宁市宾阳县", roomID: "B0001"),
RoomInfoModel(district: 11, name: "宾阳县蘑菇基地3", preImage: "3", address: "南宁市宾阳县", roomID: "B0002")
]