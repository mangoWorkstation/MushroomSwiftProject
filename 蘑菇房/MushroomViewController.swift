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
    var backgroundData : [RoomInfoModel] = Array(GLOBAL_RoomInfo.values)//本地缩略图缓存，将来可增加网络连接 2016.7.1/12:43
    
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
    
    //与滚动横幅配套的页面控制器
    //暂时被覆盖在view的最底层，原因不明
    //若无法解决，则忽略
    //2016.7.1/12:43
    @IBOutlet weak var pageDots: UIPageControl!
    
    //列表 
    //2016.7.1/12:43
    @IBOutlet weak var tableView: UITableView!
    
    let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
    
    let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
    
    let loadingTimeInterval : Double = 2.0
    
    var viewIsOnceLoaded = true

    
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
        
//        tableView.backgroundColor = UIColor.clearColor()
        
        
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

    
    //加载轮播图
    fileprivate func prepareForScrollPages(){
        for i in 1..<4 {
            let image = UIImage(named: "\(i).jpg")!
            let x = CGFloat(i - 1) * self.view.frame.width
            let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: self.view.frame.width, height: pageScroller.bounds.height))
            imageView.image = image
            pageScroller.isPagingEnabled = true
            pageScroller.showsHorizontalScrollIndicator = true
            pageScroller.showsVerticalScrollIndicator = false
            pageScroller.isScrollEnabled = true
            pageScroller.addSubview(imageView)
            pageScroller.delegate = self
        }
        
        let i:Int = 4
        pageScroller.contentSize = CGSize(width: (self.view.frame.width * CGFloat(i - 1)), height: pageScroller.frame.height)
        pageDots.numberOfPages = i - 1
        pageDots.currentPageIndicatorTintColor = UIColor.blue
        pageDots.pageIndicatorTintColor = UIColor.gray
        addTimer()
    }
    
    //滚动横幅的视图
    //MARK:- UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = self.view.frame.width
        let offsetX = scrollView.contentOffset.x
        let index = (offsetX + width / 2) / width
        pageDots.currentPage = Int(index)
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
//        cell.selectedBackgroundView?.backgroundColor = UIColor(red: 178/255, green: 190/255, blue: 143/255,alpha:1)
//        //#B2BE9F
        self.tableView.deselectRow(at: indexPath, animated: true)
        let name = cell.viewWithTag(2) as! UILabel
        performSegue(withIdentifier: "ShowDetailSegue", sender: name)
        print("didSelectRowAtIndexPath执行了")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseAreaSegue"{
            let vc = segue.destination as! ChooseAreaViewController
        }
        if(segue.identifier == "ShowDetailSegue"){
            let vc = segue.destination as! PresentRoomDetailViewController
            let name = sender as! UILabel
            vc.currentArea = self.clickOnButton.currentTitle
            vc.navigationItem.title = name.text
            vc.navigationItem.backBarButtonItem?.title = self.clickOnButton.currentTitle!
            vc.roomName = name.text
        }
    }
}
