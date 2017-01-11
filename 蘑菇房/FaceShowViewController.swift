//
//  FaceShowViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class FaceShowViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate{
    
    let userDefault = UserDefaults()
    
    @IBOutlet weak var face: UIImageView!
    
    @IBAction func headToSystemPhotoLibrary(_ sender:UINavigationItem,forEvent:UIEvent?){
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
        sheet.popoverPresentationController?.sourceRect = CGRect(x: self.face.center.x, y: self.face.center.y, width: 100, height: 50)
        sheet.popoverPresentationController?.permittedArrowDirections = .up
        
        present(sheet, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        let facePath = NSHomeDirectory() + GLOBAL_UserProfile.facePath!
        face.image = UIImage(contentsOfFile: facePath)
        face.contentMode = .scaleToFill
        let rightItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(FaceShowViewController.headToSystemPhotoLibrary(_: forEvent: )))
        self.navigationItem.rightBarButtonItem = rightItem
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        face.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        face.contentMode = .scaleToFill
        let faceData = UIImageJPEGRepresentation(face.image!, 0.4)
        try?FileManager.default.removeItem(atPath: NSHomeDirectory() + "/Documents/UserCache/\(GLOBAL_UserProfile.id!).jpg")
        try?faceData?.write(to: NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/UserCache/\(GLOBAL_UserProfile.id!).jpg", isDirectory: false) as URL)
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(_ currentImage:UIImage){
        let imageData = UIImageJPEGRepresentation(currentImage, 1)
        print(NSHomeDirectory())
        let filePath = NSHomeDirectory() + "Documents/UserProfile/face.png"
        try? imageData?.write(to: URL(fileURLWithPath: filePath), options: [])
    }
    
    func imageSavedInspector(_ image:UIImage,didFinishSavingWithError:NSError,contextInfo:AnyObject?){
        
    }
    
    //    //MARK: - NavigationSegue
}
