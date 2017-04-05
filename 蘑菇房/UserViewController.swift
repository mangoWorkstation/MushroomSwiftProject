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
    
    @IBOutlet weak var UserInfoColumn: UIImageView!
    
    var staticItems_section_3 : [StaticItem] = [] //数组：用于存放静态状态图标
    var staticItems_section_2 : [StaticItem] = [] //数组：用于存放静态状态图标
    
    var notificationRawData:[NotificationPreview] = []
        
    override func viewDidLoad() {
        
        //读取缓存部分，现用读取固件内部预先设好的plist代替！！
        let path_ = Bundle.main.url(forResource: "notificationCache", withExtension: "plist")
        let data_ = try! Data(contentsOf: path_!)
        //解码器
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data_)
        self.notificationRawData = unarchiver.decodeObject(forKey: "notificationCache") as! [NotificationPreview]
        unarchiver.finishDecoding()

        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        staticItems_section_2 = [StaticItem(iconName:"我管理的基地128px",label:"我管理的基地"),StaticItem(iconName:"授权查看的基地128px",label:"授权查看的基地"),StaticItem(iconName:"附近的基地128px",label:"附近的基地"),StaticItem(iconName:"我的资料128px",label:"我的资料"),StaticItem(iconName:"消息128px",label:"消息与通知")]
        staticItems_section_3 = [StaticItem(iconName:"Setup",label:"设置"),StaticItem(iconName:"About",label: "关于")]
        //初始化静态固定图标
        //        self.tableView.showsVerticalScrollIndicator = true
        //        self.tableView.backgroundColor = UIColor(red: 142/255, green: 164/255, blue: 182/255, alpha: 1)
