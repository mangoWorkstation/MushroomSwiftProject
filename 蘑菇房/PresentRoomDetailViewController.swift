//
//  PresentRoomDetailViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/27.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class PresentRoomDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var rawData:Dictionary<String,RoomInfoModel> = [:]
    
    var cloudDataSource:Dictionary<String,DataSource> = [:]
    
    var roomName: String?
    
    var currentArea:String?
    
    var room: RoomInfoModel?
    
    private let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
    
    private let loadingTimeInterval : Double = 2.0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var preview: UIImageView!
    
    //测试异步下载用，kingfisher测试用
    let imagesURLs = ["http://tupian.enterdesk.com/uploadfile/2016/0229/20160229101318786.jpg",
                      "http://tupian.enterdesk.com/uploadfile/2015/0603/20150603110712511.jpg",
                      "http://tupian.enterdesk.com/uploadfile/2015/0409/20150409032727732.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForBackButton()

        //读取缓存部分，现用读取固件内部预先设好的plist代替！！
        let path_ = Bundle.main.url(forResource: "roomsInfo", withExtension: "plist")
        let data_ = try! Data(contentsOf: path_!)
        //解码器
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data_)
        self.rawData = unarchiver.decodeObject(forKey: "roomsInfo") as! Dictionary<String, RoomInfoModel>
        unarchiver.finishDecoding()

        //读取缓存部分，现用读取固件内部预先设好的plist代替！！
        let path_1 = Bundle.main.url(forResource: "cloudDataSource", withExtension: "plist")
        let data_1 = try! Data(contentsOf: path_1!)
        //解码器
        let unarchiver_1 = NSKeyedUnarchiver(forReadingWith: data_1)
        self.cloudDataSource = unarchiver_1.decodeObject(forKey: "cloudDataSource")as! Dictionary<String, DataSource>
        unarchiver.finishDecoding()

        
        room = acquireRoomInfoByName(self.roomName!,rawData: rawData)
        self.preview.image = UIImage(named: (room?.preImage)!)
        self.navigationController?.navigationBar.isTranslucent = false
        tableView.delegate = self
        tableView.dataSource = self
        configurateHeaderAndFooter()
        
        preview.kf.indicatorType = .activity
        let url = URL(string: imagesURLs[Int((room?.preImage)!)!-1])
        preview.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
            print("\(receivedSize)/\(totalSize)")
        }, completionHandler: { image, error, cacheType, imageURL in
            print("done")
            self.preview.kf.cancelDownloadTask()
        })
        
        self.tableView.es_addPullToRefresh(animator: header) {
            [weak self] in
            self?.refresh()
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = self.tableView.indexPathForSelectedRow
        if indexPath != nil {
            self.tableView.deselectRow(at: indexPath!, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configurateHeaderAndFooter(){
        header.loadingDescription = "🍄小蘑菇正在努力刷新数据"
        header.pullToRefreshDescription = "👇🏻下拉可以刷新噢"
        header.releaseToRefreshDescription = "👋🏻快松手呀～"
        header.trigger = 70
    }
    
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingTimeInterval) {
            self.tableView.reloadData()
            self.tableView.es_stopPullToRefresh(completion: true)
            let bannerView = MGBannerIndicatorView(duration: 3.0, text: "更新成功", backgroundColor: .orange, textColor: .white)
            bannerView.alpha = 0.8
            bannerView.stroke(in: self.view)
        }
    }
    
    private func prepareForBackButton(){
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
            if (self.cloudDataSource[(self.room?.roomID)! + "A0"] != nil){
                performSegue(withIdentifier: "ShowDataSourceSegue", sender: self.room)
            }
            else {
                let alertView = UIAlertController(title: "数据获取失败", message: "请检查是否允许蘑菇房使用网络😊", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "设置", style: .default, handler: {
                    (action)->Void in
                    let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if UIApplication.shared.canOpenURL(settingUrl as! URL){
                        UIApplication.shared.openURL(settingUrl as! URL)
                    }
                }))
                alertView.addAction(UIAlertAction(title: "好", style: .default, handler: nil))
                present(alertView, animated: true, completion: {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            }
        }
        if (indexPath as NSIndexPath).section == 1 {
            if indexPath.row != 0{
                let alertView = UIAlertController(title: "前方施工", message: "新功能正在开发，敬请期待😊", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "好", style: .default, handler: nil))
                present(alertView, animated: true, completion: {
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
            }
        }
        
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
                let label_1 = NSAttributedString(string: "申请查看权限", attributes: [NSFontAttributeName:UIFont(name: GLOBAL_appFont!, size: 14.0)!,NSForegroundColorAttributeName:UIColor(red: 28/255, green: 61/255, blue: 57/255, alpha: 1)])
                button.setAttributedTitle(label_1, for: UIControlState())
                button.backgroundColor = UIColor(red: 250/255, green: 181/255, blue: 14/255, alpha: 1)
                button.clipsToBounds = true
                button.layer.masksToBounds = true
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 5
                button.layer.borderColor = UIColor.white.cgColor
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
            let room = sender as! RoomInfoModel
            vc.navigationItem.backBarButtonItem?.title = nil
            vc.roomID = room.roomID!
        }
    }
    
}
