//
//  WeatherViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/5/15.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    var forecast_url = "http://apis.baidu.com/apistore/weatherservice/recentweathers"
    var cityNameID = "cityname=%E5%8D%97%E5%AE%81&cityid=101300101"
    
    var realTimeWeather_url = "http://apis.baidu.com/apistore/weatherservice/cityname"
    var cityName = "cityname=%E5%8D%97%E5%AE%81"    //南宁
    
    let baiduAPIKey = "d596f298898e51557c9d3e93f143c74d"
    
    @IBOutlet weak var selectedPage: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPage.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont(name: GLOBAL_appFont!, size: 12.0)!], for: UIControlState())
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        requestForWeather(httpUrl: realTimeWeather_url, httpArg: cityName)
        requestForWeather(httpUrl: forecast_url, httpArg: cityNameID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestForWeather(httpUrl: String, httpArg: String){
        var req = URLRequest(url: NSURL(string: httpUrl + "?" + httpArg)! as URL)
        req.timeoutInterval = 6
        req.httpMethod = "GET"
        req.addValue(baiduAPIKey, forHTTPHeaderField: "apikey")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: req,completionHandler: {(data, response, error) -> Void in
            if error != nil{
//                if error?.localizedDescription == "请求超时"{
                    print("请求超时")
                    let sheet = UIAlertController(title: "天气信息请求超时", message: nil, preferredStyle: .alert)
                    sheet.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                    self.present(sheet, animated: true, completion: nil)
//                }

            }else{
                let json = JSON(data: data!)
                print("今天")
                print(json["retData"]["today"])
                print("未来预报")
                print(json["retData"]["forecast"])
                print("历史天气")
                print(json["retData"]["history"])

                
            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
    


}

