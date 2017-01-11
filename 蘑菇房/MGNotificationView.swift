//
//  MGNotificationView.swift
//  蘑菇房
//
//  Created by 芒果君 on 2017/1/11.
//  Copyright © 2017年 蘑菇房工作室. All rights reserved.
//

import UIKit

class MGNotificationView: UIView {
    
    open var labelText:String?
    
    open var textColor:UIColor?
    
    open var duration:Double!
    
    open var doneImage:UIImage?
    
    private var alertView:UIView!
    private var label:UILabel!
    private var loading:UIActivityIndicatorView!
    private var doneImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alertView = UIView(frame: frame)
        alertView.alpha = 0.95
        alertView.center.x = UIScreen.main.bounds.midX
        alertView.center.y = UIScreen.main.bounds.midY - 20
        alertView.layer.cornerRadius = 20
        alertView.layer.masksToBounds = true
        alertView.clipsToBounds = true
        label = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.bounds.width , height: alertView.bounds.height/2 + 20))
        label.font = UIFont(name: "AvenirNext-Regular", size: 18)
        label.textAlignment = .center
        loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: alertView.bounds.width/10, height: alertView.bounds.height/5))
        loading.center.x = label.center.x
        loading.center.y = label.center.y + 30
        doneImageView = UIImageView(frame: loading.frame)
        doneImageView.contentMode = .scaleToFill
        alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        alertView.addSubview(label)
        alertView.addSubview(loading)
        self.addSubview(alertView)
    }
    
    init(frame: CGRect,labelText:String?,textColor:UIColor?,duration:Double,doneImage:UIImage?) {
        super.init(frame: frame)
        alertView = UIView(frame: frame)
        alertView.backgroundColor = UIColor(white: 0.6, alpha: 1)
        alertView.alpha = 0.95
        alertView.center.x = UIScreen.main.bounds.midX
        alertView.center.y = UIScreen.main.bounds.midY - 20
        alertView.layer.cornerRadius = 20
        alertView.layer.masksToBounds = true
        alertView.clipsToBounds = true
        label = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.bounds.width , height: alertView.bounds.height/2 + 20))
        label.font = UIFont(name: "AvenirNext-Regular", size: 18)
        label.textAlignment = .center
        label.text = labelText
        label.textColor = textColor
        loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: alertView.bounds.width/10, height: alertView.bounds.height/5))
        loading.center.x = label.center.x
        loading.center.y = label.center.y + 30
        doneImageView = UIImageView(frame: loading.frame)
        doneImageView.image = doneImage
        doneImageView.contentMode = .scaleToFill
        alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        self.labelText = labelText
        self.textColor = textColor
        self.duration = duration
        self.doneImage = doneImage
        
        alertView.addSubview(label)
        alertView.addSubview(loading)
        self.addSubview(alertView)

    }
    
    func addFeatures(labelText:String?,textColor:UIColor?,duration:Double,doneImage:UIImage?){
        self.labelText = labelText
        self.textColor = textColor
        self.duration = duration
        self.doneImage = doneImage
    }
    
    func stroke(in inputView:UIView){
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                if self.doneImage == nil{
                    self.doneImageView.image = UIImage(named: "cross_circle_128px")?.withRenderingMode(.alwaysOriginal)
                }
                else{
                    self.doneImageView.image = self.doneImage
                }
                
                if self.textColor == nil{
                    self.label.textColor = UIColor.white
                }
                else{
                    self.label.textColor = self.textColor
                }
                if self.labelText == nil{
                    self.label.text = "ExampleView"
                }
                else{
                    self.label.text = self.labelText
                }
                
                if (self.label.text?.characters.count)! > 10{
                    self.label.font = UIFont(name: "AvenirNext-Regular", size: 15)
                }
                self.alertView.addSubview(self.label)
                self.alertView.addSubview(self.loading)
                inputView.addSubview(self.alertView)
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.alertView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.alertView.alpha = 1
                    
                }, completion: {
                    (finished)->Void in
                    UIView.animate(withDuration: 0.2, delay: self.duration, options: .transitionCurlUp, animations: {
                        self.loading.stopAnimating()
                        self.alertView.addSubview(self.doneImageView)
                        self.alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        self.alertView.alpha = 0
                    }, completion: {
                        (com)->Void in
                        self.alertView.removeFromSuperview()
                    })
                })
                
            }
            
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
