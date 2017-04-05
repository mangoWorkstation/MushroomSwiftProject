//
//  PDPieChart.swift
//  Swift_iPhone_demo
//
//  Created by Pandara on 14-7-7.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

import UIKit
import QuartzCore

struct PieDataItem {
    var description: String?
    var color: UIColor?
    var percentage: CGFloat!
}

let lightGreen: UIColor = UIColor(red: 69.0 / 255, green: 212.0 / 255, blue: 103.0 / 255, alpha: 1.0)
let middleGreen: UIColor = UIColor(red: 66.0 / 255, green: 187.0 / 255, blue: 102.0 / 255, alpha: 1.0)
let deepGreen: UIColor = UIColor(red: 64.0 / 255, green: 164.0 / 255, blue: 102.0 / 255, alpha: 1.0)

class PDPieChartDataItem {
    //optional
    var animationDur: CGFloat = 1.0
    var clockWise: Bool = true
    var chartStartAngle: CGFloat = CGFloat(-CGFloat.pi / 2)
    var pieTipFontSize: CGFloat = 12.0
    var pieTipTextColor: UIColor = UIColor.white
    var pieMargin: CGFloat = 0
    
    //required
    var pieWidth: CGFloat!
    var dataArray: [PieDataItem]!
    
    init() {
        
    }
}

class PDPieChart: PDChart {
    var dataItem: PDPieChartDataItem!
    
    init(frame: CGRect, dataItem: PDPieChartDataItem) {
        super.init(frame: frame)
        self.dataItem = dataItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getShapeLayerWithARCPath(_ color: UIColor?, lineWidth: CGFloat, center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockWise: Bool) -> CAShapeLayer {
        //layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.lineCap = kCALineCapButt
        pathLayer.fillColor = UIColor.clear.cgColor
        if (color != nil) {
            pathLayer.strokeColor = color!.cgColor
        }
        pathLayer.lineWidth = self.dataItem.pieWidth
        pathLayer.strokeStart = 0.0
        pathLayer.strokeEnd = 1.0
        pathLayer.backgroundColor = UIColor.clear.cgColor
        
        //path
        let path: UIBezierPath = UIBezierPath()
        path.lineWidth = lineWidth
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: self.dataItem.clockWise)
        path.stroke()
        
        pathLayer.path = path.cgPath
        return pathLayer
    }
    
    override func strokeChart() {
        var pieCenterPointArray: [CGPoint] = []
        let radius: CGFloat = self.frame.size.width / 2 - self.dataItem.pieMargin - self.dataItem.pieWidth / 2
        let center: CGPoint = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        let chartLayer: CAShapeLayer = CAShapeLayer()
        chartLayer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(chartLayer)
        
        UIGraphicsBeginImageContext(self.frame.size)
        //每一段饼
        var totalPercentage: CGFloat = 0.0
        for i in 0..<self.dataItem.dataArray.count {
            //data
            let dataItem: PieDataItem = self.dataItem.dataArray[i]
            let startAngle: CGFloat = CGFloat(CGFloat.pi * 2.0) * totalPercentage + self.dataItem.chartStartAngle
            let endAngle: CGFloat = startAngle + dataItem.percentage * CGFloat(CGFloat.pi * 2)
            
            //pie center point
            let angle: Float = Float(dataItem.percentage) * Float(Float.pi) * Float(2.0) / 2.0 + Float(totalPercentage) * Float(Float.pi * 2.0)
            
            let pieCenterPointX: CGFloat = center.x + radius * CGFloat(sinf(angle))
            let pieCenterPointY: CGFloat = center.y - radius * CGFloat(cosf(angle))
            let pieCenterPoint: CGPoint = CGPoint(x: pieCenterPointX, y: pieCenterPointY)
            pieCenterPointArray.append(pieCenterPoint)
            
            totalPercentage += dataItem.percentage
            
            //arc path layer
            let pathLayer = self.getShapeLayerWithARCPath(dataItem.color, lineWidth: self.dataItem.pieWidth, center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockWise: true)
            chartLayer.addSublayer(pathLayer)
        }
        
        //mask
        let maskCenter: CGPoint = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2)
        let maskRadius: CGFloat = self.frame.size.width / 2 - self.dataItem.pieMargin - self.dataItem.pieWidth / 2
        let maskStartAngle: CGFloat = -CGFloat(CGFloat.pi) / 2
        let maskEndAngle: CGFloat = CGFloat(CGFloat.pi) * 2 - CGFloat(CGFloat.pi) / 2
        let maskLayer: CAShapeLayer = self.getShapeLayerWithARCPath(UIColor.white, lineWidth: self.dataItem.pieWidth, center: maskCenter, radius: maskRadius, startAngle: maskStartAngle, endAngle: maskEndAngle, clockWise: true)
        maskLayer.strokeStart = 0.0
        maskLayer.strokeEnd = 1.0
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = CFTimeInterval(self.dataItem.animationDur)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = true
        maskLayer.add(animation, forKey: "maskAnimation")
        
        self.layer.mask = maskLayer
        
        UIGraphicsEndImageContext()
        
        //pie tip
        for i in 0..<pieCenterPointArray.count {
            let dataItem: PieDataItem = self.dataItem.dataArray[i]
            
            let pieTipLabel: UILabel = UILabel()
            pieTipLabel.backgroundColor = UIColor.clear;
            pieTipLabel.font = UIFont.systemFont(ofSize: self.dataItem.pieTipFontSize)
            pieTipLabel.textColor = self.dataItem.pieTipTextColor
            pieTipLabel.numberOfLines = 2
            pieTipLabel.lineBreakMode = .byWordWrapping
            //芒果君自己新增的属性 2016.9.3
            if (dataItem.description != nil) {
                pieTipLabel.text = dataItem.description! + "\n\(round(dataItem.percentage * 100))%"
            } else {
                pieTipLabel.text = "\(round(dataItem.percentage * 100))%"
                //芒果君自己加的 显示小改造 2016.9.3
            }
            pieTipLabel.sizeToFit()
            pieTipLabel.alpha = 0.0
            pieTipLabel.center = pieCenterPointArray[i]
            
            UIView.animate(withDuration: 0.5, delay: TimeInterval(self.dataItem.animationDur), options: UIViewAnimationOptions(), animations:{
                    () -> Void in
                    pieTipLabel.alpha = 1.0
                }, completion: {
                    (completion: Bool) -> Void in
                    return
                })
            
            self.addSubview(pieTipLabel)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

}















