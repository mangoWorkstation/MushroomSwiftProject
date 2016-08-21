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

var GLOBAL_UserProfile = UserProfiles(face: "User", nickName: "芒果君", id: 123456, sex: 1, province: "广西", city: "南宁",allowPushingNotification: false,allowPushingNewMessageToMobile: false,latitude: 0,longitude:0)


var GLOBAL_RoomInfo  : [RoomInfoModel] = [
    //西乡塘区
    RoomInfoModel(district: 0, name: "广西大学", preImage: "1", address: "南宁市西乡塘区大学路100号", roomID: "00000",latitude:22.8371727422, longitude:108.2884892346),
    RoomInfoModel(district: 0, name: "广西民族大学", preImage: "2", address: "南宁市西乡塘区", roomID: "00001",latitude:22.8406188793, longitude:108.2354495692),
    RoomInfoModel(district: 0, name: "广西药用植物园", preImage: "3", address: "南宁市西乡塘区", roomID: "00002",latitude:22.8539483773, longitude:108.3746464867),
    RoomInfoModel(district: 0, name: "南宁动物园", preImage: "1", address: "南宁市西乡塘区", roomID: "00003",latitude:22.836873668, longitude:108.2693347539),
    RoomInfoModel(district: 0, name: "西乡塘蘑菇基地5", preImage: "1", address: "南宁市西乡塘区", roomID: "00005",latitude:22.833159668, longitude:108.2704847539),
    RoomInfoModel(district: 0, name: "西乡塘蘑菇基地6", preImage: "2", address: "南宁市西乡塘区", roomID: "00006",latitude:22.8404478915, longitude:108.2677161699),
    
    //兴宁区
    RoomInfoModel(district: 1, name: "兴宁区蘑菇基地1", preImage: "3", address: "南宁市兴宁区", roomID: "10000",latitude:22.854260521, longitude:108.3683639416),
    RoomInfoModel(district: 1, name: "兴宁区蘑菇基地2", preImage: "2", address: "南宁市兴宁区", roomID: "10001",latitude:22.8512552183, longitude:108.3580150058),
    RoomInfoModel(district: 1, name: "兴宁区蘑菇基地3", preImage: "3", address: "南宁市兴宁区", roomID: "10002",latitude:22.8563502183, longitude:108.3507920058),
    RoomInfoModel(district: 1, name: "兴宁区蘑菇基地4", preImage: "2", address: "南宁市兴宁区", roomID: "10003",latitude:22.8530202183, longitude:108.3506480058),
    RoomInfoModel(district: 1, name: "兴宁区蘑菇基地5", preImage: "1", address: "南宁市兴宁区", roomID: "10004",latitude:22.8513243773, longitude:108.3700374867),
    RoomInfoModel(district: 1, name: "兴宁区蘑菇基地6", preImage: "3", address: "南宁市兴宁区", roomID: "10005",latitude:22.8337121201, longitude:108.3415972061),
    RoomInfoModel(district: 1, name: "兴宁区蘑菇基地7", preImage: "2", address: "南宁市兴宁区", roomID: "10006",latitude:22.8446358659, longitude:108.3444764344),
    
    
    //青秀区
    RoomInfoModel(district: 2, name: "青秀区蘑菇基地1", preImage: "2", address: "南宁市青秀区", roomID: "20000",latitude:22.786536098, longitude:108.4969336708),
    RoomInfoModel(district: 2, name: "青秀区蘑菇基地2", preImage: "1", address: "南宁市青秀区", roomID: "20001",latitude:22.794014065, longitude:108.4914624112),
    RoomInfoModel(district: 2, name: "青秀区蘑菇基地3", preImage: "3", address: "南宁市青秀区", roomID: "20002",latitude:22.791881065, longitude:108.4979304112),
    RoomInfoModel(district: 2, name: "青秀区蘑菇基地4", preImage: "1", address: "南宁市青秀区", roomID: "20003",latitude:22.797878065, longitude:108.4955594112),
    RoomInfoModel(district: 2, name: "青秀区蘑菇基地5", preImage: "2", address: "南宁市青秀区", roomID: "20004",latitude:22.794913065, longitude:108.4918224112),
    RoomInfoModel(district: 2, name: "青秀区蘑菇基地6", preImage: "3", address: "南宁市青秀区", roomID: "20005",latitude:22.8016487898, longitude:108.5013773925),
    RoomInfoModel(district: 2, name: "青秀区蘑菇基地7", preImage: "1", address: "南宁市青秀区", roomID: "20006",latitude:22.795553894, longitude:108.5017103578),
    
    //江南区
    RoomInfoModel(district: 3, name: "江南区蘑菇基地1", preImage: "3", address: "南宁市江南区", roomID: "30000",latitude:23.851615052, longitude:106.688945574),
    RoomInfoModel(district: 3, name: "江南区蘑菇基地2", preImage: "1", address: "南宁市江南区", roomID: "30001",latitude:23.9021279063, longitude:106.6266956926),
    RoomInfoModel(district: 3, name: "江南区蘑菇基地3", preImage: "2", address: "南宁市江南区", roomID: "30002",latitude:23.8547100601, longitude:106.6584352348),
    RoomInfoModel(district: 3, name: "江南区蘑菇基地4", preImage: "2", address: "南宁市江南区", roomID: "30003",latitude:23.7904466925, longitude:106.6866258365),
    RoomInfoModel(district: 3, name: "江南区蘑菇基地5", preImage: "1", address: "南宁市江南区", roomID: "30004",latitude:23.9550872815, longitude:106.705008615),
    RoomInfoModel(district: 3, name: "江南区蘑菇基地6", preImage: "3", address: "南宁市江南区", roomID: "30005",latitude:22.794613065, longitude:108.4954874112),
    RoomInfoModel(district: 3, name: "江南区蘑菇基地7", preImage: "2", address: "南宁市江南区", roomID: "30006",latitude:22.793754894, longitude:108.5022133578),
    
    
    //邕宁区
    RoomInfoModel(district: 4, name: "邕宁区蘑菇基地1", preImage: "1", address: "南宁市邕宁区", roomID: "40000",latitude:22.7583459744, longitude:108.4873699459),
    RoomInfoModel(district: 4, name: "邕宁区蘑菇基地2", preImage: "3", address: "南宁市邕宁区", roomID: "40001",latitude:22.7568959744, longitude:108.4844239459),
    RoomInfoModel(district: 4, name: "邕宁区蘑菇基地3", preImage: "2", address: "南宁市邕宁区", roomID: "40002",latitude:22.7581798503, longitude:108.4992899761),
    RoomInfoModel(district: 4, name: "邕宁区蘑菇基地4", preImage: "3", address: "南宁市邕宁区", roomID: "40003",latitude:22.7614721022, longitude:108.4903403314),
    RoomInfoModel(district: 4, name: "邕宁区蘑菇基地5", preImage: "1", address: "南宁市邕宁区", roomID: "40004",latitude:22.7594391022, longitude:108.4972393314),
    RoomInfoModel(district: 4, name: "邕宁区蘑菇基地6", preImage: "1", address: "南宁市邕宁区", roomID: "40005",latitude:22.7583053025, longitude:108.4939664851),
    RoomInfoModel(district: 4, name: "邕宁区蘑菇基地7", preImage: "3", address: "南宁市邕宁区", roomID: "40006",latitude:22.7602061022, longitude:108.4895503314),
    
    
    //良庆区
    RoomInfoModel(district: 5, name: "良庆区蘑菇基地1", preImage: "3", address: "南宁市良庆区", roomID: "50000",latitude:22.7561363069, longitude:108.3208302292),
    RoomInfoModel(district: 5, name: "良庆区蘑菇基地2", preImage: "1", address: "南宁市良庆区", roomID: "50001",latitude:22.759352578, longitude:108.3199717034),
    RoomInfoModel(district: 5, name: "良庆区蘑菇基地3", preImage: "1", address: "南宁市良庆区", roomID: "50002",latitude:22.7569193069, longitude:108.3258612292),
    RoomInfoModel(district: 5, name: "良庆区蘑菇基地4", preImage: "2", address: "南宁市良庆区", roomID: "50003",latitude:22.7554500209, longitude:108.3325423893),
    RoomInfoModel(district: 5, name: "良庆区蘑菇基地5", preImage: "1", address: "南宁市良庆区", roomID: "50004",latitude:22.7567500209, longitude:108.3367823893),
    RoomInfoModel(district: 5, name: "良庆区蘑菇基地6", preImage: "3", address: "南宁市良庆区", roomID: "50005",latitude:22.7598836898, longitude:108.3379003899),
    RoomInfoModel(district: 5, name: "良庆区蘑菇基地7", preImage: "3", address: "南宁市良庆区", roomID: "50006",latitude:22.7575668212, longitude:108.3416289131),
    
    
    //武鸣区
    RoomInfoModel(district: 6, name: "武鸣区蘑菇基地1", preImage: "2", address: "南宁市武鸣区", roomID: "60000",latitude:23.1586338163, longitude:108.2746313446),
    RoomInfoModel(district: 6, name: "武鸣区蘑菇基地2", preImage: "2", address: "南宁市武鸣区", roomID: "60001",latitude:23.1552713656, longitude:108.2901032262),
    RoomInfoModel(district: 6, name: "武鸣区蘑菇基地3", preImage: "3", address: "南宁市武鸣区", roomID: "60002",latitude:23.1635098505, longitude:108.2931118124),
    RoomInfoModel(district: 6, name: "武鸣区蘑菇基地4", preImage: "1", address: "南宁市武鸣区", roomID: "60003",latitude:23.1605597932, longitude:108.2800513861),
    RoomInfoModel(district: 6, name: "武鸣区蘑菇基地5", preImage: "3", address: "南宁市武鸣区", roomID: "60004",latitude:23.1532853746, longitude:108.283762783),
    RoomInfoModel(district: 6, name: "武鸣区蘑菇基地6", preImage: "1", address: "南宁市武鸣区", roomID: "60005",latitude:23.1483379906, longitude:108.2998120523),
    RoomInfoModel(district: 6, name: "武鸣区蘑菇基地7", preImage: "1", address: "南宁市武鸣区", roomID: "60006",latitude:23.1506758163, longitude:108.2698523446),
    
    
    //横县
    RoomInfoModel(district: 7, name: "横县蘑菇基地1", preImage: "1", address: "南宁市横县", roomID: "70000",latitude:22.6799770705, longitude:109.2614636746),
    RoomInfoModel(district: 7, name: "横县蘑菇基地2", preImage: "2", address: "南宁市横县", roomID: "70001",latitude:22.6824863481, longitude:109.2517252633),
    RoomInfoModel(district: 7, name: "横县蘑菇基地3", preImage: "1", address: "南宁市横县", roomID: "70002",latitude:22.682762868, longitude:109.2408934601),
    RoomInfoModel(district: 7, name: "横县蘑菇基地1", preImage: "3", address: "南宁市横县", roomID: "70003",latitude:22.6799784313, longitude:109.2746288441),
    RoomInfoModel(district: 7, name: "横县蘑菇基地2", preImage: "3", address: "南宁市横县", roomID: "70004",latitude:22.6937811782, longitude:109.2715675115),
    RoomInfoModel(district: 7, name: "横县蘑菇基地3", preImage: "2", address: "南宁市横县", roomID: "70005",latitude:22.6902223819, longitude:109.2576126696),
    RoomInfoModel(district: 7, name: "横县蘑菇基地3", preImage: "1", address: "南宁市横县", roomID: "70006",latitude:22.684905187, longitude:109.287883537),
    
    
    //隆安县
    RoomInfoModel(district: 8, name: "隆安县蘑菇基地1", preImage: "1", address: "南宁市隆安县", roomID: "80000",latitude:23.1658743764, longitude:107.6960980935),
    RoomInfoModel(district: 8, name: "隆安县蘑菇基地2", preImage: "3", address: "南宁市隆安县", roomID: "80001",latitude:23.176859221, longitude:107.6997870593),
    RoomInfoModel(district: 8, name: "隆安县蘑菇基地3", preImage: "2", address: "南宁市隆安县", roomID: "80002",latitude:23.1786889825, longitude:107.6844320558),
    RoomInfoModel(district: 8, name: "隆安县蘑菇基地4", preImage: "3", address: "南宁市隆安县", roomID: "80003",latitude:23.1679438691, longitude:107.676100547),
    RoomInfoModel(district: 8, name: "隆安县蘑菇基地5", preImage: "1", address: "南宁市隆安县", roomID: "80004",latitude:23.1829572662, longitude:107.6761605109),
    RoomInfoModel(district: 8, name: "隆安县蘑菇基地6", preImage: "2", address: "南宁市隆安县", roomID: "80005",latitude:23.1740619643, longitude:107.6890833163),
    RoomInfoModel(district: 8, name: "隆安县蘑菇基地7", preImage: "2", address: "南宁市隆安县", roomID: "80006",latitude:23.1590468822, longitude:107.714949395),
    
    
    //马山县
    RoomInfoModel(district: 9, name: "马山县蘑菇基地1", preImage: "3", address: "南宁市马山县", roomID: "90000",latitude:23.7081530362, longitude:108.1770200152),
    RoomInfoModel(district: 9, name: "马山县蘑菇基地2", preImage: "2", address: "南宁市马山县", roomID: "90001",latitude:23.7137380957, longitude:108.1845360816),
    RoomInfoModel(district: 9, name: "马山县蘑菇基地3", preImage: "1", address: "南宁市马山县", roomID: "90002",latitude:23.7051671572, longitude:108.1679844289),
    RoomInfoModel(district: 9, name: "马山县蘑菇基地4", preImage: "2", address: "南宁市马山县", roomID: "90003",latitude:23.7123961937, longitude:108.1579261814),
    RoomInfoModel(district: 9, name: "马山县蘑菇基地5", preImage: "1", address: "南宁市马山县", roomID: "90004",latitude:23.7226299316, longitude:108.1697737125),
    RoomInfoModel(district: 9, name: "马山县蘑菇基地6", preImage: "2", address: "南宁市马山县", roomID: "90005",latitude:23.7171790957, longitude:108.1846800816),
    RoomInfoModel(district: 9, name: "马山县蘑菇基地7", preImage: "1", address: "南宁市马山县", roomID: "90006",latitude:23.7043401924, longitude:108.1865041103),
    
    
    //上林县
    RoomInfoModel(district: 10, name: "上林县蘑菇基地1", preImage: "3", address: "南宁市上林县", roomID: "A0000",latitude:23.4320403399, longitude:108.6050613306),
    RoomInfoModel(district: 10, name: "上林县蘑菇基地2", preImage: "1", address: "南宁市上林县", roomID: "A0001",latitude:23.425226685, longitude:108.6004259462),
    RoomInfoModel(district: 10, name: "上林县蘑菇基地3", preImage: "2", address: "南宁市上林县", roomID: "A0002",latitude:23.4187027409, longitude:108.6119458358),
    RoomInfoModel(district: 10, name: "上林县蘑菇基地4", preImage: "3", address: "南宁市上林县", roomID: "A0003",latitude:23.4375943399, longitude:108.6012163306),
    RoomInfoModel(district: 10, name: "上林县蘑菇基地5", preImage: "3", address: "南宁市上林县", roomID: "A0004",latitude:23.4332988831, longitude:108.6216147412),
    RoomInfoModel(district: 10, name: "上林县蘑菇基地6", preImage: "1", address: "南宁市上林县", roomID: "A0005",latitude:23.4195755627, longitude:108.6317828766),
    RoomInfoModel(district: 10, name: "上林县蘑菇基地7", preImage: "2", address: "南宁市上林县", roomID: "A0006",latitude:23.4104787409, longitude:108.6151798358),
    
    
    //宾阳县
    RoomInfoModel(district: 11, name: "宾阳县蘑菇基地1", preImage: "2", address: "南宁市宾阳县", roomID: "B0000",latitude:23.2176118614, longitude:108.8103096356),
    RoomInfoModel(district: 11, name: "宾阳县蘑菇基地2", preImage: "1", address: "南宁市宾阳县", roomID: "B0001",latitude:23.2244408077, longitude:108.798749071),
    RoomInfoModel(district: 11, name: "宾阳县蘑菇基地3", preImage: "2", address: "南宁市宾阳县", roomID: "B0002",latitude:23.2273610236, longitude:108.8184047579),
    RoomInfoModel(district: 11, name: "宾阳县蘑菇基地4", preImage: "1", address: "南宁市宾阳县", roomID: "B0003",latitude:23.2163887073, longitude:108.8304838733),
    RoomInfoModel(district: 11, name: "宾阳县蘑菇基地5", preImage: "2", address: "南宁市宾阳县", roomID: "B0004",latitude:23.2268453873, longitude:108.8281019419),
    RoomInfoModel(district: 11, name: "宾阳县蘑菇基地6", preImage: "1", address: "南宁市宾阳县", roomID: "B0005",latitude:23.2432912108, longitude:108.8305779067),
    RoomInfoModel(district: 11, name: "宾阳县蘑菇基地7", preImage: "3", address: "南宁市宾阳县", roomID: "B0006",latitude:23.2329885913, longitude:108.8464581346)
]
