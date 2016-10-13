//
//  FaceShowViewController.swift
//  蘑菇房
//
//  Created by 芒果君 on 16/7/22.
//  Copyright © 2016年 蘑菇房工作室. All rights reserved.
//

import UIKit

class FaceShowViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate{

    
    @IBOutlet weak var face: UIImageView!
    
    
    @IBAction func headToSystemPhotoLibrary(_ sender:UINavigationItem,forEvent:UIEvent?){
        let sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册中选择")
        sheet.show(in: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        face.image = UIImage(named: GLOBAL_UserProfile.face!)
        let rightItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(FaceShowViewController.headToSystemPhotoLibrary(_: forEvent: )))
        self.navigationItem.rightBarButtonItem = rightItem
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveImage(self.face.image!)
        print("图片已保存")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int){
        if buttonIndex == 1{
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerVC = UIImagePickerController()
                imagePickerVC.allowsEditing = false
                imagePickerVC.sourceType = .camera
                imagePickerVC.cameraDevice = .front
                imagePickerVC.delegate = self
                self.present(imagePickerVC, animated: true, completion: nil)
            }
        }
        if buttonIndex == 2 {
            if ((GLOBAL_deviceModel?.contains("iPhone")) != nil){
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePickerVC = UIImagePickerController()
                    imagePickerVC.allowsEditing = false
                    imagePickerVC.sourceType = .photoLibrary
                    imagePickerVC.delegate = self
                    self.present(imagePickerVC, animated: true, completion: nil)
                }
            }
            else if ((GLOBAL_deviceModel?.contains("iPad")) != nil){
//                if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
//                    let imagePickerVC = UIImagePickerController()
//                    imagePickerVC.allowsEditing = false
//                    imagePickerVC.sourceType = .PhotoLibrary
//                    imagePickerVC.delegate = self
//                }
                

            }
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        face.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        face.contentMode = .scaleAspectFit
//        UIImageWriteToSavedPhotosAlbum(face.image, self, , )
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
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowSystemPhotoAlbumSegue"{
//            let vc = segue.destinationViewController as! UIImagePickerController
//            vc.popoverPresentationController?.delegate = self
//            vc.preferredContentSize = CGSize(width: 320, height: 300)
//            vc.delegate = self
//        }
//    }
}
