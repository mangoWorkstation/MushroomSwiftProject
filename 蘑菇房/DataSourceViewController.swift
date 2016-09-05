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
    
    @IBAction func upPullLoadData(sender:UITableViewHeaderFooterView?){
        
        //延迟执行，模拟网络延迟
        xwDelay(1) { () -> Void in
            
            self.tableView.reloadData()
            self.tableView.headerView?.endRefreshing()
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DataType.selectedSegmentIndex = 0
        self.tableView.backgroundColor = UIColor(red: 142/255, green: 164/255, blue: 182/255, alpha: 1)
        //16进制码:#8EA4B6
        
        self.tableView.separatorColor = UIColor(white: 0.9, alpha: 1)    //设置分割线颜色
        
        tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(MushroomViewController.upPullLoadData(_:)))
        
        self.tableView.sectionIndexColor = UIColor.whiteColor()
        self.tableView.sectionIndexBackgroundColor = UIColor(red: 108/255, green: 181/255, blue: 167/255, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        switch self.DataType.selectedSegmentIndex {
        case 0:
            return 300
        case 1:
            return 900
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2 //上下两层
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell : UITableViewCell! = nil
        
        if self.DataType.selectedSegmentIndex == 0 {
            //            if cell == nil{
            //            cell = self.tableView.dequeueReusableCellWithIdentifier("DataCell",forIndexPath: indexPath)
            if cell == nil {
                cell = self.tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath)
            }
            else {
                while cell.contentView.subviews.last != nil{
                    cell.contentView.subviews.last!.removeFromSuperview()
                }
                //                 cell = self.tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath)
                //                cell.removeFromSuperview()
            }
            
            
            let datum = shownDatum[self.roomID+self.areaIndex[indexPath.section]+"\(indexPath.row)"]
            
            //气温
            let label_1 = cell!.viewWithTag(1001) as! UILabel
            label_1.text = "空气温度"
            var airTemperatrue_dynamicNumberLabel : UICountingLabel? = cell!.viewWithTag(1003) as? UICountingLabel
            repeat {
                if airTemperatrue_dynamicNumberLabel == nil{ //控制子视图的redraw,防内存溢出
                    airTemperatrue_dynamicNumberLabel = UICountingLabel(frame: CGRect(x: 25, y: 30, width: 80, height: 50))
                    airTemperatrue_dynamicNumberLabel!.font = UIFont(name: "DamascusBold", size: 30.0)
                    airTemperatrue_dynamicNumberLabel!.contentMode = .ScaleToFill
                    airTemperatrue_dynamicNumberLabel!.countFrom(0, endValue: (datum?.getCurrentAirTemperature())!, duration: 2)
                    airTemperatrue_dynamicNumberLabel?.textColor = UIColor.whiteColor()
                    airTemperatrue_dynamicNumberLabel!.tag = 1003
                    cell!.addSubview(airTemperatrue_dynamicNumberLabel!)
                    print("airTemperatrue_dynamicNumberLabel初始化了")
                    break
                }
                else{
                    airTemperatrue_dynamicNumberLabel?.removeFromSuperview()
                    print("airTemperatrue_dynamicNumberLabel?.removeFromSuperview()执行了")
                    airTemperatrue_dynamicNumberLabel = UICountingLabel(frame: CGRect(x: 25, y: 30, width: 80, height: 50))
                    airTemperatrue_dynamicNumberLabel!.font = UIFont(name: "DamascusBold", size: 30.0)
                    airTemperatrue_dynamicNumberLabel!.contentMode = .ScaleToFill
                    airTemperatrue_dynamicNumberLabel!.countFrom(0, endValue: (datum?.getCurrentAirTemperature())!, duration: 2)
                    airTemperatrue_dynamicNumberLabel?.textColor = UIColor.whiteColor()
                    airTemperatrue_dynamicNumberLabel!.tag = 1003
                    cell!.addSubview(airTemperatrue_dynamicNumberLabel!)
                    print("airTemperatrue_dynamicNumberLabel初始化了")
                    break
                }
            }
                while(airTemperatrue_dynamicNumberLabel == nil)
            
            //层号
            let label_2 = cell!.viewWithTag(2001) as! UILabel
            let label_3 = cell!.viewWithTag(2002) as! UILabel
            if indexPath.row == 0 {
                label_2.text = "上层"
            }
            else {
                label_2.text = "下层"
            }
            label_3.text = "层级"
            label_2.textColor = UIColor.whiteColor()
            label_2.font = UIFont(name: "PingFangSC-Regular", size: 30)
            label_3.font = UIFont(name: "PingFangSC-Regular", size: 17.0)
            
            
            //空气湿度
            var pieChart_AirHumidity : PDPieChart? = cell!.viewWithTag(1004) as? PDPieChart
            repeat{
                if pieChart_AirHumidity == nil{
                    let airHumidity = datum?.getCurrentAirHumidity()
                    let data_AirHumidity = PDPieChartDataItem()
                    data_AirHumidity.pieWidth = 40
                    data_AirHumidity.pieMargin = 30
                    data_AirHumidity.animationDur = 2.0
                    data_AirHumidity.pieTipFontSize = 10.0
                    data_AirHumidity.pieTipTextColor = UIColor.whiteColor()
                    data_AirHumidity.dataArray = [
                        PieDataItem(description:"水汽",color:UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1),percentage: airHumidity!/100),
                        PieDataItem(description:"干燥空气",color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1),percentage: (1 - (airHumidity!/100)))
                    ]
                    pieChart_AirHumidity = PDPieChart(frame: CGRectMake(28, 150, 60, 60), dataItem: data_AirHumidity)
                    pieChart_AirHumidity?.tag = 1004
                    pieChart_AirHumidity!.strokeChart()
                    cell!.addSubview(pieChart_AirHumidity!)
                    print("pieChart_AirHumidity初始化了")
                }
                else{
                    pieChart_AirHumidity?.removeFromSuperview()
                    print("pieChart_AirHumidity?.removeFromSuperview()执行了")
                    let airHumidity = datum?.getCurrentAirHumidity()
                    let data_AirHumidity = PDPieChartDataItem()
                    data_AirHumidity.pieWidth = 40
                    data_AirHumidity.pieMargin = 30
                    data_AirHumidity.animationDur = 2.0
                    data_AirHumidity.pieTipFontSize = 10.0
                    data_AirHumidity.pieTipTextColor = UIColor.whiteColor()
                    data_AirHumidity.dataArray = [
                        PieDataItem(description:"水汽",color:UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1),percentage: airHumidity!/100),
                        PieDataItem(description:"干燥空气",color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1),percentage: (1 - (airHumidity!/100)))
                    ]
                    pieChart_AirHumidity = PDPieChart(frame: CGRectMake(28, 150, 60, 60), dataItem: data_AirHumidity)
                    pieChart_AirHumidity?.tag = 1004
                    pieChart_AirHumidity!.strokeChart()
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
            repeat{
                if pieChart_CO2 == nil{
                    let CO2 = datum?.getCurrentCO2()
                    let data_CO2 = PDPieChartDataItem()
                    data_CO2.pieWidth = 40
                    data_CO2.pieMargin = 30
                    data_CO2.animationDur = 2.0
                    data_CO2.pieTipFontSize = 10.0
                    data_CO2.pieTipTextColor = UIColor.whiteColor()
                    data_CO2.dataArray = [
                        PieDataItem(description: "CO2", color: UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1), percentage: CO2!/100),
                        PieDataItem(description: "空气", color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1), percentage: (1 - (CO2!/100)))
                    ]
                    pieChart_CO2 = PDPieChart(frame: CGRectMake(label_5.superview!.center.x - 30,150,60,60), dataItem: data_CO2)
                    //偏移量30p正好
                    pieChart_CO2?.tag = 2004
                    pieChart_CO2?.strokeChart()
//                    let layout_pieChart_CO2 = NSLayoutConstraint(item: pieChart_CO2!, attribute: .BottomMargin , relatedBy: .Equal, toItem: label_5.superview, attribute: .TopMargin, multiplier: 1, constant: 0)
//                    layout_pieChart_CO2.active = true
//                    pieChart_CO2?.addConstraint(layout_pieChart_CO2)
                    cell.addSubview(pieChart_CO2!)
                }
                else{
                    pieChart_CO2?.removeFromSuperview()
                    let CO2 = datum?.getCurrentCO2()
                    let data_CO2 = PDPieChartDataItem()
                    data_CO2.pieWidth = 40
                    data_CO2.pieMargin = 30
                    data_CO2.animationDur = 2.0
                    data_CO2.pieTipFontSize = 10.0
                    data_CO2.pieTipTextColor = UIColor.whiteColor()
                    data_CO2.dataArray = [
                        PieDataItem(description: "CO2", color: UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1), percentage: CO2!/100),
                        PieDataItem(description: "空气", color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1), percentage: (1 - (CO2!/100)))
                    ]
                    pieChart_CO2 = PDPieChart(frame: CGRectMake(label_5.superview!.center.x - 30,150,60,60), dataItem: data_CO2)
                    //偏移量30p正好
                    pieChart_CO2?.tag = 2004
                    pieChart_CO2?.strokeChart()
