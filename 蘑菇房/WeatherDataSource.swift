//
//  WeatherDataSource.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/12/11.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation

class WeatherDataSource:NSObject{
    var windLevel:String?
    var currentTemp:String?
    var week:String?
    var date:String?
    var highTemp:String?
    var lowTemp:String?
    var windDirection:String?
    var type:String?
    
    init(windLevel:String?,currentTemp:String?,week:String?,date:String?,highTemp:String?,lowTemp:String?,windDirection:String?,type:String?) {
        self.windLevel = windLevel
        self.currentTemp = currentTemp
        self.week = week
        self.date = date
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.windDirection = windDirection
        self.type = type
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
