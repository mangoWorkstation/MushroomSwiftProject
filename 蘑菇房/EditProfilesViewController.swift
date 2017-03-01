//
//  EditProfilesViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class EditProfilesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate{
    
    var isOnceLoaded : Bool? = true
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindSegueForEditOtherVC(_ unwindSegue :UIStoryboardSegue){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        if self.isOnceLoaded == true{
            super.viewWillAppear(animated)
            self.isOnceLoaded = false
        }
        else{
            //保存到用户配置
            syncUserProfilesToUserDefault()
            
            //保存到本地数据库，以后换成网络连接
            syncUserProfileToLocalSqliteDB()
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if((indexPath as NSIndexPath).row == 0){
            return 100
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if((indexPath as NSIndexPath).row == 0){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "UserIconCell",for: indexPath)
            let label = cell.viewWithTag(101) as! UILabel
            let icon = cell.viewWithTag(102) as! UIImageView
            label.text = "头像"
            label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            let facePath = GLOBAL_UserProfile.facePath
            icon.image = UIImage(contentsOfFile: NSHomeDirectory() + facePath!)
            icon.contentMode = .scaleToFill
            icon.clipsToBounds = true
            icon.layer.masksToBounds = true
            icon.layer.cornerRadius = 40
            icon.layer.borderColor = UIColor.lightGray.cgColor
            icon.layer.borderWidth = 3.0
        }
        if((indexPath as NSIndexPath).row > 0){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "GeneralCell",for: indexPath)
            let labels = ["昵称","用户ID","权限级别","性别","地区"]
            let label = cell.viewWithTag(201) as! UILabel
            let detail = cell.viewWithTag(202) as! UILabel
            label.text = labels[(indexPath as NSIndexPath).row - 1]
            label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            detail.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            switch label.text! {
            case "昵称":
                detail.text = GLOBAL_UserProfile.nickName
            case "用户ID":
                detail.text = "\(GLOBAL_UserProfile.id!)"
            case "权限级别":
                if GLOBAL_UserProfile.root == 1{
                    detail.text = "游客"
                }
                else{
                    detail.text = "农场主"
                }
            case "性别":
                if GLOBAL_UserProfile.sex == 0 {
                    detail.text = "女"
                }
                else{
                    detail.text = "男"
                }
            case "地区":
                if (GLOBAL_UserProfile.province == nil) || (GLOBAL_UserProfile.city == nil) {
                    detail.text = "点击设置省份城市"
                }
                else{
                    detail.text = GLOBAL_UserProfile.province! + " " + GLOBAL_UserProfile.city!
                }
            default:
                detail.text = ""
            }
            
            if (label.text == "用户ID"||label.text == "权限级别") {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true)
        if((indexPath as NSIndexPath).row == 0){
            performSegue(withIdentifier: "EditImageSegue", sender: nil)
        }
        if((indexPath as NSIndexPath).row == 1){
            performSegue(withIdentifier: "EditOtherSegue", sender: "昵称")
        }
        if((indexPath as NSIndexPath).row == 4){
            performSegue(withIdentifier: "EditOtherSegue", sender: "性别")
        }
        if(indexPath.row == 5){
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Page_3_User", bundle: nil)
//            let vc = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "UserDistrictPicker"))
            let vc = storyboard.instantiateViewController(withIdentifier: "UserDistrictPicker")
//            vc.navigationBar.tintColor = .white
            vc.navigationItem.backBarButtonItem?.title = "取消"
            vc.navigationItem.rightBarButtonItem?.title = "确定"
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            popover.delegate = self
            popover.barButtonItem = UINavigationItem.init().backBarButtonItem
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: 0, y: 0, width: 300, height: 200)
            present(vc, animated: true, completion:nil)
        }
    }
    
    //MARK: - UIPopoverPresentationCotrollerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.popover
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(EditProfilesViewController.dismissPopo))
        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismissPopo() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "EditImageSegue"){
            let vc = segue.destination as! FaceShowViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "头像"
        }
        
        if(segue.identifier == "EditOtherSegue"){
            let vc = segue.destination as! EditOtherViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.rightBarButtonItem?.title = "保存"
            let rowName = sender as! String
            vc.selectedRow = rowName
            vc.navigationItem.title = rowName
        }
        
    }
    
    
}



func syncUserProfilesToUserDefault(){
    //同步到用户配置
    let userDefault = UserDefaults()
    let userSaved = NSKeyedArchiver.archivedData(withRootObject: GLOBAL_UserProfile)
    userDefault.removeObject(forKey: "UserInfoModel")
    userDefault.set(userSaved, forKey: "UserInfoModel")
    userDefault.synchronize()
}

func syncUserProfileToLocalSqliteDB(){
    //同步到数据库
    let userDefault = UserDefaults()
    let currentID = userDefault.object(forKey: "loginID") as! Int
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.managedObjectContext
    let entity = NSEntityDescription.entity(forEntityName: "UserProperties", in: context)
    if entity != nil{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        do{
            let data = try? context.fetch(fetchRequest) as! [UserPropertiesManagedObject]
            for temp in data! {
                if temp.id == Int64(currentID){
                    temp.allowPushingNewMessageToMobile = GLOBAL_UserProfile.allowPushingNewMessageToMobile!
                    temp.allowPushingNotification = GLOBAL_UserProfile.allowPushingNotification!
                    temp.city = GLOBAL_UserProfile.city
                    temp.province = GLOBAL_UserProfile.province as String!
                    temp.sex = Int64(GLOBAL_UserProfile.sex!)
                    temp.nickName = GLOBAL_UserProfile.nickName!
                    break
                }
            }
            
        }
        do {
            try context.save()
            print("当前用户资料成功保存到数据库")
        } catch let error{
            print("context can't save!, Error: \(error)")
        }
        
    }
    
}
