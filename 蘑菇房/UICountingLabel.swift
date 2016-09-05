//
//  CountingLabel.swift
//  UICountingLabel
//
//  Created by EyreFree on 15/4/13.
//  Copyright (c) 2015 EyreFree. All rights reserved.
//

import Foundation
import UIKit

class UICountingLabel : UILabel
{
    var startingValue:CGFloat = 0
    var destinationValue:CGFloat = 0
    var progress:NSTimeInterval = NSTimeInterval()
    var lastUpdate:NSTimeInterval = NSTimeInterval()
    var totalTime:NSTimeInterval = NSTimeInterval()
    var timer:NSTimer = NSTimer()
    
    func countFrom(startValue:CGFloat, endValue:CGFloat, duration:NSTimeInterval)
    {
        self.startingValue = startValue
        self.destinationValue = endValue
        
        //初始化计时器
        self.timer.invalidate()
        
        if (duration <= 0.0)
        {
            self.text = NSString(format:"%.0lf", Double(endValue)) as String
            return
        }
        else
        {
            self.progress = 0
            self.totalTime = duration
            self.lastUpdate = NSDate.timeIntervalSinceReferenceDate()
            
            let timer = NSTimer(timeInterval:(1.0/30.0), target:self, selector:#selector(UICountingLabel.updateValue(_:)), userInfo:nil, repeats:true)
            
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: UITrackingRunLoopMode)
            self.timer = timer
        }
    }
    
    func updateValue(timer:NSTimer)
    {
        let now = NSDate.timeIntervalSinceReferenceDate()
        
        self.progress = self.progress + now - self.lastUpdate
        self.lastUpdate = now

        if (self.progress >= self.totalTime)
        {
            self.timer.invalidate()
            self.progress = self.totalTime
        }
        self.text = NSString(format:"%.0lf", Double(self.currentValue())) as String
        self.text = self.text! + "℃"
    }
    
    func currentValue()->CGFloat
    {
        if (self.progress >= self.totalTime)
        {
            return self.destinationValue
        }
        let updateVal:Double = self.progress / self.totalTime
        return CGFloat(Double(self.startingValue) + updateVal * Double(self.destinationValue - self.startingValue))
    }
}