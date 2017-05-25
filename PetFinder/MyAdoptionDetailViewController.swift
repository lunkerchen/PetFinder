//
//  MyAdoptionDetailViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/19.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase


class MyAdoptionDetailViewController: UIViewController {
    
    let adoptionInfo = memberIdCache.sharedInstance()
 
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petGender: UITextField!
    @IBOutlet weak var petAge: UITextField!
    @IBOutlet weak var petVariety: UITextField!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var telephoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var remark: UITextField!
    
    var myActivityIndicator:UIActivityIndicatorView!
    var adoptionId :String =  ""
    var md5Hex :String = ""
    
    @IBAction func selectImage(_ sender: Any) {
        selectImage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        adoptionId = adoptionInfo.adoptionList[adoptionInfo.selectMyAdoptionRow]

        petName.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectMyAdoptionRow]])?["petName"] as? String
        petGender.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectMyAdoptionRow]])?["petGender"] as? String
        petAge.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["petAge"] as? String
        petVariety.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["petVariety"] as? String
        contactName.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["contactName"] as? String
        telephoneNumber.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["telephoneNumber"] as? String
        email.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["email"] as? String
        remark.text = (self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectAdoptionRow]])?["remark"] as? String
        
        let saveFilePathString = ((self.adoptionInfo.adoptionFireUploadDic?[self.adoptionInfo.adoptionList[adoptionInfo.selectMyAdoptionRow]])?["AdoptionPetImageFileName"] as? String)!
        let saveFilePath = NSTemporaryDirectory() + "\(saveFilePathString).data"
        petImage.image = UIImage(contentsOfFile: saveFilePath)!

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveData(_ sender: Any) {
//        var newArticle: Dictionary<String, AnyObject> = [:]
        if (self.petName.text != "" &&
            self.petGender.text != "" &&
            self.petAge.text != "" &&
            self.petVariety.text != "" &&
            self.contactName.text != "" &&
            self.telephoneNumber.text != "" &&
            self.email.text != "" &&
            self.petImage.image != nil)
        {
            
            let fullScreenSize = UIScreen.main.bounds.size
            // 建立一個 UIActivityIndicatorView
            myActivityIndicator = UIActivityIndicatorView(
                activityIndicatorStyle:.whiteLarge)
            // 環狀進度條的顏色
            myActivityIndicator.color = UIColor.red
            // 底色
            myActivityIndicator.backgroundColor =
                UIColor.white
            // 設置位置並放入畫面中
            myActivityIndicator.center = CGPoint(
                x: fullScreenSize.width * 0.5,
                y: fullScreenSize.height * 0.4)
            self.view.addSubview(myActivityIndicator);
            myActivityIndicator.startAnimating()
            
            
            let resizePetImage = resizeImage(image: petImage.image!, targetSize: CGSize(width: 120, height: 100))
            let storageRef = FIRStorage.storage().reference().child("AddAdoptionPetImage").child("\(md5Hex).png")
            print("fuck you")
            if let uploadData = UIImagePNGRepresentation(resizePetImage) {
                storageRef.put(uploadData, metadata: nil, completion: { (data, error) in
                    if error != nil {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                        print("Photo Url: \(uploadImageUrl)")
                        
                        FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["AdoptionPetImageFileName": self.md5Hex])
                        FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["AdoptionPetImageURL": uploadImageUrl], withCompletionBlock: { (error:Error?, ref:FIRDatabaseReference!) in
                            self.myActivityIndicator.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                })
            }
            FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["petName": self.petName.text as Any])
            FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["petGender": self.petGender.text as Any])
            FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["petAge": self.petAge.text as Any])
            FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["petVariety": self.petVariety.text as Any])
            FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["contactName": self.contactName.text as Any])
            FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["telephoneNumber": self.telephoneNumber.text as Any])
            FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["email": self.email.text as Any])
            FIRDatabase.database().reference(fromURL: "\(BASE_URL)/Adoption/\(self.adoptionId)/").updateChildValues(["remark": self.remark.text as Any])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MyAdoptionDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            petImage.image = pickedImage
            
            //將info轉換成string
            let cookieHeader = (info.flatMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }) as Array).joined(separator: ";")
            print("cookieHeader:\(cookieHeader)")
            //轉成MD5檔案
            let md5Data = MD5(string: cookieHeader)
            //轉成Hash值
             md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
            print("md5Hex: \(md5Hex)")
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
    
    func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
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
