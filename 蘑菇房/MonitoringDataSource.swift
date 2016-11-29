//
//  MonitoringDataSource.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

//未被管理的实体类，通用的检测数据表（湿度，温度，co2，通用）

import Foundation

class MonitoringDataSource{
    var baseID:Int64
    var userID:Int64
    var time:Int64
    var value:Double
    var dataID:Int64
    var cropsID:Int64
    
    init(baseID:Int64,userID:Int64,time:Int64,value:Double,dataID:Int64,cropsID:Int64) {
        self.baseID = baseID
        self.userID = userID
        self.time = time
        self.dataID = dataID
        self.value = value
        self.cropsID = cropsID
    }
    
}
