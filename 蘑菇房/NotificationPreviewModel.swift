//
//  NotificationPreviewModel.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import Foundation
class NotificationPreview: NSObject {
    var preImage : String?
    var prelabel : String?
    var isRead : Bool = false
    
    init(preImage:String,prelabel:String,isRead:Bool) {
        self.preImage = preImage
        self.prelabel = prelabel
        self.isRead = isRead
    }
}