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
        self.automaticallyAdjustsScrollViewInsets = true
        
        //设置estimatedRowHeight属性默认值
//        self.tableView.estimatedRowHeight = 44.0;
//        //rowHeight属性设置为UITableViewAutomaticDimension
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
//        self.tableView.backgroundColor = UIColor(white: 0.8, alpha: 1)

        
        preview.kf.indicatorType = .activity
        let url = URL(string: imagesURLs[Int((room?.preImage)!)!-1])
        preview.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
            print("\(receivedSize)/\(totalSize)")
        }, completionHandler: { image, error, cacheType, imageURL in
            print("done")
            self.preview.kf.cancelDownloadTask()
        })
        
        let _ = self.tableView.es_addPullToRefresh(animator: header) {
            [weak self] in
            self?.refresh()
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = self.tableView.indexPathForSelectedRow
        if indexPath != nil {
            self.tableView.deselectRow(at: indexPath!, animated: true)
        }
        
        self.tableView.reloadData()
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
//        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1{
//            return 40
//        }
        
        if indexPath.section == 2{
//            print(UITableViewAutomaticDimension)
            return 200
        }
        if indexPath.section == 3{
            return 600
        }
        else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            return 200
        }
        else{
            return 44
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
                    if UIApplication.shared.canOpenURL(settingUrl! as URL){
                        UIApplication.shared.openURL(settingUrl! as URL)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 50
        }
        else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if section == 2{
            return 300
        }
        else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let segment = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            segment.insertSegment(withTitle: "实时数据", at: 0, animated: true)
            segment.insertSegment(withTitle: "历史数据", at: 1, animated: true)
            segment.selectedSegmentIndex = 0
            segment.backgroundColor = .white
            segment.tintColor = UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 50))
            segment.center = view.center
            view.addSubview(segment)
            return view
        }
        else{
            return nil
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
            return 1
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
        
        if indexPath.section == 2{
            cell = self.tableView.dequeueReusableCell(withIdentifier: "dataMenu")!
            let collectionView = cell.viewWithTag(100) as! UICollectionView
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsVerticalScrollIndicator = true
            
            //            DispatchQueue.main.async {
            let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            
            //                if UIDevice.current.userInterfaceIdiom == .pad{
            //间隔
            let spacing:CGFloat = 20
            //水平间隔
            flow.minimumInteritemSpacing = spacing
            //垂直行间距
            flow.minimumLineSpacing = spacing
            
            //列数
            let columnsNum = 4
            //整个view的宽度
            let collectionViewWidth = collectionView.bounds.width
            let leftGap = (collectionViewWidth - spacing * CGFloat(columnsNum-1)
                - CGFloat(columnsNum) * flow.itemSize.width) / 2
            flow.sectionInset = UIEdgeInsets(top: 5, left: leftGap + 20, bottom: 5, right: leftGap+20)
            //                }
            
            //            }
            
        }
        
        if indexPath.section == 3{
            cell = self.tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath)
            
            
            let chartSettings = ChartSettings()
            chartSettings.leading = 10
            chartSettings.top = 10
            chartSettings.trailing = 10
            chartSettings.bottom = 10
            chartSettings.labelsToAxisSpacingX = 5
            chartSettings.labelsToAxisSpacingY = 5
            chartSettings.axisTitleLabelsToLabelsSpacing = 4
            chartSettings.axisStrokeWidth = 0.2
            chartSettings.spacingBetweenAxesX = 8
            chartSettings.spacingBetweenAxesY = 8
            
                let labelSettings = ChartLabelSettings(font: UIFont(name: "AvenirNext-Regular", size: 14)!,fontColor:UIColor.white)
                
                let chartPoints = [(2, 2), (4, 4), (7, 1), (8, 11), (12, 3)].map{ChartPoint(x: ChartAxisValueDouble($0.0, labelSettings: labelSettings), y: ChartAxisValueDouble($0.1))}
                
                let xValues = chartPoints.map{$0.x}
                
                let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
                
                let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
                let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
                let chartFrame = CGRect(x: 0 , y: 0, width: 200, height: 200)
                let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
                let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
                
                let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.red, animDuration: 1, animDelay: 0)
                let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
                
                
                let trackerLayerSettings = ChartPointsLineTrackerLayerSettings(thumbSize: 20, thumbCornerRadius: 10, thumbBorderWidth: 2, infoViewFont:UIFont(name: GLOBAL_appFont!, size: 16)!
                    , infoViewSize: CGSize(width: 160, height: 40), infoViewCornerRadius: 15)
                let chartPointsTrackerLayer = ChartPointsLineTrackerLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints, lineColor: UIColor.black, animDuration: 1, animDelay: 2, settings: trackerLayerSettings)
                
                let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: 0.1)
                let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
                
                let chart = Chart(
                    frame: chartFrame,
                    layers: [
                        xAxis,
                        yAxis,
                        guidelinesLayer,
                        chartPointsLineLayer,
                        chartPointsTrackerLayer
                    ]
                )
            chart.view.center = cell.contentView.center
                cell.addSubview(chart.view)
            
        }
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0{
            cell.accessoryType = .none
        }
        else {
            cell.accessoryType = .disclosureIndicator
        }
        
        if indexPath.section == 2 || indexPath.section == 3{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 4
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

extension PresentRoomDetailViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let point = CGPoint(x: 0, y: 200)
        self.tableView.setContentOffset(point, animated: true)
        print("collection items did select!     \(indexPath.row)")

        
    }
}

extension PresentRoomDetailViewController:UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataMenu", for: indexPath)
        
        
        let staticIcons = [StaticItem(iconName: "Thermometer", label: "温度"),
                           StaticItem(iconName: "water_H2O_128px", label: "湿度"),
                           StaticItem(iconName: "我2", label: "生长量"),
                           StaticItem(iconName: "chemistry_128px", label: "土壤酸碱度"),
                           StaticItem(iconName: "light_bulb_116px", label: "光照"),
                           StaticItem(iconName: "Ecology_Leaf_128px", label: "叶面图像"),
                           StaticItem(iconName: "history_128px", label: "物候期"),]
        
        let icon = cell.viewWithTag(1001) as! UIImageView
        icon.image = UIImage(named: staticIcons[indexPath.row].iconName)
        let title = cell.viewWithTag(1002) as! UILabel
        title.text = staticIcons[indexPath.row].label
        title.font = UIFont(name: "PingFangSC-Regular", size: 16)
        title.textAlignment = .center
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension PresentRoomDetailViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 50
    }
}

