//
//  DataSourceViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/9/1.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class DataSourceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var DataType: UISegmentedControl!
    
    var roomID = "00000" //暂定
    
    var shownDatum = GLOBAL_DataSource
    
    let areaIndex = ["A","B","C","D"]
    
    var whichKindOfDataShow = 0
    
    var historyDataType = 0
    
    let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)

    let loadingTimeInterval : Double = 2.0

    
    @IBAction func changeDataSourceType(_ sender:UISegmentedControl!,forEvent:UIEvent?){
        let dataTypeIndex = sender.selectedSegmentIndex
        switch dataTypeIndex {
        case 0:
            self.whichKindOfDataShow = 0
            self.tableView.reloadData()
        case 1:
            self.whichKindOfDataShow = 1
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    @IBAction func showSegmentedHistoryData(_ sender:UISegmentedControl!,forEvent:UIEvent?){
        let row = sender.tag - 1001
        let indexPath = IndexPath(row: row, section: 1)
        self.historyDataType = sender.selectedSegmentIndex
        sender.tag = 1001
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DataType.selectedSegmentIndex = 0
        let background = UIImageView(image: UIImage(named: "Background_1"))
        background.contentMode = .scaleToFill
        self.tableView.backgroundView = background
        
        configurateHeaderAndFooter()
        
//        self.tableView.backgroundColor = UIColor(red: 142/255, green: 164/255, blue: 182/255, alpha: 1)
        //16进制码:#8EA4B6
        
        self.tableView.separatorColor = UIColor(white: 0.9, alpha: 1)    //设置分割线颜色
        
        self.tableView.es_addPullToRefresh(animator: header) {
            [weak self] in
            self?.refresh()
        }
        
//        tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(MushroomViewController.upPullLoadData(_:)))
        
        self.tableView.sectionIndexColor = UIColor.white
        self.tableView.sectionIndexBackgroundColor = UIColor(red: 64/255, green: 100/255, blue: 32/255, alpha: 1)
        
        self.DataType.addTarget(self, action: #selector(DataSourceViewController.changeDataSourceType(_:forEvent:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingTimeInterval) {
            self.tableView.reloadData()
            self.tableView.es_stopPullToRefresh(completion: true)
        }
    }
    
    private func configurateHeaderAndFooter(){
        header.loadingDescription = "🍄小蘑菇正在努力刷新数据"
        header.pullToRefreshDescription = "下拉可以刷新噢"
        header.releaseToRefreshDescription = "快松手呀～"
        header.trigger = 70
    }

    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch self.DataType.selectedSegmentIndex {
        case 0:
            return 300
        case 1:
            return 300
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2 //上下两层
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        switch section {
        case 0:
            return "A区"
        case 1:
            return "B区"
        case 2:
            return "C区"
        default:
            return "D区"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell : UITableViewCell! = nil
        
        //*********************************************************************************************************************************
        
        //实时监控数据
        if self.whichKindOfDataShow == 0 {
            if cell == nil{
                cell = self.tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
            }
            else {
                while cell.contentView.subviews.last != nil{
                    cell.contentView.subviews.last!.removeFromSuperview()
                }
            }
            
            
            let datum = shownDatum[self.roomID+self.areaIndex[(indexPath as NSIndexPath).section]+"\((indexPath as NSIndexPath).row)"]
            
            //气温
            let label_1 = cell!.viewWithTag(1001) as! UILabel
            label_1.text = "空气温度"
            var airTemperatrue_dynamicNumberLabel : UICountingLabel? = cell!.viewWithTag(1003) as? UICountingLabel
            
            func prepareForAirTemperatrue_dynamicNumberLabel(){
                airTemperatrue_dynamicNumberLabel = UICountingLabel(frame: CGRect(x: 25, y: 30, width: 80, height: 50))
                airTemperatrue_dynamicNumberLabel!.font = UIFont(name: "DamascusBold", size: 30.0)
                airTemperatrue_dynamicNumberLabel!.contentMode = .scaleToFill
                airTemperatrue_dynamicNumberLabel!.countFrom(0, endValue: (datum?.getCurrentAirTemperature())!, duration: 2)
                airTemperatrue_dynamicNumberLabel?.textColor = UIColor.black
                airTemperatrue_dynamicNumberLabel!.tag = 1003
            }
            repeat {
                if airTemperatrue_dynamicNumberLabel == nil{ //控制子视图的redraw,防内存溢出
                    prepareForAirTemperatrue_dynamicNumberLabel()
                    cell!.addSubview(airTemperatrue_dynamicNumberLabel!)
                    print("airTemperatrue_dynamicNumberLabel初始化了")
                    break
                }
                else{
                    airTemperatrue_dynamicNumberLabel?.removeFromSuperview()
                    prepareForAirTemperatrue_dynamicNumberLabel()
                    cell.addSubview(airTemperatrue_dynamicNumberLabel!)
                    print("airTemperatrue_dynamicNumberLabel初始化了")
                    break
                }
            }
                while(airTemperatrue_dynamicNumberLabel == nil)
            
            //层号
            let label_2 = cell!.viewWithTag(2001) as! UILabel
            let label_3 = cell!.viewWithTag(2002) as! UILabel
            if (indexPath as NSIndexPath).row == 0 {
                label_2.text = "上层"
            }
            else {
                label_2.text = "下层"
            }
            label_3.text = "层级"
            label_2.textColor = UIColor.black
            label_2.font = UIFont(name: "PingFangSC-Regular", size: 30)
            label_3.font = UIFont(name: "PingFangSC-Regular", size: 17.0)
            
            
            //空气湿度
            var pieChart_AirHumidity : PDPieChart? = cell!.viewWithTag(1004) as? PDPieChart
            
            func prepareForPieChart_AirHumidity(){
                let airHumidity = datum?.getCurrentAirHumidity()
                let data_AirHumidity = PDPieChartDataItem()
                data_AirHumidity.pieWidth = 40
                data_AirHumidity.pieMargin = 30
                data_AirHumidity.animationDur = 2.0
                data_AirHumidity.pieTipFontSize = 10.0
                data_AirHumidity.pieTipTextColor = UIColor.white
                data_AirHumidity.dataArray = [
                    PieDataItem(description:"水汽",color:UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1),percentage: airHumidity!/100),
                    PieDataItem(description:"干燥空气",color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1),percentage: (1 - (airHumidity!/100)))
                ]
                pieChart_AirHumidity = PDPieChart(frame: CGRect(x: 28, y: 150, width: 60, height: 60), dataItem: data_AirHumidity)
                pieChart_AirHumidity?.tag = 1004
                pieChart_AirHumidity!.strokeChart()
            }
            repeat{
                if pieChart_AirHumidity == nil{
                    prepareForPieChart_AirHumidity()
                    cell!.addSubview(pieChart_AirHumidity!)
                    print("pieChart_AirHumidity初始化了")
                }
                else{
                    pieChart_AirHumidity?.removeFromSuperview()
                    print("pieChart_AirHumidity?.removeFromSuperview()执行了")
                    prepareForPieChart_AirHumidity()
                    cell!.addSubview(pieChart_AirHumidity!)
                    print("pieChart_AirHumidity初始化了")
                }
            }
                while(pieChart_AirHumidity == nil)
            
            let label_4 = cell!.viewWithTag(1002) as! UILabel
            label_4.text = "空气湿度"
            
            //CO2浓度饼图
            let label_5 = cell.viewWithTag(2003) as! UILabel
            label_5.text = "CO2浓度"
            
            var pieChart_CO2 : PDPieChart? = cell.viewWithTag(2004) as? PDPieChart
            
            func prepareForPieChart_CO2(){
                let CO2 = datum?.getCurrentCO2()
                let data_CO2 = PDPieChartDataItem()
                data_CO2.pieWidth = 40
                data_CO2.pieMargin = 30
                data_CO2.animationDur = 2.0
                data_CO2.pieTipFontSize = 10.0
                data_CO2.pieTipTextColor = UIColor.white
                data_CO2.dataArray = [
                    PieDataItem(description: "CO2", color: UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1), percentage: CO2!/100),
                    PieDataItem(description: "空气", color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1), percentage: (1 - (CO2!/100)))
                ]
                pieChart_CO2 = PDPieChart(frame: CGRect(x: label_5.superview!.center.x - 30,y: 150,width: 60,height: 60), dataItem: data_CO2)
                //偏移量30p正好
                pieChart_CO2?.tag = 2004
                pieChart_CO2?.strokeChart()
            }
            
            repeat{
                if pieChart_CO2 == nil{
                    prepareForPieChart_CO2()
                    cell.addSubview(pieChart_CO2!)
                }
                else{
                    pieChart_CO2?.removeFromSuperview()
                    prepareForPieChart_CO2()
                    cell.addSubview(pieChart_CO2!)
                }
            }
                while(pieChart_CO2 == nil)
            
            //土壤温度
            let label_6 = cell!.viewWithTag(3001) as! UILabel
            label_6.text = "土壤温度"
            var soilTemperature_dynamicNumberLabel : UICountingLabel? = cell!.viewWithTag(3003) as? UICountingLabel
            
            func prepareForSoilTemperature_dynamicNumberLabel(){
                soilTemperature_dynamicNumberLabel = UICountingLabel(frame: CGRect(x: label_6.superview!.center.x + 65, y: 30, width: 80, height: 50))
                soilTemperature_dynamicNumberLabel!.font = UIFont(name: "DamascusBold", size: 30.0)
                soilTemperature_dynamicNumberLabel!.contentMode = .scaleToFill
                soilTemperature_dynamicNumberLabel!.countFrom(0, endValue: (datum?.getCurrentSoilTemperature())!, duration: 2)
                soilTemperature_dynamicNumberLabel?.textColor = UIColor.black
                soilTemperature_dynamicNumberLabel!.tag = 3003
                
            }
            repeat {
                if soilTemperature_dynamicNumberLabel == nil{ //控制子视图的redraw,防内存溢出
                    prepareForSoilTemperature_dynamicNumberLabel()
                    cell!.addSubview(soilTemperature_dynamicNumberLabel!)
                    print("soilTemperature_dynamicNumberLabel初始化了")
                    break
                }
                else{
                    soilTemperature_dynamicNumberLabel?.removeFromSuperview()
                    print("soilTemperature_dynamicNumberLabel?.removeFromSuperview()执行了")
                    prepareForSoilTemperature_dynamicNumberLabel()
                    cell!.addSubview(soilTemperature_dynamicNumberLabel!)
                    print("soilTemperature_dynamicNumberLabel初始化了")
                    break
                }
            }
                while(soilTemperature_dynamicNumberLabel == nil)
            
            //土壤湿度饼图
            let label_7 = cell.viewWithTag(3002) as! UILabel
            label_7.text = "土壤湿度"
            
            var pieChart_soilHumidity : PDPieChart? = cell.viewWithTag(3004) as? PDPieChart
            
            func prepareForPieChart_soilHumidity(){
                let soilHumidity = datum?.getCurrentSoilHumidity()
                let data_soilHumidity = PDPieChartDataItem()
                data_soilHumidity.pieWidth = 40
                data_soilHumidity.pieMargin = 30
                data_soilHumidity.animationDur = 2.0
                data_soilHumidity.pieTipFontSize = 10.0
                data_soilHumidity.pieTipTextColor = UIColor.white
                data_soilHumidity.dataArray = [
                    PieDataItem(description: "水分", color: UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1), percentage: soilHumidity!/100),
                    PieDataItem(description: "干燥土壤", color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1), percentage: (1 - (soilHumidity!/100)))
                ]
                pieChart_soilHumidity = PDPieChart(frame: CGRect(x: label_7.superview!.center.x + 70,y: 150,width: 60,height: 60), dataItem: data_soilHumidity)
                //偏移量30p正好
                pieChart_soilHumidity?.tag = 3004
                pieChart_soilHumidity?.strokeChart()
                //                    let layout_pieChart_CO2 = NSLayoutConstraint(item: pieChart_CO2!, attribute: .BottomMargin , relatedBy: .Equal, toItem: label_5.superview, attribute: .TopMargin, multiplier: 1, constant: 0)
                //                    layout_pieChart_CO2.active = true
                //                    pieChart_CO2?.addConstraint(layout_pieChart_CO2)
            }
            
            repeat{
                if pieChart_soilHumidity == nil{
                    prepareForPieChart_soilHumidity()
                    cell.addSubview(pieChart_soilHumidity!)
                }
                else{
                    pieChart_soilHumidity?.removeFromSuperview()
                    prepareForPieChart_soilHumidity()
                    cell.addSubview(pieChart_soilHumidity!)
                }
            }
                while(pieChart_CO2 == nil)
            
        }
    
    //*********************************************************************************************************************************
    //历史数据统计图
    if self.whichKindOfDataShow == 1 {
        if cell == nil{
            cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        }
        else {
            while cell.contentView.subviews.last != nil{
                cell.contentView.subviews.last!.removeFromSuperview()
            }
            cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        }
    
        let datum = shownDatum[self.roomID+self.areaIndex[(indexPath as NSIndexPath).section]+"\((indexPath as NSIndexPath).row)"]
    
        let segControl = cell.viewWithTag(1001) as? UISegmentedControl
//        segControl.addTarget(self, action: #selector(DataSourceViewController.showSegmentedHistoryData(_:forEvent:)), forControlEvents: .ValueChanged)
        segControl!.tintColor = UIColor.white
        segControl!.backgroundColor = UIColor.green
//        segControl!.tag = indexPath.row + 1000
        
        if segControl!.selectedSegmentIndex == 0{
            
            var airTemperatureHistory : PDBarChart? = cell.viewWithTag(1002) as? PDBarChart
            
            
            let tempArr = datum?.arr_airTemperature
            let dataItem = PDBarChartDataItem()
            dataItem.yMax = (tempArr?.max())! + 5.0
            dataItem.yInterval = 5.0
            dataItem.xMax = 7.0
            dataItem.xInterval = 1.0
            dataItem.xAxesDegreeTexts = ["周日", "一", "二", "三", "四", "五", "周六"]
            dataItem.barPointArray = [
                CGPoint(x: CGFloat(7), y: round(tempArr![7])),
                CGPoint(x: CGFloat(6), y: round(tempArr![6])),
                CGPoint(x: CGFloat(5), y: round(tempArr![5])),
                CGPoint(x: CGFloat(4), y: round(tempArr![4])),
                CGPoint(x: CGFloat(3), y: round(tempArr![3])),
                CGPoint(x: CGFloat(2), y: round(tempArr![2])),
                CGPoint(x: CGFloat(1), y: round(tempArr![1])),
            ]
            airTemperatureHistory = PDBarChart(frame: CGRect(x: 50, y: 100, width: 300, height: 200), dataItem: dataItem)
            airTemperatureHistory?.backgroundColor = UIColor(red: 142/255, green: 164/255, blue: 182/255, alpha: 1)
            airTemperatureHistory?.strokeChart()
            repeat{
                if airTemperatureHistory == nil{
                    cell.addSubview(airTemperatureHistory!)
                }
                else{
                    airTemperatureHistory?.removeFromSuperview()
                    cell.addSubview(airTemperatureHistory!)
                }
                
            }while airTemperatureHistory == nil
        }
//        if self.historyDataType == 1 {
//            return cell
//        }
    }

    //            //for barChart
    //
    //            var dataItem: PDBarChartDataItem = PDBarChartDataItem()
    //            dataItem.xMax = 7.0
    //            dataItem.xInterval = 1.0
    //            dataItem.yMax = 100.0
    //            dataItem.yInterval = 10.0
    //            dataItem.barPointArray = [CGPoint(x: 1.0, y: 95.0), CGPoint(x: 2.0, y: 25.0), CGPoint(x: 3.0, y: 30.0), CGPoint(x: 4.0, y:50.0), CGPoint(x: 5.0, y: 55.0), CGPoint(x: 6.0, y: 60.0), CGPoint(x: 7.0, y: 90.0)]
    //            dataItem.xAxesDegreeTexts = ["周日", "一", "二", "三", "四", "五", "周六"]
    //            dataItem.yAxesDegreeTexts = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    //
    //            var barChart: PDBarChart = PDBarChart(frame: CGRectMake(0, 100, 320, 320), dataItem: dataItem)
    //
    //            self.view.addSubview(barChart)
    //            barChart.addSubview(barChart)
    
    
    cell!.isUserInteractionEnabled = true
    cell!.backgroundColor = UIColor.clear
    
    print("cellForRowAtIndexPath执行了")
    print("(\((indexPath as NSIndexPath).section)),(\((indexPath as NSIndexPath).row))")
    print(self.roomID+self.areaIndex[(indexPath as NSIndexPath).section]+"\((indexPath as NSIndexPath).row)")
    
    return cell!
}


func numberOfSections(in tableView: UITableView) -> Int{
    return 4 //A,B,C,D四个区
}

func sectionIndexTitles(for tableView: UITableView) -> [String]?{
    return ["A区","B区","C区","D区"]
}

func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int{
    return index
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}
