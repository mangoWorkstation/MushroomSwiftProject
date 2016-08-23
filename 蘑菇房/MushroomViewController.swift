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
    
    var roomPreview : [RoomInfoModel] = GLOBAL_RoomInfo //本地缩略图缓存，将来可增加网络连接 2016.7.1/12:43
    
    var timer:NSTimer!
    
    @IBOutlet weak var clickOnButton: UIButton!//选择地区的按钮 2016.7.1/12:43
    
    @IBOutlet weak var pageScroller: UIScrollView!//滚动横幅 2016.7.1/12:43
    
    @IBOutlet weak var pageDots: UIPageControl!//与滚动横幅配套的页面控制器 2016.7.1/12:43
    
    @IBOutlet weak var List: UITableView! //列表 2016.7.1/12:43
    
    @IBAction func unwindSegueToMushroomVC(segue:UIStoryboardSegue){
        let vc = segue.sourceViewController as! ChooseAreaViewController
        let index = vc.chooseAreaPickerView.selectedRowInComponent(0)
        self.chosenArea = vc.area[index]
        self.clickOnButton.setTitle(self.chosenArea, forState: UIControlState.Normal)
        self.roomPreview = regionFilter(self.chosenArea!, rawDataArray: GLOBAL_RoomInfo)
        self.List.reloadData()
        self.List.setContentOffset(CGPointMake(0,0), animated: true)//数据刷新后，返回顶部 2016.8.2
    }
    
    @IBAction func justJumpBackToThisVC(sender:AnyObject?){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        roomPreview = [Preview(name: "广西大学",preImage: "1"),Preview(name: "广西药用植物园",preImage: "2"),Preview(name: "坛洛镇蘑菇基地",preImage: "3"),Preview(name: "西乡塘区蘑菇大棚1",preImage: "2"),Preview(name: "西乡塘区蘑菇大棚2",preImage: "1"),Preview(name: "西乡塘区蘑菇大棚3",preImage: "3"),Preview(name: "西乡塘区蘑菇大棚4",preImage: "2")]
        clickOnButton.setTitle("选择区域", forState: UIControlState.Normal)
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
        
        let i:Int = 3
        pageScroller.contentSize = CGSizeMake((self.view.frame.width * CGFloat(i - 1)), pageScroller.frame.height)
        pageDots.numberOfPages = i - 1
        pageDots.currentPageIndicatorTintColor = UIColor.blueColor()
        pageDots.pageIndicatorTintColor = UIColor.grayColor()
        addTimer()
        // Do any additional setup after loading the view, typically from a nib.
        List.delegate = self
        List.dataSource = self
//        self.List.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//    时间控制器，控制滚动
    func addTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(MushroomViewController.nextImage), userInfo: nil, repeats: true)
    }

    func removeTimer() {
        timer.invalidate()
    }

//    控制视图跳转
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
        return roomPreview.count
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
        let cell = self.List.dequeueReusableCellWithIdentifier("CellForRooms")! as UITableViewCell
            let info = roomPreview[indexPath.section] as RoomInfoModel
        let image = cell.viewWithTag(1) as! UIImageView
        let name = cell.viewWithTag(2) as! UILabel
        let more = cell.viewWithTag(3) as! UILabel
        image.image = UIImage(named: info.preImage!)
        name.text = info.name
        more.text = "查看详情"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.List.deselectRowAtIndexPath(indexPath, animated: true) //点击后取消被选中状态 2016.7.17
        let cell = self.List.cellForRowAtIndexPath(indexPath)
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
            vc.roomName = name.text
        }
    }
}