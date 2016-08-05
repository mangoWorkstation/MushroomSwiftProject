//
//  NotificationViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate{

    @IBOutlet weak var InfoType: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    @IBAction func SegmentOnChanged(sender: AnyObject) {
        self.whichKindOfInfoType = InfoType.selectedSegmentIndex
        self.tableView.reloadData() //重要！！刷新表格数据！！ 2016.7.16/10:58
                                    //triggered when user click on different segments
    }
    
    @IBAction func TrashAllMessage(sender: UIBarButtonItem) {
        var sheet = UIActionSheet()
        if(InfoType.selectedSegmentIndex == 0){
            if !GLOBAL_UnreadMessage.isEmpty {
                sheet = UIActionSheet(title: "将所有未读消息标记为已读消息？", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
                sheet.showInView(self.view)
            }
        }
        else if(InfoType.selectedSegmentIndex == 1){
            if !GLOBAL_NotificationCache.isEmpty {
                sheet = UIActionSheet(title: "将要清空所有消息？", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
                sheet.showInView(self.view)
            }
        }

    }
    var whichKindOfInfoType = 0 //should be initialized! 2016.7.16/11:42
    
    var isThereAnythingNew : Bool = true   //identify if unread messages exist 2016.7.16/11:41 // Need to be updated later
    
//    var notificationCache : [NotificationPreview] = GLOBAL_NotificationCache
//    
//    var unreadMessage : [NotificationPreview] = GLOBAL_UnreadMessage
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //测试数据
        if(GLOBAL_UnreadMessage.count == 0){
            self.isThereAnythingNew = false
        }
//        if(whichKindOfInfoType == 0){
//            trashButton.title = "全部标记已读"
//        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(right:)];
//        }
        self.tableView.reloadData()
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
        else if(1 == self.InfoType.selectedSegmentIndex){
            if(GLOBAL_NotificationCache.count == 0){
                return 420
            }
            else{
                return 120
            }
        }
        else {
          return 0
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
//                let UnreadMessage = unreadMessageFilter(self.notificationCache)
                return GLOBAL_UnreadMessage.count //返回未读信息数 2016.7.17/9:40
            }
        }
        else if (1 == self.InfoType.selectedSegmentIndex){
            if(GLOBAL_NotificationCache.count == 0){
                return 1
            }
            else{
                return GLOBAL_NotificationCache.count
            }
        }
        else{
            return 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell? = UITableViewCell()
        if(self.whichKindOfInfoType == 0){
            if(self.isThereAnythingNew == false){
                cell = self.tableView!.dequeueReusableCellWithIdentifier("EmptyMailBoxCell")!
                let emptyIcon = cell?.viewWithTag(1001) as! UIImageView
                let emptySign = cell?.viewWithTag(1002) as! UILabel
                emptyIcon.image = UIImage(named: "Empty")
                emptySign.text = "暂时木有新消息，待会再来刷刷～～～～"
            }
            else{
                cell = self.tableView.dequeueReusableCellWithIdentifier("MailCell",forIndexPath: indexPath)
                let UnreadMessage = GLOBAL_UnreadMessage
                let preImage = cell?.viewWithTag(2001) as! UIImageView
                let preLabel = cell?.viewWithTag(2002) as! UILabel
                let timeLabel = cell?.viewWithTag(2003) as! UILabel
                let preview = UnreadMessage[indexPath.row]
                preImage.image = UIImage(named: preview.preImage!)
                preLabel.text = preview.prelabel!
                timeLabel.text = timeStampToString(preview.timestamp!)
                //返回未读信息 2016.7.17/9:40
            }
        }
        else if(self.whichKindOfInfoType == 1){
            if(GLOBAL_NotificationCache.count == 0){
                cell = self.tableView!.dequeueReusableCellWithIdentifier("EmptyMailBoxCell")!
                let emptyIcon = cell?.viewWithTag(1001) as! UIImageView
                let emptySign = cell?.viewWithTag(1002) as! UILabel
                emptyIcon.image = UIImage(named: "Empty")
                emptySign.text = "暂时木有新消息，待会再来刷刷～～～～"
            }
            else {
                cell = self.tableView.dequeueReusableCellWithIdentifier("MailCell",forIndexPath: indexPath)
                let preImage = cell?.viewWithTag(2001) as! UIImageView
                let preLabel = cell?.viewWithTag(2002) as! UILabel
                let timeLabel = cell?.viewWithTag(2003) as! UILabel
                let preview = GLOBAL_NotificationCache[indexPath.row]
                preImage.image = UIImage(named: preview.preImage!)
                preLabel.text = preview.prelabel!
                timeLabel.text = timeStampToString(preview.timestamp!)
            }
        }
        return cell!
    }
    
//单元格被选中后的效果，排除信箱空的情况 2016.7.17
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true) //点击后取消被选中状态 2016.7.17
        if(self.whichKindOfInfoType == 0){
            if(GLOBAL_UnreadMessage.count != 0){    //加这个判断，防止“暂时没有新信息”的单元格被点击 2016.7.17
                let tempElement = GLOBAL_UnreadMessage[indexPath.row]
                GLOBAL_UnreadMessage.removeAtIndex(indexPath.row)
                GLOBAL_NotificationCache.append(tempElement)
                if(GLOBAL_UnreadMessage.count == 0){
                    self.isThereAnythingNew = false
                }
                self.tableView.reloadData()
            }
        }
    }
    
//控制哪一些单元格可以向右滑动，排除信箱空的情况 2016.7.17
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        var deleteSwitch: Bool = false
        if(self.whichKindOfInfoType == 0){
            if(GLOBAL_UnreadMessage.count != 0){
                deleteSwitch = true
            }
        }
        else if(self.whichKindOfInfoType == 1){
            if(GLOBAL_NotificationCache.count != 0){
                deleteSwitch = true
            }
        }
        else {
            deleteSwitch = false
        }
        return deleteSwitch
    }
    
//向右滑动的编辑形式:删除 2016.7.17
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.Delete
    }
    
//向右滑动产生的结果 2016.7.17
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        if(self.whichKindOfInfoType == 0){
            let tempElement = GLOBAL_UnreadMessage[row]
            GLOBAL_NotificationCache.append(tempElement)
            GLOBAL_UnreadMessage.removeAtIndex(row)
            self.tableView.reloadData()
        }//标记为已读 2016.7.18
        else if(self.whichKindOfInfoType == 1){
            GLOBAL_NotificationCache.removeAtIndex(row)
            self.tableView.reloadData()
        }//删除信息 2016.7.18
        
    }

//设置向右滑动删除时显示的标签 2016.7.17
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?{
        var label:String?
        if(self.whichKindOfInfoType == 0){
            if(GLOBAL_UnreadMessage.count != 0){
                label = "标记已读"
            }
        }
        else if (self.whichKindOfInfoType == 1){
            label = "删除"
        }
        return label
    }
    
    //MARK: -UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        if self.InfoType.selectedSegmentIndex == 0{
            if buttonIndex == 0 {
                for(var i=0;i<GLOBAL_UnreadMessage.count;i+=1){
                    let tempElement = clearAllUnreadMessage(GLOBAL_UnreadMessage)
                    GLOBAL_NotificationCache.append(tempElement[i])// “所有信息“中有重复元素 待解决 2016.7.17
                }
                GLOBAL_UnreadMessage.removeAll()
                self.isThereAnythingNew = false
                self.tableView.reloadData()
            }
        }
        else if self.InfoType.selectedSegmentIndex == 1{
            if buttonIndex == 0{
                GLOBAL_NotificationCache.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
}
