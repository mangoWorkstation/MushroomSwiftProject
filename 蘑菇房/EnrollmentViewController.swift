//
//  EnrollmentViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/16.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import CoreData

class EnrollmentViewController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var phoneNumInput: UITextField!
    
    @IBOutlet weak var authCode: UITextField!
    
    @IBOutlet weak var requestAuthCode: UIButton!
    
    @IBOutlet weak var countingNumView: UIView!
    
    @IBOutlet weak var countingNumAdditionalLabel: UILabel!
    
    @IBOutlet weak var submit: UIButton!
    
    private var progressView = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
    
    private var timer:Timer?
    
    private let countingNum = UICountingLabel(frame: CGRect(x: 0, y: 0, width: 28, height: 30))
    
    
    //老方法，等价于闭包
    @IBAction func timerInvalidate_1(){
        //发送网络请求
        progressView.stopAnimating()
        self.countingNumView.addSubview(self.countingNum)
        self.countingNumAdditionalLabel.text = " 秒后可重新获取"
        if self.countingNum.currentValue() == 0{
            self.countingNum.removeFromSuperview()
            self.countingNumAdditionalLabel.text = nil
            self.requestAuthCode.setTitle("获取验证码", for: .normal)
        }
    }
    
    @IBAction func timerInvalidate_2(){
        progressView.stopAnimating()
        if authCode.isFirstResponder {
            authCode.resignFirstResponder()
        }
        else if phoneNumInput.isFirstResponder {
            phoneNumInput.resignFirstResponder()
        }
        if progressView.isAnimating == false{
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let context = appDel.managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "UserProperties", in: context)
            var count = 1
            if entity != nil{
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                fetchRequest.entity = entity
                let data = try? context.fetch(fetchRequest) as! [UserPropertiesManagedObject]
                for temp in data!{
                    if temp.id == Int64(self.phoneNumInput.text!)!{
                        break
                    }
                    count += 1
                }
                //防止重复处理
                if count <= (data?.count)!{
                    let alert = UIAlertController(title: "注册失败", message: "该手机号已被注册", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                    
                }
                else{
                    //接受网络数据，解析结果，以后需要加一个判断，默认成功
                    let alert = UIAlertController(title: "验证成功", message: "进入下一步完善你的资料", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .default, handler: {
                        (action)->Void in
                        self.performSegue(withIdentifier: "SetupProfile", sender: nil)
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func click(sender:UIButton,forEvent:UIEvent?){
        if sender.tag == 1003{
            if sender.currentTitle != "验证码已发送..."{
                if self.phoneNumInput.text?.characters.count == 11{
                    setProgressView(tag: "正在加载...")
                    countingNum.countFrom(60, endValue: 0, duration: 60.0)
                    if #available(iOS 10.0, *) {
                        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: {
                            (timer)-> Void in
                            //发送网络请求
                            self.progressView.stopAnimating()
                            self.countingNumView.addSubview(self.countingNum)
                            self.countingNumAdditionalLabel.text = "秒后可重新获取"
                            if self.countingNum.currentValue() == 0{
                                self.countingNum.removeFromSuperview()
                                self.countingNumAdditionalLabel.text = nil
                                self.requestAuthCode.setTitle("获取验证码", for: .normal)
                            }
                            
                        })
                    } else {
                        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(EnrollmentViewController.timerInvalidate_1), userInfo: nil, repeats: true)
                        // Fallback on earlier versions
                    }
                    self.requestAuthCode.setTitle("验证码已发送...", for: .normal)
                    self.requestAuthCode.setTitleColor(UIColor(white: 0.8, alpha: 1), for: .disabled)
                    self.requestAuthCode.titleColor(for: .disabled)
                    if authCode.isFirstResponder {
                        authCode.resignFirstResponder()
                    }
                    else if phoneNumInput.isFirstResponder {
                        phoneNumInput.resignFirstResponder()
                    }
                    
                }
                else{
                    let alert = UIAlertController(title: "手机号码格式错误", message: "中国大陆手机号码为11位", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
        if sender.tag == 1004 {
            if (self.phoneNumInput.text?.isEmpty)! || (self.authCode.text?.isEmpty)!{
                let alert = UIAlertController(title: "注册失败", message: "请输入手机号码和验证码", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            else if self.phoneNumInput.text?.characters.count != 11 {
                let alert = UIAlertController(title: "手机号码格式错误", message: "中国大陆手机号码为11位", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            else if self.authCode.text?.characters.count != 4 {
                let alert = UIAlertController(title: "验证码格式错误", message: "验证码应为4位数字", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
            }
            else{
                setProgressView(tag: nil)
                timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(EnrollmentViewController.timerInvalidate_2), userInfo: nil, repeats: false)
                //                progressView.stopAnimating()
                if authCode.isFirstResponder {
                    authCode.resignFirstResponder()
                }
                else if phoneNumInput.isFirstResponder {
                    phoneNumInput.resignFirstResponder()
                }
                
                //解析验证结果，先默认认证成功
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "请输入您的手机号📱"
        titleLabel.font = UIFont(name: GLOBAL_appFont!, size: 16)
        
        
        phoneNumInput.placeholder = "常用手机号"
        phoneNumInput.keyboardType = .numberPad
        phoneNumInput.keyboardAppearance = .dark
        phoneNumInput.clearButtonMode = .whileEditing
        phoneNumInput.returnKeyType = .next
        phoneNumInput.font = UIFont(name: GLOBAL_appFont!, size: 16)
        phoneNumInput.tag = 1001
        
        authCode.placeholder = "短信验证码"
        authCode.keyboardType = .numberPad
        authCode.keyboardAppearance = .dark
        authCode.clearButtonMode = .whileEditing
        authCode.returnKeyType = .next
        authCode.font = UIFont(name: GLOBAL_appFont!, size: 16)
        authCode.tag = 1002
        
        requestAuthCode.setTitle("获取验证码", for: .normal)
        requestAuthCode.backgroundColor = UIColor(red: 250/255, green: 181/255, blue: 14/255, alpha: 1)
        requestAuthCode.tintColor = UIColor.white
        requestAuthCode.clipsToBounds = true
        requestAuthCode.layer.masksToBounds = true
        requestAuthCode.layer.cornerRadius = 7
        requestAuthCode.tag = 1003
        requestAuthCode.addTarget(self, action: #selector(EnrollmentViewController.click(sender:forEvent:)), for: .touchUpInside)
        
        countingNum.font = UIFont(name: GLOBAL_appFont!, size: 12)
        countingNum.textColor = UIColor.black
        
        countingNumAdditionalLabel.text = nil
        countingNumAdditionalLabel.font = UIFont(name: GLOBAL_appFont!, size: 11)
        
        submit.setTitle("       验证手机号       ", for: .normal)
        submit.backgroundColor = UIColor(red: 250/255, green: 181/255, blue: 14/255, alpha: 1)
        submit.tintColor = UIColor.white
        submit.clipsToBounds = true
        submit.layer.masksToBounds = true
        submit.layer.cornerRadius = 7
        submit.tag = 1004
        submit.addTarget(self, action: #selector(EnrollmentViewController.click(sender:forEvent:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setProgressView(tag:String?){
        progressView.center = self.view.center
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        let label = UILabel(frame: CGRect(x: 21, y: 57, width: 70, height: 50))
        label.text = tag
        label.textColor = UIColor.white
        label.font = UIFont(name: GLOBAL_appFont!, size: 12)
        progressView.addSubview(label)
        progressView.backgroundColor = UIColor.lightGray
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 20
        progressView.clipsToBounds = true   //磨成圆角
        self.view.addSubview(progressView)
        progressView.startAnimating()
        progressView.becomeFirstResponder()
        
    }
    
    //MARK: - UIStoryBoardSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetupProfile"{
            let vc = segue.destination as! SetupProfileViewController
            vc.receivedPhoneNUM = phoneNumInput.text!
        }
    }
    
}
