//
//  UserViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class UserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    var staticItems_section_4 : [StaticItem] = [] //数组：用于存放静态状态图标
    var staticItems_section_3 : [StaticItem] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.translucent = false
        staticItems_section_3 = [StaticItem(iconName:"MyProfiles",label:"我的资料"),StaticItem(iconName:"Inform",label:"消息与通知")]
        staticItems_section_4 = [StaticItem(iconName:"Setup",label:"设置"),StaticItem(iconName:"About",label: "关于")]
        //初始化静态固定图标
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource
    //设置每一行的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0){  //用户信息栏 2016.7.5
            return 200
        }
        else if(indexPath.section == 1){//滚动信息栏 2016.7.5
            let cell = self.tableView!.dequeueReusableCellWithIdentifier("Notification")! as UITableViewCell
            let notification = cell.viewWithTag(202) as! UILabel
            if(notification.text!.characters.count<27){    //自适应表格宽度 2016.7.6
                return 50
            }
            else {
                return 30
            }
        
        }
        else if(indexPath.section == 2 ){//四个小图标栏 2016.7.12
            return 120
        }
        
        else if(indexPath.section == 3){//选项栏 2016.7.12
            return 50
        }
        else if(indexPath.section == 4){
            return 50
        }
            
        else {
            return 120
        }
    }
    
    //设置每个部分分别有多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section{
        case 0:fallthrough
        case 1:fallthrough
        case 2:return 1
        case 3:return staticItems_section_3.count
        case 4:return staticItems_section_4.count
        default:
            return 1
        }
    }
    
    //设置部分（section）的数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    //绑定数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = UITableViewCell()
        
        if (indexPath.section == 0){
            cell = self.tableView!.dequeueReusableCellWithIdentifier("UserInfo")!
            let icon = cell!.viewWithTag(1011) as! UIImageView
            let nameLabel = cell!.viewWithTag(1012) as! UILabel
//          let background = cell.viewWithTag(102) as! UIImageView
            icon.image = UIImage(named: "User")
            icon.layer.cornerRadius = icon.frame.size.width/2.5
            icon.clipsToBounds = true     //制作圆形的头像
            nameLabel.text = "芒果君"//
//          background.image = UIImage(named:"2")
        }
        else if (indexPath.section == 1){
            
            cell = self.tableView!.dequeueReusableCellWithIdentifier("Notification")!
            let sign = cell!.viewWithTag(201) as! UIImageView
            let notification = cell!.viewWithTag(202) as! UILabel
            sign.image = UIImage(named: "Alert")
            notification.text = "2016-7-6 南宁市气象局发布暴雨红色预警，请注意强对流天气"
            
        }
        else if(indexPath.section == 2){
            
            cell = self.tableView!.dequeueReusableCellWithIdentifier("Inspector")!
            
            let stackview = cell!.viewWithTag(10) as! UIStackView
            let deviceModel:String = UIDevice.currentDevice().model
            if (deviceModel == "@iPhone 4s"){
                stackview.spacing = 10
            }
            else if (deviceModel == "@iPhone 6s"){
                stackview.spacing = 40
            }
            
            //stackview_1 Room
            let roomIcon = cell!.viewWithTag(101) as! UIImageView
            let roomLabel = cell!.viewWithTag(102) as! UILabel
            roomIcon.image = UIImage(named: "Mushroom")
            roomLabel.text = "蘑菇房"
            
            //stackview_2 Barn
            let barnIcon = cell!.viewWithTag(201) as! UIImageView
            let barnLabel = cell!.viewWithTag(202) as! UILabel
            barnIcon.image = UIImage(named: "Barn")
            barnLabel.text = "堆料房"
            
            //stackview_3 Battery
            let batteryIcon = cell!.viewWithTag(301) as! UIImageView
            let batteryLabel = cell!.viewWithTag(302) as! UILabel
            batteryIcon.image = UIImage(named: "Battery")
            batteryLabel.text = "电量检测"
            
            //stackview_4 Statistics
            let chartIcon = cell!.viewWithTag(401) as! UIImageView
            let chartlabel = cell!.viewWithTag(402) as! UILabel
            chartIcon.image = UIImage(named: "Statistics")
            chartlabel.text = "历史数据"
            
//            四个stackview的编号说明：
//            蘑菇房：图标101，标签102
//            堆料房：图标201，标签202
//            电量检测：图标301，标签302
//            历史数据：图标401，标签402
            
        }
        else if(indexPath.section == 3){
            cell = self.tableView.dequeueReusableCellWithIdentifier("Inform",forIndexPath: indexPath)
            let icon = cell?.viewWithTag(3001) as! UIImageView
            let label = cell?.viewWithTag(3002) as! UILabel
            let _staticItem = staticItems_section_3[indexPath.row] as StaticItem
            icon.image = UIImage(named: _staticItem.iconName)
            label.text = _staticItem.label
        }
        else if (indexPath.section == 4){
            cell = self.tableView.dequeueReusableCellWithIdentifier("General",forIndexPath: indexPath)
            let Icon = cell!.contentView.viewWithTag(3001) as! UIImageView
            let Title = cell!.contentView.viewWithTag(3002) as! UILabel
            let _staticItem = staticItems_section_4[indexPath.row] as StaticItem//点击后内容会消失，原因不明，目测可能和数据持久化有关2016.7.14／13:52
            Icon.image = UIImage(named: _staticItem.iconName)
            Title.text = _staticItem.label //有问题 2016.7.14 00:02
        }
        
        return cell!
    }
    
    //设置表格部分（section）的间距 2016.7.15/9:17
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if(0 == section){
            return 0.1     //不要顶部留白
        }
        else if(1 == section){
            return 2
        }
        else if(2 == section){
            return 2
        }
        else if(4 == section){
            return 8
        }
        else {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true) //点击后取消被选中状态 2016.7.17
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                performSegueWithIdentifier("EditProfilesSegue", sender: nil)
            }
            if(indexPath.row == 1){
                performSegueWithIdentifier("NotificationSegue", sender: nil)
            }
        }
    }
    
    //MARK - UIStoryBoardSegue
    //segue 跳转页面
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SetupSegue"){
            let indexPath = self.tableView.indexPathForSelectedRow
            let vc = segue.destinationViewController as! GeneralDetailController
            let row = indexPath!.row
            var title = ""
            switch row {
            case 0:
                title = "设置"
            case 1:
                title = "关于蘑菇房"
            default:
                break
            }
            vc.navigationController?.view.backgroundColor = UIColor.whiteColor()
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = title
            vc.selectedRow = row
        }
        if(segue.identifier == "NotificationSegue"){
            let vc = segue.destinationViewController as! NotificationViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = ""
        }
        if(segue.identifier == "EditProfilesSegue"){
                let vc = segue.destinationViewController as! EditProfilesViewController
                vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
                vc.navigationItem.title = "个人资料"
            }
        }
    
}
