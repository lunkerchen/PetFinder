//
//  PetCollectionViewController.swift
//  PetFinder
//
//  Created by Laban on 2017/4/19.
//  Copyright © 2017年 Cheng Jung Chen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

private let reuseIdentifier = "PetCell"

class PetCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    var animalArray:[Any]?
    
    func loadData() {
        // Load JSON file from open data.
        
        let urlString = "http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=500"
        
        
        Alamofire.request(urlString).responseJSON {
            response in
            self.collectionView?.refreshControl?.endRefreshing()
            guard response.result.isSuccess else{
                print("load data error: \(String(describing: response.result.error))")
                return
            }
            guard let JSON = response.result.value  else {
                print("JSON formate error")
                return
                
            }
            
            if let list = JSON as? [Any] {
                self.animalArray = list
                self.collectionView?.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        if revealViewController() != nil {
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            // 加入手勢判斷
            revealViewController().tapGestureRecognizer()
            revealViewController().panGestureRecognizer()
            // Menu寬度調整至200
            revealViewController().rearViewRevealWidth = 200

            //            revealViewController().rightViewRevealWidth = 150
            //            extraButton.target = revealViewController()
            //            extraButton.action = "rightRevealToggle:"
            
            
            
        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async{
        self.loadData()
        }
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        loadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let num = self.animalArray?.count{
            return num
        } else {
            return 0
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PetCollectionViewCell
        // 讀取第 indexPath.row 的值
        guard let animallist = self.animalArray?[indexPath.row] as? [String:Any] else {
            print("Get row \(indexPath.row) error")
            return cell
        }
        // 動物類型
        let animaltype = animallist["animal_kind"] as! String
        // 判斷動物所在地
        let animalAreaKey = (NSString(format: "%@" , animallist["animal_area_pkid"] as! CVarArg) as String)
        let animalArea = PetData.transAnimalPlace(animalPlaceKey: animalAreaKey)
        // 判斷動物性別
        let sexType = PetData.transAnimalSex(animalSexKey: (animallist["animal_sex"] as! String))
        // 導入 Label 的值
        cell.animalTypeLabel?.text =    "動物類型：\(animaltype)"
        cell.animalPlaceLabel?.text =   "所在縣市：\(animalArea)"
        cell.animalSexLabel?.text =     "性        別：\(sexType)"
        
        // 顯示縮圖
        cell.thumbImageView.layer.borderWidth = 1
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 2
        cell.backgroundColor = UIColor.init(randomFlatColorOf: .dark)
        
        let imgList = animallist["album_file"] as? String
        let placeholderImage = UIImage(named: "noimage")
        if imgList != nil && imgList != ""{
            let url = URL(string: imgList!)
            
            cell.thumbImageView?.af_setImage(withURL: url!, placeholderImage: placeholderImage)
            
        } else {
            cell.thumbImageView?.image = placeholderImage
        }
                
        return cell
    }
    

    
    func transAnimalSex(animalSexKey:String) -> String {
        let animalSexTypeValue = PetData.animalSexTypeDic[animalSexKey]
        let sexType = animalSexTypeValue!
        return sexType
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PetDetail" {
                let petDetailVC = segue.destination as? PetDetailViewController
                if let indexPaths = self.collectionView?.indexPathsForSelectedItems{
                var animallist = self.animalArray?[indexPaths[0].row] as? [String:Any]
                
                // 點選CollectionViewCell後將資料代入下一個vc
                petDetailVC?.animalDetailImageUrl = animallist?["album_file"] as? String
                petDetailVC?.animalDetailIDText = animallist?["animal_id"] as? String
                petDetailVC?.animalDetailKindText = animallist?["animal_kind"] as? String
                petDetailVC?.animalDetailSexTypeText = PetData.transAnimalSex(animalSexKey: (animallist?["animal_sex"] as? String)!)
                petDetailVC?.animalDetailAgeText = animallist?["animal_age"] as? String
                petDetailVC?.animalDetailBodyTypeText = animallist?["animal_bodytype"] as? String
                petDetailVC?.animalDetailSterilizationText = animallist?["animal_sterilization"] as? String
                petDetailVC?.aniamlDetailFoundPlaceText = animallist?["animal_foundplace"] as? String
                petDetailVC?.animalDetailOpendateText = animallist?["animal_opendate"] as? String
                petDetailVC?.animalDetailClosedDateText = animallist?["animal_closeddate"] as? String
               let animalAreaKey = (NSString(format: "%@" , animallist?["animal_area_pkid"] as! CVarArg) as String)
                    
                petDetailVC?.animalDetailCityText = PetData.transAnimalPlace(animalPlaceKey: animalAreaKey)
                    
                petDetailVC?.animalDetailAdressText = animallist?["shelter_adress"] as? String
                petDetailVC?.animalDetailShelterNameText = animallist?["shelter_name"] as? String
                petDetailVC?.animalDetailShelterTelText = animallist?["shelter_tel"] as? String
                petDetailVC?.animalDetailRemarkTexts = animallist?["animal_remark"] as? String
            }
        }
    }
}
