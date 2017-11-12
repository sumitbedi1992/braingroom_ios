//
//  ProfileViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 06/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var braingroomTitle: UILabel!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileTable: UITableView!
    var dataArray = NSArray()
    var fromSocial = Bool()

    @IBOutlet weak var knowledgeImage: UIImageView!
    @IBOutlet weak var discussionImage: UIImageView!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var buyImage: UIImageView!
    
    @IBOutlet weak var knowledgeLbl: UILabel!
    @IBOutlet weak var discussionLbl: UILabel!
    @IBOutlet weak var activityLbl: UILabel!
    @IBOutlet weak var buyLbl: UILabel!
    
    @IBOutlet weak var userImage: UIButtonX!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var collegeLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var localityLbl: UILabel!
    
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var postCountLbl: UILabel!
    
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let dic = UserDefaults.standard.object(forKey: "userData") as! NSDictionary
        
        userImage.sd_setImage(with: URL(string: dic.object(forKey: "profile_pic") as! String), for: .normal,placeholderImage: nil)
            
        userNameLbl.text = dic.object(forKey: "name") as? String
        collegeLbl.text = ""
        categoryLbl.text = ""
        localityLbl.text = ""
        
        if fromSocial == true
        {
            headerHeightConstraint.constant = 55
            self.braingroomTitle.isHidden = false
        }
        else
        {
            headerHeightConstraint.constant = 0
            self.braingroomTitle.isHidden = true
        }
        
        self.profileTable.delegate = self
        self.profileTable.dataSource = self
        self.profileTable.reloadData()
        
        postsApiHitting(major: "learners_forum", minor: "tips_tricks")
        
        knowledgeImage.image = UIImage.init(named: "Knowledge & nugget selected.png")
        discussionImage.image = UIImage.init(named: "Buy & Sell.png")
        activityImage.image = UIImage.init(named: "Buy & Sell.png")
        buyImage.image = UIImage.init(named: "activity Partners.png")
        
        knowledgeLbl.textColor = AFWrapperClass.colorWithHexString("00BEFF")
        discussionLbl.textColor = UIColor.darkGray
        activityLbl.textColor = UIColor.darkGray
        buyLbl.textColor = UIColor.darkGray
    }
    
    @IBAction func knowledgeBtnAction(_ sender: Any)
    {
        postsApiHitting(major: "learners_forum", minor: "tips_tricks")
        
        knowledgeImage.image = UIImage.init(named: "Knowledge & nugget selected.png")
        discussionImage.image = UIImage.init(named: "Buy & Sell.png")
        activityImage.image = UIImage.init(named: "Buy & Sell.png")
        buyImage.image = UIImage.init(named: "activity Partners.png")
        
        knowledgeLbl.textColor = AFWrapperClass.colorWithHexString("00BEFF")
        discussionLbl.textColor = UIColor.darkGray
        activityLbl.textColor = UIColor.darkGray
        buyLbl.textColor = UIColor.darkGray
        
    }
    
    @IBAction func discussionBtnAction(_ sender: Any)
    {
        postsApiHitting(major: "tutors_talk", minor: "user_post")
        
        knowledgeImage.image = UIImage.init(named: "Knowledge & nugget.png")
        discussionImage.image = UIImage.init(named: "Buy & Sell selected.png")
        activityImage.image = UIImage.init(named: "Buy & Sell.png")
        buyImage.image = UIImage.init(named: "activity Partners.png")
        
        knowledgeLbl.textColor = UIColor.darkGray
        discussionLbl.textColor = AFWrapperClass.colorWithHexString("00BEFF")
        activityLbl.textColor = UIColor.darkGray
        buyLbl.textColor = UIColor.darkGray
    }
    @IBAction func activityBtnAction(_ sender: Any)
    {
        postsApiHitting(major: "learners_forum", minor: "activity_request")
        
        knowledgeImage.image = UIImage.init(named: "Knowledge & nugget.png")
        discussionImage.image = UIImage.init(named: "Buy & Sell.png")
        activityImage.image = UIImage.init(named: "Buy & Sell selected.png")
        buyImage.image = UIImage.init(named: "activity Partners.png")
        
        knowledgeLbl.textColor = UIColor.darkGray
        discussionLbl.textColor = UIColor.darkGray
        activityLbl.textColor = AFWrapperClass.colorWithHexString("00BEFF")
        buyLbl.textColor = UIColor.darkGray
    }
    @IBAction func buyBtnAction(_ sender: Any)
    {
        postsApiHitting(major: "learners_forum", minor: "group_post")
        
        knowledgeImage.image = UIImage.init(named: "Knowledge & nugget.png")
        discussionImage.image = UIImage.init(named: "Buy & Sell.png")
        activityImage.image = UIImage.init(named: "Buy & Sell.png")
        buyImage.image = UIImage.init(named: "activity Partners selected.png")
        
        knowledgeLbl.textColor = UIColor.darkGray
        discussionLbl.textColor = UIColor.darkGray
        activityLbl.textColor = UIColor.darkGray
        buyLbl.textColor = AFWrapperClass.colorWithHexString("00BEFF")
    }
    
    func postsApiHitting(major: String, minor: String)
    {
        let baseURL: String  = String(format:"%@getConnectFeedsData",Constants.mainURL)
        let innerParams : [String: Any] = [
            "author_id":"",
            "categ_id":"",
            "city_id":"",
            "country_id":"",
            "best_posts":0,
            "group_id":"",
            "institute_id":"",
            "is_my_group":0,
            "locality_id":"",
            "major_categ":major,
            "minor_categ":minor,
            "search_query":"",
            "seg_id":"",
            "state_id":"",
            "user_id":userId()
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
            
            print("Knowledge Post Response:---> \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.dataArray = dic["braingroom"] as! NSArray
                self.profileTable.reloadData()
            }
            else
            {
//            self.alert(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
//            self.alert(text: error.localizedDescription)
        }
        
    }


//MARK: ----------------- TV Delegates & Datasource ---------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostTVCell") as! ProfilePostTVCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.userNameLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "vendor_name") as? String
        cell.collegeLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "institute_name") as? String
        
        cell.categoryLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "segment_name") as? String
        cell.dateLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "date") as? String
        cell.segmentLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as? String
        cell.descLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String
        cell.likeCountLbl.text = String(format:"%lu",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "num_likes") as! Int)
        cell.commentsCountLbl.text = String(format:"%lu comments",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "num_comments") as! Int)
        cell.userImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "vendor_image") as! String), for: .normal,placeholderImage: nil)
        
        cell.postImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String), placeholderImage: nil)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 302
    }
//MARK: ------------------------ Api Hitting -------------------------------
    
    func uploadMedia()
    {
        let parameters = [
            "post_type": "",
            ] as [String : String]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //            multipartFormData.append(UIImageJPEGRepresentation(self.photoImageView.image!, 0.7)!, withName: "image", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
        for (key, value) in parameters {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        }, to:"")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    let progressStatus = Float(progress.fractionCompleted)
                    print(progressStatus)
                    
                    DispatchQueue.main
                    do
                    {
                    
                    }
                })
                upload.responseJSON { response in
                    print(response)
                    print("PROFILE PIC UPLOADED SUCCESSFULLY.")
                }
            case .failure(let _):
                break
            }
        }
    }

    @IBAction func editBtnAction(_ sender: Any)
    {
        
    }

}
