//
//  MyBasesTableViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 2017/3/1.
//  Copyright © 2017年 蘑菇云工作室. All rights reserved.
//

import UIKit

class MyBasesTableViewController: UITableViewController {
    
    var rawData: Dictionary<String,RoomInfoModel> = [:]
    
    var myBaseType:String?
    
    //测试异步下载用，kingfisher测试用
    let imagesURLs = ["http://tupian.enterdesk.com/uploadfile/2016/0229/20160229101318786.jpg",
                      "http://tupian.enterdesk.com/uploadfile/2015/0603/20150603110712511.jpg",
                      "http://tupian.enterdesk.com/uploadfile/2015/0409/20150409032727732.jpg"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //读取缓存部分，现用读取固件内部预先设好的plist代替！！
        let path_ = Bundle.main.url(forResource: "roomsInfo", withExtension: "plist")
        let data_ = try! Data(contentsOf: path_!)
        //解码器
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data_)
        self.rawData = unarchiver.decodeObject(forKey: "roomsInfo") as! Dictionary<String, RoomInfoModel>
        unarchiver.finishDecoding()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.rawData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForRooms", for: indexPath)
        let infos = Array(self.rawData.values)
        let info = infos[(indexPath as NSIndexPath).row] as RoomInfoModel
        let image = cell.viewWithTag(1) as! UIImageView
        let name = cell.viewWithTag(2) as! UILabel
        let more = cell.viewWithTag(3) as! UILabel
        //        image.image = UIImage(named: info.preImage!)
        
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.kf.indicatorType = .activity
        
        name.text = info.name
        more.text = "查看详情"
        
        name.font = UIFont(name: GLOBAL_appFont!, size: 17.0)!
        more.font = UIFont(name: GLOBAL_appFont!, size: 12.0)
        
        name.textColor = UIColor.black
        more.textColor = UIColor.black
        
//        cell.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true


        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0{
            return 2
        }
        else{
            return 10
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let infos = Array(self.rawData.values)
        let info = infos[(indexPath as NSIndexPath).row] as RoomInfoModel
        let downloadIndicator = Int(info.preImage!)
        let url = URL(string: self.imagesURLs[downloadIndicator!-1])
        let preImage = cell.viewWithTag(1) as! UIImageView
        preImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
        }, completionHandler: { image, error, cacheType, imageURL in
            print("\(indexPath.row + 1): Finished")
        })
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let preImage = cell.viewWithTag(1) as! UIImageView
        preImage.kf.cancelDownloadTask()
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
