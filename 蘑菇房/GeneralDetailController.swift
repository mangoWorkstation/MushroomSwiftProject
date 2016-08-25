//
//  GeneralDetailController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/14.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class GeneralDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {
    
    var selectedRow : Int?

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func close(segue:UIStoryboardSegue){
    }
    
    
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
                label.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 16.0)
            }
            else if (1 == section){
                cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                let labelGroup = ["新消息通知","帮助与反馈"]
                label.text = labelGroup[indexPath.row]
                label.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 16.0)

            }
            else if(2 == section){
                cell = self.tableView.dequeueReusableCellWithIdentifier("CacheCell")!
                let label = cell.viewWithTag(2001) as! UILabel
                let label_1 = cell.viewWithTag(2002) as! UILabel
                label.text = "清除缓存"
                label_1.text = "1.23 MB"  //显示缓存大小 2016.7.15/7:08
                label.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 16.0)
                label_1.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 16.0)

                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else if(3 == section){
                cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                label.text = "退出登录"
                label.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 16.0)
                label.textAlignment = NSTextAlignment.Center      //居中 2016.7.15／1:13a.m
                label.textColor = UIColor.redColor()
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
                label.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 16.0)
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
                version.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 12.0)
                appName.text = "蘑菇房"
                appName.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 24.0)
                copyRight.text = "Copyright © 2016 MushRoom Workstation \n All Rights Reserved \n 广西大学 蘑菇房工作室 出品"
                copyRight.font = UIFont(name: "FZQKBYSJW--GB1-0", size: 12.0)

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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){//点击后取消被选中状态 2016.7.17
        if(self.selectedRow == 0){
            if(indexPath.section == 0){
                if(indexPath.row == 0){
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    performSegueWithIdentifier("AccountSegue", sender: nil)
                }
            }
            if(indexPath.section == 1){
                if(indexPath.row == 0){
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    performSegueWithIdentifier("NewMessageInformSegue", sender: nil)
                }
                if(indexPath.row == 1){
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    performSegueWithIdentifier("FeedBackSegue", sender: nil)
                }
            }
        }
        if(self.selectedRow == 1){
            if(indexPath.section == 0){
                if(indexPath.row == 0){
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    performSegueWithIdentifier("AboutUsSegue",sender: nil)
                }
            }
        }
        if(indexPath.section == 2){
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            let detail = cell?.viewWithTag(2002) as! UILabel
            if detail.text != "0.00MB"{
                let sheet = UIActionSheet(title: "将要清除所有缓存", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
                sheet.showInView(self.view)
            }
            else{
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        else{
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    //MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 0 {
            let indexPath = self.tableView.indexPathForSelectedRow
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!)
            let detail = cell?.viewWithTag(2002) as! UILabel
            detail.text = "0.00MB"
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
    
    //MARK: - UIStoryBoardSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "AboutUsSegue"){
            let vc = segue.destinationViewController as! AboutUsViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "关于我们"
        }
        
        if(segue.identifier == "NewMessageInformSegue"){
            let vc = segue.destinationViewController as! NewMessageInformViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "消息与通知"
        }
        
        if(segue.identifier == "FeedBackSegue"){
            let vc = segue.destinationViewController as! FeedBackViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "您的建议"
        }
        
        if(segue.identifier == "AccountSegue"){
            let vc = segue.destinationViewController as! AccountViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "账号与安全"
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
