//
//  LoginViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/14.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate{
    
    
    
    @IBOutlet weak var userNameInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var enroll: UIButton!
    
    @IBOutlet weak var visitor: UIButton!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBAction func click(sender:UIButton,forEvent:UIEvent?){
        if sender.tag == 1000 {
            if userNameInput.text?.isEmpty == false && passwordInput.text?.isEmpty == false{
                performSegue(withIdentifier: "Main", sender: nil)
            }
            else {
                let alert = UIAlertController(title: "登录错误", message: "用户名和密码不能为空", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        if sender.tag == 1004{
            performSegue(withIdentifier: "Main", sender: nil)
        }
        if sender.tag == 1005{
            performSegue(withIdentifier: "Enroll", sender: nil)
        }
    }
    
    @IBAction func unwindSegueToLogin(segue:UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameInput.delegate = self
        passwordInput.delegate = self
        
        //输入框
        userNameInput.placeholder = "请输入用户ID/手机"
        userNameInput.font = UIFont(name: GLOBAL_appFont!, size: 16)
        userNameInput.keyboardType = .numberPad
        userNameInput.clearButtonMode = .whileEditing
        userNameInput.returnKeyType = .done
        userNameInput.keyboardAppearance = .dark
        userNameInput.tag = 1001
        passwordInput.placeholder = "请输入密码"
        passwordInput.font = UIFont(name: GLOBAL_appFont!, size: 16)
        passwordInput.keyboardType = .emailAddress
        passwordInput.keyboardAppearance = .dark
        passwordInput.returnKeyType = .done
        passwordInput.clearButtonMode = .whileEditing
        passwordInput.isSecureTextEntry = true //遮盖密码
        passwordInput.tag = 1002
        
        login.setTitle("                    登录                    ", for: .normal)
        //20个空格
        login.backgroundColor = UIColor(red: 250/255, green: 181/255, blue: 14/255, alpha: 1)
        login.tintColor = UIColor.white
        login.clipsToBounds = true
        login.layer.masksToBounds = true
        login.layer.cornerRadius = 7
        login.tag = 1000
        login.addTarget(self, action: #selector(LoginViewController.click(sender:forEvent:)), for: .touchUpInside)
        
        visitor.setTitle("       跳过注册，我先试用      ", for: .normal)
        //20个空格
        visitor.backgroundColor = UIColor.white
        visitor.tintColor = UIColor.black
        visitor.clipsToBounds = true
        visitor.layer.masksToBounds = true
        visitor.layer.cornerRadius = 7
        visitor.tag = 1004
        visitor.addTarget(self, action: #selector(LoginViewController.click(sender:forEvent:)), for: .touchUpInside)
        
        
        enroll.setTitle("还没注册？点击这里>>", for: .normal)
        enroll.contentHorizontalAlignment = .center
        enroll.tintColor = UIColor.white
        enroll.addTarget(self, action: #selector(LoginViewController.click(sender:forEvent:)), for: .touchUpInside)
        enroll.tag = 1005
        
        background.image = UIImage(named: "ChooseAreaBackground")
        background.contentMode = .scaleToFill
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Main"{
            let _ = segue.destination as! TabbarViewController
        }
        
        if segue.identifier == "Enroll"{
            let vc = segue.destination as! EnrollmentViewController
            vc.navigationItem.backBarButtonItem?.title = "登录蘑菇云"
            vc.navigationItem.title = "注册"
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
