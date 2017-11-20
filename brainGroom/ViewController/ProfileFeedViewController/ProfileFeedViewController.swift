//
//  ProfileFeedViewController.swift
//  brainGroom
//
//  Created by Gaurav Parmar on 28/10/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileFeedViewController: UIViewController {

    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var constraintHeightProfileTbl: NSLayoutConstraint!
    var dataArray = NSArray()
    var fromSocial = false
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var userImage: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var collegeLbl: UILabel!
    @IBOutlet weak var constraintHeightCollageLbl: NSLayoutConstraint!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var constraintHeightCategoryLbl: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightUserView: NSLayoutConstraint!
    //@IBOutlet weak var localityLbl: UILabel!
    
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var postCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateLoggedInUserData), name: NSNotification.Name(rawValue: NOTIFICATION.UPDATE_LOGIN_USER_PROFILE), object: nil)
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.masksToBounds = true
        profileTable.estimatedRowHeight = 324
        profileTable.rowHeight = UITableViewAutomaticDimension
        onUpdateLoggedInUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        postsApiHitting(major: "learners_forum", minor: "tips_tricks")
        appDelegate.getUserProfile()
    }

    func onUpdateLoggedInUserData()
    {
        print(appDelegate.userData)
        userNameLbl.text = (appDelegate.userData.value(forKey:"name") as? String)?.capitalized
        
        if appDelegate.userData.value(forKey:"profile_image") != nil {
            userImage.sd_setImage(with: URL(string: appDelegate.userData.value(forKey:"profile_image") as! String), for: .normal, placeholderImage: UIImage.init(named: "imm"))
        }else
        {
            userImage.setImage(UIImage.init(named: "imm"), for: .normal)
        }
        
        collegeLbl.text = appDelegate.getLoginUserCollage()
        categoryLbl.text = appDelegate.getLoginUserCategory()
        //localityLbl.text = (appDelegate.userData.value(forKey:"locality") as? String)
        
        constraintHeightCollageLbl.constant = AFWrapperClass.getLableHeight(collegeLbl)
        if constraintHeightCollageLbl.constant == 0
        {
            constraintHeightCollageLbl.constant = 18
        }
        constraintHeightCategoryLbl.constant = AFWrapperClass.getLableHeight(categoryLbl)
        if constraintHeightCategoryLbl.constant == 0
        {
            constraintHeightCategoryLbl.constant = 18
        }
        
        constraintHeightUserView.constant = 142 - 36 + constraintHeightCollageLbl.constant + constraintHeightCategoryLbl.constant
    }
    
    @IBAction func clickToEditProfile(_ sender: Any)
    {
        let vc : EditProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ProfileFeedViewController {
    
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
                
                var height : Float = 0
                for i in 0..<self.dataArray.count
                {
                    let dict : NSDictionary = self.dataArray[i] as! NSDictionary
                    if let post_image : String = dict.object(forKey: "post_image") as? String
                    {
                        if post_image != ""
                        {
                            height = height + 324
                        }
                        else
                        {
                            height = height + (324-152)
                        }
                    }
                    else
                    {
                        height = height + (324-152)
                    }
                }
                self.constraintHeightProfileTbl.constant = CGFloat(height)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
        
    }
    
    func likeWebService (_ postValue : String) {
        let baseURL: String  = String(format:"%@likeUnlike",Constants.mainURL)
        
        let innerParams : [String: Any] = [
            "user_id":userId(),
            "post_id": postValue
        ]
        
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
            
            print("Knowledge Post Response:---> \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.postsApiHitting(major: "learners_forum", minor: "tips_tricks")
            
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
    }
    
    func commentWebService (_ postValue : String){
        let mainStory = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = mainStory.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.postId = postValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileFeedViewController : UITableViewDataSource, UITableViewDelegate {
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
        
//        cell.categoryLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "segment_name") as? String
        
        let timeStamp = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "date") as? String
        cell.dateLbl.text = timeStampToDate(time: timeStamp!)

        //        cell.segmentLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as? String
        
        cell.descLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String
        cell.likeCountLbl.text = String(format:"%lu",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "num_likes") as! Int)
        cell.commentsCountLbl.text = String(format:"%lu comments",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "num_comments") as! Int)

        cell.userImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "vendor_image") as! String), placeholderImage: nil)
        
        cell.postImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String), placeholderImage: nil)
        if let _ = cell.postImage.image {
            cell.postImage.isHidden = false
        }
        else {
            cell.postImage.isHidden = true
        }
        
        
        cell.likeCountbtn.tag = indexPath.row
        cell.commentsCountbtn.tag = indexPath.row
        
        cell.onlikeTapped = {(likeid) -> Void in
            let strID = (self.dataArray.object(at: likeid) as! NSDictionary).object(forKey: "id") as! String
            self.likeWebService(strID)
        }
        
        cell.onCommentTapped = {(commentid) -> Void in
            let strID = (self.dataArray.object(at: commentid) as! NSDictionary).object(forKey: "id") as! String
            self.commentWebService(strID)
        }
        
        return cell
    }

//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func timeStampToDate(time: String) -> String
    {
        let date = NSDate(timeIntervalSince1970: Double(time)!)
        
        let dayTimePeriodFormatter =
            
            DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}
