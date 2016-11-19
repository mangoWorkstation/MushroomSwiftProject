//
//  MushroomViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class MushroomViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var chosenArea :String? = "选择区域" //保存选择的区域 2016.8.2
    
    //后台的数据原型
    //2016.8.27
    var backgroundData : [RoomInfoModel] = Array(GLOBAL_RoomInfo.values)
    
    //前台的显示数据，是数据原型的子数组。
    //滑动到表格的底部时，从后台原型变量处拿数据，并在尾部追加，每次追加15条，直至前后台数据完全一致
    //2016.8.27
    var foregroundShownData :[RoomInfoModel] = []
    
    //定时器
    //用于控制轮播图的滑动
    //2016.7.1
    fileprivate var timer:Timer!
    
    //"选择地区"的按钮
    //2016.7.1/12:43
    @IBOutlet weak var clickOnButton: UIButton!
    
    //轮播图
    //2016.7.1/12:43
    @IBOutlet weak var pageScroller: UIScrollView!
    
    private var pageDots: UIPageControl!
    
    private var pageDotsView : UIView!
    //横条
    
    private var pageScrollTitle:UILabel!
    

    
    //与滚动横幅配套的页面控制器
    //暂时被覆盖在view的最底层，原因不明
    //若无法解决，则忽略
    //2016.7.1/12:43
    
    //列表 
    //2016.7.1/12:43
    @IBOutlet weak var tableView: UITableView!
    
    private let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
    
    private let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
    
    private let loadingTimeInterval : Double = 2.0
    
    private var viewIsOnceLoaded = true
    


    
    //unwindSegue
    //用于“选择地区”视图完成之后，刷新当前前台数据
    @IBAction func unwindSegueToMushroomVC(_ segue:UIStoryboardSegue){
        let vc = segue.source as! ChooseAreaViewController
        let index = vc.chooseAreaPickerView.selectedRow(inComponent: 0)
        self.chosenArea = vc.area[index]
        self.clickOnButton.setTitle(self.chosenArea, for: UIControlState())
        self.backgroundData = regionFilter(self.chosenArea!, rawDataArray: GLOBAL_RoomInfo)
        self.foregroundShownData = self.backgroundData
        self.tableView.es_startPullToRefresh()
        self.tableView.es_autoPullToRefresh()
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)//数据刷新后，返回顶部 2016.8.2
    }
    
    //上拉加载数据
    //测试于2016.8.27通过


    //unwindSegue
    //简单地返回到本页面
    //测试于2016.8.24通过
    @IBAction func justJumpBackToThisVC(_ sender:AnyObject?){
        //Do nothing
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.removeAllRecordInExplictEntity(_EntityName: "Base")
//        self.insertNewRecordForBases()
////        self.displayAllBase()
//        self.removeAllRecordInExplictEntity(_EntityName: "Crops")
//        self.insertNewRecordForCrops()
//        self.removeAllRecordInExplictEntity(_EntityName: "AirHumidity")
//        self.insertNewRecordForAirHumidity()
        
        clickOnButton.setTitle("选择区域", for: UIControlState())
        clickOnButton.titleLabel?.font = UIFont(name: GLOBAL_appFont!, size: 17.5)
        
        prepareForLoadedData()  //加载数据
        
        prepareForScrollPages() //加载轮播图
        
        NotificationCenter.default.addObserver(self, selector: #selector(MushroomViewController.refresh(_notification:)), name: NSNotification.Name(rawValue: "homeRefresh"), object: nil)
        
        //点击tabbar后刷新页面
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
//        tableView.backgroundColor = UIColor(red: 142/255, green: 164/255, blue: 182/255, alpha: 1)
//        //16进制码:#8EA4B6 (142,164,182)
        
//        tableView.backgroundColor = UIColor(red: 131/255, green: 175/255, blue: 155/255, alpha: 1)
        
        let background = UIImageView(image: UIImage(named: "Background_1"))
        tableView.backgroundView = background
        
        tableView.separatorColor = UIColor(white: 1, alpha: 1)    //设置分割线颜色
        
        configurateHeaderAndFooter() //设置表头和表尾

        self.tableView.es_addPullToRefresh(animator: header) {
            [weak self] in
            self?.refresh()
        }
        
        
        self.tableView.es_addInfiniteScrolling(animator: footer) {
            [weak self] in
            self?.loadMore()
        }
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(viewIsOnceLoaded)
        print("viewDidAppear执行了")
        if viewIsOnceLoaded {
            super.viewDidAppear(animated)
            self.tableView.es_startPullToRefresh()
            self.viewIsOnceLoaded = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NotificationCenter.default.removeObserver(self)
        print("removed!!!")
        // Dispose of any resources that can be recreated.
    }
    
    //为首次加载准备数据，仅显示15条，滑动到底部再继续加载
    private func prepareForLoadedData(){
        let newElements = backgroundData
        for newElement in newElements{
            self.foregroundShownData.append(newElement)
            if self.foregroundShownData.count > 15{
                break
            }
        }
    }
    
    private func configurateHeaderAndFooter(){
        header.loadingDescription = "🍄小蘑菇正在努力加载"
        header.pullToRefreshDescription = "下拉可以刷新噢"
        header.releaseToRefreshDescription = "快松手呀～"
        header.trigger = 70
        
        
        footer.loadingDescription = "🍄小蘑菇正在找自己的家"
        footer.noMoreDataDescription = "已经是最后一个啦"
        footer.loadingMoreDescription = "上拉可以找到更多的家～"
    }
    
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingTimeInterval) {
            self.tableView.reloadData()
            self.tableView.es_stopPullToRefresh(completion: true)
        }
    }
    
    //override
    @objc private func refresh(_notification:NotificationCenter) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingTimeInterval) {
            self.tableView.reloadData()
            self.tableView.es_stopPullToRefresh(completion: true)
        }
    }
    
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingTimeInterval) {
            if self.backgroundData.count > 15{
                for i in self.foregroundShownData.endIndex..<self.foregroundShownData.endIndex+15{
                    if i == self.backgroundData.count{
                        break
                    }
                    else{
                        self.foregroundShownData.append(self.backgroundData[i])
                    }
                }
                self.tableView.reloadData()
                self.tableView.es_stopLoadingMore()
            }
            if self.foregroundShownData == self.backgroundData{
                self.tableView.es_noticeNoMoreData()
            }
            else{
                self.tableView.es_stopLoadingMore()
            }
        }
    }

    @IBAction func openWebView(sender:UIButton,forEvent:UIEvent?){
        performSegue(withIdentifier: "officialWeb", sender: nil)
    }
    
    //加载轮播图
    fileprivate func prepareForScrollPages(){
        for i in 1..<4 {
            let image = UIImage(named: "\(i).jpg")!
            let x = CGFloat(i - 1) * self.view.frame.width
            let button = UIButton(frame: CGRect(x: x, y: 0, width: self.view.frame.width, height: pageScroller.bounds.height))
            button.setBackgroundImage(image, for: .normal)
            button.addTarget(self, action: #selector(MushroomViewController.openWebView(sender:forEvent:)), for: .touchUpInside)
            pageScroller.isPagingEnabled = true
            pageScroller.showsHorizontalScrollIndicator = true
            pageScroller.showsVerticalScrollIndicator = false
            pageScroller.isScrollEnabled = true
            pageScroller.addSubview(button)
            pageScroller.delegate = self
            
        }
        let i = 4
        pageScroller.contentSize = CGSize(width: (self.view.frame.width * CGFloat(i - 1)), height: pageScroller.frame.height)
        
        pageDots = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.maxX - 70, y: -10, width: 50, height: 50))
        pageDots.numberOfPages = i - 1
        pageDots.currentPageIndicatorTintColor = UIColor.green
        pageDots.pageIndicatorTintColor = UIColor.white
        
        pageDotsView = UIView(frame: CGRect(x: 0, y: self.pageScroller.frame.maxY - 30, width: UIScreen.main.bounds.maxX, height: 30))
        pageDotsView.backgroundColor = UIColor.darkGray
        pageDotsView.alpha = 0.8
        
        pageScrollTitle = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 30))
        pageScrollTitle.text = "广西大学官方首页"
        //初始化默认值为1
        pageScrollTitle.font = UIFont(name: GLOBAL_appFont!, size: 15.0)
        pageScrollTitle.textColor = UIColor.white
        
        self.pageScroller.superview?.addSubview(pageDotsView)
        self.pageDotsView.addSubview(pageDots)
        self.pageDotsView.addSubview(pageScrollTitle)
        //将三个点加载scrollView的父类视图上才能固定
        
        addTimer()
    }
    
    //滚动横幅的视图
    //MARK:- UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = self.view.frame.width
        let offsetX = scrollView.contentOffset.x
        let index = (offsetX + width / 2) / width
        pageDots.currentPage = Int(index)
        switch pageDots.currentPage {
        case 0:
            pageScrollTitle.text = "广西大学官方首页"
        case 1:
            pageScrollTitle.text = "广西大学农学院官方首页"
        default:
            pageScrollTitle.text = "广西大学计电学院官方首页"
        }
        //        self.tableView.fixedPullToRefreshViewForDidScroll()
        
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }

    //时间控制器，控制滚动
    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MushroomViewController.nextImage), userInfo: nil, repeats: true)
    }

    func removeTimer() {
        timer.invalidate()
    }

    //控制视图跳转
    func nextImage() {
        var pageIndex = pageDots.currentPage
        if pageIndex == 2 {
            pageIndex = 0
        }
        else{
            pageIndex += 1
        }
    
        let offsetX = CGFloat(pageIndex) * self.view.frame.width
        pageScroller.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }

    
    
    //MARK:- UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.foregroundShownData.count
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0{
            return 2
        }
        else if section > 0 {
            return 2
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForRooms")! as UITableViewCell
        let info = foregroundShownData[(indexPath as NSIndexPath).section] as RoomInfoModel
        let image = cell.viewWithTag(1) as! UIImageView
        let name = cell.viewWithTag(2) as! UILabel
        let more = cell.viewWithTag(3) as! UILabel
        image.image = UIImage(named: info.preImage!)
        
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        
        name.text = info.name
        more.text = "查看详情"
        
        name.font = UIFont(name: GLOBAL_appFont!, size: 17.0)
        more.font = UIFont(name: GLOBAL_appFont!, size: 12.0)
        
        name.textColor = UIColor.black
        more.textColor = UIColor.black
        
        cell.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 25
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = self.tableView.cellForRow(at: indexPath)!
        self.tableView.deselectRow(at: indexPath, animated: true)
        let name = cell.viewWithTag(2) as! UILabel
        performSegue(withIdentifier: "ShowDetailSegue", sender: name)
        print("didSelectRowAtIndexPath执行了")
    }
    
    //MARK: - UIStoryBoardSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseAreaSegue"{
            _ = segue.destination as! ChooseAreaViewController
        }
        if(segue.identifier == "ShowDetailSegue"){
            let vc = segue.destination as! PresentRoomDetailViewController
            let name = sender as! UILabel
            vc.currentArea = self.clickOnButton.currentTitle
            vc.navigationItem.title = name.text
            vc.navigationItem.backBarButtonItem?.title = self.clickOnButton.currentTitle!
            vc.roomName = name.text
        }
        if segue.identifier == "officialWeb"{
            let vc = segue.destination as! pageScrollWebViewController
            vc.navigationItem.backBarButtonItem?.title = nil
            switch self.pageDots.currentPage {
            case 0:
                vc.url = "http://www.gxu.edu.cn"
                vc.navigationItem.title = "广西大学"
            case 1:
                vc.url = "http://nxy.gxu.edu.cn"
                vc.navigationItem.title = "广西大学农学院"
            default:
                vc.navigationItem.title = "广西大学计电学院"
                vc.url = "http://www.ccie.gxu.edu.cn"
            }
        }
    }
    
    
    //MARK: - 固件预置数据库读写
    
    //MARK: - 基地表100段
    func insertNewRecordForBases(){
        var main_user : [Int64] = []
        var main_base : [Int64] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        

        let currentUser_ID = GLOBAL_UserProfile.id!
        let currentBase_ID = arc4random()
        main_user.append(Int64(currentUser_ID))
        main_base.append(Int64(currentBase_ID))
        let current_base_entity = NSEntityDescription.insertNewObject(forEntityName: "Base", into: context) as! BaseManagedObject
        current_base_entity.user_ID = Int64(currentUser_ID)
        current_base_entity.base_ID = Int64(currentBase_ID)
        do {
            try context.save()
            print("当前用户与基地ID成功写入缓存")
        } catch let error{
            print("context can't save!, Error: \(error)")
        }
        
        
        for _ in 0..<100 {
            var temp_user_ID = Int64(arc4random())
            for temp in main_user{
                while temp == temp_user_ID {
                    temp_user_ID = Int64(arc4random())
                }
            }
            var temp_base_ID = Int64(arc4random())
            for temp in main_base{
                while temp == temp_base_ID {
                    temp_base_ID = Int64(arc4random())
                }
            }
            main_user.append(temp_user_ID)
            main_base.append(temp_base_ID)
            
            let temp_base_entity = NSEntityDescription.insertNewObject(forEntityName: "Base", into: context) as! BaseManagedObject
            temp_base_entity.user_ID = temp_user_ID
            temp_base_entity.base_ID = temp_base_ID
            
            do {
                try context.save()
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
        }
        print("成功写入基地表\n")

    }

    
    func displayAllBase(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Base", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        do{
            let data = try? context.fetch(fetchRequest) as! [NSManagedObject]
            for temp in data! as! [BaseManagedObject] {
                print("用户ID：\(temp.user_ID)     基地ID：\(temp.base_ID)")
            }
        }
    }
    
    //MARK: - 农作物表4段
    func insertNewRecordForCrops(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        var mainKeys : [Int64] = []
        let cropsTypeName = ["蘑菇","芒果","甘蔗","葡萄"]
        for i in 0..<4 {
            var crops_ID = Int64(arc4random())
            for temp in mainKeys {
                while temp == crops_ID{
                    crops_ID = Int64(arc4random())
                }
            }
            mainKeys.append(crops_ID)
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Crops", into: context) as! CropsManagedObject
            entity.crops_ID = crops_ID
            entity.crops_name = cropsTypeName[i]
            do {
                try context.save()
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
        }
        print("成功写入农作物表")
    }

    
    //MARK: - 空气湿度表100段
    func insertNewRecordForAirHumidity(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        //一个内部类，用来寄存数据而已
        class AH{
            var baseID:Int64
            var userID:Int64
            var time:Int64
            var value:Double
            var dataID:Int64
            var cropsID:Int64
            
            init(baseID:Int64,userID:Int64,time:Int64,value:Double,dataID:Int64,cropsID:Int64) {
                self.baseID = baseID
                self.userID = userID
                self.time = time
                self.dataID = dataID
                self.value = value
                self.cropsID = cropsID
            }
            
        }

        //取基地表
        var entity = NSEntityDescription.entity(forEntityName: "Base", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        let Base = try? context.fetch(fetchRequest) as! [NSManagedObject]
        var baseManageObjectArr : [AH] = []
        for tempBase in Base as! [BaseManagedObject]{
            let baseManageObjectArrTemp = AH(baseID: 0,userID: 0,time: 0,value: 0,dataID: 0,cropsID: 0)
            baseManageObjectArrTemp.baseID = tempBase.base_ID
            baseManageObjectArrTemp.userID = tempBase.user_ID
            baseManageObjectArr.append(baseManageObjectArrTemp)
        }
        
        //取农作物表
        entity = NSEntityDescription.entity(forEntityName: "Crops", in: context)
        fetchRequest.entity = entity
        let Crops = try? context.fetch(fetchRequest) as! [NSManagedObject]
        var tempCropsArr : [AH] = []
        for tempCrop in Crops as! [CropsManagedObject] {
            let cropsManageObjectArrTemp = AH(baseID: 0,userID: 0,time: 0,value: 0,dataID: 0,cropsID: 0)
            cropsManageObjectArrTemp.cropsID = tempCrop.crops_ID
            tempCropsArr.append(cropsManageObjectArrTemp)
        }
        
        
        var dataIDExisted : [Int64] = []
        var timeExisted : [Int64] = []
        var valueExisted : [Double] = []
        for i in 0..<100 {
            //数据ID
            var data_ID = Int64(arc4random())
            for temp in dataIDExisted {
                while temp == data_ID{
                    data_ID = Int64(arc4random())
                }
            }
            dataIDExisted.append(data_ID)
            //时间
            var time = Int64(arc4random_uniform(1500000000)+1400000000)
            for temp in timeExisted {
                while temp == time{
                    time = Int64(arc4random_uniform(1500000000)+1400000000)
                }
            }
            timeExisted.append(time)
            //数值
            var value = Double(arc4random_uniform(50))
            for temp in valueExisted {
                while temp == value{
                    value = Double(arc4random_uniform(50))
                }
            }
            valueExisted.append(Double(value))
            
            let entity = NSEntityDescription.insertNewObject(forEntityName: "AirHumidity", into: context) as! AirHumidityManagedObject
            if i<(Base?.count)! {
                entity.base_ID = baseManageObjectArr[i].baseID
                entity.user_ID = baseManageObjectArr[i].userID
            }
            else{
                entity.base_ID = (baseManageObjectArr.first?.baseID)!
                entity.user_ID = (baseManageObjectArr.first?.userID)!
            }
            
            if i<(Crops?.count)! {
                entity.crops_ID = tempCropsArr[i].cropsID
            }
            else{
                entity.crops_ID = (tempCropsArr.first?.cropsID)!
            }
            
            entity.data_ID = data_ID
            entity.time = time
            entity.value = Double(value)
            
            
            do {
                try context.save()
                print("\(i)段数据写入成功")
                print("基地ID：\(entity.base_ID)   用户ID：\(entity.user_ID)   农作物种类ID：\(entity.crops_ID) ")
                print("时间戳：\(entity.time)   数值：\(entity.value)      数据标识ID：\(entity.data_ID)\n")
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
        }
        print("成功写入空气湿度表")
    }
    
    //删除指定实体下所有字段
    func removeAllRecordInExplictEntity(_EntityName:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: _EntityName, in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        do{
            let data = try? context.fetch(fetchRequest)
            for temp in data! {
                context.delete(temp as! NSManagedObject)
                do {
                    try context.save()
                } catch let error{
                    print("context can't save!, Error: \(error)")
                }
            }
        }
        print("成功删除\(_EntityName)表\n")

    }




}
