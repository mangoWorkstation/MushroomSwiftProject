//
//  pageScrollWebViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/18.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class pageScrollWebViewController: UIViewController,UIWebViewDelegate{
    
    var url : String?
    
    private var progressView = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        let requestURL = NSURL(string: url!)
        webView.loadRequest(URLRequest(url: requestURL as! URL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30))
        //超时时间
        setProgressView()
    }
    
    fileprivate func setProgressView(){
        progressView.center = self.view.center
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        let label = UILabel(frame: CGRect(x: 21, y: 57, width: 70, height: 50))
        label.text = "正在加载..."
        label.textColor = UIColor.white
        label.font = UIFont(name: GLOBAL_appFont!, size: 12)
        progressView.addSubview(label)
        progressView.backgroundColor = UIColor.lightGray
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 20
        progressView.clipsToBounds = true 
        self.view.addSubview(progressView)
        progressView.startAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(_ webView: UIWebView){
        progressView.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        progressView.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        progressView.stopAnimating()
        let alert = UIAlertController(title: "网络连接失败", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
