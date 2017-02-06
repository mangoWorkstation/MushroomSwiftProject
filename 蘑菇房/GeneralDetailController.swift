//
//  GeneralDetailController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/14.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class GeneralDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate {
    
    var selectedRow : Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func close(_ segue:UIStoryboardSegue){
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
    
    //MARK: - Cache Management
    func fileSizeOfCache()-> Double {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        //缓存目录路径
        let cachePath_1 = cachePath! + "/Weather/today"
        let cachePath_2 = cachePath! + "/Weather/forecast"
        let cachePath_3 = cachePath! + "/com.onevcat.Kingfisher.ImageCache.default"
        print(cachePath!)
        
        // 取出文件夹下所有文件数组
        var fileArr = FileManager.default.subpaths(atPath: cachePath_1)
        
        
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath_1.appending("/"+file)
            // 取出文件属性
            let folder = try! FileManager.default.attributesOfItem(atPath: path)
            let fs = folder[FileAttributeKey.size] as! Int
            print(fs)
            size += fs
        }
        print(size)
        
        fileArr = FileManager.default.subpaths(atPath: cachePath_2)
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath_2.appending("/"+file)
            // 取出文件属性
            let folder = try! FileManager.default.attributesOfItem(atPath: path)
            let fs = folder[FileAttributeKey.size] as! Int
            print(fs)
            size += fs
        }
        
        fileArr = FileManager.default.subpaths(atPath: cachePath_3)
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath_3.appending("/"+file)
            // 取出文件属性
            let folder = try! FileManager.default.attributesOfItem(atPath: path)
            let fs = folder[FileAttributeKey.size] as! Int
            print(fs)
            size += fs
        }

        
        let mm = Double(size) / 1024
        
        return mm
        //KB
    }
    
    func clearCache() {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        let cachePath_1 = cachePath! + "/Weather/today"
        let cachePath_2 = cachePath! + "/Weather/forecast"

        // 取出文件夹下所有文件数组
        var fileArr = FileManager.default.subpaths(atPath: cachePath_1)
        
        // 遍历删除
        for file in fileArr! {
            
            let path = cachePath_1.appending("/"+file)
            if FileManager.default.fileExists(atPath: path) {
                
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
        }
        
        fileArr = FileManager.default.subpaths(atPath: cachePath_2)
        for file in fileArr! {
            
            let path = cachePath_2.appending("/"+file)
            if FileManager.default.fileExists(atPath: path) {
                
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
        }

        
        print(FileManager.default.subpaths(atPath: cachePath!)!)
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let section = (indexPath as NSIndexPath).section
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        let section = (indexPath as NSIndexPath).section
        
        //点击“设置”
        if(0 == self.selectedRow){
            if(0 == section){
                cell = self.tableView.dequeueReusableCell(withIdentifier: "GeneralCell",for: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                label.text = "账号与安全"
                label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            }
            else if (1 == section){
                cell = self.tableView.dequeueReusableCell(withIdentifier: "GeneralCell",for: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                let labelGroup = ["新消息通知","帮助与反馈"]
                label.text = labelGroup[(indexPath as NSIndexPath).row]
                label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
                
            }
            else if(2 == section){
                cell = self.tableView.dequeueReusableCell(withIdentifier: "CacheCell")!
                let label = cell.viewWithTag(2001) as! UILabel
                let label_1 = cell.viewWithTag(2002) as! UILabel
                let cacheFile = self.fileSizeOfCache()
                label.text = "清除缓存"
                if cacheFile>1024{
                    label_1.text = String(Int(cacheFile/1024))+"MB"
                }
                else{
                    label_1.text = String(Int(cacheFile))+"KB"
                }
                label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
                label_1.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
                
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            else if(3 == section){
                cell = self.tableView.dequeueReusableCell(withIdentifier: "GeneralCell",for: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                label.text = "退出登录"
                label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
                label.textAlignment = NSTextAlignment.center
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        
        //点击“关于”
        if(1 == self.selectedRow){
            if(0 == section){
                cell = self.tableView.dequeueReusableCell(withIdentifier: "GeneralCell",for: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                let labels = ["关于我们","给蘑菇房来个好评吧😊","联系我们"]
                label.text = labels[(indexPath as NSIndexPath).row]
                label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            else{
                cell = self.tableView.dequeueReusableCell(withIdentifier: "AboutAppCell")!
                let appIcon = cell.viewWithTag(2001) as! UIImageView
                let version = cell.viewWithTag(2002) as! UILabel
                let appName = cell.viewWithTag(2003) as! UILabel
                let copyRight = cell.viewWithTag(2004) as! UILabel
                appIcon.image = UIImage(named: "icon")
                appIcon.contentMode = .scaleToFill
                appIcon.clipsToBounds = true
                appIcon.layer.masksToBounds = true
                appIcon.layer.cornerRadius = 10
                version.text = "当前版本：1.0.1 Alpha"
                version.font = UIFont(name: GLOBAL_appFont!, size: 12.0)
                appName.text = "蘑菇房"
                appName.font = UIFont(name: GLOBAL_appFont!, size: 24.0)
                copyRight.text = "Copyright © 2016 MushRoom Workstation \n All Rights Reserved \n 广西大学 蘑菇房工作室 出品"
                copyRight.font = UIFont(name: GLOBAL_appFont!, size: 12.0)
                
                copyRight.lineBreakMode = NSLineBreakMode.byWordWrapping
                copyRight.numberOfLines = 0
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
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
                return 3
            default:
                return 1
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){//点击后取消被选中状态 2016.7.17
        if(self.selectedRow == 0){
            if((indexPath as NSIndexPath).section == 0){
                if((indexPath as NSIndexPath).row == 0){
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    performSegue(withIdentifier: "AccountSegue", sender: nil)
                }
            }
            if((indexPath as NSIndexPath).section == 1){
                if((indexPath as NSIndexPath).row == 0){
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    performSegue(withIdentifier: "NewMessageInformSegue", sender: nil)
                }
                if((indexPath as NSIndexPath).row == 1){
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    performSegue(withIdentifier: "FeedBackSegue", sender: nil)
                }
            }
            
        }
        if(self.selectedRow == 1){
            if((indexPath as NSIndexPath).section == 0){
                if((indexPath as NSIndexPath).row == 0){
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    performSegue(withIdentifier: "AboutUsSegue",sender: nil)
                }
                if indexPath.row == 1{
                    let url = NSURL(string: "http://www.apple.com/cn/")
                    let vc = SFSafariViewController(url: url as! URL, entersReaderIfAvailable: true)
                    present(vc, animated: true, completion: nil)
                }
                if indexPath.row == 2{
                    if MFMailComposeViewController.canSendMail(){
                        let controller = MFMailComposeViewController()
                        controller.navigationItem.backBarButtonItem?.title = "返回"
                        //设置代理
                        controller.mailComposeDelegate = self
                        //设置主题
                        controller.setSubject("用户\(GLOBAL_UserProfile.nickName!)的意见反馈")
                        //设置收件人
                        controller.setToRecipients(["ryanhowe@qq.com"])
                        //设置抄送人
                        //                        controller.setCcRecipients(["b1@hangge.com","b2@hangge.com"])
                        //                        //设置密送人
                        //                        controller.setBccRecipients(["c1@hangge.com","c2@hangge.com"])
                        
                        //添加图片附件
                        //                        let path = NSBundle.mainBundle().pathForResource("hangge.png", ofType: "")
                        //                        let myData = NSData(contentsOfFile: path!)
                        //                        controller.addAttachmentData(myData!, mimeType: "image/png", fileName: "swift.png")
                        
                        //设置邮件正文内容（支持html）
                        controller.setMessageBody("我遇到了这样的问题：\n\n", isHTML: false)
                        
                        //打开界面
                        self.present(controller, animated: true, completion: nil)
                    }else{
                        print("本设备不能发送邮件")
                    }
                }
            }
        }
        if((indexPath as NSIndexPath).section == 2){
            let cell = self.tableView.cellForRow(at: indexPath)
            let detail = cell?.viewWithTag(2002) as! UILabel
            if detail.text != "0KB"{
                let sheet = UIAlertController(title: "将要清除所有缓存", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "确定", style: .destructive, handler: {
                    (action)-> Void in
                    let cell = self.tableView.cellForRow(at: indexPath)
                    let detail = cell?.viewWithTag(2002) as! UILabel
                    self.clearCache()
                    KingfisherManager.shared.cache.clearDiskCache()
                    let cacheFile = self.fileSizeOfCache()
                    detail.text = String(Int(cacheFile))+"KB"
                    let frame = CGRect(x: 0, y: 0, width: 200, height: 100)
                    let doneImage = UIImage(named: "tick_outline_128px")
                    let alertView = MGNotificationView(frame: frame , labelText: "刷新成功", textColor: UIColor.white, duration: 2, doneImage: doneImage, backgroundColor:UIColor.lightGray)
                    alertView.stroke(in: self.view)
                }))
                sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {
                    (action)-> Void in
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }))
                present(sheet, animated: true, completion: nil)
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            else{
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        if self.selectedRow == 0{
            if indexPath.section == 3 {
                let sheet = UIAlertController(title: "将要注销当前账户", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "确定", style: .destructive, handler: {
                    (action)-> Void in
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    self.dismiss(animated: true, completion:nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                    vc.hidesBottomBarWhenPushed = false
                    let vcNav = UINavigationController(rootViewController: vc)
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.window?.rootViewController = vcNav
                    appDel.window?.makeKeyAndVisible()
                    let userDefaultInfo = UserDefaults()
                    userDefaultInfo.removeObject(forKey: "UserInfoModel")
                    userDefaultInfo.removeObject(forKey: "loginID")
                    userDefaultInfo.synchronize()
                    //                    try?FileManager.default.removeItem(atPath: NSHomeDirectory() + "/Documents/UserCache/")
                    //                    try?FileManager.default.removeItem(atPath: NSHomeDirectory() + "/Documents/UserCache/\(GLOBAL_UserProfile.id!).jpg")
                    //临时性的解决方案,暂不删除图像
                    self.dismiss(animated: true, completion: nil)
                }))
                sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {
                    (action)-> Void in
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }))
                
                present(sheet, animated: true, completion: {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            }
        }
        else{
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK: - UIStoryBoardSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AboutUsSegue"){
            let vc = segue.destination as! AboutUsViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "关于我们"
        }
        
        if(segue.identifier == "NewMessageInformSegue"){
            let vc = segue.destination as! NewMessageInformViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "消息与通知"
        }
        
        if(segue.identifier == "FeedBackSegue"){
            let vc = segue.destination as! FeedBackViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "您的建议"
        }
        
        if(segue.identifier == "AccountSegue"){
            let vc = segue.destination as! AccountViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "账号与安全"
        }
        
    }
    
    //MARK : -MFMailComposeControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result{
        case MFMailComposeResult.sent:
            print("邮件已发送")
        case MFMailComposeResult.cancelled:
            print("邮件已取消")
        case MFMailComposeResult.saved:
            print("邮件已保存")
        case MFMailComposeResult.failed:
            print("邮件发送失败")
        default:
            break
        }
    }
    
    //MARK : - SFSafariControllerDelegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
