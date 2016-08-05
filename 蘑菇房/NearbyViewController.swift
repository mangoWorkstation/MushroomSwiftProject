//
//  NearbyViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/8/4.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import MapKit

class NearbyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var mapShow: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0{
            return 50
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
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return GLOBAL_NearbyRooms.count //数据量待定 2016.8.5
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
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
            name.text = GLOBAL_NearbyRooms[indexPath.row].name!
            preImage.image = UIImage(named: GLOBAL_NearbyRooms[indexPath.row].preImage!)
            address.text = GLOBAL_NearbyRooms[indexPath.row].address!
            detailSign.text = "查看详情"
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
//    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
//        
//    }
}
