//
//  NotificationViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var InfoType: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isThereAnythingNew : Bool = true{
        didSet{
            isThereAnythingNew = true
        }
    }
    
    var notificationCache : [NotificationPreview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        InfoType.selectedSegmentIndex = 0
        notificationCache = [NotificationPreview(preImage: "Hello", prelabel:"南宁市未来三天高温将继续持续",isRead: false),NotificationPreview(preImage: "MyName", prelabel:"您的蘑菇房高温警报",isRead: false),NotificationPreview(preImage: "IsNot", prelabel:"您的蘑菇房二氧化碳浓度偏高",isRead: false),NotificationPreview(preImage: "XiJinping", prelabel:"每日提醒：您的蘑菇房运行正常",isRead: false),NotificationPreview(preImage: "IM", prelabel:"监控系统故障停机，请及时联系维修人员",isRead: false),NotificationPreview(preImage: "LiKeqiang", prelabel:"本周蘑菇房的监测分析报告出来啦！快点开瞧瞧吧～",isRead: false)]
        //测试数据
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if(0 == self.InfoType.selectedSegmentIndex){
            if(self.isThereAnythingNew == false){
                return 420
            }
            else {
                return 120
            }
        }
        else{
            return 120
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if(0 == self.InfoType.selectedSegmentIndex){
            return 0
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(0 == self.InfoType.selectedSegmentIndex){
            if(self.isThereAnythingNew == false){
                return 1
            }
            else {
                return self.notificationCache.count
            }
        }
        else {
            return self.notificationCache.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell? = UITableViewCell()
        if(0 == self.InfoType.selectedSegmentIndex){
            if(self.isThereAnythingNew == false){
                cell = self.tableView!.dequeueReusableCellWithIdentifier("EmptyMailBoxCell")!
                let emptyIcon = cell?.viewWithTag(1001) as! UIImageView
                let emptySign = cell?.viewWithTag(1002) as! UILabel
                emptyIcon.image = UIImage(named: "Empty")
                emptySign.text = "暂时木有新消息，待会再来刷刷～～～～"
            }
            else{
                cell = self.tableView.dequeueReusableCellWithIdentifier("MailCell",forIndexPath: indexPath)
                let preImage = cell?.viewWithTag(2001) as! UIImageView
                let preLabel = cell?.viewWithTag(2002) as! UILabel
                let timeLabel = cell?.viewWithTag(2003) as! UILabel
                let preview = self.notificationCache[indexPath.row]
                preImage.image = UIImage(named: preview.preImage!)
                preLabel.text = preview.prelabel!
                timeLabel.text = "Time"
            }
        }
        else {
            cell = self.tableView.dequeueReusableCellWithIdentifier("MailCell",forIndexPath: indexPath)
            let preImage = cell?.viewWithTag(2001) as! UIImageView
            let preLabel = cell?.viewWithTag(2002) as! UILabel
            let timeLabel = cell?.viewWithTag(2003) as! UILabel
            let preview = self.notificationCache[indexPath.row]
            preImage.image = UIImage(named: preview.preImage!)
            preLabel.text = preview.prelabel!
            timeLabel.text = "Time"
        }
        return cell!
    }
    
    
    
    
}
