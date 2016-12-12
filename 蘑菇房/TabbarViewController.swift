//
//  TabbarViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/9/25.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.tag)
        if item.tag == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homeRefresh"), object: nil)
            
        }
        else if item.tag == 1
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileRefresh"), object: nil)
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "discoverRefresh"), object: nil)
            
        }
    }
    
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
