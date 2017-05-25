//
//  ArticleListTableViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/4/24.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit
import Firebase
import BTNavigationDropdownMenu

class ArticleListTableViewController: UITableViewController,UINavigationBarDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var mainTableView: UITableView!
    let articleInfo = memberIdCache.sharedInstance()
    var menuView: BTNavigationDropdownMenu!


    
    override func viewDidLoad() {
        articleInfo.currentUser = FIRAuth.auth()?.currentUser
        loadFirebaseData()
        loadAdoptionData()
        revealViewController().rearViewRevealWidth = 200
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        revealViewController().panGestureRecognizer()
        revealViewController().tapGestureRecognizer()
        
    }
    @IBAction func menuBtn(_ sender: UIBarButtonItem) {
        helloMenu()
    }
    
    func helloMenu(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let onview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*2))
        onview.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 0.5)
        
        view.addSubview(onview)
    }


    override func viewWillAppear(_ animated: Bool) {
        let items = ["民眾協尋資訊", "民眾領養資訊"]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "民眾協尋資訊", items: items as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if (indexPath == 1) {
                self?.performSegue(withIdentifier: "toAdoptionTableViewControllerSegue", sender: nil)
            }
        }
        print("viewWillAppear")
        revealViewController().rightRevealToggle(animated: false) // 登入後 左邊menu縮回去
        
        
        if (FIRAuth.auth()?.currentUser) != nil{
            articleInfo.userId = (String(describing: (FIRAuth.auth()?.currentUser?.uid)!))
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            let defaultBlueColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            self.navigationItem.rightBarButtonItem?.tintColor = defaultBlueColor
        }else{
            articleInfo.userId = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        }
        
        loadFirebaseData()
        self.tableView.reloadData()
    }


    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    
    func loadFirebaseData () {
        DataService.dataService.ARTICLEID_REF.observe(.value, with: { [weak self] (snapshot) in
            if let uploadDataDic = snapshot.value as? [String:Dictionary<String, Any>] {
                print("****************\(uploadDataDic)")
                self?.articleInfo.fireUploadDic = uploadDataDic
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    print("****************\(snapshots)")
                    var tempArticleId: [String] = []
                    for snap in snapshots {
                        tempArticleId.insert(snap.key, at: 0) //文章ID
                        print("****************\(tempArticleId)")
                        self?.articleInfo.articleList = tempArticleId
                    }
                }
                self?.tableView.reloadData()
            }
        })
    }
    func loadAdoptionData () {
        DataService.dataService.ADOPTION_REF.observe(.value, with: { [weak self] (snapshot) in
            if let uploadDataDic = snapshot.value as? [String:Dictionary<String, Any>] {
                self?.articleInfo.adoptionFireUploadDic = uploadDataDic
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    var tempAdoption: [String] = []
                    for snap in snapshots {
                        tempAdoption.insert(snap.key, at: 0) //文章ID
                        self?.articleInfo.adoptionList = tempAdoption
                    }
                }
                self?.tableView.reloadData()
            }
        })
    }
 
    func checkImage(indexPathRow:Int) -> UIImage{
        let saveFilePathString = ((self.articleInfo.fireUploadDic?[self.articleInfo.articleList[indexPathRow]])?["missingPetImageFileName"] as? String)!
        let saveFilePath = NSTemporaryDirectory() + "\(saveFilePathString).data"
//        print("儲存位置是：\(saveFilePath)")
        let fileManager = FileManager()
        var isDir:ObjCBool = false
        let isExist = fileManager.fileExists(atPath: saveFilePath,isDirectory: &isDir)
        if isExist == true && isDir.boolValue == false{
//            print("該檔案存在，是檔案")
            return UIImage(contentsOfFile: saveFilePath)!
        }else if isExist == false{
//            print("該檔案不存在，下載檔案")
            downloadeImage(indexPathRow: indexPathRow,saveFilePath: saveFilePath)
        }
        return UIImage(named: "熊大.png")!
    }
    
    func downloadeImage(indexPathRow:Int,saveFilePath: String) {
        let saveFilePathStringURL = ((self.articleInfo.fireUploadDic?[self.articleInfo.articleList[indexPathRow]])?["missingPetImageURL"] as? String)!
        let webAddress = saveFilePathStringURL
        let webURL = URL(string: webAddress)
        if let url = webURL{
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: {
                    (data:Data?, response:URLResponse?, error:Error?) in
                    if error != nil{
//                        print("發生錯誤：\(error!.localizedDescription)")
                        return
                    }
                    if let downloadedData = data{
//                        print("暫存資料夾：\(saveFilePath)")
                        if let downloadeImage = UIImage(data:downloadedData){
                            if let dataToSave = UIImagePNGRepresentation(downloadeImage){
                                do{
                                    try dataToSave.write(to: URL(fileURLWithPath: saveFilePath), options: [.atomic])
//                                    print("儲存成功")
                                }catch{
//                                    print("無法順利儲存")
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            task.resume()
        }
    }
    
    
    
//    @IBAction func accountLogout(_ sender: Any) {
//        if FIRAuth.auth()?.currentUser != nil {
//            do {
//                try FIRAuth.auth()?.signOut()
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
//                present(vc, animated: true, completion: nil)
//                
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleInfo.articleList.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! ArticleTableViewCell
        let label1 = cell.contentView.viewWithTag(1) as! UILabel
        let label2 = cell.contentView.viewWithTag(2) as! UILabel
        let label3 = cell.contentView.viewWithTag(3) as! UILabel
        let label4 = cell.contentView.viewWithTag(4) as! UILabel
        
        label1.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[indexPath.row]])?["petName"] as? String
        label2.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[indexPath.row]])?["missingTime"] as? String
        label3.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[indexPath.row]])?["missingLocation"] as? String
        label4.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[indexPath.row]])?["addTime"] as? String
        
        cell.petImage.image = checkImage(indexPathRow: indexPath.row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articleInfo.selectArticleRow = indexPath.row
        performSegue(withIdentifier: "toDetailViewControllerSegue", sender: nil)
    }
}