//                    let layout_pieChart_CO2 = NSLayoutConstraint(item: pieChart_CO2!, attribute: .BottomMargin , relatedBy: .Equal, toItem: label_5.superview, attribute: .TopMargin, multiplier: 1, constant: 0)
//                    layout_pieChart_CO2.active = true
//                    pieChart_CO2?.addConstraint(layout_pieChart_CO2)
                    cell.addSubview(pieChart_CO2!)
                }
            }
            while(pieChart_CO2 == nil)
            
            //土壤温度
            let label_6 = cell!.viewWithTag(3001) as! UILabel
            label_6.text = "土壤温度"
            var soilTemperature_dynamicNumberLabel : UICountingLabel? = cell!.viewWithTag(3003) as? UICountingLabel
            repeat {
                if soilTemperature_dynamicNumberLabel == nil{ //控制子视图的redraw,防内存溢出
                    soilTemperature_dynamicNumberLabel = UICountingLabel(frame: CGRect(x: label_6.superview!.center.x + 65, y: 30, width: 80, height: 50))
                    soilTemperature_dynamicNumberLabel!.font = UIFont(name: "DamascusBold", size: 30.0)
                    soilTemperature_dynamicNumberLabel!.contentMode = .ScaleToFill
                    soilTemperature_dynamicNumberLabel!.countFrom(0, endValue: (datum?.getCurrentSoilTemperature())!, duration: 2)
                    soilTemperature_dynamicNumberLabel?.textColor = UIColor.whiteColor()
                    soilTemperature_dynamicNumberLabel!.tag = 3003
                    cell!.addSubview(soilTemperature_dynamicNumberLabel!)
                    print("soilTemperature_dynamicNumberLabel初始化了")
                    break
                }
                else{
                    soilTemperature_dynamicNumberLabel?.removeFromSuperview()
                    print("soilTemperature_dynamicNumberLabel?.removeFromSuperview()执行了")
                    soilTemperature_dynamicNumberLabel = UICountingLabel(frame: CGRect(x: label_6.superview!.center.x + 65, y: 30, width: 80, height: 50))
                    soilTemperature_dynamicNumberLabel!.font = UIFont(name: "DamascusBold", size: 30.0)
                    soilTemperature_dynamicNumberLabel!.contentMode = .ScaleToFill
                    soilTemperature_dynamicNumberLabel!.countFrom(0, endValue: (datum?.getCurrentSoilTemperature())!, duration: 2)
                    soilTemperature_dynamicNumberLabel?.textColor = UIColor.whiteColor()
                    soilTemperature_dynamicNumberLabel!.tag = 3003
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
            repeat{
                if pieChart_soilHumidity == nil{
                    let soilHumidity = datum?.getCurrentSoilHumidity()
                    let data_soilHumidity = PDPieChartDataItem()
                    data_soilHumidity.pieWidth = 40
                    data_soilHumidity.pieMargin = 30
                    data_soilHumidity.animationDur = 2.0
                    data_soilHumidity.pieTipFontSize = 10.0
                    data_soilHumidity.pieTipTextColor = UIColor.whiteColor()
                    data_soilHumidity.dataArray = [
                        PieDataItem(description: "水分", color: UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1), percentage: soilHumidity!/100),
                        PieDataItem(description: "干燥土壤", color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1), percentage: (1 - (soilHumidity!/100)))
                    ]
                    pieChart_soilHumidity = PDPieChart(frame: CGRectMake(label_7.superview!.center.x + 60,150,60,60), dataItem: data_soilHumidity)
                    //偏移量30p正好
                    pieChart_soilHumidity?.tag = 3004
                    pieChart_soilHumidity?.strokeChart()
                    //                    let layout_pieChart_CO2 = NSLayoutConstraint(item: pieChart_CO2!, attribute: .BottomMargin , relatedBy: .Equal, toItem: label_5.superview, attribute: .TopMargin, multiplier: 1, constant: 0)
                    //                    layout_pieChart_CO2.active = true
                    //                    pieChart_CO2?.addConstraint(layout_pieChart_CO2)
                    cell.addSubview(pieChart_soilHumidity!)
                }
                else{
                    pieChart_soilHumidity?.removeFromSuperview()
                    let soilHumidity = datum?.getCurrentSoilHumidity()
                    let data_soilHumidity = PDPieChartDataItem()
                    data_soilHumidity.pieWidth = 40
                    data_soilHumidity.pieMargin = 30
                    data_soilHumidity.animationDur = 2.0
                    data_soilHumidity.pieTipFontSize = 10.0
                    data_soilHumidity.pieTipTextColor = UIColor.whiteColor()
                    data_soilHumidity.dataArray = [
                        PieDataItem(description: "水分", color: UIColor(red: 64/255, green: 151/255, blue: 32/255, alpha: 1), percentage: soilHumidity!/100),
                        PieDataItem(description: "干燥土壤", color: UIColor(red: 150/255, green: 187/255, blue: 107/255, alpha: 1), percentage: (1 - (soilHumidity!/100)))
                    ]
                    pieChart_soilHumidity = PDPieChart(frame: CGRectMake(label_7.superview!.center.x + 60,150,60,60), dataItem: data_soilHumidity)
                    //偏移量30p正好
                    pieChart_soilHumidity?.tag = 3004
                    pieChart_soilHumidity?.strokeChart()
                    //                    let layout_pieChart_CO2 = NSLayoutConstraint(item: pieChart_CO2!, attribute: .BottomMargin , relatedBy: .Equal, toItem: label_5.superview, attribute: .TopMargin, multiplier: 1, constant: 0)
                    //                    layout_pieChart_CO2.active = true
                    //                    pieChart_CO2?.addConstraint(layout_pieChart_CO2)
                    cell.addSubview(pieChart_soilHumidity!)                }
            }
                while(pieChart_CO2 == nil)

            
            
        }
        //            }
        //            else{
        //                cell?.removeFromSuperview()
        //            }
        //
        //        }
        //                let airHumidity = datum?.getCurrentAirHumidity()
        //
        //                let soilTemperature = datum?.getCurrentSoilTemperature()
        //                let soilHumidity = datum?.getCurrentSoilHumidity()
        //                let co2 = datum?.getCurrentCO2()
        //                let voltage = datum?.getCurrentVoltage()
        //              var dataItem: PDPieChartDataItem = PDPieChartDataItem()
        //              dataItem.pieWidth = 80
        //              dataItem.pieMargin = 50
        //              dataItem.dataArray = [PieDataItem(description: "first pie", color: lightGreen, percentage: 0.3),
        //                                      PieDataItem(description: nil, color: middleGreen, percentage: 0.1),
        //                                      PieDataItem(description: "third pie", color: deepGreen, percentage: 0.6)]
        //               var pieChart: PDPieChart = PDPieChart(frame: CGRectMake(0, 100, 320, 320), dataItem: dataItem)
        cell!.userInteractionEnabled = false
        cell!.backgroundColor = UIColor.clearColor()
        
        print("cellForRowAtIndexPath执行了")
        print("(\(indexPath.section)),(\(indexPath.row))")
        print(self.roomID+self.areaIndex[indexPath.section]+"\(indexPath.row)")
        
        return cell!
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 4 //A,B,C,D四个区
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
        return ["A区","B区","C区","D区"]
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int{
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
