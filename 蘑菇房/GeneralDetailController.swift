//
//  GeneralDetailController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/14.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class GeneralDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var selectedRow : Int?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
        var label = cell.viewWithTag(1001) as! UILabel
        let section = indexPath.section
        if(0 == self.selectedRow){
            if(0 == section){
                label.text = "账号与安全"
            }
            else if (1 == section){
                let labelGroup = ["新消息通知","帮助与反馈"]
                label.text = labelGroup[indexPath.row]
            }
            else if(2 == section){
                label.text = "退出登录"
                label.textAlignment = NSTextAlignment.Center
                cell.accessoryType = UITableViewCellAccessoryType.None //居中 2016.7.15／1:13a.m
            }
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(0 == self.selectedRow){
            switch section {
                case 0:
                    return 1
                case 1:
                    return 2
                case 2:
                    return 1
                default:
                    return 1
            }
        }
        else {
           return 1
        }
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
