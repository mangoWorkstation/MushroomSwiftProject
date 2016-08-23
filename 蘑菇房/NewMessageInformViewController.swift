//
//  NewMessageInformViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/19.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class NewMessageInformViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func switchButtonOnChanged(sender:UISwitch,forEvent: UIEvent?) {
        let switchtag = sender.tag
        if switchtag == 100{
            if sender.on == true {
                GLOBAL_UserProfile.allowPushingNotification = true
            }
            else{
                GLOBAL_UserProfile.allowPushingNotification = false
            }
        }
        if switchtag == 101 {
            if sender.on == true{
                GLOBAL_UserProfile.allowPushingNewMessageToMobile = true
            }
            else {
                GLOBAL_UserProfile.allowPushingNewMessageToMobile = false
            }
        }
        print("switchButtonOnChanged执行了")
        print("允许1:\(GLOBAL_UserProfile.allowPushingNotification!)")
        print("允许2:\(GLOBAL_UserProfile.allowPushingNewMessageToMobile!)")
    }
    //监听开关状态变化：测试通过 2016.8.22

    var willAllowNewMessageInform :Bool? = GLOBAL_UserProfile.allowPushingNotification{
        didSet{
            //更新用户配置文件(待完善)
        }
        willSet{
            //读取用户配置文件(待完善)
        }
    }
    
    var willAllowPushNewMessageToMobile: Bool? = GLOBAL_UserProfile.allowPushingNewMessageToMobile{
        didSet{
            //更新用户配置文件(待完善)

        }
        willSet{
            //读取用户配置文件(待完善)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let labels = ["允许新消息推送","短信推送到手机"]
        cell = self.tableView.dequeueReusableCellWithIdentifier("NewMessageSetupCell",forIndexPath: indexPath)
        let label = cell.viewWithTag(101) as! UILabel
        let switchButton = cell.viewWithTag(102) as! UISwitch
        label.text = labels[indexPath.row]
        switch indexPath.row{
        case 0: switchButton.on = self.willAllowNewMessageInform!
        case 1: switchButton.on = self.willAllowPushNewMessageToMobile!
        default :break
        }
        switchButton.tag = indexPath.row + 100
        switchButton.addTarget(self, action: #selector(NewMessageInformViewController.switchButtonOnChanged(_:forEvent:)), forControlEvents: .ValueChanged)
        //注意这句话的写法，他妈，改了几次没改对
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}