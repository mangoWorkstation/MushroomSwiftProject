//
//  NotificationViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import AudioToolbox

class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate{

    @IBOutlet weak var InfoType: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var rawData: [NotificationPreview] = []
    
    var unreadMeg:[NotificationPreview] = []
    
//    var isPlaying = false
    
    @IBAction func SegmentOnChanged(_ sender: AnyObject) {
        self.whichKindOfInfoType = InfoType.selectedSegmentIndex
        self.tableView.reloadData() //重要！！刷新表格数据！！ 2016.7.16/10:58
                                    //triggered when user click on different segments
    }
    
    @IBAction func TrashAllMessage(_ sender: UIBarButtonItem) {
        var sheet = UIAlertController()
        if(InfoType.selectedSegmentIndex == 0){
            if !unreadMeg.isEmpty {
                sheet = UIAlertController(title: "将要把所有未读消息标记为已读？", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "确定", style: .default, handler: {
                    (action)->Void in
                    if self.InfoType.selectedSegmentIndex == 0{
                        for i in 0 ..< self.unreadMeg.count {
                            let tempElement = clearAllUnreadMessage(self.unreadMeg)
                            self.rawData.append(tempElement[i])// “所有信息“中有重复元素 待解决 2016.7.17
                        }
                        self.unreadMeg.removeAll()
                        self.isThereAnythingNew = false
                        self.tableView.reloadData()
                        
                    }
                }))
                sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                present(sheet, animated: true, completion: nil)
            }
            else {
                sheet = UIAlertController(title: "已读消息都被清空啦", message: nil, preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "我知道啦😊", style: .cancel, handler: nil))
                present(sheet, animated: true, completion: nil)
            }
        }
        else if(InfoType.selectedSegmentIndex == 1){
            if !self.rawData.isEmpty {
                sheet = UIAlertController(title: "将要清空所有消息？", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "确定", style: .default, handler: {
                    (action)->Void in
                    self.rawData.removeAll()
                    self.tableView.reloadData()
                }))
                sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                present(sheet, animated: true, completion: nil)
            }
            else {
                sheet = UIAlertController(title: "所有消息都被清空啦", message: nil, preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "我知道啦😊", style: .cancel, handler: nil))
                present(sheet, animated: true, completion: nil)
            }
        }

    }
    var whichKindOfInfoType = 0 //should be initialized! 2016.7.16/11:42
    
    var isThereAnythingNew : Bool = true   //identify if unread messages exist 2016.7.16/11:41 // Need to be updated later
    

    override func viewDidLoad() {
        
        //读取缓存部分，现用读取固件内部预先设好的plist代替！！
        let path_ = Bundle.main.url(forResource: "notificationCache", withExtension: "plist")
        let data_ = try! Data(contentsOf: path_!)
        //解码器
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data_)
        self.rawData = unarchiver.decodeObject(forKey: "notificationCache") as! [NotificationPreview]
        unarchiver.finishDecoding()
        
        self.unreadMeg = unreadMessageFilter(self.rawData)

        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //测试数据
        if(unreadMeg.count == 0){
            self.isThereAnythingNew = false
        }
        InfoType.setTitleTextAttributes([NSFontAttributeName: UIFont(name: GLOBAL_appFont!, size: 12.0)!
], for: UIControlState())
        
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(0 == self.InfoType.selectedSegmentIndex){
            if(self.isThereAnythingNew == false){
                return 420
            }
            else {
                return 120
            }
        }
        else if(1 == self.InfoType.selectedSegmentIndex){
            if(self.rawData.count == 0){
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if(0 == self.InfoType.selectedSegmentIndex){
            return 0
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(0 == self.InfoType.selectedSegmentIndex){
            if(self.isThereAnythingNew == false){
                return 1
            }
            else {
//                let UnreadMessage = unreadMessageFilter(self.notificationCache)
                return unreadMeg.count //返回未读信息数 2016.7.17/9:40
            }
        }
        else if (1 == self.InfoType.selectedSegmentIndex){
            if(self.rawData.count == 0){
                return 1
            }
            else{
                return self.rawData.count
            }
        }
        else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell:UITableViewCell? = UITableViewCell()
        if(self.whichKindOfInfoType == 0){
            if(self.isThereAnythingNew == false){
                cell = self.tableView!.dequeueReusableCell(withIdentifier: "EmptyMailBoxCell")!
                let emptyIcon = cell?.viewWithTag(1001) as! UIImageView
                let emptySign = cell?.viewWithTag(1002) as! UILabel
                emptyIcon.image = UIImage(named: "Empty")
                emptySign.text = "暂时木有新消息，待会再来刷刷～～～～"
                emptySign.font  = UIFont(name: GLOBAL_appFont!, size: 18.0)
            }
            else{
                cell = self.tableView.dequeueReusableCell(withIdentifier: "MailCell",for: indexPath)
                let UnreadMessage = unreadMeg
                let preImage = cell?.viewWithTag(2001) as! UIImageView
                let preLabel = cell?.viewWithTag(2002) as! UILabel
                let timeLabel = cell?.viewWithTag(2003) as! UILabel
                let preview = UnreadMessage[(indexPath as NSIndexPath).row]
                preImage.image = UIImage(named: preview.preImage!)
                preLabel.text = preview.prelabel!
                preLabel.font = UIFont(name: GLOBAL_appFont!, size: 13.0)
                timeLabel.text = timeStampToSpecificTime(preview.timestamp!)
                timeLabel.font = UIFont(name: GLOBAL_appFont!, size: 12.0)

                //返回未读信息 2016.7.17/9:40
            }
        }
        else if(self.whichKindOfInfoType == 1){
            if(self.rawData.count == 0){
                cell = self.tableView!.dequeueReusableCell(withIdentifier: "EmptyMailBoxCell")!
                let emptyIcon = cell?.viewWithTag(1001) as! UIImageView
                let emptySign = cell?.viewWithTag(1002) as! UILabel
                emptyIcon.image = UIImage(named: "Empty")
                emptySign.text = "暂时木有新消息，待会再来刷刷～～～～"
            }
            else {
                cell = self.tableView.dequeueReusableCell(withIdentifier: "MailCell",for: indexPath)
                let preImage = cell?.viewWithTag(2001) as! UIImageView
                let preLabel = cell?.viewWithTag(2002) as! UILabel
                let timeLabel = cell?.viewWithTag(2003) as! UILabel
                let preview = self.rawData[(indexPath as NSIndexPath).row]
                preImage.image = UIImage(named: preview.preImage!)
                preLabel.text = preview.prelabel!
                timeLabel.text = timeStampToSpecificTime(preview.timestamp!)
            }
        }
        return cell!
    }
    
//单元格被选中后的效果，排除信箱空的情况 2016.7.17
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true) //点击后取消被选中状态 2016.7.17
        if(self.whichKindOfInfoType == 0){
            if(unreadMeg.count != 0){    //加这个判断，防止“暂时没有新信息”的单元格被点击 2016.7.17
                let tempElement = unreadMeg[(indexPath as NSIndexPath).row]
                unreadMeg.remove(at: (indexPath as NSIndexPath).row)
                self.rawData.append(tempElement)
                if(unreadMeg.count == 0){
                    self.isThereAnythingNew = false
                }
                self.tableView.reloadData()
            }
        }
    }
    
