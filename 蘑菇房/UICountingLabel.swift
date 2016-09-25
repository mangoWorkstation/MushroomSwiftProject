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
    var progress:TimeInterval = TimeInterval()
    var lastUpdate:TimeInterval = TimeInterval()
    var totalTime:TimeInterval = TimeInterval()
    var timer:Timer = Timer()
    
    func countFrom(_ startValue:CGFloat, endValue:CGFloat, duration:TimeInterval)
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
            self.lastUpdate = Date.timeIntervalSinceReferenceDate
            
            let timer = Timer(timeInterval:(1.0/30.0), target:self, selector:#selector(UICountingLabel.updateValue(_:)), userInfo:nil, repeats:true)
            
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
            RunLoop.main.add(timer, forMode: RunLoopMode.UITrackingRunLoopMode)
            self.timer = timer
        }
    }
    
    func updateValue(_ timer:Timer)
    {
        let now = Date.timeIntervalSinceReferenceDate
        
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
