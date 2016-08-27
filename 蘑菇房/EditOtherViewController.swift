//
//  EditOtherViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class EditOtherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .OnDrag
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if(selectedRow == "昵称"){
            return "请在输入新昵称😊"
        }
        else {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if(self.selectedRow == "昵称"){
            cell = self.tableView.dequeueReusableCellWithIdentifier("InputCell")!
            let name = cell.viewWithTag(101) as! UITextField
            name.delegate = self
            name.text = GLOBAL_UserProfile.nickName
            name.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
        }
        if(self.selectedRow == "性别"){
            cell = self.tableView.dequeueReusableCellWithIdentifier("SexCell")!
            let currentSex = GLOBAL_UserProfile.sex
            if(currentSex == 0 && indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else if(currentSex == 1 && indexPath.row == 1){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            let labels = ["女","男"]
            let label = cell.viewWithTag(103) as! UILabel
            label.text = labels[indexPath.row]
            label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.selectedRow == "昵称"){
            return 1
        }
        else if (self.selectedRow == "性别"){
            return 2
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(self.selectedRow == "性别"){
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            var cells = self.tableView.visibleCells
            for i in 0 ..< cells.count {
                let _cell = cells[i] 
                _cell.accessoryType = UITableViewCellAccessoryType.None
            }
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            //设置单选
            if(indexPath.row == 0){
                GLOBAL_UserProfile.sex = 0
            }
            else {
                GLOBAL_UserProfile.sex = 1
            }
        }
        
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        print("textFieldShouldBeginEditing")
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        print("textFieldDidBeginEditing")
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        print("textFieldShouldEndEditing")
        return true
    }    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField){
        print("textFieldDidEndEditing")
        GLOBAL_UserProfile.nickName = textField.text

    }
    
}
