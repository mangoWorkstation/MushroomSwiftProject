//
//  ShowMapViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/8/24.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ShowMapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    var room:RoomInfoModel!
    
    var locationManager:CLLocationManager!
    
    var progressView = UIActivityIndicatorView(frame: CGRectMake(0,0,100,100))
    
    @IBOutlet weak var mapShow: MKMapView!
    
    @IBAction func jumpToMyLocation(sender: UIButton) {
        sender.setTitle("我的位置", forState: .Highlighted)
        setUserCurrentLocationAsMapCenter()
        sender.setTitle("我的位置", forState: .Normal)
    }
    
    @IBAction func jumpToRoomLocation(sender: UIButton) {
        sender.setTitle("基地位置", forState: .Highlighted)
        setRoomLocationAsMapCenter()
        sender.setTitle("基地位置", forState: .Normal)
    }
    
    @IBOutlet weak var myLocation: UIButton!
    
    @IBOutlet weak var roomLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()){
            self.setProgressView()  //显示加载指示器 2016.8.21
            return
        }
        
        prepareForClickButtons()
        
        openLocationService()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareForClickButtons(){
        myLocation.setTitle("我的位置", forState: .Normal)
        myLocation.backgroundColor = UIColor(red: 250/255, green: 181/255, blue: 14/255, alpha: 1)
        myLocation.tintColor = UIColor.blackColor()
        myLocation.titleLabel?.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
        myLocation.imageView?.contentMode = .ScaleToFill
        myLocation.imageView?.tintColor = UIColor.whiteColor()
        myLocation.layer.cornerRadius = 15
        myLocation.layer.masksToBounds = true
        myLocation.layer.borderWidth = 3
        myLocation.layer.borderColor = UIColor(red: 158/255, green: 168/255, blue: 174/255, alpha: 1).CGColor
        myLocation.clipsToBounds = true
        
        roomLocation.setTitle("基地位置", forState: .Normal)
        roomLocation.backgroundColor = UIColor(red: 122/255, green: 120/255, blue: 123/255, alpha: 1)
        roomLocation.tintColor = UIColor.whiteColor()
        roomLocation.titleLabel?.font = UIFont(name: GLOBAL_appFont!, size: 16.0)
        roomLocation.imageView?.contentMode = .ScaleToFill
        roomLocation.imageView?.tintColor = UIColor.whiteColor()
        roomLocation.layer.cornerRadius = 15
        roomLocation.layer.masksToBounds = true
        roomLocation.layer.borderWidth = 3
        roomLocation.layer.borderColor = UIColor(red: 158/255, green: 168/255, blue: 174/255, alpha: 1).CGColor
        roomLocation.clipsToBounds = true

    }
    
    private func setProgressView(){
        progressView.center = self.view.center
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        progressView.backgroundColor = UIColor.lightGrayColor()
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 20
        progressView.clipsToBounds = true   //磨成圆角
        self.view.addSubview(progressView)
        progressView.startAnimating()
    }
    
    private func openLocationService(){
        //如果设备没有开启定位服务
        if !CLLocationManager.locationServicesEnabled(){
            dispatch_async(dispatch_get_main_queue()){
                let alert = UIAlertView(title: "提示", message: "无法定位，因为您的设备没有启用定位服务！！！！", delegate: self, cancelButtonTitle: "好")
                alert.show()
                print("hello_1")
                
            }
            return
        }
        
        self.locationManager = CLLocationManager()
        
        //设置精确度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest        //变化距离  超过50米 重新定位
        locationManager.distanceFilter = 50
        
        //在IOS8以上系统中，需要使用requestWhenInUseAuthorization方法才能弹窗让用户确认是否允许使用定位服务的窗口
        
        //状态为，用户还没有做出选择，那么就弹窗让用户选择
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            //            locationManager.requestAlwaysAuthorization()
        }
            //状态为，用户在设置-定位中选择了【永不】，就是不允许App使用定位服务
        else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied){
            //需要把弹窗放在主线程才能强制显示
            dispatch_async(dispatch_get_main_queue()){
                let alert = UIAlertView(title: "提示", message: "无法定位，因为您的设备没有启用定位服务，请到设置中启用", delegate: self, cancelButtonTitle: "好")
                alert.show()
                return
            }
        }
        
        //设置定位获取成功或者失败后的代理，Class后面要加上CLLocationManagerDelegate协议
        locationManager.delegate = self
        //开始获取定位信息，异步方式
        locationManager.startUpdatingLocation()
    }
    
    private func getReadyForMap(){
        self.mapShow.delegate = self
        self.mapShow.mapType = MKMapType.Standard
        let latDelta = 0.1
        let lngDelta = 0.1
        let currentLocationSpan = MKCoordinateSpanMake(latDelta, lngDelta)
        
        let annotation = self.mapShow.userLocation
        annotation.title = "我的位置"
        annotation.subtitle = "耶我在这～"
        
        let temp = self.room
        let center = CLLocation(latitude: temp.latitude!, longitude: temp.longitude!)
        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        self.mapShow.setRegion(currentRegion, animated: true)
            
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: temp.latitude!, longitude: temp.longitude!).coordinate
        objectAnnotation.title = temp.name
        self.mapShow.addAnnotation(objectAnnotation)
        
        
        self.mapShow.userTrackingMode = .Follow
        self.mapShow.showsScale = true
        self.mapShow.showsCompass = true
        let userCenter = CLLocation(latitude: self.mapShow.userLocation.coordinate.latitude, longitude: self.mapShow.userLocation.coordinate.longitude)
        let userRegion = MKCoordinateRegion(center: userCenter.coordinate, span: currentLocationSpan)
        self.mapShow.setRegion(userRegion, animated: true)
        print("getReadyForMap执行了")
    }

    
    private func setUserCurrentLocationAsMapCenter(){
        self.mapShow.centerCoordinate.latitude = self.mapShow.userLocation.coordinate.latitude
        self.mapShow.centerCoordinate.longitude = self.mapShow.userLocation.coordinate.longitude
    }
    
    private func setRoomLocationAsMapCenter(){
        self.mapShow.centerCoordinate.latitude = self.room.latitude!
        self.mapShow.centerCoordinate.longitude = self.room.longitude!
    }
    
    
    //MARK: - CLLocationDelegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alert = UIAlertView(title: "定位异常提示", message: "请确认您是否已经开启定位服务，并重新进入该页面", delegate: self, cancelButtonTitle: "我知道了")
        alert.show()
        self.progressView.stopAnimating()
        print("\(error)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0{ //  使用last 获取，最后一个最新的位置， 前面是上一次的位置信息
            let locationInfo:CLLocation = locations.last! as CLLocation
            GLOBAL_UserProfile.latitude = locationInfo.coordinate.latitude
            GLOBAL_UserProfile.longitude = locationInfo.coordinate.longitude
            print("经度：\(locationInfo.coordinate.longitude)")
            print("纬度：\(locationInfo.coordinate.latitude)")
            print("\n")
            getReadyForMap()    //为地图准备数据
            //因为是异步操作，只能在这里刷新视图，他妈的，逻辑绕死我了 2016.8.21
        }
        setRoomLocationAsMapCenter()
        print("didUpdateLocations执行了")
        print("纬 : \(mapShow.centerCoordinate.latitude)")
        print("经 : \(mapShow.centerCoordinate.longitude)")
    }
    

    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        if fullyRendered == true{
            self.progressView.stopAnimating()
        }
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
