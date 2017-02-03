//
//  MGBannerIndicatorView.swift
//  蘑菇房
//
//  Created by 芒果君 on 2017/2/3.
//  Copyright © 2017年 蘑菇房工作室. All rights reserved.
//

import UIKit

class MGBannerIndicatorView: UIView {

    open var duration:TimeInterval
    
    private var title:UILabel!
    
    init(duration:TimeInterval,text:String?,backgroundColor:UIColor?,textColor:UIColor?) {
        self.duration = duration
        let frame = CGRect(x: 0, y: UIScreen.main.bounds.origin.y + 30, width: UIScreen.main.bounds.width, height: 35)
        super.init(frame: frame)
        if backgroundColor == nil{
            self.backgroundColor = UIColor.orange
        }
        else{
            self.backgroundColor = backgroundColor
        }
        title = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: 35))
        title.center.x = self.center.x
        title.text = text
        title.textAlignment = .center
        title.font = UIFont(name: GLOBAL_appFont!, size: 15)
        if textColor == nil{
            title.textColor = UIColor.white
        }
        else{
            title.textColor = textColor
        }
        addSubview(title)
    }
    
    func stroke(in view:UIView){
        view.addSubview(self)
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 33)
        }, completion: {
            (finished)->Void in
            UIView.animate(withDuration: 0.5, delay: self.duration, options: .transitionCurlUp, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: {
                (com)->Void in
                self.removeFromSuperview()
            })
        })

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
