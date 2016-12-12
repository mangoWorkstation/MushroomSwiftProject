//
//  WeatherViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UIScrollViewDelegate {
    
    var forecast_url = "http://apis.baidu.com/apistore/weatherservice/recentweathers"
    var cityNameID = "cityname=%E5%8D%97%E5%AE%81&cityid=101300101"
    let baiduAPIKey = "d596f298898e51557c9d3e93f143c74d"
    
    @IBOutlet weak var selectedPage: UISegmentedControl!
    
    @IBOutlet weak var pageScroller: UIScrollView!
    
    private var pageDots: UIPageControl!
    
    private var pageDotsView:UIView!
    
    private var today_DataSource : WeatherDataSource!
    
    private var forcast_DataSource:[WeatherDataSource] = []
    
    private var pageOffSetOriginX:CGFloat!
    
    private var updateTime:Int?
    
    //缓存需要过期时间：目前暂定为60秒
    private let expireTime:Int! = 5
    
    //MARK: - @IBAction
    @IBAction func segmentedDidChange(sender:UISegmentedControl,forEvent:UIEvent?){
        changePages(pageIndex: sender.selectedSegmentIndex)
    }
    
    @IBAction func updateNetworkData(sender:UIButton,forEvent:UIEvent?){
        SwiftSpinner.show("正在刷新天气...", animated: true)
        delay(seconds: 2.0, completion: {
            self.requestForWeather(httpUrl: self.forecast_url, httpArg: self.cityNameID)
            SwiftSpinner.hide()
        })
        let updateTimeLabel = self.pageScroller.viewWithTag(1000) as! UILabel
        let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        self.updateTime = timeStamp
        updateTimeLabel.text = "更新时间：" + timeStampToString(String(Int(self.updateTime!)))
        
    }
    
    //MARK: - Override From SuperView
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        selectedPage.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont(name: GLOBAL_appFont!, size: 12.0)!], for: UIControlState())
        selectedPage.addTarget(self, action: #selector(WeatherViewController.segmentedDidChange(sender:forEvent:)), for: .valueChanged)
        pageScroller.delegate = self
        pageScroller.backgroundColor = UIColor.yellow
        prepareForScrollPages()
        createPage_today()
        createPage_forecast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //获取当前系统时间戳
        let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = cachePath! + "/Weather"
        let fileArr = FileManager.default.subpaths(atPath: path)
        if fileArr?.isEmpty == false{
            print(fileArr!)
            //获取历史最新的缓存文件名，即时间戳
            var lastUpdateFileName = fileArr?.last
            lastUpdateFileName = lastUpdateFileName?.replacingOccurrences(of: ".plist", with: "")
            let lastUpdateTimeStamp = Int(lastUpdateFileName!)
            self.updateTime = Int(lastUpdateFileName!)
            
            //设置缓存过期时间，防止多次不必要的刷新，暂定过期时间为60秒
            if timeStamp - lastUpdateTimeStamp! > self.expireTime{
                SwiftSpinner.show("正在刷新天气...", animated: true)
                delay(seconds: 2.0, completion: {
                    self.requestForWeather(httpUrl: self.forecast_url, httpArg: self.cityNameID)
                    SwiftSpinner.hide()
                })
            }
            let updateTimeLabel = self.pageScroller.viewWithTag(1000) as! UILabel
            updateTimeLabel.text = "更新时间：" + timeStampToString(String(Int(self.updateTime!)))
        }
        else{
            SwiftSpinner.show("正在刷新天气...", animated: true)
            delay(seconds: 2.0, completion: {
                self.requestForWeather(httpUrl: self.forecast_url, httpArg: self.cityNameID)
                SwiftSpinner.hide()
            })
            self.updateTime = timeStamp
            let updateTimeLabel = self.pageScroller.viewWithTag(1000) as! UILabel
            updateTimeLabel.text = "更新时间：" + timeStampToString(String(Int(self.updateTime!)))
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private Func
    private func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    private func prepareForScrollPages(){
        let backgroundName = ["","Beach.JPG","Forest.JPG"]
        for i in 1..<3 {
            let image = UIImage(named: backgroundName[i])
            let x = CGFloat(i - 1) * self.view.frame.width
            let backImage = UIImageView(frame: CGRect(x: x, y: 0, width: self.view.frame.width, height: (pageScroller.bounds.height)))
            backImage.contentMode = .scaleToFill
            
            //设置图片背景模糊化的部分，因为在模拟器上GPU负担很大，在真机上测试时取消该代码段注释
            //            let ciImage = CIImage(image: image!)
            //            let filterMirror = CIFilter(name: "CIDepthOfField")
            //            filterMirror?.setValue(ciImage, forKey: kCIInputImageKey)
            //            let filterImage = filterMirror?.value(forKey: kCIOutputImageKey)
            //            let context = CIContext(options: nil)
            //            let cgImage = context.createCGImage(filterImage as! CIImage, from: (backImage.frame))
            //            backImage.image = UIImage(cgImage: cgImage!)
            backImage.image = image
            
            pageScroller.isPagingEnabled = true
            pageScroller.showsHorizontalScrollIndicator = false
            pageScroller.showsVerticalScrollIndicator = false
            pageScroller.isScrollEnabled = true
            pageScroller.bounces = false
            pageScroller.alwaysBounceVertical = false
            pageScroller.alwaysBounceHorizontal = false
            pageScroller.addSubview(backImage)
            
        }
        
        let i = 3
        pageScroller.contentSize = CGSize(width: (self.view.frame.width * CGFloat(i - 1)), height: 0)
        pageDots = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.midX - 25, y: self.view.frame.maxY - 100, width: 50, height: 50))
        pageDots.numberOfPages = i - 1
        pageDots.currentPageIndicatorTintColor = UIColor.lightGray
        pageDots.pageIndicatorTintColor = UIColor.white
        pageScroller.superview?.addSubview(pageDots)
    }
    
    private func changePages(pageIndex:Int) {
        let offsetX = CGFloat(pageIndex) * self.view.frame.width
        print("offset:\(offsetX)")
        //每一页的x轴的起点,重要！！！
        pageScroller.setContentOffset(CGPoint(x: offsetX, y: pageScroller.bounds.origin.y), animated: true)
    }
    
    private func createPage_today(){
        self.pageOffSetOriginX = CGFloat(0) * self.view.frame.width
        let xx = self.pageOffSetOriginX!
        
        //尺寸目前按照iPhone6s设计,后续屏幕适配再定
        
        //刷新按钮
        let refreshButton = UIButton(frame: CGRect(x: xx, y: 0, width: 30, height: 30))
        refreshButton.center.x = self.view.frame.maxX - 30
        refreshButton.center.y = 25
        refreshButton.setImage(UIImage(named: "Cloud-Refresh.png"), for: .normal)
        refreshButton.addTarget(self, action: #selector(WeatherViewController.updateNetworkData(sender:forEvent:)), for: .touchUpInside)
        self.pageScroller.addSubview(refreshButton)
        
        //上次刷新时间
        let updateTimeLabel = UILabel(frame: CGRect(x: xx, y: 0, width: 200, height: 30))
        updateTimeLabel.center.x = refreshButton.center.x - 120
        updateTimeLabel.center.y = refreshButton.center.y
        updateTimeLabel.textColor = UIColor.white
        
        if self.updateTime != nil{
            updateTimeLabel.text = "更新时间：" + timeStampToString(String(Int(self.updateTime!)))
        }
        else {
            updateTimeLabel.text = "暂无最新数据"
        }
        updateTimeLabel.font = UIFont(name: GLOBAL_appFont!, size: 11)
        self.pageScroller.addSubview(updateTimeLabel)
        updateTimeLabel.tag = 1000
        updateTimeLabel.textAlignment = .right
        
        //设置天气类型特征图(基准)
        let weatherTypeImageView = UIImageView(frame: CGRect(x: xx + UIScreen.main.bounds.midX - 50, y: self.view.center.y - 150, width: 100, height: 100))
        weatherTypeImageView.image = UIImage(named: "sunny.png")
        weatherTypeImageView.contentMode = .scaleToFill
        self.pageScroller.addSubview(weatherTypeImageView)
        
        //城市名称标签
        let cityNameLabel = UILabel(frame: CGRect(x: xx, y: 0, width: 150, height: 100))
        cityNameLabel.center.x = weatherTypeImageView.center.x
        cityNameLabel.center.y = weatherTypeImageView.center.y - 120
        cityNameLabel.text = "南宁市"
        cityNameLabel.textColor = UIColor.white
        cityNameLabel.textAlignment = .center
        cityNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 40)
        self.pageScroller.addSubview(cityNameLabel)
        
        //天气类型标签
        let typeLabel = UILabel(frame: CGRect(x: xx, y: 0, width: 150, height: 30))
        typeLabel.center.x = weatherTypeImageView.center.x
        typeLabel.center.y = weatherTypeImageView.center.y - 70
        typeLabel.textColor = UIColor.white
        typeLabel.text = "大部晴朗"
        typeLabel.textAlignment = .center
        typeLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        self.pageScroller.addSubview(typeLabel)
        
        //当前温度标签
        let curTempLabel = UILabel(frame: CGRect(x: xx, y: 0, width: 150, height: 100))
        curTempLabel.center.x = weatherTypeImageView.center.x
        curTempLabel.center.y = weatherTypeImageView.center.y + 100
        curTempLabel.text = "18℃"
        curTempLabel.textColor = UIColor.white
        curTempLabel.font = UIFont(name: "AvenirNext-Regular", size: 60)
        curTempLabel.textAlignment = .center
        self.pageScroller.addSubview(curTempLabel)
    }
    
    private func createPage_forecast(){
        
    }
    
    
    
    private func requestForWeather(httpUrl: String, httpArg: String){
        var req = URLRequest(url: NSURL(string: httpUrl + "?" + httpArg)! as URL)
        req.timeoutInterval = 3.0
        req.httpMethod = "GET"
        req.addValue(baiduAPIKey, forHTTPHeaderField: "apikey")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: req,completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                let sheet = UIAlertController(title: "天气信息请求超时", message: error.debugDescription, preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                self.present(sheet, animated: true, completion: nil)
                
            }else{
                let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
                let path = NSURL(fileURLWithPath: cachePath! + "/Weather", isDirectory: true)
                
                try?FileManager.default.createDirectory(at: path as URL, withIntermediateDirectories: false, attributes: nil)
                
                let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
                let timeStamp = Int(timeInterval)
                self.updateTime = timeStamp
                let json = JSON(data: data!)
                
                //按刷新的时间戳命名，写入缓存plist
                let newPath = path.appendingPathComponent("\(timeStamp).plist")
                NSDictionary(dictionary: json.dictionaryObject!).write(to: newPath! as URL, atomically: true)
                
                //对当前天气JSON数据进行解析
                let today_rawData = json["retData"]["today"]
                let today_Dictionary = today_rawData.dictionary!
                
                let curTemp = today_Dictionary["curTemp"]! as JSON
                let date = today_Dictionary["date"]! as JSON
                let fengxiang = today_Dictionary["fengxiang"]! as JSON
                let fengli = today_Dictionary["fengli"]! as JSON
                let hightemp = today_Dictionary["hightemp"]! as JSON
                let lowtemp = today_Dictionary["lowtemp"]! as JSON
                let type = today_Dictionary["type"]! as JSON
                let week = today_Dictionary["week"]! as JSON
                
                self.today_DataSource = WeatherDataSource(windLevel: fengli.stringValue, currentTemp: curTemp.stringValue, week: week.stringValue, date: date.stringValue, highTemp: hightemp.stringValue, lowTemp: lowtemp.stringValue, windDirection: fengxiang.stringValue, type: type.stringValue)
                
                //对预报JSON数据进行解析,4天？
                let forcast_rawData = json["retData"]["forecast"]
                let forcast_Array = forcast_rawData.array! as [JSON]
                for day_dic in forcast_Array{
                    let fengli = day_dic["fengli"].stringValue
                    let date = day_dic["date"].stringValue
                    let fengxiang = day_dic["fengxiang"].stringValue
                    let lowtemp = day_dic["lowtemp"].stringValue
                    let hightemp = day_dic["hightemp"].stringValue
                    let type = day_dic["type"].stringValue
                    let week = day_dic["week"].stringValue
                    
                    let newElement = WeatherDataSource(windLevel: fengli, currentTemp: nil, week: week, date: date, highTemp: hightemp, lowTemp: lowtemp, windDirection: fengxiang, type: type)
                    self.forcast_DataSource.append(newElement)
                }
                
                let sheet = UIAlertController(title: "今日南宁天气",message: "日期：\(self.today_DataSource.date!)\n类型：\(self.today_DataSource.type!)\n当前温度：\(self.today_DataSource.currentTemp!)\n最高温度：\(self.today_DataSource.highTemp!)\n最低温度：\(self.today_DataSource.lowTemp!)\n风力：\(self.today_DataSource.windLevel!)\n风向：\(self.today_DataSource.windDirection!)", preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                self.present(sheet, animated: true, completion: nil)
                
            }
        }) as URLSessionTask
        
        dataTask.resume()
    }
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = self.view.frame.width
        let offsetX = scrollView.contentOffset.x
        let index = (offsetX + width / 2) / width
        pageDots.currentPage = Int(index)
        switch pageDots.currentPage {
        case 0:
            self.selectedPage.selectedSegmentIndex = 0
        case 1:
            self.selectedPage.selectedSegmentIndex = 1
        default:
            self.selectedPage.selectedSegmentIndex = 1
            
        }
        
    }
}
