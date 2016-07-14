//
//  PreviewModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/1.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation

class Preview : NSObject{
    var name : String
    var preImage : String
    let more = "查看详情"
    
    init(name:String,preImage:String) {
        self.name = name;
        self.preImage = preImage
    }
}