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

class NearbyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIScrollViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var mapShow: MKMapView!
    
    var locationManager:CLLocationManager!
    
    var showData: [RoomInfoModel] = []
    
    var indexPath : NSIndexPath = NSIndexPath(forRow: 5, inSection: 1)
    
    var progressView = UIActivityIndicatorView(frame: CGRectMake(0,0,100,100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProgressView()   //显示加载指示器 2016.8.21
        
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        mapShow.delegate = self
        // Do any additional setup after loading the view.
        
        openLocationService()   //开启定位服务
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    private func setUserCurrentLocationAsMapCenter(){
        self.mapShow.centerCoordinate.latitude = self.mapShow.userLocation.coordinate.latitude
        self.mapShow.centerCoordinate.longitude = self.mapShow.userLocation.coordinate.longitude
    }
    
    private func getReadyForMap(){
        self.mapShow.mapType = MKMapType.Standard
        let latDelta = 0.1
        let lngDelta = 0.1
        let currentLocationSpan = MKCoordinateSpanMake(latDelta, lngDelta)
        
        let showInMap = self.showData
        let annotation = self.mapShow.userLocation
        annotation.title = "我的位置"
        annotation.subtitle = "耶我在这～"
        for i in 0 ..< showInMap.count{
            let temp = showInMap[i]
            let center = CLLocation(latitude: temp.latitude!, longitude: temp.longitude!)
            let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
            self.mapShow.setRegion(currentRegion, animated: true)
            
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = CLLocation(latitude: temp.latitude!, longitude: temp.longitude!).coordinate
            objectAnnotation.title = temp.name
            self.mapShow.addAnnotation(objectAnnotation)
        }
        self.mapShow.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        self.mapShow.showsScale = true
        self.mapShow.showsCompass = true
        let userCenter = CLLocation(latitude: self.mapShow.userLocation.coordinate.longitude, longitude: self.mapShow.userLocation.coordinate.longitude)
        let currentRegion = MKCoordinateRegion(center: userCenter.coordinate, span: currentLocationSpan)
        self.mapShow.setRegion(currentRegion, animated: true)
        print("getReadyForMap执行了")
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
    
    
    
    //MARK: - CLLocationDelegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alert = UIAlertView(title: "提示", message: "定位发生异常：\(error)", delegate: self, cancelButtonTitle: "好")
        alert.show()
        print("didFailWithError执行了")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
        print("纬 : \(mapShow.centerCoordinate.latitude)")
        print("经 : \(mapShow.centerCoordinate.longitude)")
    }
    

    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0{
            return 40
        }
        else if indexPath.section == 1{
            return 100
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0 {
            return 0
        }
        else {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 {
            self.mapShow.centerCoordinate.latitude = self.mapShow.userLocation.coordinate.latitude
            self.mapShow.centerCoordinate.longitude = self.mapShow.userLocation.coordinate.longitude
        }
        else{
            let selectedLocation = nearbyRoomFilter(GLOBAL_RoomInfo)[indexPath.row]
            self.mapShow.centerCoordinate.latitude = selectedLocation.latitude!
            self.mapShow.centerCoordinate.longitude = selectedLocation.longitude!
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "以下列出距您最近的5个蘑菇种植基地"
        }
        else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        }
        else {
            return 30
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        var showDataArray : [RoomInfoModel] = []
        if ((self.search.text?.isEmpty) != nil){
            showDataArray = nearbyRoomFilter(GLOBAL_RoomInfo)
        }
        else{
            showDataArray = self.showData
        }
        
        if indexPath.section == 0{
            if indexPath.row == 0 {
                cell = self.tableView.dequeueReusableCellWithIdentifier("MyLocationCell", forIndexPath: indexPath)
                let icon = cell.viewWithTag(2001) as! UIImageView
                let currentLocation = cell.viewWithTag(2002) as! UILabel
                icon.image = UIImage(named: "LocationPin")
                currentLocation.text = "当前位置：广西壮族自治区南宁市大学路100号附近"    //mark:待改造
            }
        }
        if indexPath.section == 1 {
            cell = self.tableView.dequeueReusableCellWithIdentifier("CellForRooms", forIndexPath: indexPath)
            let preImage = cell.viewWithTag(1001) as! UIImageView
            let name = cell.viewWithTag(1002) as! UILabel
            let address = cell.viewWithTag(1003) as! UILabel
            let detailSign = cell.viewWithTag(1004) as!UILabel
            name.text = showDataArray[indexPath.row].name!
            preImage.image = UIImage(named: showDataArray[indexPath.row].preImage!)
            address.text = showDataArray[indexPath.row].address!
            detailSign.text = "查看详情"
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    //MARK: - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.characters.count>0 {
            self.showData.removeAll()
//            for(var i = 0;i<GLOBAL_RoomInfo.count;i+=1){
//                let temp = GLOBAL_RoomInfo[i]
//                if ((temp.name?.containsString(searchText)) != nil){//此处匹配搜索有问题 2016.8.6
//                    showData.append(temp)
//                }
//            }
            self.showData = GLOBAL_RoomInfo.filter({ (tempElement:RoomInfoModel) -> Bool in
                    return (tempElement.name?.containsString(searchText))!
            })
            self.tableView.reloadData()
        }
        else{
            self.showData.removeAll()
            self.showData = nearbyRoomFilter(GLOBAL_RoomInfo)
            self.tableView.reloadData()
        }
    }
    
    //点击回车键，收起键盘
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar(self.search, textDidChange: self.search.text!)
        self.search.resignFirstResponder()
    }
    
    
    //MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let annotationIdentifier = "myStink"
        
        var annotationView = self.mapShow.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        let tempInfo = nearbyRoomFilter(GLOBAL_RoomInfo)
        leftIconView.image = UIImage(named: tempInfo[indexPath.row - 1].preImage!)
        annotationView?.leftCalloutAccessoryView = leftIconView
        return annotationView
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        if fullyRendered == true{
            self.progressView.stopAnimating()
        }
    }
    
    //MARK: - UIScrollViewDelegate
    //滑动时收起键盘 2016.8.14
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        self.search.resignFirstResponder()
    }
}

