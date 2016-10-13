//
////: Playground - noun: a place where people can play
//
////  Created by 芒果君 on 16/5/15.
////  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//
////  各类功能测试的试验田
//
//import Foundation
//import CoreLocation
//import AddressBookUI
//import AddressBook
//import Contacts
//
//class NotificationPreview: NSObject {
//    var preImage : String?
//    var prelabel : String?
//    var isRead : Bool = false
//    var timestamp : String?    // 时间戳 注意！输入是整型，输出是字符串！ 2016.7.17/7:50
//    
//    init(preImage:String,prelabel:String,isRead:Bool,timestamp:Int) {
//        self.preImage = preImage
//        self.prelabel = prelabel
//        self.isRead = isRead
//        self.timestamp = NSString(format: "%d",timestamp) as String
//    }
//    
//}
//class UserProfiles: NSObject {
//    var face:String?
//    var nickName:String?
//    var id:Int?
//    var sex:Int?
//    var province:String?
//    var city:String?
//    
//    var allowPushingNotification:Bool?
//    var allowPushingNewMessageToMobile:Bool?
//    var latitude:Double?
//    var longitude:Double?
//    
//    init(face:String,nickName:String,id:Int,sex:Int,province:String,city:String?,allowPushingNotification:Bool,allowPushingNewMessageToMobile:Bool?,latitude:Double,longitude:Double) {
//        self.face = face
//        self.nickName = nickName
//        self.id = id
//        self.sex = sex
//        self.province = province
//        self.city = city
//        self.allowPushingNewMessageToMobile = allowPushingNewMessageToMobile
//        self.allowPushingNotification = allowPushingNotification
//        self.latitude = latitude
//        self.longitude = longitude
//    }
//}
//
//var GLOBAL_UserProfile = UserProfiles(face: "User", nickName: "芒果君", id: 123456, sex: 1, province: "广西", city: "南宁",allowPushingNotification: false,allowPushingNewMessageToMobile: false,latitude: 22.8382665752,longitude: 108.2884396852)
//
////func changeMessageState(rawData:[NotificationPreview])->[NotificationPreview]{
////    var allData : [NotificationPreview] = []
////    for (i in 0 ..< rawData.count){
////        let info = rawData[i]
////        let isRead = info.isRead
////        if(isRead == false){
////            allData.append(NotificationPreview(preImage: info.preImage!, prelabel: info.prelabel!, isRead: true, timestamp: Int(info.timestamp!)!))
////        }
////        else{
////            allData.append(NotificationPreview(preImage: info.preImage!, prelabel: info.prelabel!, isRead: true, timestamp: Int(info.timestamp!)!))
////        }
////    }
////    return allData
////}
//var notificationCache = [NotificationPreview(preImage: "Hello", prelabel:"南宁市未来三天高温将继续持续",isRead: true,timestamp: 1468682458),NotificationPreview(preImage: "MyName", prelabel:"您的蘑菇房高温警报",isRead: false,timestamp: 1468682459),NotificationPreview(preImage: "IsNot", prelabel:"您的蘑菇房二氧化碳浓度偏高",isRead: false,timestamp: 1469682458),NotificationPreview(preImage: "XiJinping", prelabel:"每日提醒：您的蘑菇房运行正常",isRead: true,timestamp: 1478682458),NotificationPreview(preImage: "IM", prelabel:"监控系统故障停机，请及时联系维修人员",isRead: false,timestamp: 1468782458),NotificationPreview(preImage: "LiKeqiang", prelabel:"本周蘑菇房的监测分析报告出来啦！快点开瞧瞧吧～",isRead: false,timestamp: 1468882458)]
//
//var filterData = changeMessageState(rawData: notificationCache)
//filterData.count
//
///***********************************************************************/
class RoomInfoModel {
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
//
var GLOBAL_RoomInfo  : Dictionary<String,RoomInfoModel> = [
    //西乡塘区
    "00000":RoomInfoModel(district: 0, name: "广西大学", preImage: "1", address: "南宁市西乡塘区大学路100号", roomID: "00000",latitude:22.8371727422, longitude:108.2884892346),
    "00001":RoomInfoModel(district: 0, name: "广西民族大学", preImage: "2", address: "南宁市西乡塘区", roomID: "00001",latitude:22.8406188793, longitude:108.2354495692),
    "00002":RoomInfoModel(district: 0, name: "广西药用植物园", preImage: "3", address: "南宁市西乡塘区", roomID: "00002",latitude:22.8539483773, longitude:108.3746464867),
    "00003":RoomInfoModel(district: 0, name: "南宁动物园", preImage: "1", address: "南宁市西乡塘区", roomID: "00003",latitude:22.836873668, longitude:108.2693347539),
    "00004":RoomInfoModel(district: 0, name: "西乡塘蘑菇基地5", preImage: "1", address: "南宁市西乡塘区", roomID: "00004",latitude:22.833159668, longitude:108.2704847539),
    "00005":RoomInfoModel(district: 0, name: "西乡塘蘑菇基地6", preImage: "2", address: "南宁市西乡塘区", roomID: "00006",latitude:22.8404478915, longitude:108.2677161699),
    
    //兴宁区
    "10000":RoomInfoModel(district: 1, name: "兴宁区蘑菇基地1", preImage: "3", address: "南宁市兴宁区", roomID: "10000",latitude:22.854260521, longitude:108.3683639416),
    "10001":RoomInfoModel(district: 1, name: "兴宁区蘑菇基地2", preImage: "2", address: "南宁市兴宁区", roomID: "10001",latitude:22.8512552183, longitude:108.3580150058),
    "10002":RoomInfoModel(district: 1, name: "兴宁区蘑菇基地3", preImage: "3", address: "南宁市兴宁区", roomID: "10002",latitude:22.8563502183, longitude:108.3507920058),
    "10003":RoomInfoModel(district: 1, name: "兴宁区蘑菇基地4", preImage: "2", address: "南宁市兴宁区", roomID: "10003",latitude:22.8530202183, longitude:108.3506480058),
    "10004":RoomInfoModel(district: 1, name: "兴宁区蘑菇基地5", preImage: "1", address: "南宁市兴宁区", roomID: "10004",latitude:22.8513243773, longitude:108.3700374867),
    "10005":RoomInfoModel(district: 1, name: "兴宁区蘑菇基地6", preImage: "3", address: "南宁市兴宁区", roomID: "10005",latitude:22.8337121201, longitude:108.3415972061),
    "10006":RoomInfoModel(district: 1, name: "兴宁区蘑菇基地7", preImage: "2", address: "南宁市兴宁区", roomID: "10006",latitude:22.8446358659, longitude:108.3444764344),
    
    
    //青秀区
    "20000":RoomInfoModel(district: 2, name: "青秀区蘑菇基地1", preImage: "2", address: "南宁市青秀区", roomID: "20000",latitude:22.786536098, longitude:108.4969336708),
    "20001":RoomInfoModel(district: 2, name: "青秀区蘑菇基地2", preImage: "1", address: "南宁市青秀区", roomID: "20001",latitude:22.794014065, longitude:108.4914624112),
    "20002":RoomInfoModel(district: 2, name: "青秀区蘑菇基地3", preImage: "3", address: "南宁市青秀区", roomID: "20002",latitude:22.791881065, longitude:108.4979304112),
    "20003":RoomInfoModel(district: 2, name: "青秀区蘑菇基地4", preImage: "1", address: "南宁市青秀区", roomID: "20003",latitude:22.797878065, longitude:108.4955594112),
    "20004":RoomInfoModel(district: 2, name: "青秀区蘑菇基地5", preImage: "2", address: "南宁市青秀区", roomID: "20004",latitude:22.794913065, longitude:108.4918224112),
    "20005":RoomInfoModel(district: 2, name: "青秀区蘑菇基地6", preImage: "3", address: "南宁市青秀区", roomID: "20005",latitude:22.8016487898, longitude:108.5013773925),
    "20006":RoomInfoModel(district: 2, name: "青秀区蘑菇基地7", preImage: "1", address: "南宁市青秀区", roomID: "20006",latitude:22.795553894, longitude:108.5017103578),
    
    //江南区
    "30000":RoomInfoModel(district: 3, name: "江南区蘑菇基地1", preImage: "3", address: "南宁市江南区", roomID: "30000",latitude:23.851615052, longitude:106.688945574),
    "30001":RoomInfoModel(district: 3, name: "江南区蘑菇基地2", preImage: "1", address: "南宁市江南区", roomID: "30001",latitude:23.9021279063, longitude:106.6266956926),
    "30002":RoomInfoModel(district: 3, name: "江南区蘑菇基地3", preImage: "2", address: "南宁市江南区", roomID: "30002",latitude:23.8547100601, longitude:106.6584352348),
    "30003":RoomInfoModel(district: 3, name: "江南区蘑菇基地4", preImage: "2", address: "南宁市江南区", roomID: "30003",latitude:23.7904466925, longitude:106.6866258365),
    "30004":RoomInfoModel(district: 3, name: "江南区蘑菇基地5", preImage: "1", address: "南宁市江南区", roomID: "30004",latitude:23.9550872815, longitude:106.705008615),
    "30005":RoomInfoModel(district: 3, name: "江南区蘑菇基地6", preImage: "3", address: "南宁市江南区", roomID: "30005",latitude:22.794613065, longitude:108.4954874112),
    "30006":RoomInfoModel(district: 3, name: "江南区蘑菇基地7", preImage: "2", address: "南宁市江南区", roomID: "30006",latitude:22.793754894, longitude:108.5022133578),
    
    
    //邕宁区
    "40000":RoomInfoModel(district: 4, name: "邕宁区蘑菇基地1", preImage: "1", address: "南宁市邕宁区", roomID: "40000",latitude:22.7583459744, longitude:108.4873699459),
    "40001":RoomInfoModel(district: 4, name: "邕宁区蘑菇基地2", preImage: "3", address: "南宁市邕宁区", roomID: "40001",latitude:22.7568959744, longitude:108.4844239459),
    "40002":RoomInfoModel(district: 4, name: "邕宁区蘑菇基地3", preImage: "2", address: "南宁市邕宁区", roomID: "40002",latitude:22.7581798503, longitude:108.4992899761),
    "40003":RoomInfoModel(district: 4, name: "邕宁区蘑菇基地4", preImage: "3", address: "南宁市邕宁区", roomID: "40003",latitude:22.7614721022, longitude:108.4903403314),
    "40004":RoomInfoModel(district: 4, name: "邕宁区蘑菇基地5", preImage: "1", address: "南宁市邕宁区", roomID: "40004",latitude:22.7594391022, longitude:108.4972393314),
    "40005":RoomInfoModel(district: 4, name: "邕宁区蘑菇基地6", preImage: "1", address: "南宁市邕宁区", roomID: "40005",latitude:22.7583053025, longitude:108.4939664851),
    "40006":RoomInfoModel(district: 4, name: "邕宁区蘑菇基地7", preImage: "3", address: "南宁市邕宁区", roomID: "40006",latitude:22.7602061022, longitude:108.4895503314),
    
    
    //良庆区
    "50000":RoomInfoModel(district: 5, name: "良庆区蘑菇基地1", preImage: "3", address: "南宁市良庆区", roomID: "50000",latitude:22.7561363069, longitude:108.3208302292),
    "50001":RoomInfoModel(district: 5, name: "良庆区蘑菇基地2", preImage: "1", address: "南宁市良庆区", roomID: "50001",latitude:22.759352578, longitude:108.3199717034),
    "50002":RoomInfoModel(district: 5, name: "良庆区蘑菇基地3", preImage: "1", address: "南宁市良庆区", roomID: "50002",latitude:22.7569193069, longitude:108.3258612292),
    "50003":RoomInfoModel(district: 5, name: "良庆区蘑菇基地4", preImage: "2", address: "南宁市良庆区", roomID: "50003",latitude:22.7554500209, longitude:108.3325423893),
    "50004":RoomInfoModel(district: 5, name: "良庆区蘑菇基地5", preImage: "1", address: "南宁市良庆区", roomID: "50004",latitude:22.7567500209, longitude:108.3367823893),
    "50005":RoomInfoModel(district: 5, name: "良庆区蘑菇基地6", preImage: "3", address: "南宁市良庆区", roomID: "50005",latitude:22.7598836898, longitude:108.3379003899),
    "50006":RoomInfoModel(district: 5, name: "良庆区蘑菇基地7", preImage: "3", address: "南宁市良庆区", roomID: "50006",latitude:22.7575668212, longitude:108.3416289131),
    
    
    //武鸣区
    "60000":RoomInfoModel(district: 6, name: "武鸣区蘑菇基地1", preImage: "2", address: "南宁市武鸣区", roomID: "60000",latitude:23.1586338163, longitude:108.2746313446),
    "60001":RoomInfoModel(district: 6, name: "武鸣区蘑菇基地2", preImage: "2", address: "南宁市武鸣区", roomID: "60001",latitude:23.1552713656, longitude:108.2901032262),
    "60002":RoomInfoModel(district: 6, name: "武鸣区蘑菇基地3", preImage: "3", address: "南宁市武鸣区", roomID: "60002",latitude:23.1635098505, longitude:108.2931118124),
    "60003":RoomInfoModel(district: 6, name: "武鸣区蘑菇基地4", preImage: "1", address: "南宁市武鸣区", roomID: "60003",latitude:23.1605597932, longitude:108.2800513861),
    "60004":RoomInfoModel(district: 6, name: "武鸣区蘑菇基地5", preImage: "3", address: "南宁市武鸣区", roomID: "60004",latitude:23.1532853746, longitude:108.283762783),
    "60005":RoomInfoModel(district: 6, name: "武鸣区蘑菇基地6", preImage: "1", address: "南宁市武鸣区", roomID: "60005",latitude:23.1483379906, longitude:108.2998120523),
    "60006":RoomInfoModel(district: 6, name: "武鸣区蘑菇基地7", preImage: "1", address: "南宁市武鸣区", roomID: "60006",latitude:23.1506758163, longitude:108.2698523446),
    
    
    //横县
    "70000":RoomInfoModel(district: 7, name: "横县蘑菇基地1", preImage: "1", address: "南宁市横县", roomID: "70000",latitude:22.6799770705, longitude:109.2614636746),
    "70001":RoomInfoModel(district: 7, name: "横县蘑菇基地2", preImage: "2", address: "南宁市横县", roomID: "70001",latitude:22.6824863481, longitude:109.2517252633),
    "70002":RoomInfoModel(district: 7, name: "横县蘑菇基地3", preImage: "1", address: "南宁市横县", roomID: "70002",latitude:22.682762868, longitude:109.2408934601),
    "70003":RoomInfoModel(district: 7, name: "横县蘑菇基地1", preImage: "3", address: "南宁市横县", roomID: "70003",latitude:22.6799784313, longitude:109.2746288441),
    "70004":RoomInfoModel(district: 7, name: "横县蘑菇基地2", preImage: "3", address: "南宁市横县", roomID: "70004",latitude:22.6937811782, longitude:109.2715675115),
    "70005":RoomInfoModel(district: 7, name: "横县蘑菇基地3", preImage: "2", address: "南宁市横县", roomID: "70005",latitude:22.6902223819, longitude:109.2576126696),
    "70006":RoomInfoModel(district: 7, name: "横县蘑菇基地3", preImage: "1", address: "南宁市横县", roomID: "70006",latitude:22.684905187, longitude:109.287883537),
    
    
    //隆安县
    "80000":RoomInfoModel(district: 8, name: "隆安县蘑菇基地1", preImage: "1", address: "南宁市隆安县", roomID: "80000",latitude:23.1658743764, longitude:107.6960980935),
    "80001":RoomInfoModel(district: 8, name: "隆安县蘑菇基地2", preImage: "3", address: "南宁市隆安县", roomID: "80001",latitude:23.176859221, longitude:107.6997870593),
    "80002":RoomInfoModel(district: 8, name: "隆安县蘑菇基地3", preImage: "2", address: "南宁市隆安县", roomID: "80002",latitude:23.1786889825, longitude:107.6844320558),
    "80003":RoomInfoModel(district: 8, name: "隆安县蘑菇基地4", preImage: "3", address: "南宁市隆安县", roomID: "80003",latitude:23.1679438691, longitude:107.676100547),
    "80004":RoomInfoModel(district: 8, name: "隆安县蘑菇基地5", preImage: "1", address: "南宁市隆安县", roomID: "80004",latitude:23.1829572662, longitude:107.6761605109),
    "80005":RoomInfoModel(district: 8, name: "隆安县蘑菇基地6", preImage: "2", address: "南宁市隆安县", roomID: "80005",latitude:23.1740619643, longitude:107.6890833163),
    "80006":RoomInfoModel(district: 8, name: "隆安县蘑菇基地7", preImage: "2", address: "南宁市隆安县", roomID: "80006",latitude:23.1590468822, longitude:107.714949395),
    
    
    //马山县
    "90000":RoomInfoModel(district: 9, name: "马山县蘑菇基地1", preImage: "3", address: "南宁市马山县", roomID: "90000",latitude:23.7081530362, longitude:108.1770200152),
    "90001":RoomInfoModel(district: 9, name: "马山县蘑菇基地2", preImage: "2", address: "南宁市马山县", roomID: "90001",latitude:23.7137380957, longitude:108.1845360816),
    "90002":RoomInfoModel(district: 9, name: "马山县蘑菇基地3", preImage: "1", address: "南宁市马山县", roomID: "90002",latitude:23.7051671572, longitude:108.1679844289),
    "90003":RoomInfoModel(district: 9, name: "马山县蘑菇基地4", preImage: "2", address: "南宁市马山县", roomID: "90003",latitude:23.7123961937, longitude:108.1579261814),
    "90004":RoomInfoModel(district: 9, name: "马山县蘑菇基地5", preImage: "1", address: "南宁市马山县", roomID: "90004",latitude:23.7226299316, longitude:108.1697737125),
    "90005":RoomInfoModel(district: 9, name: "马山县蘑菇基地6", preImage: "2", address: "南宁市马山县", roomID: "90005",latitude:23.7171790957, longitude:108.1846800816),
    "90006":RoomInfoModel(district: 9, name: "马山县蘑菇基地7", preImage: "1", address: "南宁市马山县", roomID: "90006",latitude:23.7043401924, longitude:108.1865041103),
    
    
    //上林县
    "A0000":RoomInfoModel(district: 10, name: "上林县蘑菇基地1", preImage: "3", address: "南宁市上林县", roomID: "A0000",latitude:23.4320403399, longitude:108.6050613306),
    "A0001":RoomInfoModel(district: 10, name: "上林县蘑菇基地2", preImage: "1", address: "南宁市上林县", roomID: "A0001",latitude:23.425226685, longitude:108.6004259462),
    "A0002":RoomInfoModel(district: 10, name: "上林县蘑菇基地3", preImage: "2", address: "南宁市上林县", roomID: "A0002",latitude:23.4187027409, longitude:108.6119458358),
    "A0003":RoomInfoModel(district: 10, name: "上林县蘑菇基地4", preImage: "3", address: "南宁市上林县", roomID: "A0003",latitude:23.4375943399, longitude:108.6012163306),
    "A0004":RoomInfoModel(district: 10, name: "上林县蘑菇基地5", preImage: "3", address: "南宁市上林县", roomID: "A0004",latitude:23.4332988831, longitude:108.6216147412),
    "A0005":RoomInfoModel(district: 10, name: "上林县蘑菇基地6", preImage: "1", address: "南宁市上林县", roomID: "A0005",latitude:23.4195755627, longitude:108.6317828766),
    "A0006":RoomInfoModel(district: 10, name: "上林县蘑菇基地7", preImage: "2", address: "南宁市上林县", roomID: "A0006",latitude:23.4104787409, longitude:108.6151798358),
    
    
    //宾阳县
    "B0000":RoomInfoModel(district: 11, name: "宾阳县蘑菇基地1", preImage: "2", address: "南宁市宾阳县", roomID: "B0000",latitude:23.2176118614, longitude:108.8103096356),
    "B0001":RoomInfoModel(district: 11, name: "宾阳县蘑菇基地2", preImage: "1", address: "南宁市宾阳县", roomID: "B0001",latitude:23.2244408077, longitude:108.798749071),
    "B0002":RoomInfoModel(district: 11, name: "宾阳县蘑菇基地3", preImage: "2", address: "南宁市宾阳县", roomID: "B0002",latitude:23.2273610236, longitude:108.8184047579),
    "B0003":RoomInfoModel(district: 11, name: "宾阳县蘑菇基地4", preImage: "1", address: "南宁市宾阳县", roomID: "B0003",latitude:23.2163887073, longitude:108.8304838733),
    "B0004":RoomInfoModel(district: 11, name: "宾阳县蘑菇基地5", preImage: "2", address: "南宁市宾阳县", roomID: "B0004",latitude:23.2268453873, longitude:108.8281019419),
    "B0005":RoomInfoModel(district: 11, name: "宾阳县蘑菇基地6", preImage: "1", address: "南宁市宾阳县", roomID: "B0005",latitude:23.2432912108, longitude:108.8305779067),
    "B0006":RoomInfoModel(district: 11, name: "宾阳县蘑菇基地7", preImage: "3", address: "南宁市宾阳县", roomID: "B0006",latitude:23.2329885913, longitude:108.8464581346)
]

let temp = Array(GLOBAL_RoomInfo.values)

//
//func nearbyRoomFilter(_ rawData:RoomInfoModel)->RoomInfoModel{
//    var filterData :RoomInfoModel!
//    var differences : Dictionary<String,Double> = [:]
//    let elements = GLOBAL_RoomInfo.values
//    for element in elements {
//        let roomID = element.roomID
//        let lat_1 = element.latitude
//        let lng_1 = element.longitude
//        let lat_2 = GLOBAL_UserProfile.latitude
//        let lng_2 = GLOBAL_UserProfile.longitude
//        differences[roomID!] = distanceCalc(lat_1: lat_1!, lng_1: lng_1!, lat_2: lat_2!, lng_2: lng_2!)
//    }
//    let dicArray = differences.sorted{
//        $0.1<$1.1
//    }
//    for i in 0 ..< 5 {
//        let temp = dicArray[i]
//        let roomID = temp.0
//        let tempElement = acquireRoomInfoByRoomID(roomID: roomID)
//        filterData.setValue(tempElement, forKey: roomID)
//    }
//    return filterData
//}
//
//func acquireRoomInfoByName(name:String)->RoomInfoModel{
//    var foundOut = RoomInfoModel(district: 0, name: "0", preImage: "0", address: "0", roomID: "0",latitude: 0.0,longitude:0.0)
//    for(var i = 0;i<GLOBAL_RoomInfo.count;i+=1){
//        let temp = GLOBAL_RoomInfo[i]
//        if (temp.name == name){
//            foundOut = temp
//            break
//        }
//    }
//    return foundOut
//}
//
//var foundOut = acquireRoomInfoByName("广西大学")
//foundOut.name
//foundOut.districtIdentifier
//
//print(foundOut)
//
//
//func distanceCalc(lat_1:Double,lng_1:Double,lat_2:Double,lng_2:Double)->Double{
//    let EARTH_RADIUS = 6378.137
//    func rad(d:Double)->Double{
//        return d * M_PI / 180.0
//    }
//    let radLat_1 = rad(lat_1)
//    let radLat_2 = rad(lat_2)
//    let a = radLat_1 - radLat_2
//    let b = rad(lng_1)-rad(lng_2)
//    var s = 2 * asin(sqrt(pow(sin(a/2), 2))) + cos(radLat_1) * cos(radLat_2) * pow(sin(b / 2), 2)
//    s *= EARTH_RADIUS
//    s = round(s * 10000) / 10
//    return s
//}
//
//var s = distanceCalc(0, lng_1: 108, lat_2: 0, lng_2: 109)
//
//
//func acquireRoomInfoByRoomID(roomID:String)->RoomInfoModel{
//    var foundOut = RoomInfoModel(district: 0, name: "0", preImage: "0", address: "0", roomID: "0",latitude: 0.0,longitude:0.0)
//    for(var i = 0;i<GLOBAL_RoomInfo.count;i+=1){
//        let temp = GLOBAL_RoomInfo[i]
//        if (temp.roomID == roomID){
//            foundOut = temp
//            break
//        }
//    }
//    return foundOut
//}
//
//
//
//var nearbys = nearbyRoomFilter(GLOBAL_RoomInfo)
//
//
////func reverseGeocoder()->String{
////    var info:String?
////    var geocoder = CLGeocoder()
////    var currentUserLocation = CLLocation(latitude: GLOBAL_UserProfile.latitude!, longitude: GLOBAL_UserProfile.longitude!)
////    geocoder.reverseGeocodeLocation(currentUserLocation, completionHandler:
////        {placemarks,_ in
////        if placemarks != nil && placemarks?.count > 0{
////            let placemark = placemarks![0] as CLPlacemark
////            let countryName = placemark.country
////            let cityName = placemark.subAdministrativeArea
////            let streetName = placemark.subLocality
////            NSOperationQueue.mainQueue().addOperationWithBlock {
////                info = "\(streetName!), \(cityName!), \(countryName!)"
////            }
////        }
////    })
////    return info!
////}
////
////let info = reverseGeocoder()
//
////var info = reverseGeocoder()
//
//
////func reverseGeocoder (completion: (info:String) -> Void){
////    
////    var geocoder = CLGeocoder()
////    var currentUserLocation = CLLocation(latitude: 30, longitude: 122)
////    geocoder.reverseGeocodeLocation(currentUserLocation, completionHandler: {
////        (placemarks,error) -> Void in
////        if placemarks != nil && placemarks?.count > 0{
////            let placemark = placemarks![0] as CLPlacemark
////            let addressDictionary = placemark.addressDictionary! as NSDictionary
////            
////            let str:NSMutableString = ""
////            if let address = addressDictionary.objectForKey(kABPersonAddressStreetKey) as? String{
////                str.appendString(address)
////            }
////            
////            if let state = addressDictionary.objectForKey(kABPersonAddressStateKey) as? String{
////                str.appendString(state)
////            }
////            
////            if let city = addressDictionary.objectForKey(kABPersonAddressCityKey) as? String{
////                str.appendString(city)
////            }
////            completion(info: str as String)
////            
////        }
////        }
////    )
////}
//
//var num_1: CGFloat = 0.4343434
//var num_2 = round(num_1*100)
//
//
//
