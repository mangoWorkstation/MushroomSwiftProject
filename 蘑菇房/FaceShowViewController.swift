//
//  FaceShowViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class FaceShowViewController: UIViewController {

    
    @IBOutlet weak var face: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        face.image = UIImage(named: GLOBAL_UserProfile.face!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
