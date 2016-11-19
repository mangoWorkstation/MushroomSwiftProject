//
//  EditProfilesViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class EditProfilesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindSegueForEditOtherVC(_ unwindSegue :UIStoryboardSegue){
        self.tableView.reloadData()
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
            icon.image = UIImage(data: (GLOBAL_UserProfile.face as NSData) as Data)
            icon.contentMode = .scaleToFill
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
                detail.text = GLOBAL_UserProfile.province! + " " + GLOBAL_UserProfile.city!
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
//        if(indexPath.row == 4){
//            performSegueWithIdentifier("EditOtherSegue", sender: "地区")
//        }
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
