//
//  PetDetailViewController.swift
//  PetFinder
//
//  Created by Laban on 2017/4/30.
//  Copyright © 2017年 Cheng Jung Chen. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    let uid = memberIdCache.sharedInstance()
    var menuLogin:Array = [String]()
    var menuNotLogin:Array = [String]()
    var rowNumber:Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ManuNameArray = ["首頁","協尋文章","寵物醫院地圖","設定",]
        
        imgProfile.image = #imageLiteral(resourceName: "profile_placeholder")
        imgProfile.tintColor = UIColor.init(randomFlatColorOf: .light)
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor.flatBlue.cgColor
        imgProfile.layer.cornerRadius = 50
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true
        self.tblTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if ((FIRAuth.auth()?.currentUser) != nil){
            
            menuLogin = ["首頁","所有文章","我的文章","領養須知","設定","登出"]
            rowNumber = menuLogin.count
                        iconArray = [UIImage(named:"home")!,UIImage(named:"message")!,UIImage(named:"message")!,UIImage(named:"needToKnow")!,UIImage(named:"setting")!,UIImage(named:"logout")!]
        }else{
            menuNotLogin = ["首頁","所有文章","領養需知","設定","登入"]
                        iconArray = [UIImage(named:"home")!,UIImage(named:"message")!,UIImage(named:"needToKnow")!,UIImage(named:"setting")!,UIImage(named:"logout")!]
            rowNumber = menuNotLogin.count
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((FIRAuth.auth()?.currentUser) != nil){
            return menuLogin.count
        } else {
            return menuNotLogin.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        if ((FIRAuth.auth()?.currentUser) != nil){
            cell.lblMenuname.text! = menuLogin[indexPath.row]
            cell.imgIcon.image = iconArray[indexPath.row]
        } else {
            cell.lblMenuname.text! = menuNotLogin[indexPath.row]
            cell.imgIcon.image = iconArray[indexPath.row]
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        print(cell.lblMenuname.text!)
        if cell.lblMenuname.text! == "首頁"
        {
            print("Home Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "PetCollectionViewController") as! PetCollectionViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
            
        }
        if cell.lblMenuname.text! == "Message"
        {
            print("message Tapped")
           
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuname.text! == "設定"
        {
           print("setting Tapped")
           
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "SettingPageViewController") as! SettingPageViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuname.text! == "所有文章"
        {
            print("所有文章 Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ArticleListTableViewController") as! ArticleListTableViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
        if cell.lblMenuname.text! == "我的文章"
        {
            print("我的文章 Tapped")
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "MyArticleTableViewController") as! MyArticleTableViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        if cell.lblMenuname.text! == "登出"
        {
            print("登出 Tapped")
            if FIRAuth.auth()?.currentUser != nil {
                do {
                    print("登出了啦")
                    try FIRAuth.auth()?.signOut()
                    revealViewController().rightRevealToggle(animated: false)
                    let mainstoryboard:UIStoryboard = UIStoryboard(name: "Article", bundle: nil)
                    let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ArticleListTableViewController") as! ArticleListTableViewController
                    let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
                    
                    revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
                    uid.userId = ""
                    tblTableView.reloadData()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        if cell.lblMenuname.text! == "登入"
        {
            print("登入 Tapped")
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
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
