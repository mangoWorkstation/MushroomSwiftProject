//
//  WeatherDataSource.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/12/11.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation

class WeatherDataSource:NSObject{
    var code_day:String?
    var code_night:String?
    var windLevel:String?
    var currentTemp:String?
    var week:String?
    var date:String?
    var highTemp:String?
    var lowTemp:String?
    var windDirection:String?
    var type_day:String?
    var type_night:String?
    
    init(windLevel:String?,currentTemp:String?,week:String?,date:String?,highTemp:String?,lowTemp:String?,windDirection:String?,type_day:String?,type_night:String?,code_day:String?,code_night:String?) {
        self.windLevel = windLevel
        self.currentTemp = currentTemp
        self.week = week
        self.date = date
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.windDirection = windDirection
        self.type_day = type_day
        self.type_night = type_night
        self.code_night = code_night
        self.code_day = code_day
    }
    
    override init() {
        self.windLevel = "0"
        self.currentTemp = "0"
        self.week = "0"
        self.date = "0"
        self.highTemp = "0"
        self.lowTemp = "0"
        self.windDirection = "0"
        self.type_day = "0"
        self.type_night = "0"
        self.code_night = "0"
        self.code_day = "0"
    }
    
    init(coder aDecoder:NSCoder!){
        self.windLevel = aDecoder.decodeObject(forKey: "windLevel") as? String
        self.currentTemp = aDecoder.decodeObject(forKey: "currentTemp") as? String
        self.week = aDecoder.decodeObject(forKey: "week") as? String
        self.date = aDecoder.decodeObject(forKey: "date") as? String
        self.highTemp = aDecoder.decodeObject(forKey: "highTemp") as? String
        self.lowTemp = aDecoder.decodeObject(forKey: "lowTemp") as? String
        self.windDirection = aDecoder.decodeObject(forKey: "windDirection") as? String
        self.type_day = aDecoder.decodeObject(forKey: "type_day") as? String
        self.type_night = aDecoder.decodeObject(forKey: "type_night") as? String
        self.code_night = aDecoder.decodeObject(forKey: "code_night") as? String
        self.code_day = aDecoder.decodeObject(forKey: "code_day") as? String

    }
    
    func encodeWithCoder(_ aCoder:NSCoder!){
        aCoder.encode(windLevel, forKey: "windLevel")
        aCoder.encode(currentTemp,forKey:"currentTemp")
        aCoder.encode(week,forKey:"week")
        aCoder.encode(date,forKey:"date")
        aCoder.encode(highTemp,forKey:"highTemp")
        aCoder.encode(lowTemp,forKey:"lowTemp")
        aCoder.encode(windDirection,forKey:"windDirection")
        aCoder.encode(type_day,forKey:"type_day")
        aCoder.encode(type_night,forKey:"type_night")
        aCoder.encode(code_day,forKey:"code_day")
        aCoder.encode(code_night,forKey:"code_night")


    }

}

//返回的JSON样例
//print("今天")
//print(json["retData"]["today"])
//print("未来预报")
//print(json["retData"]["forecast"])

//今天
//    {
//        "fengli" : "微风级",
//        "aqi" : "141",
//        "curTemp" : "17℃",
//        "week" : "星期六",
//        "date" : "2016-12-11",
//        "hightemp" : "25℃",
//        "lowtemp" : "13℃",
//        "fengxiang" : "东北风",
//        "type" : "晴",
//        "index" : [
//        {
//        "code" : "gm",
//        "details" : "各项气象条件适宜，无明显降温过程，发生感冒机率较低。",
//        "name" : "感冒指数",
//        "otherName" : "",
//        "index" : ""
//        },
//        {
//        "code" : "fs",
//        "details" : "属中等强度紫外辐射天气，外出时应注意防护，建议涂擦SPF指数高于15，PA+的防晒护肤品。",
//        "name" : "防晒指数",
//        "otherName" : "",
//        "index" : "中等"
//        },
//        {
//        "code" : "ct",
//        "details" : "天气热，建议着短裙、短裤、短薄外套、T恤等夏季服装。",
//        "name" : "穿衣指数",
//        "otherName" : "",
//        "index" : "热"
//        },
//        {
//        "code" : "yd",
//        "details" : "天气较好，户外运动请注意防晒。推荐您进行室内运动。",
//        "name" : "运动指数",
//        "otherName" : "",
//        "index" : "较适宜"
//        },
//        {
//        "code" : "xc",
//        "details" : "较适宜洗车，未来一天无雨，风力较小，擦洗一新的汽车至少能保持一天。",
//        "name" : "洗车指数",
//        "otherName" : "",
//        "index" : "较适宜"
//        },
//        {
//        "code" : "ls",
//        "details" : "天气不错，适宜晾晒。赶紧把久未见阳光的衣物搬出来吸收一下太阳的味道吧！",
//        "name" : "晾晒指数",
//        "otherName" : "",
//        "index" : "适宜"
//        }
//        ]
//}
//未来预报
//[
//    {
//        "fengli" : "微风级",
//        "hightemp" : "23℃",
//        "week" : "星期天",
//        "date" : "11日",
//        "lowtemp" : "15℃",
//        "fengxiang" : "东南风",
//        "type" : "多云"
//    },
//    {
//        "fengli" : "微风级",
//        "hightemp" : "22℃",
//        "week" : "星期一",
//        "date" : "12日",
//        "lowtemp" : "16℃",
//        "fengxiang" : "东南风",
//        "type" : "阵雨"
//    },
//    {
//        "fengli" : "微风级",
//        "hightemp" : "22℃",
//        "week" : "星期二",
//        "date" : "13日",
//        "lowtemp" : "15℃",
//        "fengxiang" : "东北风",
//        "type" : "阴"
//    },
//    {
//        "fengli" : "微风级",
//        "hightemp" : "20℃",
//        "week" : "星期三",
//        "date" : "14日",
//        "lowtemp" : "13℃",
//        "fengxiang" : "东北风",
//        "type" : "阴"
//    }
//]
//
//