//        self.tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        
//        let background = UIImageView(image: UIImage(named: "Background_1"))
//        self.tableView.backgroundView = background
        self.tableView.sectionHeaderHeight = 0
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        drawUserColumn()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.reloadData()
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            let icon = self.UserInfoColumn.viewWithTag(1000) as? UIButton
            let nameLabel = self.UserInfoColumn.viewWithTag(1001) as? UILabel
            if (icon != nil || nameLabel != nil){
                icon?.removeFromSuperview()
                nameLabel?.removeFromSuperview()
            }
            self.drawUserColumn()
            
            let indexPath = self.tableView.indexPathForSelectedRow
            if indexPath != nil{
                self.tableView.deselectRow(at: indexPath!, animated: true)
            }

        }
        
    }
    
    private func drawUserColumn(){
        
        let bac = UIImage(contentsOfFile: NSHomeDirectory() + GLOBAL_UserProfile.facePath!)
        let bacImage = bac?.applyBlur(withRadius: 10, tintColor: UIColor(white: 0.3, alpha: 0.3), saturationDeltaFactor: 1.8)
        self.UserInfoColumn.image = bacImage
        
        let icon = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        icon.center.x = self.UserInfoColumn.center.x
        icon.center.y = self.UserInfoColumn.center.y + 30
        icon.setImage(UIImage(contentsOfFile: NSHomeDirectory() + GLOBAL_UserProfile.facePath!), for: .normal)
        icon.layer.cornerRadius = 40
        icon.layer.masksToBounds = true
        icon.layer.borderWidth = 3
        icon.layer.borderColor = UIColor.white.cgColor
        icon.clipsToBounds = true     //制作圆形的头像
        icon.tag = 1000
        self.UserInfoColumn.addSubview(icon)
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        nameLabel.center.x = icon.center.x
        nameLabel.center.y = icon.center.y + 70
        nameLabel.textColor = UIColor.white
        nameLabel.text = GLOBAL_UserProfile.nickName!
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: GLOBAL_appFont!, size: 25)
        nameLabel.tag = 1001
        self.UserInfoColumn.addSubview(nameLabel)
        
        
    }
    
    //MARK: - UITableViewDataSource
    //设置每一行的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if (indexPath as NSIndexPath).section == 0{
        //            return 300
        //        }
        if((indexPath as NSIndexPath).section == 0){//滚动信息栏 2016.7.5
            let cell = self.tableView!.dequeueReusableCell(withIdentifier: "Notification")! as UITableViewCell
            let notification = cell.viewWithTag(202) as! UILabel
            if(notification.text!.characters.count < 27){    //自适应表格宽度 2016.7.6
                return 50
            }
            else {
                return 30
            }
            
        }
        else if((indexPath as NSIndexPath).section == 1){//选项栏1 2016.7.12
            return 50
        }
        else if((indexPath as NSIndexPath).section == 2){//选项栏2 2016.7.12
            return 50
        }
            
        else {
            return 120
        }
    }
    
    //设置每个部分分别有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section{
        case 0:return 1
        case 1:return staticItems_section_2.count
        case 2:return staticItems_section_3.count
        default:
            return 1
        }
    }
    
    //设置部分（section）的数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //绑定数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = UITableViewCell()
        
        if ((indexPath as NSIndexPath).section == 0){
            
            cell = self.tableView!.dequeueReusableCell(withIdentifier: "Notification")!
            let sign = cell!.viewWithTag(201) as! UIImageView
            let notification = cell!.viewWithTag(202) as! UILabel
            sign.image = UIImage(named: "Alert")
            if !self.notificationRawData.isEmpty{
                let currrentMeg = self.notificationRawData.last!
                let time = timeStampToSpecificTime(currrentMeg.timestamp!)
                notification.text = "\(time)  "+"\(currrentMeg.prelabel!)"
            }
            else{
                notification.text = "暂无新消息"
            }
            
            notification.font = UIFont(name: GLOBAL_appFont!, size: 12.0)
            notification.textColor = UIColor.black
            
        }
        else if((indexPath as NSIndexPath).section == 1){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "Inform",for: indexPath)
            let icon = cell?.viewWithTag(3001) as! UIImageView
            let label = cell?.viewWithTag(3002) as! UILabel
            let _staticItem = staticItems_section_2[(indexPath as NSIndexPath).row] as StaticItem
            icon.image = UIImage(named: _staticItem.iconName)
            label.text = _staticItem.label
            label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            label.textColor = UIColor.black
        }
        else if ((indexPath as NSIndexPath).section == 2){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "General",for: indexPath)
            let Icon = cell!.contentView.viewWithTag(3001) as! UIImageView
            let Title = cell!.contentView.viewWithTag(3002) as! UILabel
            let _staticItem = staticItems_section_3[(indexPath as NSIndexPath).row] as StaticItem
            Icon.image = UIImage(named: _staticItem.iconName)
            Icon.contentMode = .scaleToFill
            Title.text = _staticItem.label
            Title.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            Title.textColor = UIColor.black
            
        }
        cell!.layer.masksToBounds = true
        cell?.layer.cornerRadius = 10
        cell?.clipsToBounds = true
        
        return cell!
    }
    
    //设置表格部分（section）的间距 2016.7.15/9:17
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if(0 == section){
            return 0
        }
        else if(1 == section){
            return 2
        }
        else if(2 == section){
            return 5
        }
            //        else if 3 == section{
            //            return 5
            //        }
        else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 30
        }
        else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 0{
            if !self.notificationRawData.isEmpty{
                performSegue(withIdentifier: "showLatestNotificationSegue", sender: nil)
            }
            else{
                let frame = CGRect(x: 0, y: 0, width: 200, height: 100)
                let alertView = MGNotificationView(frame: frame , labelText: "暂时没有新消息哟", textColor: UIColor.black, duration: 3, doneImage: nil, backgroundColor:.white)
                alertView.stroke(in: self.view)
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        if((indexPath as NSIndexPath).section == 1){
            if indexPath.row == 0 || indexPath.row == 1{
                performSegue(withIdentifier: "MyBasesSegue", sender: nil)
            }
            if (indexPath as NSIndexPath).row == 2 {
                performSegue(withIdentifier: "NearbySegue", sender: nil)
            }
            if((indexPath as NSIndexPath).row == 3){
                performSegue(withIdentifier: "EditProfilesSegue", sender: nil)
            }
            if((indexPath as NSIndexPath).row == 4){
                performSegue(withIdentifier: "NotificationSegue", sender: nil)
            }
        }
    }
    
    //MARK - UIStoryBoardSegue
    //segue 跳转页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showLatestNotificationSegue"{
            let vc = segue.destination as! NewMessageWebViewController
            vc.navigationItem.backBarButtonItem?.title = "我"
            vc.navigationItem.title = "新消息"
            vc.hidesBottomBarWhenPushed = true
        }
        
        if segue.identifier == "MyBasesSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow
            let vc = segue.destination as! MyBasesTableViewController
            vc.hidesBottomBarWhenPushed = true
            if indexPath?.row == 0{
                vc.title = "我管理的基地"
            }
            else{
                vc.title = "授权查看的基地"
            }
        }
        
        if segue.identifier == "NearbySegue"{
            let vc = segue.destination as! NearbyViewController
            vc.navigationItem.backBarButtonItem?.title = "我"
            vc.navigationItem.title = "附近的基地"
        }
        if(segue.identifier == "SetupSegue"){
            let indexPath = self.tableView.indexPathForSelectedRow
            let vc = segue.destination as! GeneralDetailController
            let row = (indexPath! as NSIndexPath).row
            var title = ""
            switch row {
            case 0:
                title = "设置"
            case 1:
                title = "关于蘑菇房"
            default:
                break
            }
            vc.navigationController?.view.backgroundColor = UIColor.white
            vc.navigationItem.backBarButtonItem?.title = "我"
            vc.navigationItem.title = title
            vc.selectedRow = row
        }
        if(segue.identifier == "NotificationSegue"){
            let vc = segue.destination as! NotificationViewController
            vc.navigationItem.backBarButtonItem?.title = "我"
            vc.navigationItem.title = ""
        }
        if(segue.identifier == "EditProfilesSegue"){
            let vc = segue.destination as! EditProfilesViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "个人资料"
        }
    }
    
}

func isDarkRGB(color:UIColor)->Bool{
    let components = color.cgColor.components
    let red = Double((components?[0])!)
    let green = Double((components?[1])!)
    let blue = Double((components?[2])!)
    let grayLevel = Int(red * 256 * 0.299 + green * 255 * 0.587 + blue * 255 * 0.114)
    print("grayLevel","\(grayLevel)")
    if grayLevel >= 192{
        return false
    }
    else{
        return true
    }
}
