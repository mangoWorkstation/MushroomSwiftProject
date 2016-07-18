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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intro.text = "制作人员:\n陈贵豪\n李曼嘉\n许洋\nEmail:ryanhowe@qq.com \n"
        intro.textAlignment = NSTextAlignment.Center

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
