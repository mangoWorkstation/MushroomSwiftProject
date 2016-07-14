//
//  MushroomViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class MushroomViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,dataExchangeBetweenViewsDelegate{
    
    var chosenArea :String? = "选择区域"
    
    var roomPreview : [Preview] = []//本地缩略图缓存，将来可增加网络连接 2016.7.1/12:43
    
    var timer:NSTimer!
    
    @IBOutlet weak var clickOnButton: UIButton!//选择地区的按钮 2016.7.1/12:43
    
    @IBOutlet weak var pageScroller: UIScrollView!//滚动横幅 2016.7.1/12:43
    
    @IBOutlet weak var pageDots: UIPageControl!//与滚动横幅配套的页面控制器 2016.7.1/12:43
    
    @IBOutlet weak var List: UITableView! //列表 2016.7.1/12:43
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomPreview = [Preview(name: "广西大学",preImage: "1"),Preview(name: "广西药用植物园",preImage: "2"),Preview(name: "坛洛镇蘑菇基地",preImage: "3"),Preview(name: "西乡塘区蘑菇大棚1",preImage: "2"),Preview(name: "西乡塘区蘑菇大棚2",preImage: "1"),Preview(name: "西乡塘区蘑菇大棚3",preImage: "3"),Preview(name: "西乡塘区蘑菇大棚4",preImage: "2")]
        clickOnButton.setTitle("选择区域", forState: UIControlState.Normal)
        var i:Int
        for (i=1;i<=3;i += 1){
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
        
        pageScroller.contentSize = CGSizeMake((self.view.frame.width * CGFloat(i-1)), pageScroller.frame.height)
        pageDots.numberOfPages = i-1
        pageDots.currentPageIndicatorTintColor = UIColor.blueColor()
        pageDots.pageIndicatorTintColor = UIColor.grayColor()
        addTimer()
        // Do any additional setup after loading the view, typically from a nib.
        List.delegate = self
        List.dataSource = self
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    滚动横幅的视图
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
//    列表视图加载部分
//    赋值
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return roomPreview.count
    }
    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.List.dequeueReusableCellWithIdentifier("CellForRooms")! as UITableViewCell
        let info = roomPreview[indexPath.section] as Preview //注意是indexPath.section，而不是row
        let image = cell.viewWithTag(1) as! UIImageView
        let name = cell.viewWithTag(2) as! UILabel
        let more = cell.viewWithTag(3) as! UILabel
        image.image = UIImage(named: info.preImage)
        name.text = info.name
        more.text = "查看详情"
        return cell
    }
    
    
//    更改当前标题
    func changeTitleArea(currentArea : String){
        clickOnButton.setTitle(currentArea, forState:  UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChooseAreaSegue"{
            let vc = segue.destinationViewController as! ChooseAreaViewController
            vc.delegate = self
        }
    }
//历史遗留问题，不要理我🌝🌝🌝
}