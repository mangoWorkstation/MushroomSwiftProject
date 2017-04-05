//
//  WeatherViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UIScrollViewDelegate {
    
//    let forecast_url = "http://apis.baidu.com/apistore/weatherservice/recentweathers"
//    let cityNameID = "cityname=%E5%8D%97%E5%AE%81&cityid=101300101"
//    let baiduAPIKey = "d596f298898e51557c9d3e93f143c74d"
    
    let weatherType = ["晴","多云","阴","阵雨","雷阵雨","雷阵雨伴有冰雹","雨夹雪","小雨","中雨","大雨","暴雨","大暴雨","特大暴雨","阵雪","小雪","中雪","大雪","暴雪","雾","冻雨","沙尘暴","小到中雨","中到大雨","大到暴雨","暴雨到大暴雨","大暴雨到特大暴雨","小到中雪","中到大雪","大到暴雪","浮尘","扬沙","强沙尘暴","霾","无"]
    
    @IBOutlet weak var selectedPage: UISegmentedControl!
    
    @IBOutlet weak var pageScroller: UIScrollView!
    
    private var pageDots: UIPageControl!
    
    private var pageDotsView:UIView!
    
    private var today_DataSource : WeatherDataSource! = WeatherDataSource()
    
    private var forcast_DataSource:[WeatherDataSource] = []
    
    private var pageOffSetOriginX:CGFloat!
    
    private var updateTime:Int?
    
    private var isOnceLoaded = true
    
    //缓存需要过期时间：目前暂定为10秒，便于测试
    private let expireTime:Int! = 1800
    
    private var forecastChart : Chart!
    
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
            self.requestForWeather()
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
        
        createAndUpdatePage_forecast()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //获取当前系统时间戳
        let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = cachePath! + "/Weather/today"
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
                    self.requestForWeather()
                    SwiftSpinner.hide()
                })
            }
            else{
                setDefaultValue_today()
            }
        }
        else{
            SwiftSpinner.show("正在更新天气...", animated: true)
            delay(seconds: 2.0, completion: {
                self.requestForWeather()
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
        let backgroundName = ["","Beach.JPG","Bliss.JPG"]
        for i in 1..<3 {
            //模糊化处理
            let image = (UIImage(named: backgroundName[i])?.applyBlur(withRadius: 10, tintColor: UIColor(white: 0.3, alpha: 0.3), saturationDeltaFactor: 1.8))!
            let x = CGFloat(i - 1) * self.view.frame.width
            let backImage = UIImageView(frame: CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height))
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
        pageDots.currentPageIndicatorTintColor = UIColor.white
        pageDots.pageIndicatorTintColor = UIColor.lightGray
        pageDots.addTarget(self, action: #selector(WeatherViewController.pageDotsDidChange(sender:forEvent:)), for: .touchUpInside)
        pageScroller.superview?.addSubview(pageDots)
    }
    
    private func changePages(pageIndex:Int) {
        let offsetX = CGFloat(pageIndex) * self.view.frame.width
        //每一页的x轴的起点,重要！！！
        pageScroller.setContentOffset(CGPoint(x: offsetX, y: pageScroller.bounds.origin.y), animated: true)
    }
    
    private func createPage_today(){
        self.pageOffSetOriginX = CGFloat(0) * self.view.frame.width
        let xx = self.pageOffSetOriginX!
        
        //尺寸目前按照iPhone6s设计,后续屏幕适配再定
        
        //刷新按钮
        let refreshButton = UIButton(frame: CGRect(x: xx, y: 0, width: 25, height: 25))
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
        
        //城市名称标签
        let cityNameLabel = UILabel(frame: CGRect(x: xx, y: 0, width: 150, height: 100))
        cityNameLabel.center.x = weatherTypeImageView.center.x
        cityNameLabel.center.y = weatherTypeImageView.center.y - 120
        cityNameLabel.tag = 1009
        cityNameLabel.textColor = UIColor.white
        cityNameLabel.textAlignment = .center
        cityNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 40)
        self.pageScroller.addSubview(cityNameLabel)

        
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
        if userDefault.object(forKey: "LatestTodayWeatherCache") != nil{
            let content = userDefault.object(forKey: "LatestTodayWeatherCache") as! Data
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
            curTempNUM.text = "N/A"
            let lowTempNUM = self.pageScroller.viewWithTag(1004) as! UILabel
            lowTempNUM.text = "N/A"
            let highTemp = self.pageScroller.viewWithTag(1005) as! UILabel
            highTemp.text = "N/A"
            let date = self.pageScroller.viewWithTag(1006) as! UILabel
            date.text = "YYYY - mm - dd"
            let windLevelLabel = self.pageScroller.viewWithTag(1007) as! UILabel
            windLevelLabel.text = "暂无风力数据"
            let windDirectionLabel = self.pageScroller.viewWithTag(1008) as! UILabel
            windDirectionLabel.text = "暂无风向数据"
            let cityLabel = self.pageScroller.viewWithTag(1009) as! UILabel
            cityLabel.text = "暂未获取当前定位"
        }
    }
    
    private func updatePage_today(){
        let updateTimeLabel = self.pageScroller.viewWithTag(1000) as! UILabel
        updateTimeLabel.text = "更新时间：" + timeStampToSpecificTime(String(Int(self.updateTime!)))
        
        //获取当前时刻,白天或者晚上
        let time = timeStampToTime((String(Int(self.updateTime!)))).components(separatedBy: ":")
        let hour = Int(time.first!)
        var hourIndicator:Bool
        if hour!>7 && hour!<18{
            hourIndicator = true
        }
        else{
            hourIndicator = false
        }
        
        
        //判断天气类型,决定天气标志
        let weatherTypeImageView = self.pageScroller.viewWithTag(1001) as! UIImageView
        if hourIndicator{
            let name = self.today_DataSource.code_day
            if name != nil{
                if Int(name!)!<10{
                    weatherTypeImageView.image = UIImage(named: "0\(name!)")
                }
                else{
                    weatherTypeImageView.image = UIImage(named: "\(name!)")
                }
            }
        }
        else{
            let name = self.today_DataSource.code_night
            if name != nil{
                if Int(name!)!<10{
                    weatherTypeImageView.image = UIImage(named: "0\(name!)")
                }
                else{
                    weatherTypeImageView.image = UIImage(named: "\(name!)")
                }
            }


        }
        
    
        let typeLabel = self.pageScroller.viewWithTag(1002) as! UILabel
        typeLabel.text = self.today_DataSource.type_day
        
        let curTempNUM = self.pageScroller.viewWithTag(1003) as! UILabel
        curTempNUM.text = "\(self.today_DataSource.currentTemp!)º"

        let lowTempNUM = self.pageScroller.viewWithTag(1005) as! UILabel
        lowTempNUM.text = "\(self.today_DataSource.lowTemp!)º"

        let highTempNUM = self.pageScroller.viewWithTag(1004) as! UILabel
        highTempNUM.text = "\(self.today_DataSource.highTemp!)º"

        let date = self.pageScroller.viewWithTag(1006) as! UILabel
        date.text = timeStampToDate(String(Int(self.updateTime!)))

        let windLevelLabel = self.pageScroller.viewWithTag(1007) as! UILabel
        windLevelLabel.text = "风力：\(self.today_DataSource.windLevel!)级"

        let windDirectionLabel = self.pageScroller.viewWithTag(1008) as! UILabel
        windDirectionLabel.text = "风向：\(self.today_DataSource.windDirection!)风"
        if (windDirectionLabel.text?.characters.count)!>5{
            windDirectionLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        }
        
        let cityLabel = self.pageScroller.viewWithTag(1009) as! UILabel
        cityLabel.text = self.today_DataSource.location!

        
        //动画更新UI,淡入淡出效果
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                
                weatherTypeImageView.alpha = 1
                curTempNUM.alpha = 1
                lowTempNUM.alpha = 1
                highTempNUM.alpha = 1
                date.alpha = 1
                windLevelLabel.alpha = 1
                windDirectionLabel.alpha = 1
                typeLabel.alpha = 1
                
                UIView.animate(withDuration: 4, delay: 2, options: .curveEaseInOut, animations: {
                    weatherTypeImageView.alpha = 0
                    curTempNUM.alpha = 0
                    lowTempNUM.alpha = 0
                    highTempNUM.alpha = 0
                    date.alpha = 0
                    windLevelLabel.alpha = 0
                    windDirectionLabel.alpha = 0
                    typeLabel.alpha = 0
                })
                
                UIView.animate(withDuration: 2, delay: 2, options: .curveEaseIn, animations: {
                }, completion: {
                    (finished)->Void in
                    UIView.animate(withDuration: 2, animations: {
                        weatherTypeImageView.alpha = 1
                        curTempNUM.alpha = 1
                        lowTempNUM.alpha = 1
                        highTempNUM.alpha = 1
                        date.alpha = 1
                        windLevelLabel.alpha = 1
                        windDirectionLabel.alpha = 1
                        typeLabel.alpha = 1
                        
                        
                    })
                })
            }
        }
        
    }
    
    //UI部分已经适配全机型 2017/1/12
    private func createAndUpdatePage_forecast(){
        self.pageOffSetOriginX = CGFloat(1) * self.view.frame.width
        let xx = self.pageOffSetOriginX!
        
        let labelSettings = ChartLabelSettings(font: UIFont(name: "AvenirNext-Regular", size: 14)!,fontColor:UIColor.white)
        //反转数据符号用,临时
        func convertSign(_ num:Double)->Double{
            return -num
        }
        
        var barsData:[(title: String, min: Double, max: Double)] = []
        if self.forcast_DataSource.isEmpty == false{
            //获取日期
            var labels : [String] = []
            for singleday in self.forcast_DataSource{
                var month = singleday.date?.components(separatedBy: "-")[1]
                var day = singleday.date?.components(separatedBy: "-")[2]
                //去“0”操作
                if Int(month!)! < 10{
                    month = month?.replacingOccurrences(of: "0", with: "")
                }
                if Int(day!)! < 10{
                    day = day?.replacingOccurrences(of: "0", with: "")
                }
                let newLabel = month! + "月" + day! + "日"
                labels.append(newLabel)
            }
            
            var count = 0
            for singleDay in self.forcast_DataSource{
                var label = labels[count]
                if count == 0{
                    label = "今天"
                }
                let barData = (label, convertSign(Double(singleDay.lowTemp!.replacingOccurrences(of: "℃", with: ""))!), Double(singleDay.highTemp!.replacingOccurrences(of: "℃", with: ""))!)
                barsData.append(barData as (title: String, min: Double, max: Double))
                count += 1

            }
        }
        else{
            let userDefault = UserDefaults()
            if userDefault.object(forKey: "LatestForecastWeatherCache") != nil{
                let content = userDefault.object(forKey: "LatestForecastWeatherCache") as! Data
                self.forcast_DataSource = NSKeyedUnarchiver.unarchiveObject(with: content as Data) as! [WeatherDataSource]
                //获取月份
                var month = self.today_DataSource.date?.components(separatedBy: "-")[1]
                //去“0”操作
                if Int(month!)! < 10{
                    month = month?.replacingOccurrences(of: "0", with: "")
                }
                var count = 0
                for singleDay in self.forcast_DataSource{
                    var label = month! + "月" + singleDay.date!
                    if count == 0{
                        label = "今天"
                    }
                    let barData = (label, convertSign(Double(singleDay.lowTemp!.replacingOccurrences(of: "℃", with: ""))!), Double(singleDay.highTemp!.replacingOccurrences(of: "℃", with: ""))!)
                    barsData.append(barData as (title: String, min: Double, max: Double))
                    count += 1
                }
                
            }
        }
        
        let posColor = UIColor(red: 64/255, green: 204/255, blue: 32/255, alpha: 0.7)
        let negColor = UIColor(red: 88/255, green: 188/255, blue: 241/255, alpha: 0.7)
        let zero = ChartAxisValueDouble(0)
        let bars: [ChartBarModel] = barsData.enumerated().flatMap {index, tuple in
            [
                ChartBarModel(constant: ChartAxisValueDouble(index), axisValue1: zero, axisValue2: ChartAxisValueDouble(tuple.min), bgColor: negColor),
                ChartBarModel(constant: ChartAxisValueDouble(index), axisValue1: zero, axisValue2: ChartAxisValueDouble(tuple.max), bgColor: posColor)
            ]
        }
        
        
        
        let yValues = stride(from: (-40), through: 40, by: 5).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
        let xValues =
            [ChartAxisValueString(order: -1)] +
                barsData.enumerated().map {index, tuple in ChartAxisValueString(tuple.0, order: index, labelSettings: labelSettings)} +
                [ChartAxisValueString(order: barsData.count)]
        
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "未来2天气温", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "温度", settings: labelSettings.defaultVertical()))
        
        let chartFrame = CGRect(x: xx - 25 , y: 0, width: self.view.frame.width, height: self.pageScroller.frame.height - 200)
        // 25和200正好，蜜汁神奇
        
        let chartSettings = ChartSettings()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
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
        default:
            let chartSettings = ChartSettings()
            chartSettings.leading = 20
            chartSettings.top = 20
            chartSettings.trailing = 20
            chartSettings.bottom = 20
            chartSettings.labelsToAxisSpacingX = 10
            chartSettings.labelsToAxisSpacingY = 10
            chartSettings.axisTitleLabelsToLabelsSpacing = 5
            chartSettings.axisStrokeWidth = 1
            chartSettings.spacingBetweenAxesX = 15
            chartSettings.spacingBetweenAxesY = 15
        }
        
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let barsLayer = ChartBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, bars: bars, horizontal: false, barWidth: 20, animDuration: 0.5)
        // labels layer
        // create chartpoints for the top and bottom of the bars, where we will show the labels
        let labelChartPoints = bars.map {bar in
            ChartPoint(x: bar.constant, y: bar.axisValue2)
        }
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        let labelsLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: labelChartPoints, viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let label = HandlingLabel()
            let posOffset: CGFloat = 10
            
            let pos = chartPointModel.chartPoint.y.scalar > 0
            
            let yOffset = pos ? -posOffset : posOffset
            label.text = "\(formatter.string(from: NSNumber(value: abs(chartPointModel.chartPoint.y.scalar)))!)℃"
            label.font = UIFont(name: "AvenirNext-Regular", size: 14)
            label.sizeToFit()
            label.center = CGPoint(x: chartPointModel.screenLoc.x, y: pos ? innerFrame.origin.y : innerFrame.origin.y + innerFrame.size.height)
            label.alpha = 0
            label.textColor = UIColor.white
            
            label.movedToSuperViewHandler = {[weak label] in
                UIView.animate(withDuration: 0.3, animations: {
                    label?.alpha = 1
                    label?.center.y = chartPointModel.screenLoc.y + yOffset
                })
            }
            
            return label
            
        }, displayDelay: 0.6) // show after bars animation
        
        
        // show a gap between positive and negative bar
        let dummyZeroYChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
        let yZeroGapLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: [dummyZeroYChartPoint], viewGenerator: {(chartPointModel, layer, chart) -> UIView? in
            let height: CGFloat = 1
            let v = UIView(frame: CGRect(x: innerFrame.origin.x + 2, y: chartPointModel.screenLoc.y - height / 2, width: coordsSpace.xAxis.length, height: height))
            v.backgroundColor = UIColor.darkGray
            return v
        })
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                //                yAxis,
                barsLayer,
                labelsLayer,
                yZeroGapLayer,
                ]
        )
        self.pageScroller.addSubview(chart.view)
        self.forecastChart = chart
        
        
        if self.forcast_DataSource.isEmpty == false{
            var forecastTypes : [String] = []
            for forecast in self.forcast_DataSource{
                let type = forecast.type_day
                forecastTypes.append(type!)
            }
            
            let time = timeStampToTime((String(Int(self.updateTime!)))).components(separatedBy: ":")
            let hour = Int(time.first!)
            var hourIndicator:Bool
            if hour!>7 && hour!<18{
                hourIndicator = true
            }
            else{
                hourIndicator = false
            }
            
            var weatherImageTypes:[UIImageView] = []
            var typeLabels:[UILabel] = []
            
            for i in 1..<4{
                let pointsScreenLocations = labelsLayer.chartPointScreenLocs
                var xLocs:[CGFloat] = [0]
                var index = 0
                for point in pointsScreenLocations{
                    if index % 2 == 0{
                        xLocs.append(point.x)
                    }
                    index = index + 1
                }
                
                
                let weatherTypeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
                if hourIndicator{
                    let name = self.forcast_DataSource[i-1].code_day
                    if name != nil{
                        if Int(name!)!<10{
                            weatherTypeImage.image = UIImage(named: "0\(name!)")
                        }
                        else{
                            weatherTypeImage.image = UIImage(named: "\(name!)")
                        }
                    }

                }
                else{
                    let name = self.forcast_DataSource[i-1].code_night
                    if name != nil{
                        if Int(name!)!<10{
                            weatherTypeImage.image = UIImage(named: "0\(name!)")
                            print("w\(String(describing: name))")
                        }
                        else{
                            weatherTypeImage.image = UIImage(named: "\(name!)")
                        }
                    }


                }
                weatherTypeImage.center.x = xLocs[i]
                weatherTypeImage.center.y = innerFrame.maxY - 60
                weatherTypeImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                weatherImageTypes.append(weatherTypeImage)
                
                let typeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 60))
                typeLabel.center.x = weatherTypeImage.center.x
                typeLabel.center.y = weatherTypeImage.center.y + 38
                typeLabel.text = forecastTypes[i-1]
                typeLabel.textAlignment = .center
                typeLabel.textColor = UIColor.white
                typeLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
                typeLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                typeLabels.append(typeLabel)
                
                chart.addSubview(typeLabel)
                chart.addSubview(weatherTypeImage)
            }
            
            //更新动画UI,缩放效果
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.6, animations: {
                        for weatherImageType in weatherImageTypes{
                            weatherImageType.transform = CGAffineTransform(scaleX: 1, y: 1)
                            weatherImageType.alpha = 1
                        }
                        
                        for typeLabel in typeLabels{
                            typeLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                            typeLabel.alpha = 1
                        }
                        
                    }, completion: nil)

                }
            }
        }
    }
    
    
    //心知天气API文档 - http://www.thinkpage.cn/doc
    private func requestForWeather(){
        let url_today = "https://api.thinkpage.cn/v3/weather/now.json?key=lrpn5sdf3kotqfk5&location=ip&language=zh-Hans&unit=c"
            
        let url_forecast = "https://api.thinkpage.cn/v3/weather/daily.json?key=lrpn5sdf3kotqfk5&location=ip&language=zh-Hans&unit=c&start=0"
        var req_today = URLRequest(url: NSURL(string: url_today)! as URL)
        var req_forecast = URLRequest(url: NSURL(string: url_forecast)! as URL)
        req_today.timeoutInterval = 4.0
        req_forecast.timeoutInterval = 4.0
        req_today.httpMethod = "GET"
        req_forecast.httpMethod = "GET"
        
        //结果反馈提示框（动画显示），“成功”和”超时“公用
        let alertView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        alertView.backgroundColor = UIColor(white: 0.6, alpha: 1)
        alertView.alpha = 0.95
        alertView.center.x = UIScreen.main.bounds.midX
        alertView.center.y = UIScreen.main.bounds.midY - 20
        alertView.layer.cornerRadius = 20
        alertView.layer.masksToBounds = true
        alertView.clipsToBounds = true
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.bounds.width , height: alertView.bounds.height/2 + 20))
        label.text = "刷新成功"
        label.font = UIFont(name: "AvenirNext-Regular", size: 18)
        label.textColor = UIColor.white
        label.textAlignment = .center
        let loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: alertView.bounds.width/10, height: alertView.bounds.height/5))
        loading.center.x = label.center.x
        loading.center.y = label.center.y + 30
        loading.startAnimating()
        let doneImage = UIImageView(frame: loading.frame)
        doneImage.image = UIImage(named: "tick_outline_128px")?.withRenderingMode(.alwaysOriginal)
        doneImage.contentMode = .scaleToFill
        alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        alertView.backgroundColor = UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1)
        
        
        let session_today = URLSession.shared
        let session_forecast = URLSession.shared
        let dataTask_today = session_today.dataTask(with: req_today,completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                
                DispatchQueue.global().async {
                    
                    DispatchQueue.main.async {
                        doneImage.image = UIImage(named: "cross_circle_128px")
                        label.text = error?.localizedDescription.replacingOccurrences(of: "。", with: "")
                        alertView.backgroundColor = UIColor(red: 243/255, green: 113/255, blue: 92/255, alpha: 0.9)
                        if (label.text?.characters.count)! > 10{
                            label.font = UIFont(name: "AvenirNext-Regular", size: 15)
                        }
                        alertView.addSubview(label)
                        alertView.addSubview(loading)
                        self.view.addSubview(alertView)
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            alertView.transform = CGAffineTransform(scaleX: 1, y: 1)
                            alertView.alpha = 1
                            
                        }, completion: {
                            (finished)->Void in
                            UIView.animate(withDuration: 0.2, delay: 2.0, options: .transitionCurlUp, animations: {
                                loading.stopAnimating()
                                alertView.addSubview(doneImage)
                                alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                                alertView.alpha = 0
                            }, completion: {
                                (com)->Void in
                                alertView.removeFromSuperview()
                            })
                        })
                        
                    }
                    
                }
                
                
            }else{
                let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
                let path = NSURL(fileURLWithPath: cachePath! + "/Weather/today", isDirectory: true)
                
                try?FileManager.default.createDirectory(at: path as URL, withIntermediateDirectories: true, attributes: nil)
                
                let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
                let timeStamp = Int(timeInterval)
                self.updateTime = timeStamp
                let json = JSON(data: data!)
                print(json)
                
                //按刷新的时间戳命名，写入缓存plist
                let newPath = path.appendingPathComponent("\(timeStamp).plist")
                NSDictionary(dictionary: json.dictionaryObject!).write(to: newPath! as URL, atomically: true)
                
                //对当前天气JSON数据进行解析
                let today_rawData = json["results"][0]["now"]
                let today_Dictionary = today_rawData.dictionary!
                
                let curTemp = today_Dictionary["temperature"]! as JSON
//                let date = today_Dictionary["last_update"]! as JSON
                let code = today_Dictionary["code"]! as JSON
                print(code)
                let text = today_Dictionary["text"]! as JSON

                
                self.today_DataSource.currentTemp = curTemp.stringValue
//                self.today_DataSource.date = date.stringValue
                self.today_DataSource.code_day = code.stringValue
                self.today_DataSource.code_night = code.stringValue
                self.today_DataSource.type_day = text.stringValue
                self.today_DataSource.type_night = text.stringValue
                
                let location_rawData = json["results"][0]["location"]
                let location_dic = location_rawData.dictionary!
                let location = location_dic["name"]! as JSON
                self.today_DataSource.location = location.stringValue

                let userDefault = UserDefaults()
                userDefault.removeObject(forKey: "LatestTodayWeatherCache")
                userDefault.removeObject(forKey: "LatestWeatherUpdateTime")
                let userSaved = NSKeyedArchiver.archivedData(withRootObject: self.today_DataSource)
                userDefault.set(userSaved, forKey: "LatestTodayWeatherCache")
                userDefault.set(self.updateTime, forKey: "LatestWeatherUpdateTime")
                userDefault.synchronize()

                
                //没有办法解决文字显示延迟的问题，轮子没问题，可以在首页正常使用，目测问题是因为线程阻塞？？？2017/1/11
                
//                let frame = CGRect(x: 0, y: 0, width: 200, height: 100)
//                let SSView = MGNotificationView(frame: frame , labelText: "hello", textColor: UIColor.black, duration: 5, doneImage: nil, backgroundColor:UIColor.red)
//                SSView.stroke(in: self.view)
                
//                动画显示"刷新成功"提示框
                DispatchQueue.global().async {
                    
                    DispatchQueue.main.async {
                        
                        
                        self.updatePage_today()
                        
                        
                        alertView.addSubview(label)
                        alertView.addSubview(loading)
                        self.view.addSubview(alertView)
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            alertView.transform = CGAffineTransform(scaleX: 1, y: 1)
                            alertView.alpha = 0.8
                            
                        }, completion: {
                            (finished)->Void in
                            UIView.animate(withDuration: 0.2, delay: 2.0, options: .transitionCurlUp, animations: {
                                loading.stopAnimating()
                                alertView.addSubview(doneImage)
                                alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                                alertView.alpha = 0
                            }, completion: {
                                (com)->Void in
                                alertView.removeFromSuperview()
                            })
                        })
                        
                    }
                    
                }
                
                
            }
        }) as URLSessionTask
        
        dataTask_today.resume()
        
        let dataTask_forecast = session_forecast.dataTask(with: req_forecast,completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
            }
            else{
                let json = JSON(data: data!)
                print(json)
                let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
                let path = NSURL(fileURLWithPath: cachePath! + "/Weather/forecast", isDirectory: true)
                
                try?FileManager.default.createDirectory(at: path as URL, withIntermediateDirectories: true, attributes: nil)
                
                let timeInterval:TimeInterval = NSDate().timeIntervalSince1970
                let timeStamp = Int(timeInterval)
                
                //按刷新的时间戳命名，写入缓存plist
                let newPath = path.appendingPathComponent("\(timeStamp).plist")
                NSDictionary(dictionary: json.dictionaryObject!).write(to: newPath! as URL, atomically: true)
                
                let forcast_rawData = json["results"][0]["daily"]
                let forcast_Array = forcast_rawData.array! as [JSON]
                self.forcast_DataSource.removeAll()
                var count = 0
                for day_dic in forcast_Array{
                    let code_day = day_dic["code_day"].stringValue
                    let code_night = day_dic["code_night"].stringValue
                    let date = day_dic["date"].stringValue
                    let lowtemp = day_dic["low"].stringValue
                    let hightemp = day_dic["high"].stringValue
                    let type_day = day_dic["text_day"].stringValue
                    let type_night = day_dic["text_night"].stringValue
                    
                    if count == 0{
                        self.today_DataSource.date = date
                        self.today_DataSource.lowTemp = lowtemp
                        self.today_DataSource.highTemp = hightemp
                        self.today_DataSource.windDirection = day_dic["wind_direction"].stringValue
                        self.today_DataSource.windLevel = day_dic["wind_scale"].stringValue

                    }
                    
                    let newElement = WeatherDataSource(windLevel: nil, currentTemp: nil, week: nil, date: date, highTemp: hightemp, lowTemp: lowtemp, windDirection: nil, type_day: type_day, type_night: type_night, code_day: code_day, code_night: code_night)
                    self.forcast_DataSource.append(newElement)
                    count = count + 1
                }
                let userDefault = UserDefaults()
                userDefault.removeObject(forKey: "LatestForecastWeatherCache")
                let userSaved = NSKeyedArchiver.archivedData(withRootObject: self.forcast_DataSource)
                userDefault.set(userSaved, forKey: "LatestForecastWeatherCache")
                userDefault.synchronize()
                
                DispatchQueue.main.async {
                    
                    
                    self.forecastChart.clearView()
                    self.forecastChart.view.removeFromSuperview()
                    self.createAndUpdatePage_forecast()

                }

            }
        }) as URLSessionTask
        
        dataTask_forecast.resume()
        
        self.updatePage_today()
        
        //解决异步时差产生数据不全的问题，等待数据补全后再次保存
        if self.today_DataSource != nil{
            let userDefault = UserDefaults()
            userDefault.removeObject(forKey: "LatestTodayWeatherCache")
            userDefault.removeObject(forKey: "LatestWeatherUpdateTime")
            let userSaved = NSKeyedArchiver.archivedData(withRootObject: self.today_DataSource)
            userDefault.set(userSaved, forKey: "LatestTodayWeatherCache")
            userDefault.set(self.updateTime, forKey: "LatestWeatherUpdateTime")
            userDefault.synchronize()
        }


        if self.forcast_DataSource.isEmpty == false{
            let userDefault = UserDefaults()
            userDefault.removeObject(forKey: "LatestForecastWeatherCache")
            let userSaved = NSKeyedArchiver.archivedData(withRootObject: self.forcast_DataSource)
            userDefault.set(userSaved, forKey: "LatestForecastWeatherCache")
            userDefault.synchronize()
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
            if self.pageScroller.contentOffset.x == CGFloat(0) * self.view.frame.width{
                forecastChart.clearView()
            }
        case 1:
            self.selectedPage.selectedSegmentIndex = 1
            if self.pageScroller.contentOffset.x == CGFloat(1) * self.view.frame.width{
                self.forecastChart.view.removeFromSuperview()
                createAndUpdatePage_forecast()
            }
        default:
            self.selectedPage.selectedSegmentIndex = 1
            
        }
    }
}



