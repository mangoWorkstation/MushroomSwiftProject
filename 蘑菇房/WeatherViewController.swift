//
//  WeatherViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    
    @IBOutlet weak var selectedPage: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPage.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont(name: GLOBAL_appFont!, size: 12.0)!], for: UIControlState())
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

