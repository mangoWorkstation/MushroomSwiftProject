//
//  PresentRoomDetailViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/27.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class PresentRoomDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var roomName: String?
    
    var currentArea:String?
    
    var room: RoomInfoModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var preview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForBackButton()
        
        room = acquireRoomInfoByName(self.roomName!)
        self.preview.image = UIImage(named: (room?.preImage)!)
        self.navigationController?.navigationBar.translucent = false
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareForBackButton(){
        let backButton = UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: #selector(MushroomViewController.justJumpBackToThisVC))
        let font = UIFont(name: GLOBAL_appFont!,size: 17.5)
        backButton.setTitleTextAttributes([NSFontAttributeName:font!], forState: .Normal)
        self.navigationItem.backBarButtonItem = backButton
        //更改不了“返回”标题 2016.8.23
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0 && indexPath.row == 1{
            return 40
        }
        else{
            return 50
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 && indexPath.row == 1{
            performSegueWithIdentifier("ShowMapSegue", sender: self.room)
        }
        if indexPath.section == 1 && indexPath.row == 0{
            performSegueWithIdentifier("ShowDataSourceSegue", sender: nil)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if section == 1 {
            return 100
        }
        else {
            return 20
        }
    }
    
    //MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 2
        }
        if section == 1 {
            return 4
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = self.tableView.dequeueReusableCellWithIdentifier("FollowCell", forIndexPath: indexPath)
                let icon = cell.viewWithTag(2001) as! UIImageView
                let label = cell.viewWithTag(2002) as! UILabel
                let button = cell.viewWithTag(2003) as! UIButton
                icon.image = UIImage(named: "ID")
                label.text = self.room?.name
                label.font = UIFont(name: GLOBAL_appFont!, size: 18.0)
                button.setTitle("关注", forState: UIControlState.Normal)
                let label_1 = NSAttributedString(string: "关注", attributes: [NSFontAttributeName:UIFont(name: GLOBAL_appFont!, size: 14.0)!,NSForegroundColorAttributeName:UIColor(red: 28/255, green: 61/255, blue: 57/255, alpha: 1)])
                button.setAttributedTitle(label_1, forState: .Normal)
            }
            if indexPath.row == 1 {
                cell = self.tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath)
                let icon = cell.viewWithTag(1001) as! UIImageView
                let label = cell.viewWithTag(1002) as! UILabel
                icon.image = UIImage(named: "LocationPin")
                icon.contentMode = UIViewContentMode.ScaleAspectFit
                label.text = room?.address
                label.textColor = UIColor.grayColor()
                label.font = UIFont(name: GLOBAL_appFont!, size: 15.0)
            }
        }
        if indexPath.section == 1 {
            cell = self.tableView.dequeueReusableCellWithIdentifier("InspectorCell", forIndexPath: indexPath)
            let icons = ["Mushroom","Barn","Battery","Statistics"]
            let labels = ["蘑菇房","堆料房","电量检测","历史数据"]
            let icon = cell.viewWithTag(1001) as! UIImageView
            let label = cell.viewWithTag(1002) as! UILabel
            icon.image = UIImage(named: icons[indexPath.row])
            label.text = labels[indexPath.row]
            label.font = UIFont(name: GLOBAL_appFont!, size: 17.5)
        }
        if indexPath.section == 0 && indexPath.row == 0{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMapSegue" {
            let vc = segue.destinationViewController as! ShowMapViewController
            vc.navigationController?.navigationItem.backBarButtonItem?.title  = self.navigationItem.title
            vc.room = self.room
        }
        if segue.identifier == "ShowDataSourceSegue"{
            let vc = segue.destinationViewController as! DataSourceViewController
            vc.navigationItem.backBarButtonItem?.title = nil
        }
    }
    
}
