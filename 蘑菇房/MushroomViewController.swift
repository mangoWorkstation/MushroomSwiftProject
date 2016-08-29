//
//  MushroomViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class MushroomViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var chosenArea :String? = "选择区域" //保存选择的区域 2016.8.2
    
    //后台的数据原型
    //2016.8.27
    var backgroundData : [RoomInfoModel] = GLOBAL_RoomInfo//本地缩略图缓存，将来可增加网络连接 2016.7.1/12:43
    
    //前台的显示数据，是数据原型的子数组。
    //滑动到表格的底部时，从后台原型变量处拿数据，并在尾部追加，每次追加15条，直至前后台数据完全一致
    //2016.8.27
    var foregroundShownData : [RoomInfoModel] = []
    
    //定时器
    //用于控制轮播图的滑动
    //2016.7.1
    private var timer:NSTimer!
    
    //"选择地区"的按钮
    //2016.7.1/12:43
    @IBOutlet weak var clickOnButton: UIButton!
    
    //轮播图
    //2016.7.1/12:43
    @IBOutlet weak var pageScroller: UIScrollView!
    
    //与滚动横幅配套的页面控制器
    //暂时被覆盖在view的最底层，原因不明
    //若无法解决，则忽略
    //2016.7.1/12:43
    @IBOutlet weak var pageDots: UIPageControl!
    
    //列表 
    //2016.7.1/12:43
    @IBOutlet weak var tableView: UITableView!
    
    //unwindSegue
    //用于“选择地区”视图完成之后，刷新当前前台数据
    @IBAction func unwindSegueToMushroomVC(segue:UIStoryboardSegue){
        let vc = segue.sourceViewController as! ChooseAreaViewController
        let index = vc.chooseAreaPickerView.selectedRowInComponent(0)
        self.chosenArea = vc.area[index]
        self.tableView.headerView?.beginRefreshing()
        self.clickOnButton.setTitle(self.chosenArea, forState: UIControlState.Normal)
        self.backgroundData = regionFilter(self.chosenArea!, rawDataArray: GLOBAL_RoomInfo)
        self.foregroundShownData = self.backgroundData
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPointMake(0,0), animated: true)//数据刷新后，返回顶部 2016.8.2
    }
    
    //上拉加载数据
    //测试于2016.8.27通过
    @IBAction func upPullLoadData(sender:UITableViewHeaderFooterView?){
        
        //延迟执行，模拟网络延迟
        xwDelay(1) { () -> Void in
            
            self.tableView.reloadData()
            self.tableView.headerView?.endRefreshing()
            
        }
        
    }
    
    //下拉加载更多
    //测试于2016.8.27通过
    @IBAction func downPlullLoadData(sender:UITableViewHeaderFooterView?){
        xwDelay(1) { () -> Void in
            //如果从当前前台数据foregroundShownData的最后一个数据往后数15个，下标还没超过后台数据原型backgroundData的最大下标，则加载数据
            //如果下标达到后台数据backgroundData的最大下标，则退出
            if self.backgroundData.count > 15{
                for i in self.foregroundShownData.endIndex..<self.foregroundShownData.endIndex+15{
                    if i == self.backgroundData.count{
                        break
                    }
                    else{
                        self.foregroundShownData.append(GLOBAL_RoomInfo[i])
                    }
                }
            }
            self.tableView.reloadData()
            self.tableView.footerView?.endRefreshing()
        }
        
    }

    //unwindSegue
    //简单地返回到本页面
    //测试于2016.8.24通过
    @IBAction func justJumpBackToThisVC(sender:AnyObject?){
        //Do nothing
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clickOnButton.setTitle("选择区域", forState: UIControlState.Normal)
        clickOnButton.titleLabel?.font = UIFont(name: GLOBAL_appFont!, size: 17.5)
        
        prepareForLoadedData()  //加载数据
        
        prepareForScrollPages() //加载轮播图
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        tableView.backgroundColor = UIColor(red: 142/255, green: 164/255, blue: 182/255, alpha: 1)
        //16进制码:#8EA4B6
        
        tableView.separatorColor = UIColor(white: 0.9, alpha: 1)    //设置分割线颜色
        
        tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(MushroomViewController.upPullLoadData(_:)))    //下拉刷新 2016.8.27
        
        tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(MushroomViewController.downPlullLoadData(_:))) //上拉加载 2016.8.27
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //为首次加载准备数据，仅显示15条，滑动到底部再继续加载
    private func prepareForLoadedData(){
        for newElement in backgroundData {
            self.foregroundShownData.append(newElement)
            if self.foregroundShownData.count > 15{
                break
            }
        }
    }
    
    //加载轮播图
    private func prepareForScrollPages(){
        for i in 1..<4 {
            let image = UIImage(named: "\(i).jpg")!
            let x = CGFloat(i - 1) * self.view.frame.width
            let imageView = UIImageView(frame: CGRectMake(x, 0, self.view.frame.width, pageScroller.bounds.height))
            imageView.image = image
            pageScroller.pagingEnabled = true
            pageScroller.showsHorizontalScrollIndicator = true
            pageScroller.showsVerticalScrollIndicator = false
            pageScroller.scrollEnabled = true
            pageScroller.addSubview(imageView)
            pageScroller.delegate = self
        }
        
        let i:Int = 4
        pageScroller.contentSize = CGSizeMake((self.view.frame.width * CGFloat(i - 1)), pageScroller.frame.height)
        pageDots.numberOfPages = i - 1
        pageDots.currentPageIndicatorTintColor = UIColor.blueColor()
        pageDots.pageIndicatorTintColor = UIColor.grayColor()
        addTimer()
    }
    
    //滚动横幅的视图
    //MARK:- UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = self.view.frame.width
        let offsetX = scrollView.contentOffset.x
        let index = (offsetX + width / 2) / width
        pageDots.currentPage = Int(index)
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }

    //时间控制器，控制滚动
    func addTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(MushroomViewController.nextImage), userInfo: nil, repeats: true)
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
        pageScroller.setContentOffset(CGPointMake(offsetX, 0), animated: true)
    }

    
    
    //MARK:- UITableViewDelegate,UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.foregroundShownData.count
    }
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0{
            return 0.0
        }
        else if section > 0 {
            return 3
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellForRooms")! as UITableViewCell
        let info = foregroundShownData[indexPath.section] as RoomInfoModel
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
        
        name.textColor = UIColor.whiteColor()
        more.textColor = UIColor.blackColor()
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true) //点击后取消被选中状态 2016.7.17
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        let name = cell?.viewWithTag(2) as! UILabel
        performSegueWithIdentifier("ShowDetailSegue", sender: name)
        print("didSelectRowAtIndexPath执行了")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChooseAreaSegue"{
            let vc = segue.destinationViewController as! ChooseAreaViewController
        }
        if(segue.identifier == "ShowDetailSegue"){
            let vc = segue.destinationViewController as! PresentRoomDetailViewController
            let name = sender as! UILabel
            vc.currentArea = self.clickOnButton.currentTitle
            vc.navigationItem.title = name.text
            vc.navigationItem.backBarButtonItem?.title = self.clickOnButton.currentTitle!
            vc.roomName = name.text
        }
    }
}