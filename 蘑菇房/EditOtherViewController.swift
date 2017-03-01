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
    
    var nameInputPointer : UITextField!
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if selectedRow == "昵称"{
            if self.nameInputPointer.text == ""{
                let sheet = UIAlertController(title: "昵称不能为空", message: nil, preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                present(sheet, animated: true, completion: nil)
            }
            else{
                performSegue(withIdentifier: "backToEditProfiles", sender: nil)
            }
        }
        else{
            performSegue(withIdentifier: "backToEditProfiles", sender: nil)
        }
    }
    
    var selectedRow : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if(selectedRow == "昵称"){
            return "请在输入新昵称😊"
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if(self.selectedRow == "昵称"){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "InputCell")!
            let name = cell.viewWithTag(101) as! UITextField
            self.nameInputPointer = name
            name.delegate = self
            name.text = GLOBAL_UserProfile.nickName
            name.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
        }
        if(self.selectedRow == "性别"){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "SexCell")!
            let currentSex = GLOBAL_UserProfile.sex
            if(currentSex == 0 && (indexPath as NSIndexPath).row == 0){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else if(currentSex == 1 && (indexPath as NSIndexPath).row == 1){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            let labels = ["女","男"]
            let label = cell.viewWithTag(103) as! UILabel
            label.text = labels[(indexPath as NSIndexPath).row]
            label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true)
        if(self.selectedRow == "性别"){
            let cell = self.tableView.cellForRow(at: indexPath)
            var cells = self.tableView.visibleCells
            for i in 0 ..< cells.count {
                let _cell = cells[i]
                _cell.accessoryType = UITableViewCellAccessoryType.none
            }
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
            //设置单选
            if((indexPath as NSIndexPath).row == 0){
                GLOBAL_UserProfile.sex = 0
            }
            else {
                GLOBAL_UserProfile.sex = 1
            }
        }
        
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        print("textFieldShouldBeginEditing")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("textFieldDidBeginEditing")
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        print("textFieldShouldEndEditing")
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        print("textFieldDidEndEditing")
        self.nameInputPointer = textField
        GLOBAL_UserProfile.nickName = textField.text
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToEditProfiles"{
            let vc = segue.destination as! EditProfilesViewController
        }
    }
    
}
