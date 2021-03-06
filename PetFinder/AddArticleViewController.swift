//
//  AddArticleViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/4/19.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase

class AddArticleViewController: UIViewController{

    let uid = memberIdCache.sharedInstance()
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petGender: UITextField!
    @IBOutlet weak var petAge: UITextField!
    @IBOutlet weak var petVariety: UITextField!
    @IBOutlet weak var petFeature: UITextField!
    @IBOutlet weak var missingTime: UITextField!
    @IBOutlet weak var missingLocation: UITextField!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var telephoneNumber: UITextField!    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var remark: UITextField!
    @IBOutlet weak var petImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = FIRAuth.auth()?.currentUser{
            self.uid.userId = user.uid
        }
        petName.delegate = self
        petGender.delegate = self
        petAge.delegate = self
        petVariety.delegate = self
        petFeature.delegate = self
        contactName.delegate = self
        telephoneNumber.delegate = self
        missingTime.delegate = self
        missingLocation.delegate = self
        email.delegate = self
        remark.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func submitButton(_ sender: Any) {
        var newArticle: Dictionary<String, AnyObject> = [:]
        if (self.petName.text != "" &&
            self.petGender.text != "" &&
            self.petAge.text != "" &&
            self.petVariety.text != "" &&
            self.petFeature.text != "" &&
            self.contactName.text != "" &&
            self.telephoneNumber.text != "" &&
            self.missingTime.text != "" &&
            self.missingLocation.text != "" &&
            self.email.text != "" &&
            self.petImageView.image != nil)
        {
            let resizePetImage = resizeImage(image: petImageView.image!, targetSize: CGSize(width: 120, height: 100))
            let uniqueString = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("MissingPetImage").child("\(uniqueString).png")
            if let uploadData = UIImagePNGRepresentation(resizePetImage) {
                storageRef.put(uploadData, metadata: nil, completion: { (data, error) in

                    if error != nil {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                        print("Photo Url: \(uploadImageUrl)")
                        // 创建一个日期格式器
                        let now = Date()
                        let dformatter = DateFormatter()
                        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                        print("当前日期时间：\(dformatter.string(from: now))")
                        
                        newArticle = [
                            "petName": self.petName.text! as AnyObject,
                            "petGender": self.petGender.text! as AnyObject,
                            "petAge": self.petAge.text! as AnyObject,
                            "petVariety": self.petVariety.text! as AnyObject,
                            "petFeature": self.petFeature.text! as AnyObject,
                            "contactName": self.contactName.text! as AnyObject,
                            "telephoneNumber": self.telephoneNumber.text! as AnyObject,
                            "missingTime": self.missingTime.text! as AnyObject,
                            "missingLocation": self.missingLocation.text! as AnyObject,
                            "email": self.email.text! as AnyObject,
                            "remark": self.remark.text! as AnyObject,
                            "missingPetImageURL": uploadImageUrl as AnyObject,
                            "missingPetImageFileName": uniqueString as AnyObject,
                            "UID": self.uid.userId as AnyObject,
                            "addTime": dformatter.string(from: now) as AnyObject
                        ]
                        DataService.dataService.createNewArticle(newArticle)
//                        print("圖片已儲存")
                    }
                })
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func selectImageButton(_ sender: Any) {
        selectImage()
    }
    
}






extension AddArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            petImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func selectImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

