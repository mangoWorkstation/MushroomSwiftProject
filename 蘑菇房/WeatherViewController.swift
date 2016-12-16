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
    
    let weatherType = ["晴","多云","阴","阵雨","雷阵雨","雷阵雨伴有冰雹","雨夹雪","小雨","中雨","大雨","暴雨","大暴雨","特大暴雨","阵雪","小雪","中雪","大雪","暴雪","雾","冻雨","沙尘暴","小到中雨","中到大雨","大到暴雨","暴雨到大暴雨","大暴雨到特大暴雨","小到中雪","中到大雪","大到暴雪","浮尘","扬沙","强沙尘暴","霾","无"]
    
    @IBOutlet weak var selectedPage: UISegmentedControl!
    
    @IBOutlet weak var pageScroller: UIScrollView!
    
    private var pageDots: UIPageControl!
    
    private var pageDotsView:UIView!
    
    private var today_DataSource : WeatherDataSource!
    
    private var forcast_DataSource:[WeatherDataSource] = []
    
    private var pageOffSetOriginX:CGFloat!
    
    private var updateTime:Int?
    
    //缓存需要过期时间：目前暂定为10秒，便于测试
    private let expireTime:Int! = 10
    
    //MARK: - @IBAction
    @IBAction func segmentedDidChange(sender:UISegmentedControl,forEvent:UIEvent?){
        changePages(pageIndex: sender.selectedSegmentIndex)
    }
    @IBAction func pageDotsDidChange(sender:UIPageControl,forEvent:UIEvent?){
        changePages(pageIndex: sender.currentPage)
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
        updateTimeLabel.text = "更新时间：" + timeStampToSpecificTime(String(Int(self.updateTime!)))
//        updatePage_today()
        
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
        setDefaultValue_today()
        
        createPage_forecast()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            
            //设置缓存过期时间，防止多次不必要的刷新
            if timeStamp - lastUpdateTimeStamp! > self.expireTime{
                SwiftSpinner.show("正在刷新天气...", animated: true)
                delay(seconds: 2.0, completion: {
                    self.requestForWeather(httpUrl: self.forecast_url, httpArg: self.cityNameID)
                    SwiftSpinner.hide()
                })
            }
        }
        else{
            SwiftSpinner.show("正在更新天气...", animated: true)
            delay(seconds: 2.0, completion: {
                self.requestForWeather(httpUrl: self.forecast_url, httpArg: self.cityNameID)
                SwiftSpinner.hide()
            })
            self.updateTime = timeStamp
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
        let backgroundName = ["","Beach.JPG","StoneRidges.JPG"]
        for i in 1..<3 {
            let image = UIImage(named: backgroundName[i])?.applyBlur(withRadius: 10, tintColor: UIColor(white: 0.3, alpha: 0.3), saturationDeltaFactor: 1.8)
            //模糊化处理
            let x = CGFloat(i - 1) * self.view.frame.width
            let backImage = UIImageView(frame: CGRect(x: x, y: 0, width: self.view.frame.width, height: (pageScroller.bounds.height)))
            backImage.contentMode = .scaleToFill
            
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
        pageDots.addTarget(self, action: #selector(WeatherViewController.pageDotsDidChange(sender:forEvent:)), for: .touchUpInside)
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
        let refreshButton = UIButton(frame: CGRect(x: xx, y: 0, width: 20, height: 20))
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
        

        updateTimeLabel.font = UIFont(name: "AvenirNext-Regular", size: 11)
        self.pageScroller.addSubview(updateTimeLabel)
        updateTimeLabel.tag = 1000
        updateTimeLabel.textAlignment = .right
        
        //设置天气类型特征图(基准)
        let weatherTypeImageView = UIImageView(frame: CGRect(x: xx + UIScreen.main.bounds.midX - 50, y: self.view.center.y - 150, width: 100, height: 100))
        weatherTypeImageView.contentMode = .scaleToFill
        weatherTypeImageView.tag = 1001
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
        typeLabel.textAlignment = .center
        typeLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        typeLabel.tag = 1002
        self.pageScroller.addSubview(typeLabel)
        
        //当前温度标签
        let curTempLabel = UILabel(frame: CGRect(x: xx, y: 0, width: 150, height: 100))
        curTempLabel.center.x = weatherTypeImageView.center.x
        curTempLabel.center.y = weatherTypeImageView.center.y + 100
        curTempLabel.textColor = UIColor.white
        curTempLabel.font = UIFont(name: "AvenirNext-Regular", size: 60)
        curTempLabel.textAlignment = .center
        curTempLabel.tag = 1003
        self.pageScroller.addSubview(curTempLabel)
        
        //详细天气预报 （屏幕左侧+40px）
        let highTempLabel = UILabel(frame: CGRect(x: self.view.frame.midX - 137, y: curTempLabel.center.y + 40, width: 50, height: 30))
        highTempLabel.text = "最高"
        highTempLabel.textColor = UIColor.white
        highTempLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        self.pageScroller.addSubview(highTempLabel)
        
        let highTempNUM = UILabel(frame: CGRect(x: highTempLabel.frame.midX + 10, y: highTempLabel.center.y + 5, width: 100, height: 35))
        highTempNUM.textColor = UIColor.white
        highTempNUM.font = UIFont(name: "AvenirNext-Regular", size: 30)
        highTempNUM.tag = 1004
        self.pageScroller.addSubview(highTempNUM)
        
        let lowTempLabel = UILabel(frame: CGRect(x: self.view.frame.midX - 137, y: highTempLabel.center.y + 70, width: 50, height: 30))
        lowTempLabel.text = "最低"
        lowTempLabel.textColor = UIColor.white
        lowTempLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        self.pageScroller.addSubview(lowTempLabel)
        
        let lowTempNUM = UILabel(frame: CGRect(x: lowTempLabel.frame.midX + 10, y: lowTempLabel.center.y + 5, width: 100, height: 35))
        lowTempNUM.textColor = UIColor.white
        lowTempNUM.font = UIFont(name: "AvenirNext-Regular", size: 30)
        lowTempNUM.tag = 1005
        self.pageScroller.addSubview(lowTempNUM)
        
        //日期(屏幕中心+5)
        let date = UILabel(frame: CGRect(x: self.view.frame.midX + 5, y: highTempLabel.center.y + 20, width: 250, height: 30))
        date.center.y = highTempLabel.center.y
        date.textColor = UIColor.white
        date.font = UIFont(name: "AvenirNext-Regular", size: 22)
        date.tag = 1006
        self.pageScroller.addSubview(date)
        
        //风力风向
        let windImage = UIImageView(frame: CGRect(x:date.frame.minX, y: 0, width: 70, height: 70))
        windImage.center.y = lowTempLabel.center.y - 5
        windImage.image = UIImage(named: "Wind_Flag_151px.png")?.withRenderingMode(.alwaysOriginal)
        windImage.contentMode = .scaleToFill
        self.pageScroller.addSubview(windImage)
        
        let windLevelLabel = UILabel(frame: CGRect(x: windImage.frame.maxX + 5, y: 0, width: 90, height: 30))
        windLevelLabel.center.y = windImage.center.y - 10
        windLevelLabel.textColor = UIColor.white
        windLevelLabel.font = UIFont(name: "AvenirNext-Regular", size: 17)
        windLevelLabel.tag = 1007
        self.pageScroller.addSubview(windLevelLabel)
        
        let windDirectionLabel = UILabel(frame: CGRect(x: windLevelLabel.frame.minX, y: 0, width: 90, height: 30))
        windDirectionLabel.center.y = windLevelLabel.frame.maxY + 20
        windDirectionLabel.textColor = UIColor.white
        windDirectionLabel.font = UIFont(name: "AvenirNext-Regular", size: 17)
        windDirectionLabel.tag = 1008
        self.pageScroller.addSubview(windDirectionLabel)
        
//        tag汇总
//        1000：刷新时间
//        1001：天气类型标记
//        1002：天气类型
//        1003：当前温度
//        1004：最高温
//        1005：最低温
//        1006：日期
//        1007：风力
//        1008：风向
        
    }
    
    private func setDefaultValue_today(){
        let userDefault = UserDefaults()
        if userDefault.object(forKey: "LatestWeatherCache") != nil{
            let content = userDefault.object(forKey: "LatestWeatherCache") as! Data
            self.today_DataSource = NSKeyedUnarchiver.unarchiveObject(with: content as Data) as! WeatherDataSource
            self.updateTime = userDefault.object(forKey: "LatestWeatherUpdateTime") as! Int?
            updatePage_today()
        }
        else{
            
            let updateTime = self.pageScroller.viewWithTag(1000) as! UILabel
            updateTime.text = "更新时间：暂无最新数据"
            let weatherTypeImageView = self.pageScroller.viewWithTag(1001) as! UIImageView
            weatherTypeImageView.image = UIImage(named: "dunno.png")
            let typeLabel = self.pageScroller.viewWithTag(1002) as! UILabel
            typeLabel.text = "暂无天气类型"
            let curTempNUM = self.pageScroller.viewWithTag(1003) as! UILabel
            curTempNUM.text = "NaN"
            let lowTempNUM = self.pageScroller.viewWithTag(1004) as! UILabel
            lowTempNUM.text = "NaN"
            let highTemp = self.pageScroller.viewWithTag(1005) as! UILabel
            highTemp.text = "NaN"
            let date = self.pageScroller.viewWithTag(1006) as! UILabel
            date.text = "YYYY - mm - dd"
            let windLevelLabel = self.pageScroller.viewWithTag(1007) as! UILabel
            windLevelLabel.text = "暂无风力数据"
            let windDirectionLabel = self.pageScroller.viewWithTag(1008) as! UILabel
            windDirectionLabel.text = "暂无风向数据"
        }
    }
    
    private func updatePage_today(){
        let updateTimeLabel = self.pageScroller.viewWithTag(1000) as! UILabel
        updateTimeLabel.text = "更新时间：" + timeStampToSpecificTime(String(Int(self.updateTime!)))
        
        //获取当前时刻,白天或者晚上
        let time = timeStampToTime((String(Int(self.updateTime!)))).components(separatedBy: ":")
        let hour = Int(time.first!)
        var hourIndicator = ""
        if hour!>=7 && hour!<=18{
            hourIndicator = "day_"
        }
        else{
            hourIndicator = "night_"
        }
        
        let typeLabel = self.pageScroller.viewWithTag(1002) as! UILabel
        typeLabel.text = "\(self.today_DataSource.type!)"
        //判断天气类型,决定天气标志
        var typeCode = 0
        switch self.today_DataSource.type! {
        case self.weatherType[0]:
            typeCode = 0
        case self.weatherType[1]:
            typeCode = 1
        case self.weatherType[2]:
            typeCode = 2
        case self.weatherType[3]:
            typeCode = 3
        case self.weatherType[4]:
            typeCode = 4
        case self.weatherType[5]:
            typeCode = 5
        case self.weatherType[6]:
            typeCode = 6
        case self.weatherType[7]:
            typeCode = 7
        case self.weatherType[8]:
            typeCode = 8
        case self.weatherType[9]:
            typeCode = 9
        case self.weatherType[10]:
            typeCode = 10
        case self.weatherType[11]:
            typeCode = 11
        case self.weatherType[12]:
            typeCode = 12
        case self.weatherType[13]:
            typeCode = 13
        case self.weatherType[14]:
            typeCode = 14
        case self.weatherType[15]:
            typeCode = 15
        case self.weatherType[16]:
            typeCode = 16
        case self.weatherType[17]:
            typeCode = 17
        case self.weatherType[18]:
            typeCode = 18
        case self.weatherType[19]:
            typeCode = 19
        case self.weatherType[20]:
            typeCode = 20
        case self.weatherType[21]:
            typeCode = 21
        case self.weatherType[22]:
            typeCode = 22
        case self.weatherType[23]:
            typeCode = 23
        case self.weatherType[24]:
            typeCode = 24
        case self.weatherType[25]:
            typeCode = 25
        case self.weatherType[26]:
            typeCode = 26
        case self.weatherType[27]:
            typeCode = 27
        case self.weatherType[28]:
            typeCode = 28
        case self.weatherType[29]:
            typeCode = 29
        case self.weatherType[30]:
            typeCode = 30
        case self.weatherType[31]:
            typeCode = 31
        case self.weatherType[32]:
            typeCode = 32
        default:
            typeCode = -1
            
        }
        var weatherImageFileName:String
        if typeCode == -1{
            weatherImageFileName = "dunno"
        }
        else{
            weatherImageFileName = hourIndicator.appending(String(typeCode))
        }
        let weatherTypeImageView = self.pageScroller.viewWithTag(1001) as! UIImageView
        weatherTypeImageView.image = UIImage(named: "\(weatherImageFileName).png")
        let curTempNUM = self.pageScroller.viewWithTag(1003) as! UILabel
        curTempNUM.text = "\(self.today_DataSource.currentTemp!)"
        let lowTempNUM = self.pageScroller.viewWithTag(1005) as! UILabel
        lowTempNUM.text = "\(self.today_DataSource.lowTemp!)"
        let highTempNUM = self.pageScroller.viewWithTag(1004) as! UILabel
        highTempNUM.text = "\(self.today_DataSource.highTemp!)"
        let date = self.pageScroller.viewWithTag(1006) as! UILabel
        date.text = timeStampToDate(String(Int(self.updateTime!)))
        let windLevelLabel = self.pageScroller.viewWithTag(1007) as! UILabel
        windLevelLabel.text = "\(self.today_DataSource.windLevel!)"
        let windDirectionLabel = self.pageScroller.viewWithTag(1008) as! UILabel
        windDirectionLabel.text = "\(self.today_DataSource.windDirection!)"
        
    }
    
    private func createPage_forecast(){
        
    }
    
    
    
    private func requestForWeather(httpUrl: String, httpArg: String){
        var req = URLRequest(url: NSURL(string: httpUrl + "?" + httpArg)! as URL)
        req.timeoutInterval = 4.0
        req.httpMethod = "GET"
        req.addValue(baiduAPIKey, forHTTPHeaderField: "apikey")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: req,completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                let sheet = UIAlertController(title: "天气信息请求超时", message: error?.localizedDescription, preferredStyle: .alert)
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
                
//                let sheet = UIAlertController(title: "今日南宁天气",message: "日期：\(self.today_DataSource.date!)\n类型：\(self.today_DataSource.type!)\n当前温度：\(self.today_DataSource.currentTemp!)\n最高温度：\(self.today_DataSource.highTemp!)\n最低温度：\(self.today_DataSource.lowTemp!)\n风力：\(self.today_DataSource.windLevel!)\n风向：\(self.today_DataSource.windDirection!)", preferredStyle: .alert)
//                sheet.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
//                self.present(sheet, animated: true, completion: nil)
                
            }
        }) as URLSessionTask
        
        dataTask.resume()
        
        if self.today_DataSource != nil{
            let userDefault = UserDefaults()
            userDefault.removeObject(forKey: "LatestWeatherCache")
            userDefault.removeObject(forKey: "LatestWeatherUpdateTime")
            let userSaved = NSKeyedArchiver.archivedData(withRootObject: self.today_DataSource)
            userDefault.set(userSaved, forKey: "LatestWeatherCache")
            userDefault.set(self.updateTime, forKey: "LatestWeatherUpdateTime")
            userDefault.synchronize()
            self.updatePage_today()
        }

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

