//
//  FeedBackViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/19.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.keyboardDismissMode = .OnDrag //滑动收键盘 和 func scrollViewDidScroll(scrollView: UIScrollView) 作用相同，只留其一
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if((indexPath as NSIndexPath).section == 1){
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if((indexPath as NSIndexPath).section == 0){
            return 200
        }
        else if((indexPath as NSIndexPath).section == 1){
            return 50
        }
        else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if((indexPath as NSIndexPath).section == 0){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "InputCell")!
            let textView = cell.viewWithTag(102) as! UITextView
            textView.isEditable = true
            textView.keyboardType = UIKeyboardType.default
            textView.delegate = self
        }
        if((indexPath as NSIndexPath).section == 1){
            cell = self.tableView.dequeueReusableCell(withIdentifier: "ConfirmButtonCell")!
            let label = cell.textLabel
            label?.text = "发送"
            label!.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
            label?.textAlignment = NSTextAlignment.center
            label?.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if(section == 0){
            return "请输入您的建议，不超过140个字噢～"
        }
        else{
            return nil
        }
    }
    
//回车收键盘 2016.7.21
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //滑动收键盘
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
//    -(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//    {
//    if ([text isEqualToString:@"\n"]) {
//    [textView resignFirstResponder];
//    return NO;
//    }
//    return YES;
//    }
    
    
}




