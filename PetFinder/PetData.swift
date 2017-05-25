//
//  PetData.swift
//  PetFinder
//
//  Created by Laban on 2017/4/26.
//  Copyright © 2017年 Cheng Jung Chen. All rights reserved.
//

import UIKit
import Alamofire

class PetData: NSObject {
    static let animalAreaDic = ["2":"臺北市","3":"新北市","4":"基隆市","5":"宜蘭縣","6":"桃園縣","7":"新竹縣","8":"新竹市","9":"苗栗縣","10":"臺中市","11":"彰化縣","12":"南投縣","13":"雲林縣","14":"嘉義縣","15":"嘉義市","16":"臺南市","17":"高雄市","18":"屏東縣","19":"花蓮縣","20":"臺東縣","21":"澎湖縣","22":"金門縣","23":"連江縣","none":"未確認"]
    static let animalShelterDic = ["52":"新北市新莊動物之家",
                                   "69":"彰化縣流浪狗中途之家",
                                   "51":"新北市新店動物之家",
                                   "70":"南投縣公立動物收容所",
                                   "50":"新北市板橋動物之家",
                                   "71":"嘉義市流浪犬收容中心",
                                   "49":"臺北市動物之家",
                                   "72":"嘉義縣流浪犬中途之家",
                                   "48":"基隆市政府動物保護防疫所寵物銀行",
                                   "73":"臺南市灣裡站動物之家",
                                   "53":"新北市中和動物之家",
                                   "74":"臺南市善化站動物之家",
                                   "54":"新北市三峽動物之家",
                                   "75":"高雄市壽山站動物保護教育園區",
                                   "55":"新北市淡水動物之家",
                                   "76":"高雄市燕巢站動物保護教育園區",
                                   "56":"新北市瑞芳動物之家",
                                   "77":"屏東縣流浪動物收容所",
                                   "58":"新北市五股動物之家",
                                   "78":"宜蘭縣流浪動物中途之家",
                                   "59":"新北市八里動物之家",
                                   "79":"花蓮縣流浪犬中途之家",
                                   "60":"新北市三芝動物之家",
                                   "80":"臺東縣流浪動物收容中心",
                                   "61":"桃園市動物保護教育園區",
                                   "81":"連江縣流浪犬收容中心",
                                   "62":"新竹市動物收容所",
                                   "82":"金門縣動物收容中心",
                                   "63":"新竹縣動物收容所",
                                   "83":"澎湖縣流浪動物收容中心",
                                   "64":"苗栗縣北區動物收容中心（竹南鎮公所）",
                                   "89":"雲林縣動植物防疫所",
                                   "65":"苗栗縣苗中區動物收容中心（苗栗市公所）",
                                   "90":"臺中市愛心小站",
                                   "66":"苗栗縣南區動物收容中心（苑裡鎮公所）",
                                   "91":"臺中市中途動物醫院",
                                   "67":"臺中市南屯園區動物之家",
                                   "92":"新北市政府動物保護防疫處",
                                   "68":"臺中市后里園區動物之家",
                                   "94":"新北市金山動物之家"]
    
    static let animalSexTypeDic = ["M":"公","F":"母","N":"未確認"]
    static let animalSterilizationDic = ["T":"是","F":"否","N":"未輸入"]
    static let animalBodyTypeDic = ["MINI":"迷你","SMALL":"小型","MEDIUM":"中型","BIG":"大型"]
    static let adressDic = ["臺中市中途動物醫院":"24.147573, 120.575581",]
    
    static func transAnimalPlace(animalPlaceKey:String) -> String{
        // 判斷動物所在地
        let animalPlaceID = animalAreaDic[animalPlaceKey]
        var animalPlace = ""
        if animalPlaceID != nil {
            animalPlace = animalPlaceID!
        }   else {
            animalPlace = "未輸入"
        }
        return animalPlace
    }
    static func transAnimalSex(animalSexKey:String) -> String {
        let animalSexTypeValue = PetData.animalSexTypeDic[animalSexKey]
        let sexType = animalSexTypeValue!
        return sexType
    }

}
