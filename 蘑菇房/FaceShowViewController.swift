//
//  FaceShowViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class FaceShowViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var face: UIImageView!
    
    
    @IBAction func headToSystemPhotoLibrary(sender:UINavigationItem,forEvent:UIEvent?){
        let sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "自拍一张嘛～", "从相册中选择")
        sheet.showInView(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        face.image = UIImage(named: GLOBAL_UserProfile.face!)
        let rightItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(FaceShowViewController.headToSystemPhotoLibrary(_: forEvent: )))
        self.navigationItem.rightBarButtonItem = rightItem
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 1{
            if UIImagePickerController.isSourceTypeAvailable(.Camera){
                let imagePickerVC = UIImagePickerController()
                imagePickerVC.allowsEditing = false
                imagePickerVC.sourceType = .Camera
                imagePickerVC.cameraDevice = .Front
                imagePickerVC.delegate = self
                self.presentViewController(imagePickerVC, animated: true, completion: nil)
            }
        }
        if buttonIndex == 2 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let imagePickerVC = UIImagePickerController()
                imagePickerVC.allowsEditing = false
                imagePickerVC.sourceType = .PhotoLibrary
                imagePickerVC.delegate = self
                self.presentViewController(imagePickerVC, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        face.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        face.contentMode = .ScaleAspectFit
//        UIImageWriteToSavedPhotosAlbum(face.image, self, <#T##completionSelector: Selector##Selector#>, <#T##contextInfo: UnsafeMutablePointer<Void>##UnsafeMutablePointer<Void>#>)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage(currentImage:UIImage){
        let imageData = UIImageJPEGRepresentation(currentImage, 1)
        print(NSHomeDirectory())
        let filePath = NSHomeDirectory().stringByAppendingString("Documents/UserProfile/face.png")
        imageData?.writeToFile(filePath, atomically: false)
    }
    
    func imageSavedInspector(image:UIImage,didFinishSavingWithError:NSError,contextInfo:AnyObject?){
        
    }

}
