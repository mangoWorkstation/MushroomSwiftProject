//
//  AcknowledgementsTableViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 2017/2/26.
//  Copyright © 2017年 蘑菇房工作室. All rights reserved.
//

import UIKit
import SafariServices

class AcknowledgementsTableViewController: UITableViewController {


    private let titles_section_1 = ["广西大学","广西大学计算机与电子信息学院","广西大学农学院"]
    private let https_section_1 = ["http://www.gxu.edu.cn","http://nxy.gxu.edu.cn","http://www.ccie.gxu.edu.cn"]
    
    private let titles_section_2 = ["CountingLabel","ESRefreshControl","ImageHelper","Kingfisher","PDCharts","SwiftyJSON","SwiftCharts","SwiftSpinner",]
    private let https_section_2 = ["https://github.com/geekbing/CountingLabel",
                         "https://github.com/EnjoySR/ESRefreshControl",
                         "https://github.com/melvitax/ImageHelper",
                         "https://github.com/onevcat/Kingfisher",
                         "https://github.com/PandaraWen/PDChart",
                         "https://github.com/i-schuetz/SwiftCharts",
                         "https://github.com/SwiftyJSON/SwiftyJSON",
                         "https://github.com/icanzilb/SwiftSpinner",
                         ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }
        else{
            return 8
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath)
        if indexPath.section == 0{
            cell.textLabel?.text = self.titles_section_1[indexPath.row]
        }
        else{
            cell.textLabel?.text = self.titles_section_2[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var url = NSURL()
        if indexPath.section == 0{
            url = NSURL(string: https_section_1[indexPath.row])!
        }
        else{
            url = NSURL(string: https_section_2[indexPath.row])!
        }
        let vc = SFSafariViewController(url: url as URL, entersReaderIfAvailable: true)
        present(vc, animated: true, completion: {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        })
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "机构"
        }
        else{
            return "开源框架"
        }
    }
    


}

extension AcknowledgementsTableViewController:SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        })
    }

}

