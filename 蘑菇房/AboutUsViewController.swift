//
//  AboutUsViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/18.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    
    @IBOutlet weak var intro: UILabel!
    
    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intro.text = "制作人员:\n陈贵豪\n李曼嘉\n许洋\nEmail:ryanhowe@qq.com \n"
        intro.font = UIFont(name: GLOBAL_appFont!, size: 18.0)
        intro.textAlignment = NSTextAlignment.center
        
        appIcon.image = UIImage(named: "icon")
        appIcon.contentMode = .scaleToFill
        appIcon.clipsToBounds = true
        appIcon.layer.masksToBounds = true
        appIcon.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }

}
