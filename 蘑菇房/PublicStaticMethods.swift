//
//  PublicStaticMethods.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/21.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//  各类静态方法

import Foundation

//时间戳转日期 2016.7.16
func timeStampToString(timeStamp:String)->String {
    
    let string = NSString(string: timeStamp)
    
    let timeSta:NSTimeInterval = string.doubleValue
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat="yyyy年MM月dd日"
    
    let date = NSDate(timeIntervalSince1970: timeSta)
    
    //    print(dfmatter.stringFromDate(date))
    return dfmatter.stringFromDate(date)
}
