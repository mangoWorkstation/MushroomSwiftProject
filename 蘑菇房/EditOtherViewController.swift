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
    
    var newName : String?
    
    var newSex : Int?

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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if(self.selectedRow == "昵称"){
            cell = self.tableView.dequeueReusableCellWithIdentifier("InputCell")!
            let name = cell.viewWithTag(101) as! UITextField
            name.text = GLOBAL_UserProfile.nickName
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
            for(var i=0;i<cells.count;i+=1){
                let _cell = cells[i] 
                _cell.accessoryType = UITableViewCellAccessoryType.None
            }
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            if(indexPath.row == 0){
                self.newSex = 1
            }
            else {
                self.newSex = 0
            }
        }
        
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField) {
        if(self.selectedRow == "昵称"){
            self.newName = textField.text
        }
    }

}
