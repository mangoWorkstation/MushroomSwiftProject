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
                label.text = "清除缓存"
                label_1.text = "1.23 MB"  //显示缓存大小 2016.7.15/7:08
                label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
                label_1.font = UIFont(name: GLOBAL_appFont!, size: 16.0)

                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            else if(3 == section){
                cell = self.tableView.dequeueReusableCell(withIdentifier: "GeneralCell",for: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                label.text = "退出登录"
                label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
                label.textAlignment = NSTextAlignment.center      //居中 2016.7.15／1:13a.m
                label.textColor = UIColor.red
                cell.accessoryType = UITableViewCellAccessoryType.none   //无箭头指示器ii
            }
        }
        
        //点击“关于”
        if(1 == self.selectedRow){
            if(0 == section){
                cell = self.tableView.dequeueReusableCell(withIdentifier: "GeneralCell",for: indexPath)
                let label = cell.viewWithTag(1001) as! UILabel
                let labels = ["关于我们","给蘑菇房来个好评吧😊"]
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
                return 2
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
            }
        }
        if((indexPath as NSIndexPath).section == 2){
            let cell = self.tableView.cellForRow(at: indexPath)
            let detail = cell?.viewWithTag(2002) as! UILabel
            if detail.text != "0.00MB"{
//                let sheet = UIActionSheet(title: "将要清除所有缓存", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")
//                sheet.show(in: self.view)
                let sheet = UIAlertController(title: "将要清除所有缓存", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "确定", style: .destructive, handler: {
                    (action)-> Void in
                    let cell = self.tableView.cellForRow(at: indexPath)
                    let detail = cell?.viewWithTag(2002) as! UILabel
                    detail.text = "0.00MB"
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
    
}
