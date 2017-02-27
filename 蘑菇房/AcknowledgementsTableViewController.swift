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


    private let titles = ["CountingLabel","ESRefreshControl","ImageHelper","Kingfisher","PDCharts","SwiftyJSON","SwiftCharts","SwiftSpinner",]
    private let https = ["https://github.com/geekbing/CountingLabel",
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath)
        cell.textLabel?.text = self.titles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = NSURL(string: https[indexPath.row])
        print(url?.absoluteString! as Any)
        let vc = SFSafariViewController(url: url as! URL, entersReaderIfAvailable: true)
        present(vc, animated: true, completion: {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        })
    }
    


}

extension AcknowledgementsTableViewController:SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        })
    }

}

