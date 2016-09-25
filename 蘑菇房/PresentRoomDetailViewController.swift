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
        self.navigationController?.navigationBar.isTranslucent = false
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareForBackButton(){
        let backButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(MushroomViewController.justJumpBackToThisVC))
        let font = UIFont(name: GLOBAL_appFont!,size: 17.5)
        backButton.setTitleTextAttributes([NSFontAttributeName:font!], for: UIControlState())
        self.navigationItem.backBarButtonItem = backButton
        //更改不了“返回”标题 2016.8.23
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1{
            return 40
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1{
            performSegue(withIdentifier: "ShowMapSegue", sender: self.room)
        }
        if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0{
            performSegue(withIdentifier: "ShowDataSourceSegue", sender: nil)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if section == 1 {
            return 100
        }
        else {
            return 20
        }
    }
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                cell = self.tableView.dequeueReusableCell(withIdentifier: "FollowCell", for: indexPath)
                let icon = cell.viewWithTag(2001) as! UIImageView
                let label = cell.viewWithTag(2002) as! UILabel
                let button = cell.viewWithTag(2003) as! UIButton
                icon.image = UIImage(named: "ID")
                label.text = self.room?.name
                label.font = UIFont(name: GLOBAL_appFont!, size: 18.0)
                button.setTitle("关注", for: UIControlState())
                let label_1 = NSAttributedString(string: "关注", attributes: [NSFontAttributeName:UIFont(name: GLOBAL_appFont!, size: 14.0)!,NSForegroundColorAttributeName:UIColor(red: 28/255, green: 61/255, blue: 57/255, alpha: 1)])
                button.setAttributedTitle(label_1, for: UIControlState())
            }
            if (indexPath as NSIndexPath).row == 1 {
                cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
                let icon = cell.viewWithTag(1001) as! UIImageView
                let label = cell.viewWithTag(1002) as! UILabel
                icon.image = UIImage(named: "LocationPin")
                icon.contentMode = UIViewContentMode.scaleAspectFit
                label.text = room?.address
                label.textColor = UIColor.gray
                label.font = UIFont(name: GLOBAL_appFont!, size: 15.0)
            }
        }
        if (indexPath as NSIndexPath).section == 1 {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "InspectorCell", for: indexPath)
            let icons = ["Mushroom","Barn","Battery","Statistics"]
            let labels = ["蘑菇房","堆料房","电量检测","历史数据"]
            let icon = cell.viewWithTag(1001) as! UIImageView
            let label = cell.viewWithTag(1002) as! UILabel
            icon.image = UIImage(named: icons[(indexPath as NSIndexPath).row])
            label.text = labels[(indexPath as NSIndexPath).row]
            label.font = UIFont(name: GLOBAL_appFont!, size: 17.5)
        }
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMapSegue" {
            let vc = segue.destination as! ShowMapViewController
            vc.navigationController?.navigationItem.backBarButtonItem?.title  = self.navigationItem.title
            vc.room = self.room
        }
        if segue.identifier == "ShowDataSourceSegue"{
            let vc = segue.destination as! DataSourceViewController
            vc.navigationItem.backBarButtonItem?.title = nil
        }
    }
    
}
