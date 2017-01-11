//
//  SetupProfileViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 2016/11/17.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SetupProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAdaptivePresentationControllerDelegate{
    
    
    @IBOutlet weak var face: UIButton!
    
    private var facePath:String?
    
    @IBOutlet weak var nickNameInput: UITextField!
    
    @IBOutlet weak var gender: UISegmentedControl!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var receivedPhoneNUM : String!
    
    @IBAction func changeFace(sender:UIButton,forEvent:UIEvent?){
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: {
            (action)->Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerVC = UIImagePickerController()
                imagePickerVC.allowsEditing = false
                imagePickerVC.sourceType = .camera
                imagePickerVC.cameraDevice = .front
                imagePickerVC.delegate = self
                self.present(imagePickerVC, animated: true, completion: nil)
            }
            
        }))
        sheet.addAction(UIAlertAction(title: "从手机相册选择", style: .default, handler: {
            (action)->Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePickerVC = UIImagePickerController()
                imagePickerVC.allowsEditing = false
                imagePickerVC.sourceType = .photoLibrary
                imagePickerVC.delegate = self
                self.present(imagePickerVC, animated: true, completion: nil)
            }
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        sheet.popoverPresentationController?.sourceView = self.view
        sheet.popoverPresentationController?.sourceRect = CGRect(x: self.face.frame.midX, y: self.face.frame.maxY, width: 100, height: 50)
        sheet.popoverPresentationController?.permittedArrowDirections = .left
        
        //泡泡模式，针对iPad使用。不用加判别设备类型，因为iPhone不care这两行代码
        present(sheet, animated: true, completion: nil)
        
    }
    
    @IBAction func resaveUserProfile(sender:UIButton,forEvent:UIEvent?){
        if self.nickNameInput.text != nil && self.password.text != nil{
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let context = appDel.managedObjectContext
            let entity = NSEntityDescription.insertNewObject(forEntityName: "UserProperties", into: context) as! UserPropertiesManagedObject
            let encodedPassword = password.text?.hmac(algorithm: .MD5, key: self.receivedPhoneNUM)
            
            entity.facePath = self.facePath!
            entity.nickName = self.nickNameInput.text!
            entity.id = Int64(self.receivedPhoneNUM)!
            entity.password = encodedPassword!
            entity.root = Int64(0)
            entity.sex = Int64(self.gender.selectedSegmentIndex)
            entity.province = nil
            entity.city = nil
            entity.allowPushingNewMessageToMobile = true
            entity.allowPushingNotification = true
            
            do {
                try context.save()
            } catch let error{
                print("context can't save!, Error: \(error)")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "完善个人资料"
        titleLabel.font = UIFont(name: GLOBAL_appFont!, size: 20)
        titleLabel.textAlignment = .center
        
        face.setTitle(nil, for: .normal)
        face.setImage(UIImage(named: "User")?.withRenderingMode(.alwaysOriginal), for: .normal)
        face.contentMode = .scaleToFill
        face.clipsToBounds = true
        face.layer.masksToBounds = true
        face.layer.cornerRadius = 40
        face.layer.borderWidth = 3
        face.layer.borderColor = UIColor.lightGray.cgColor
        face.addTarget(self, action: #selector(SetupProfileViewController.changeFace(sender:forEvent:)), for: .touchUpInside)
        let faceData = UIImageJPEGRepresentation(face.currentImage!, 0.4)
        
        let path = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/UserCache", isDirectory: true)
        try?FileManager.default.createDirectory(at: path as URL, withIntermediateDirectories: false, attributes: nil)
        try?faceData?.write(to: NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/UserCache/\(self.receivedPhoneNUM!).jpg", isDirectory: false) as URL)
        self.facePath = "/Documents/UserCache/\(self.receivedPhoneNUM!).jpg"
        
        gender.setTitle("女", forSegmentAt: 0)
        gender.setTitle("男", forSegmentAt: 1)
        
        nickNameInput.placeholder = "输入昵称"
        nickNameInput.keyboardType = .default
        nickNameInput.keyboardAppearance = .dark
        nickNameInput.clearButtonMode = .whileEditing
        nickNameInput.returnKeyType = .done
        nickNameInput.font = UIFont(name: GLOBAL_appFont!, size: 16)
        nickNameInput.delegate = self
        nickNameInput.tag = 1001
        
        password.placeholder = "6～16位密码，英文字母或数字"
        password.keyboardType = .default
        password.keyboardAppearance = .dark
        password.clearButtonMode = .whileEditing
        password.returnKeyType = .done
        password.isSecureTextEntry = true
        password.delegate = self
        
        password.font = UIFont(name: GLOBAL_appFont!, size: 14)
        password.tag = 1002
        
        submit.setTitle("            完成填写            ", for: .normal)
        submit.backgroundColor = UIColor(red: 250/255, green: 181/255, blue: 14/255, alpha: 1)
        submit.tintColor = UIColor.white
        submit.clipsToBounds = true
        submit.layer.masksToBounds = true
        submit.layer.cornerRadius = 7
        submit.addTarget(self, action: #selector(SetupProfileViewController.resaveUserProfile(sender:forEvent:)), for: .touchUpInside)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        face.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        face.contentMode = .scaleToFill
        let faceData = UIImageJPEGRepresentation(face.currentImage!, 0.4)
        try?FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/UserCache/\(self.receivedPhoneNUM!).jpg")
        let path = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/UserCache", isDirectory: true)
        try?FileManager.default.createDirectory(at: path as URL, withIntermediateDirectories: false, attributes: nil)
        try?faceData?.write(to: NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/UserCache/\(self.receivedPhoneNUM!).jpg", isDirectory: false) as URL)
        self.facePath = "/Documents/UserCache/\(self.receivedPhoneNUM!).jpg"
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
