//
//  NearbyViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/8/4.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import Contacts // iOS9

class NearbyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIScrollViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var mapShow: MKMapView!
    
    var index : Int?
    
    var locationManager:CLLocationManager!
    
    var showData: [RoomInfoModel] = []
    
    var indexPath : IndexPath = IndexPath(row: 5, section: 1)
    
    var progressView = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
    
    var userAddress = "正在搜索..."{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async{
            self.setProgressView()  //显示加载指示器 2016.8.21
            return
        }
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        mapShow.delegate = self
        // Do any additional setup after loading the view.
        
        openLocationService()   //开启定位服务
        
        //需要再加一个判断网络状态
        prepareForGeocoder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.locationManager.stopUpdatingLocation()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setProgressView(){
        progressView.center = self.view.center
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        progressView.backgroundColor = UIColor.lightGray
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 20
        progressView.clipsToBounds = true   //磨成圆角
        self.view.addSubview(progressView)
        progressView.startAnimating()
    }
    
    fileprivate func setUserCurrentLocationAsMapCenter(){
        self.mapShow.centerCoordinate.latitude = self.mapShow.userLocation.coordinate.latitude
        self.mapShow.centerCoordinate.longitude = self.mapShow.userLocation.coordinate.longitude
    }
    
    fileprivate func getReadyForMap(){
        self.mapShow.mapType = MKMapType.standard
        let latDelta = 0.1
        let lngDelta = 0.1
        let currentLocationSpan = MKCoordinateSpanMake(latDelta, lngDelta)
        
        let showInMap = self.showData
        let locationCount = showInMap.count
        let annotation = self.mapShow.userLocation
        annotation.title = "我的位置"
        annotation.subtitle = "耶我在这～"
        for i in 0 ..< locationCount{
            let temp = showInMap[i]
            let center = CLLocation(latitude: temp.latitude!, longitude: temp.longitude!)
            let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
            self.mapShow.setRegion(currentRegion, animated: true)
            
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = CLLocation(latitude: temp.latitude!, longitude: temp.longitude!).coordinate
            objectAnnotation.title = temp.name
            self.mapShow.addAnnotation(objectAnnotation)
        }
        self.mapShow.userTrackingMode = MKUserTrackingMode.followWithHeading
        self.mapShow.showsScale = true
        self.mapShow.showsCompass = true
        let userCenter = CLLocation(latitude: self.mapShow.userLocation.coordinate.latitude, longitude: self.mapShow.userLocation.coordinate.longitude)
        //闪退小bug在此，写错了一个参数，已更正 2016.8.29
        let currentRegion = MKCoordinateRegion(center: userCenter.coordinate, span: currentLocationSpan)
        self.mapShow.setRegion(currentRegion, animated: true)
        print("getReadyForMap执行了")
    }
    
    fileprivate func openLocationService(){
        //如果设备没有开启定位服务
        if !CLLocationManager.locationServicesEnabled(){
            DispatchQueue.main.async{
                let alert = UIAlertView(title: "提示", message: "无法定位，请您到“设置”中开启定位功能", delegate: self, cancelButtonTitle: "好")
                alert.show()
            }
            return
        }
        
        self.locationManager = CLLocationManager()
        
        //设置精确度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest        //变化距离  超过50米 重新定位
        locationManager.distanceFilter = 50
        
        //在IOS8以上系统中，需要使用requestWhenInUseAuthorization方法才能弹窗让用户确认是否允许使用定位服务的窗口
        
        //状态为，用户还没有做出选择，那么就弹窗让用户选择
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestAlwaysAuthorization()
        }
            //状态为，用户在设置-定位中选择了【永不】，就是不允许App使用定位服务
        else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied){
            //需要把弹窗放在主线程才能强制显示
            DispatchQueue.main.async{
                let alert = UIAlertView(title: "提示", message: "无法定位，请您到“设置”中开启定位功能", delegate: self, cancelButtonTitle: "好")
                alert.show()
                return
            }
        }
        
        //设置定位获取成功或者失败后的代理，Class后面要加上CLLocationManagerDelegate协议
        locationManager.delegate = self
        //设置精确度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //开始获取定位信息，异步方式
        locationManager.startUpdatingLocation()
    }
    
    //当前位置反编码 测试通过2016.8.31
    fileprivate func prepareForGeocoder(){
        let currentUserLocation = CLLocation(latitude: GLOBAL_UserProfile.latitude!, longitude: GLOBAL_UserProfile.longitude!)
        self.geocoder.reverseGeocodeLocation(currentUserLocation, completionHandler: {
            (placemarks,error) -> Void in
            if error == nil {
                let placemark = placemarks![0]
                
                let str:NSMutableString = ""
                
                if let province = placemark.administrativeArea{
                    str.append(province)
                    print("province : ",province)
                }
                
                if let city = placemark.locality{
                    str.append(city)
                    print("city : ",city)
                }
                
                if let strict = placemark.subLocality{
                    str.append(strict)
                    print("strict : ",strict)
                }
                
                if let street = placemark.thoroughfare{
                    str.append(street+"\n")
                    print("street : ",street)
                }
                
                if let address = placemark.name{
                    str.append(address)
                    print("address : ",address)
                }
                print(str)
                self.userAddress = str as String
            }
            print("Geocoder 执行了！！！")
        })

    }

    //MARK: - CLLocationDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertView(title: "定位异常提示", message: "请确认您是否已经开启定位服务，并重新进入该页面", delegate: self, cancelButtonTitle: "好")
        alert.show()
        self.progressView.stopAnimating()
        print("\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0{ //  使用last 获取，最后一个最新的位置， 前面是上一次的位置信息
            let locationInfo:CLLocation = locations.last! as CLLocation
            GLOBAL_UserProfile.latitude = locationInfo.coordinate.latitude
            GLOBAL_UserProfile.longitude = locationInfo.coordinate.longitude
            print("经度：\(locationInfo.coordinate.longitude)")
            print("纬度：\(locationInfo.coordinate.latitude)")
            print("\n")
            self.showData = nearbyRoomFilter(GLOBAL_RoomInfo)
            self.tableView.reloadData()
            getReadyForMap()    //为地图准备数据
            //因为是异步操作，只能在这里刷新视图，他妈的，逻辑绕死我了 2016.8.21
        }
        setUserCurrentLocationAsMapCenter()
        print("didUpdateLocations执行了")
        print("纬 : \(mapShow.userLocation.coordinate.latitude)")
        print("经 : \(mapShow.userLocation.coordinate.longitude)")
    }
    

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if (indexPath as NSIndexPath).section == 0{
            return 50
        }
        else if (indexPath as NSIndexPath).section == 1{
            return 100
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0 {
            return 0
        }
        else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if (indexPath as NSIndexPath).section == 0 {
            self.mapShow.centerCoordinate.latitude = self.mapShow.userLocation.coordinate.latitude
            self.mapShow.centerCoordinate.longitude = self.mapShow.userLocation.coordinate.longitude
        }
        else{
            let selectedLocation = nearbyRoomFilter(GLOBAL_RoomInfo)[(indexPath as NSIndexPath).row]
            self.mapShow.centerCoordinate.latitude = selectedLocation.latitude!
            self.mapShow.centerCoordinate.longitude = selectedLocation.longitude!
        }
        self.tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            if !self.showData.isEmpty {
                return "以下列出距您最近的5个蘑菇种植基地"
            }
            else {
                return "查找不到符合条件的基地"
            }
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        }
        else {
            return 30
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return showData.count //数据量待定 2016.8.5
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        var showDataArray : [RoomInfoModel] = []
        if ((self.search.text?.isEmpty) != nil){
            showDataArray = nearbyRoomFilter(GLOBAL_RoomInfo)
        }
        else{
            showDataArray = self.showData
        }
        
        if (indexPath as NSIndexPath).section == 0{
            if (indexPath as NSIndexPath).row == 0 {
                cell = self.tableView.dequeueReusableCell(withIdentifier: "MyLocationCell", for: indexPath)
                let icon = cell.viewWithTag(2001) as! UIImageView
                let currentLocation = cell.viewWithTag(2002) as! UILabel
                icon.image = UIImage(named: "LocationPin")
                currentLocation.text = self.userAddress
                currentLocation.font = UIFont(name: GLOBAL_appFont!, size: 10.0)//mark:待改造
            }
        }
        if (indexPath as NSIndexPath).section == 1 {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForRooms", for: indexPath)
            let preImage = cell.viewWithTag(1001) as! UIImageView
            let name = cell.viewWithTag(1002) as! UILabel
            let address = cell.viewWithTag(1003) as! UILabel
            let detailSign = cell.viewWithTag(1004) as!UILabel
            name.text = showDataArray[(indexPath as NSIndexPath).row].name!
            preImage.image = UIImage(named: showDataArray[(indexPath as NSIndexPath).row].preImage!)
            preImage.layer.masksToBounds = true
            preImage.layer.cornerRadius = 10
            preImage.clipsToBounds = true
            address.text = showDataArray[(indexPath as NSIndexPath).row].address!
            detailSign.text = "查看详情"
            name.font = UIFont(name: GLOBAL_appFont!, size: 15.0)
            address.font = UIFont(name: GLOBAL_appFont!, size: 10.0)
            detailSign.font = UIFont(name: GLOBAL_appFont!, size: 10.0)
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    //MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.characters.count>0 {
            self.showData.removeAll()
//            for(var i = 0;i<GLOBAL_RoomInfo.count;i+=1){
//                let temp = GLOBAL_RoomInfo[i]
//                if ((temp.name?.containsString(searchText)) != nil){//此处匹配搜索有问题 2016.8.6
//                    showData.append(temp)
//                }
//            }
            let elements = GLOBAL_RoomInfo.values
            for element in elements{
                if strcmp(element.name!,searchText) == 0{
                    self.showData.append(element)
                }
            }
//            self.showData = GLOBAL_RoomInfo.filter({ (tempElement:RoomInfoModel) -> Bool in
//                    return (tempElement.name?.containsString(searchText))!
//            })
            self.tableView.reloadData()
        }
        else{
            self.showData.removeAll()
            self.showData = nearbyRoomFilter(GLOBAL_RoomInfo)
            self.tableView.reloadData()
        }
    }
    
    //点击回车键，收起键盘
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar(self.search, textDidChange: self.search.text!)
        self.search.resignFirstResponder()
    }
    
    
    //MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let annotationIdentifier = "myStink"
        
        var annotationView = self.mapShow.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        let tempInfo = nearbyRoomFilter(GLOBAL_RoomInfo)
        leftIconView.image = UIImage(named: tempInfo[(indexPath as IndexPath).row - 1].preImage!)
        annotationView?.leftCalloutAccessoryView = leftIconView
        return annotationView
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if fullyRendered == true{
            self.progressView.stopAnimating()
        }
    }
    
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        setUserCurrentLocationAsMapCenter()
//        print("didUpdateUserLocation执行了")
//    }
    
    
    //MARK: - UIScrollViewDelegate
    //滑动时收起键盘 2016.8.14
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.search.resignFirstResponder()
    }
}

