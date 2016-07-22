//
//  AccountViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()

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
        cell = self.tableView.dequeueReusableCellWithIdentifier("GeneralCell",forIndexPath: indexPath)
        let label = cell.viewWithTag(1001) as! UILabel
        let labels = ["更改个人资料","更改登录密码","更改绑定手机号"]
        label.text! = labels[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0){
            performSegueWithIdentifier("EditProfilesSegue", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "EditProfilesSegue"){
            let vc = segue.destinationViewController as! EditProfilesViewController
            vc.navigationItem.backBarButtonItem?.title = self.navigationItem.title
            vc.navigationItem.title = "个人资料"
        }
    }
    
    
}
