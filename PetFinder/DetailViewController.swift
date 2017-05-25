//
//  DetailViewController.swift
//  Article
//
//  Created by 陳柏勳 on 2017/5/10.
//  Copyright © 2017年 LeoChen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var missingTimeLabel: UILabel!
    @IBOutlet weak var missingLocationLabel: UILabel!
    @IBOutlet weak var petGender: UILabel!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petVariety: UILabel!
    @IBOutlet weak var petFeature: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var telephoneNumber: UILabel!    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    let articleInfo = memberIdCache.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petNameLabel.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["petName"] as? String
        missingTimeLabel.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["missingTime"] as? String
        missingLocationLabel.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["missingLocation"] as? String
        petGender.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["petGender"] as? String
        petAge.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["petAge"] as? String
        petVariety.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["petVariety"] as? String
        petFeature.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["petFeature"] as? String
        contactName.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["contactName"] as? String
        telephoneNumber.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["telephoneNumber"] as? String
        email.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["email"] as? String
        remark.text = (self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["remark"] as? String
        
        
        
        let saveFilePathString = ((self.articleInfo.fireUploadDic?[self.articleInfo.articleList[articleInfo.selectArticleRow]])?["missingPetImageFileName"] as? String)!
        let saveFilePath = NSTemporaryDirectory() + "\(saveFilePathString).data"
        petImage.image = UIImage(contentsOfFile: saveFilePath)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