//控制哪一些单元格可以向右滑动，排除信箱空的情况 2016.7.17
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        var deleteSwitch: Bool = false
        if(self.whichKindOfInfoType == 0){
            if(unreadMeg.count != 0){
                deleteSwitch = true
            }
        }
        else if(self.whichKindOfInfoType == 1){
            if(self.rawData.count != 0){
                deleteSwitch = true
            }
        }
        else {
            deleteSwitch = false
        }
        return deleteSwitch
    }
    
//向右滑动的编辑形式:删除 2016.7.17
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.delete
    }
    
//向右滑动产生的结果 2016.7.17
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        let row = (indexPath as NSIndexPath).row
        if(self.whichKindOfInfoType == 0){
            let tempElement = unreadMeg[row]
            self.rawData.append(tempElement)
            unreadMeg.remove(at: row)
            self.tableView.reloadData()
        }//标记为已读 2016.7.18
        else if(self.whichKindOfInfoType == 1){
            self.rawData.remove(at: row)
            self.tableView.reloadData()
        }//删除信息 2016.7.18
        
    }

//设置向右滑动删除时显示的标签 2016.7.17
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        var label:String?
        if(self.whichKindOfInfoType == 0){
            if(unreadMeg.count != 0){
                label = "标记已读"
            }
        }
        else if (self.whichKindOfInfoType == 1){
            label = "删除"
        }
        return label
    }
    
}

