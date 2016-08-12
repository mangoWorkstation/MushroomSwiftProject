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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 1){
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if(indexPath.section == 0){
            return 200
        }
        else if(indexPath.section == 1){
            return 50
        }
        else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(indexPath.section == 0){
            cell = self.tableView.dequeueReusableCellWithIdentifier("InputCell")!
            let textView = cell.viewWithTag(102) as! UITextView
            textView.editable = true
            textView.keyboardType = UIKeyboardType.Default
            textView.delegate = self
            
        }
        if(indexPath.section == 1){
            cell = self.tableView.dequeueReusableCellWithIdentifier("ConfirmButtonCell")!
            let label = cell.textLabel
            label?.text = "发送"
            label?.textAlignment = NSTextAlignment.Center
            label?.textColor = UIColor.redColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if(section == 0){
            return "请输入您的建议，不超过140个字噢～\n按换行键完成输入"
        }
        else{
            return nil
        }
    }
    
//回车收键盘 2016.7.21
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
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




