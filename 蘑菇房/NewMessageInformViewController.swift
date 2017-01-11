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
    
    @IBAction func switchButtonOnChanged(_ sender:UISwitch,forEvent: UIEvent?) {
        let switchtag = sender.tag
        if switchtag == 100{
            if sender.isOn == true {
                GLOBAL_UserProfile.allowPushingNotification = true
            }
            else{
                GLOBAL_UserProfile.allowPushingNotification = false
            }
        }
        if switchtag == 101 {
            if sender.isOn == true{
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
        tableView.isScrollEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let labels = ["允许新消息推送","允许短信推送到手机"]
        cell = self.tableView.dequeueReusableCell(withIdentifier: "NewMessageSetupCell",for: indexPath)
        let label = cell.viewWithTag(101) as! UILabel
        let switchButton = UISwitch()
        cell.accessoryView = switchButton
        //2016.8.29修改，使列表可以滑动
        label.text = labels[(indexPath as NSIndexPath).row]
        label.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
        switch (indexPath as NSIndexPath).row{
        case 0: switchButton.isOn = self.willAllowNewMessageInform!
        case 1: switchButton.isOn = self.willAllowPushNewMessageToMobile!
        default :break
        }
        switchButton.tag = (indexPath as NSIndexPath).row + 100
        switchButton.addTarget(self, action: #selector(NewMessageInformViewController.switchButtonOnChanged(_:forEvent:)), for: .valueChanged)
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
