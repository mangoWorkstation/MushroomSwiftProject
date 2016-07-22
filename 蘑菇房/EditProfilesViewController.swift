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
    
    @IBAction func close(unwindSegue :UIStoryboardSegue){
        let vc = unwindSegue.sourceViewController as! EditOtherViewController
        if(vc.selectedRow == "昵称"){
            GLOBAL_UserProfile.nickName = vc.newName
        }
        if(vc.selectedRow == "性别"){
            GLOBAL_UserProfile.sex = vc.newSex
        }
        self.tableView.reloadData() //传值有问题，没办法确定全局变量是否被修改，待解决 2016.7.22／17:55
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if(indexPath.row == 0){
            return 100
        }
        else{
            return 50
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if(indexPath.row == 0){
            cell = self.tableView.dequeueReusableCellWithIdentifier("UserIconCell",forIndexPath: indexPath)
            let label = cell.viewWithTag(101) as! UILabel
            let icon = cell.viewWithTag(102) as! UIImageView
            label.text = "头像"
            icon.image = UIImage(named: GLOBAL_UserProfile.face!)
        }
        if(indexPath.row > 0){
            cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
            let labels = ["昵称","用户ID","性别","地区"]
            let label = cell.viewWithTag(201) as! UILabel
            let detail = cell.viewWithTag(202) as! UILabel
            label.text = labels[indexPath.row - 1]
            switch label.text! {
            case "昵称":
                detail.text = GLOBAL_UserProfile.nickName
            case "用户ID":
                detail.text = "\(GLOBAL_UserProfile.id!)"
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
            
            if label.text == "用户ID" {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0){
            performSegueWithIdentifier("EditImageSegue", sender: nil)
        }
        if(indexPath.row == 1){
            performSegueWithIdentifier("EditOtherSegue", sender: "昵称")
        }
        if(indexPath.row == 3){
            performSegueWithIdentifier("EditOtherSegue", sender: "性别")
        }
//        if(indexPath.row == 4){
//            performSegueWithIdentifier("EditOtherSegue", sender: "地区")
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "EditImageSegue"){
            let vc = segue.destinationViewController as! FaceShowViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "头像"
        }
        
        if(segue.identifier == "EditOtherSegue"){
            let vc = segue.destinationViewController as! EditOtherViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.rightBarButtonItem?.title = "保存"
            let rowName = sender as! String
            vc.selectedRow = rowName
            vc.navigationItem.title = rowName
        }
    }
    

}
