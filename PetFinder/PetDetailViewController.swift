//
//  PetDetailViewController.swift
//  PetFinder
//
//  Created by Laban on 2017/4/30.
//  Copyright © 2017年 Cheng Jung Chen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PetDetailViewController: UIViewController {
    // Label IBOutlet
    @IBOutlet weak var animalDetailID: UILabel!
    @IBOutlet weak var animalDetailKind: UILabel!
    @IBOutlet weak var animalDetailSexType: UILabel!
    @IBOutlet weak var animalDetailAge: UILabel!
    @IBOutlet weak var animalDetailImageView: UIImageView!
    @IBOutlet weak var animalDetailBodyType: UILabel!
    @IBOutlet weak var animalDetailSterilization: UILabel!
    @IBOutlet weak var aniamlDetailFoundPlace: UILabel!
    @IBOutlet weak var animalDetailOpendate: UILabel!
    @IBOutlet weak var animalDetailClosedDate: UILabel!
    @IBOutlet weak var animalDetailCity: UILabel!
    @IBOutlet weak var animalDetailAdress: UILabel!
    @IBOutlet weak var animalDetailShelterName: UILabel!
    @IBOutlet weak var animalDetailShelterTel: UITextView!
    @IBOutlet weak var animalDetailRemark: UITextView!
    
    // Label Text
    var animalDetailImageUrl : String! = nil
    var animalDetailIDText : String! = nil
    var animalDetailKindText : String! = nil
    var animalDetailSexTypeText : String! = nil
    var animalDetailAgeText : String! = nil
    var animalDetailBodyTypeText : String!  = nil
    var animalDetailSterilizationText : String! = nil
    var aniamlDetailFoundPlaceText : String! = nil
    var animalDetailOpendateText : String! = nil
    var animalDetailClosedDateText : String! = nil
    var animalDetailCityText : String! = nil
    var animalDetailAdressText : String! = nil
    var animalDetailShelterNameText : String! = nil
    var animalDetailShelterTelText : String! = nil
    var animalDetailRemarkTexts: String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDetailData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func labelStyle() {
        
        self.animalDetailID.layer.borderWidth = 1
        self.animalDetailKind.layer.borderWidth = 1
        self.animalDetailSexType.layer.borderWidth = 1
        self.animalDetailAge.layer.borderWidth = 1
        self.animalDetailBodyType.layer.borderWidth = 1
        self.animalDetailSterilization.layer.borderWidth = 1
        self.aniamlDetailFoundPlace.layer.borderWidth = 1
        self.animalDetailOpendate.layer.borderWidth = 1
        self.animalDetailClosedDate.layer.borderWidth = 1
        self.animalDetailCity.layer.borderWidth = 1
        self.animalDetailAdress.layer.borderWidth = 1
        self.animalDetailShelterName.layer.borderWidth = 1
        self.animalDetailShelterTel.layer.borderWidth = 1
        self.animalDetailRemark.layer.borderWidth = 1
        
    }
    
    func loadDetailData() {
        
        if animalDetailImageUrl != nil && animalDetailImageUrl != "" {
            
        let url = URL(string: animalDetailImageUrl!)
        let placeholderImage = #imageLiteral(resourceName: "noimage")
        self.animalDetailImageView?.af_setImage(withURL: url! , placeholderImage:placeholderImage)
        }
        // 編號
        self.animalDetailID.text = " 編號：\(animalDetailIDText!)"
        // 種類
        self.animalDetailKind.text = " 種類：\(animalDetailKindText!)"
        // 性別
        self.animalDetailSexType.text = " 性別：\(animalDetailSexTypeText!)"
        // 年齡
        switch animalDetailAgeText! {
        case "CHILD":
            self.animalDetailAge.text = " 年齡：幼年"
        default:
            self.animalDetailAge.text = " 年齡：成年"
        }
        // 體型
        let bodyTypeKey = animalDetailBodyTypeText
        let bodyTypeValue = PetData.animalBodyTypeDic[bodyTypeKey!]
        self.animalDetailBodyType.text = " 體型：\(bodyTypeValue!)"
        // 結紮
        let sterilizationKey = animalDetailSterilizationText
        let sterilizationValue = PetData.animalSterilizationDic[sterilizationKey!]
        self.animalDetailSterilization.text = " 結紮：\(sterilizationValue!)"
        // 尋獲地
        if self.aniamlDetailFoundPlaceText == ""{
            self.aniamlDetailFoundPlace.text = " 尋獲地：未輸入"
        } else {
        self.aniamlDetailFoundPlace.text = " 尋獲地：\(aniamlDetailFoundPlaceText!)"
        }
        // 開放、結束認養時間
        self.animalDetailOpendate.text = " 開放認養時間：\(animalDetailOpendateText!)"
        self.animalDetailClosedDate.text = " 結束認養時間：\(animalDetailClosedDateText!) "
        // 縣市
        self.animalDetailCity.text = " 縣市：\(animalDetailCityText!)"
        // 地址
        self.animalDetailAdress.text = " 地址：\(aniamlDetailFoundPlaceText!)"
        // 收容單位
        self.animalDetailShelterName.text = " 收容單位：\(animalDetailShelterNameText!)"
        // 電話
        if animalDetailShelterTelText == ""{
        self.animalDetailShelterTel.text = "電話：未輸入"
        } else {
            self.animalDetailShelterTel.text = "電話：\(animalDetailShelterTelText!)"
        }
        
        // 備註
        if self.animalDetailRemarkTexts == ""{
        self.animalDetailRemark.text = "備註：無"
        } else {
            self.animalDetailRemark.text = "備註：\(animalDetailRemarkTexts!)"
        }
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
