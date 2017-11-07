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
    var dataArray = NSArray()
    var fromSocial = false
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var collegeLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var localityLbl: UILabel!
    
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var postCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dic = UserDefaults.standard.object(forKey: "userData") as! NSDictionary
        
        let url = URL(string: dic.object(forKey: "profile_pic") as! String)!
        
        userImage.af_setImage(withURL: url)
        
        userNameLbl.text = dic.object(forKey: "name") as? String
        collegeLbl.text = ""
        categoryLbl.text = ""
        localityLbl.text = ""
        
        profileTable.estimatedRowHeight = 330
        profileTable.rowHeight = UITableViewAutomaticDimension
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        postsApiHitting(major: "learners_forum", minor: "tips_tricks")
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 330
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
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
