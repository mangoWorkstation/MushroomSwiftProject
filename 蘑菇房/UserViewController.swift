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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        configUserInfo()
        
        staticItems_section_2 = [StaticItem(iconName:"MyHouse",label:"我家的蘑菇房"),StaticItem(iconName:"MyFollow",label:"我关注的蘑菇房"),StaticItem(iconName:"Nearby",label:"附近的基地"),StaticItem(iconName:"MyProfiles",label:"我的资料"),StaticItem(iconName:"Inform",label:"消息与通知")]
        staticItems_section_3 = [StaticItem(iconName:"Setup",label:"设置"),StaticItem(iconName:"About",label: "关于")]
        //初始化静态固定图标
//        self.tableView.showsVerticalScrollIndicator = true
//        self.tableView.backgroundColor = UIColor(red: 142/255, green: 164/255, blue: 182/255, alpha: 1)
        self.tableView.separatorColor = UIColor(white: 0.9, alpha: 1)
        
        let background = UIImageView(image: UIImage(named: "Background_1"))
        self.tableView.backgroundView = background
        self.tableView.sectionHeaderHeight = 0
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)


        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.reloadData()
        
    }
    
    
    private func configUserInfo(){
//        UserInfoColumn.image = UIImage(named: "Background")
//        UserInfoColumn.contentMode = .scaleAspectFill
//        print(UserInfoColumn.center.x)
//        print(UserInfoColumn.center.y)
//        
//        print(UserInfoColumn.frame.width)
//        print(UserInfoColumn.frame.height)
//        let face = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        face.image = UIImage(named: GLOBAL_UserProfile.face!)
//        face.layer.masksToBounds = true
//        face.layer.borderWidth = 3
//        face.layer.borderColor = UIColor.white.cgColor
//        face.layer.cornerRadius = 25
//        face.clipsToBounds = true
//        UserInfoColumn.addSubview(face)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    //设置每一行的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0{
            return 300
        }
        if((indexPath as NSIndexPath).section == 1){//滚动信息栏 2016.7.5
            let cell = self.tableView!.dequeueReusableCell(withIdentifier: "Notification")! as UITableViewCell
            let notification = cell.viewWithTag(202) as! UILabel
            if(notification.text!.characters.count < 27){    //自适应表格宽度 2016.7.6
                return 50
            }
            else {
                return 30
            }
        
        }
        else if((indexPath as NSIndexPath).section == 2){//选项栏1 2016.7.12
            return 50
        }
        else if((indexPath as NSIndexPath).section == 3){//选项栏2 2016.7.12
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
        case 1:return 1
        case 2:return staticItems_section_2.count
        case 3:return staticItems_section_3.count
        default:
            return 1
        }
    }
    
    //设置部分（section）的数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //绑定数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = UITableViewCell()
        
        if ((indexPath as NSIndexPath).section == 0){
            cell = self.tableView!.dequeueReusableCell(withIdentifier: "UserInfo")!
            let icon = cell!.viewWithTag(1011) as! UIImageView
            let nameLabel = cell!.viewWithTag(1012) as! UILabel
            let background = cell!.viewWithTag(102) as! UIImageView
            icon.image = UIImage(data: GLOBAL_UserProfile.face)
//            icon.bounds = CGRectMake((icon.bounds.size.width-60)/2, (icon.bounds.size.height-60)/2-150, 60, 60)
//            icon.frame = CGRectMake((icon.bounds.size.width - 60)/2, (icon.bounds.size.height-60)/2-150, 60,60)
            icon.layer.cornerRadius = 25
            //注意:cornerRadius必须是storyBoard中，宽度的1/2;
            //在storyBoard中设置imageView时，高度必须是宽度的1/4才能磨成圆形
            //2016.7.27
            icon.layer.masksToBounds = true
            icon.layer.borderWidth = 3
            icon.layer.borderColor = UIColor.white.cgColor
            icon.clipsToBounds = true     //制作圆形的头像
            nameLabel.text = GLOBAL_UserProfile.nickName
            nameLabel.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            nameLabel.textColor = UIColor.white
            
            //黑科技，将头像高斯模糊化，作为背景 2016.10.17
            let ciImage = CIImage(image: UIImage(data: GLOBAL_UserProfile.face)!)
            let filterMirror = CIFilter(name: "CIGaussianBlur")
            filterMirror?.setValue(ciImage, forKey: kCIInputImageKey)
            let filterImage = filterMirror?.value(forKey: kCIOutputImageKey)
            let context = CIContext(options: nil)
            let cgImage = context.createCGImage(filterImage as! CIImage, from: (cell?.frame)!)
            background.image = UIImage(cgImage: cgImage!)
            
        }
        if ((indexPath as NSIndexPath).section == 1){
            
            cell = self.tableView!.dequeueReusableCell(withIdentifier: "Notification")!
            let sign = cell!.viewWithTag(201) as! UIImageView
            let notification = cell!.viewWithTag(202) as! UILabel
            sign.image = UIImage(named: "Alert")
            notification.text = "2016-7-6 南宁市气象局发布暴雨红色预警，请注意强对流天气"
            notification.font = UIFont(name: GLOBAL_appFont!, size: 12.0)
            notification.textColor = UIColor.black

            
        }
        else if((indexPath as NSIndexPath).section == 2){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "Inform",for: indexPath)
            let icon = cell?.viewWithTag(3001) as! UIImageView
            let label = cell?.viewWithTag(3002) as! UILabel
            let _staticItem = staticItems_section_2[(indexPath as NSIndexPath).row] as StaticItem
            icon.image = UIImage(named: _staticItem.iconName)
            label.text = _staticItem.label
            label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            label.textColor = UIColor.black
        }
        else if ((indexPath as NSIndexPath).section == 3){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "General",for: indexPath)
            let Icon = cell!.contentView.viewWithTag(3001) as! UIImageView
            let Title = cell!.contentView.viewWithTag(3002) as! UILabel
            let _staticItem = staticItems_section_3[(indexPath as NSIndexPath).row] as StaticItem
            Icon.image = UIImage(named: _staticItem.iconName)
            Title.text = _staticItem.label
            Title.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            Title.textColor = UIColor.black

        }
        if (indexPath as NSIndexPath).section != 0 {
            cell!.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
            cell!.layer.masksToBounds = true
            cell?.layer.cornerRadius = 10
            cell?.clipsToBounds = true
        }
        
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
        else if 3 == section{
            return 5
        }
        else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true) //点击后取消被选中状态 2016.7.17
        if((indexPath as NSIndexPath).section == 2){
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
