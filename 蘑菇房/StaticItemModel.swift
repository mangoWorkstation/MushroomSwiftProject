//
//  StaticItemModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/14.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//
//“设置”一栏的静态固定选项 2016.7.14／13:34

import Foundation

class StaticItem: NSObject {
    var iconName:String
    var label:String
    
    init(iconName:String,label:String) {
        self.iconName = iconName
        self.label = label
    }
}