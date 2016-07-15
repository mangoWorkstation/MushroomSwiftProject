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
        let section = indexPath.section
        if(0 == self.selectedRow){
            return 50
        }
        else if(1 == self.selectedRow){
            switch section {
            case 0:
                return 50
            default:
                return 370
            }
        }
        else{
            return 50
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        let section = indexPath.section
        
        //点击“设置”
        if(0 == self.selectedRow){
            if(0 == section){
                cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                label.text = "账号与安全"
            }
            else if (1 == section){
                cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                let labelGroup = ["新消息通知","帮助与反馈"]
                label.text = labelGroup[indexPath.row]
            }
            else if(2 == section){
                cell = self.tableView.dequeueReusableCellWithIdentifier("CacheCell")!
                let label = cell.viewWithTag(2001) as! UILabel
                let label_1 = cell.viewWithTag(2002) as! UILabel
                label.text = "清除缓存"
                label_1.text = "1.23 MB"  //显示缓存大小 2016.7.15/7:08
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else if(3 == section){
                cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                label.text = "退出登录"
                label.textAlignment = NSTextAlignment.Center      //居中 2016.7.15／1:13a.m
                cell.accessoryType = UITableViewCellAccessoryType.None   //无箭头指示器ii
            }
        }
        
        //点击“关于”
        if(1 == self.selectedRow){
            if(0 == section){
                cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                let labels = ["关于我们","给蘑菇房来个好评吧😊"]
                label.text = labels[indexPath.row]
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else{
                cell = self.tableView.dequeueReusableCellWithIdentifier("AboutAppCell")!
                let appIcon = cell.viewWithTag(2001) as! UIImageView
                let version = cell.viewWithTag(2002) as! UILabel
                let appName = cell.viewWithTag(2003) as! UILabel
                let copyRight = cell.viewWithTag(2004) as! UILabel
                appIcon.image = UIImage(named: "App")
                version.text = "当前版本：1.0.1 Alpha"
                appName.text = "蘑菇房"
                copyRight.text = "Copyright © 2016 MushRoom Workstation \n All Rights Reserved \n 广西大学 蘑菇房工作室 出品"
                copyRight.lineBreakMode = NSLineBreakMode.ByWordWrapping
                copyRight.numberOfLines = 0
            }
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if selectedRow == 0{
            return 4
        }
        else if(1 == self.selectedRow){
            return 2
        }
        else {
            return 1
        }
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
        else if(1 == self.selectedRow) {
            switch section {
            case 0:
                return 2
            default:
                return 1
            }
        }
        else {
            return 1
        }
    }
    
    //MARK: - UIStoryBoardSegue
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        <#code#>
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
