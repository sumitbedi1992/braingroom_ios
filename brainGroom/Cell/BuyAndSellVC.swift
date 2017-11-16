//
//  BuyAndSellVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 14/10/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import SDWebImage
import FCAlertView

class BuyAndSellMenuTVC: UITableViewCell
{
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
class BuyAndSellPostTVCell: UITableViewCell
{
    
    @IBOutlet weak var userImage: UIButtonX!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var collegeLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var segmentLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentsCountLbl: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLbl: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    var onlikeTapped : ((_ indexTapped : Int) -> Void)? = nil
    var onCommentTapped : ((_ indexTapped : Int) -> Void)? = nil
    
    @IBAction func liveClicked(_ sender: UIButton) {
        if let onlikeTapped = self.onlikeTapped {
            onlikeTapped(sender.tag)
        }
    }
    
    @IBAction func commentClicked(_ sender: UIButton) {
        if let onCommentTapped = self.onCommentTapped {
            onCommentTapped(sender.tag)
        }
    }

    
}

class BuyAndSellVC: UIViewController,UITableViewDelegate,UITableViewDataSource,FCAlertViewDelegate
{
    
    @IBOutlet weak var TV: UITableView!
    
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var sideMenuCloseBtn: UIButton!
    @IBOutlet weak var menuTV: UITableView!
    
    @IBOutlet weak var userImageLbl: UIImageViewX!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var dataArray = NSMutableArray()
    var menuArray = NSArray()
    var imageArray = NSArray()
    
    var selectedIndex = IndexPath()
    
    var isLike = Bool()
    
    var indexOfPageToRequest = String()
    var pageCount = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if appDelegate.userId == ""
        {
            menuArray = ["Home","Login","Register","FAQ","Terms and Conditions","Contact Us"]
            imageArray = ["home","login","comment","FAQ","terms and Condition","contact us"]
            userEmailLbl.text = "Hello Learner!"
            userNameLbl.text = "Please Login to Braingroom"
            userImageLbl.image = UIImage.init(named: "imm")
        }
        else
        {
            
            menuArray = ["Home","My Profile","Wishlist","Booking History","Change Password","Logout","FAQ","Terms and Conditions","Contact Us","Competitions"]
            imageArray = ["home","my profile","wishlist","booking history","change password","login","FAQ","terms and Condition","contact us","competition"]
            
            
            print(appDelegate.userData)
            
            
            userNameLbl.text = (appDelegate.userData.value(forKey:"name") as? String)?.capitalized
            userEmailLbl.text = UserDefaults.standard.value(forKey: "user_email") as? String
            //            userImageLbl.image = UIImage.init(named: "imm")
            if appDelegate.userData.value(forKey:"profile_pic") != nil {
            userImageLbl.sd_setImage(with: URL(string: appDelegate.userData.value(forKey:"profile_pic") as! String), placeholderImage: UIImage.init(named: "imm"))
            }
            
        }
        
        sideMenuCloseBtn.isHidden = false
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postsApiHitting()
    }
    func postsApiHitting()
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
            "major_categ":"learners_forum",
            "minor_categ":"group_post",
            "search_query":"",
            "seg_id":"",
            "state_id":"",
            "user_id":userId()
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        if self.isLike != true
        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
            
            print("Knowledge Post Response:---> \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                if self.isLike == true
                {
                    self.dataArray.removeAllObjects()
                    let array = dic["braingroom"] as! NSArray
                    self.dataArray.addObjects(from: array as! [Any])
                    self.indexOfPageToRequest = String(format:"%lu",dic.object(forKey: "next_page") as! Int)
                    self.TV.reloadData()
                }
                else
                {
                    let array = dic["braingroom"] as! NSArray
                    self.dataArray.addObjects(from: array as! [Any])
                    self.indexOfPageToRequest = String(format:"%lu",dic.object(forKey: "next_page") as! Int)
                    self.TV.reloadData()
                }
            }
            else
            {
            self.alert(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alert(text: error.localizedDescription)
        }
        
    }
    
    func nextPagePostsApiHitting(page:String)
    {
        let baseURL: String  = String(format:"%@getConnectFeedsData/%@",Constants.mainURL,page)
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
            "major_categ":"learners_forum",
            "minor_categ":"tips_tricks",
            "search_query":"",
            "seg_id":"",
            "state_id":"",
            "user_id":userId()
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        if self.isLike != true
        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        }
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
            
            print("Knowledge Post Response:---> \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                let array = dic["braingroom"] as! NSArray
                self.dataArray.addObjects(from: array as! [Any])
                self.indexOfPageToRequest = String(format:"%lu",dic.object(forKey: "next_page") as! Int)
                self.TV.reloadData()
            }
            else
            {
                self.alert(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alert(text: error.localizedDescription)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height
        {
            pageCount += 1
            print("IndexPage--->\(self.indexOfPageToRequest),PageCount--->\(self.pageCount)")
            if self.indexOfPageToRequest == String(format:"%d",pageCount)
            {
                nextPagePostsApiHitting(page:indexOfPageToRequest)
            }
            self.TV.reloadData()
        }
    }

    
    
    //MARK: ------------------------ TV Delegates & DataSource ---------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == TV
        {
            return self.dataArray.count
        }
        else
        {
            return self.menuArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == TV
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuyAndSellPostTVCell") as! BuyAndSellPostTVCell
            
            cell.userNameLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "vendor_name") as? String
            cell.collegeLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "institute_name") as? String
            
            cell.categoryLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "segment_name") as? String
            
            let str = (self.dataArray.object(at: indexPath.row) as!
                NSDictionary).object(forKey: "date") as? String
            cell.dateLbl.text  = appDelegate.timeStampToDate(time: str!)
//            cell.dateLbl.text = (self.dataArray.object(at: indexPath.row) as!
//                NSDictionary).object(forKey: "date") as? String
            
            
            cell.segmentLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as? String
            cell.descLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String
            cell.likeCountLbl.text = String(format:"%lu",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "num_likes") as! Int)
            cell.commentsCountLbl.text = String(format:"%lu comments",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "num_comments") as! Int)
            cell.userImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "vendor_image") as! String), for: .normal,placeholderImage: nil)
            
            cell.postImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String), placeholderImage: nil)
            
            if (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "liked") as! Int == 1 {
                cell.likeLbl.text = "liked"
            }else {
                cell.likeLbl.text = "like"
            }
            
//            cell.likeBtn.tag = indexPath.row
//            cell.likeBtn.addTarget(self, action: #selector(self.likeUnlikeBtnAction(_:)), for: .touchUpInside)
//            cell.commentBtn.tag = indexPath.row
//            cell.commentBtn.addTarget(self, action: #selector(self.commentBtnAction(_:)), for: .touchUpInside)
//            cell.shareBtn.tag = indexPath.row
//            cell.shareBtn.addTarget(self, action: #selector(self.shareBtnAction(_:)), for: .touchUpInside)

            cell.shareBtn.tag = indexPath.row
            cell.shareBtn.addTarget(self, action: #selector(self.shareBtnAction(_:)), for: .touchUpInside)
            
            
            cell.likeBtn.tag = indexPath.row
            cell.commentBtn.tag = indexPath.row
            
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
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuyAndSellMenuTVC", for: indexPath as IndexPath) as! BuyAndSellMenuTVC
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.titleLbl.text = menuArray[indexPath.row] as? String
            cell.menuIcon.image = UIImage.init(named: imageArray[indexPath.row] as! String)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == menuTV
        {
            if appDelegate.userId == ""
            {
                switch indexPath.row
                {
                case 0:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case 1:
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    vc.fromSocial = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case 3:
                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
//                    self.navigationController?.pushViewController(vc, animated: true)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
                    vc.fromSocial = true
                    vc.isFaq = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case 4:
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
                    vc.fromSocial = true
                    vc.isFaq = false
                    self.navigationController?.pushViewController(vc, animated: true)
                case 5:
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                    vc.fromSocial = true
                    self.navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
            }
            else
            {
                switch indexPath.row
                {
                case 0:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                case 1:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileFeedViewController") as! ProfileFeedViewController
                    vc.fromSocial = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListViewController") as! WishListViewController
                    vc.fromSocial = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case 3:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookmarksViewController") as! BookmarksViewController
                    vc.fromSocial = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case 4:
                    if appDelegate.isSocialLogin() == false
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                        vc.fromSocial = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        let alert = FCAlertView()
                        alert.blurBackground = false
                        alert.cornerRadius = 15
                        alert.bounceAnimations = true
                        alert.dismissOnOutsideTouch = false
                        alert.delegate = self
                        alert.makeAlertTypeCaution()
                        alert.showAlert(in: self.appDelegate.window, withTitle: "Braingroom", withSubtitle: "You are logged in with Social Login", withCustomImage: nil, withDoneButtonTitle:"OK", andButtons: nil)
                    }
                    
                case 5:
                    
                    let alert = FCAlertView()
                    alert.blurBackground = false
                    alert.cornerRadius = 15
                    alert.bounceAnimations = true
                    alert.dismissOnOutsideTouch = false
                    alert.delegate = self
                    alert.makeAlertTypeCaution()
                    alert.showAlert(in: self.appDelegate.window, withTitle: "Braingroom", withSubtitle: "Are you sure, you want to Logout?", withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    alert.hideDoneButton = true
                    
                    alert.addButton("Yes", withActionBlock: {
                        
                        UserDefaults.standard.set("", forKey: "user_id")
                        self.appDelegate.userId = ""
                        self.viewWillAppear(false)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    alert.addButton("No, Thanks", withActionBlock: {
                    })
                case 6:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case 7:
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
                    vc.fromSocial = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case 8:
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                    vc.fromSocial = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case 9:
                    UIApplication.shared.openURL(URL(string: "https://www.braingroom.com/")!)
                    
                default:
                    break
                }
            }
            self.sideMenuCloseBtnAction(self)
        } else {
            
            let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "PostDetailsVC") as! PostDetailsVC
            controller.data = dataArray .object(at: indexPath.row) as! [String : Any]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == TV
        {
            return 350
        }
        else
        {
            return 45
        }
    }
    
    
    func likeUnlikeBtnAction(_ sender: UIButton)
    {
        if userId() != ""
        {
            selectedIndex = IndexPath(row: sender.tag, section: 0)
            
            let cell = self.TV.dequeueReusableCell(withIdentifier: "BuyAndSellPostTVCell", for: selectedIndex) as! BuyAndSellPostTVCell
            
            let baseURL: String  = String(format:"%@likeUnlike",Constants.mainURL)
            
            let innerParams : [String: String] = [
                "user_id": "\(userId())",
                "post_id": "\((self.dataArray.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as! String)"
            ]
            let params : [String: AnyObject] = [
                "braingroom": innerParams as AnyObject
            ]
            print(params)
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
                AFWrapperClass.svprogressHudDismiss(view: self)
                let dic:NSDictionary = responseDict as NSDictionary
                if (dic.object(forKey: "res_code")) as! String == "1"
                {
                let dataArray = dic["braingroom"] as! NSArray
                    
//                self.isLike = true
//                self.postsApiHitting()
                    
                if (dataArray.object(at:0) as! NSDictionary).object(forKey: "liked") as? String == "1"    
                {
                    cell.likeLbl.text = "liked"
                    self.TV.reloadRows(at: [self.selectedIndex], with: .automatic)
                    self.isLike = true
                    self.postsApiHitting()
                    print("------>like<------")
                }
                else
                {
                    cell.likeLbl.text = "Like"
                    self.TV.reloadRows(at: [self.selectedIndex], with: .automatic)
                    self.isLike = true
                    self.postsApiHitting()
                    print("------>unlike<------")
                }
                    self.TV.reloadData()
                }
            }) { (error) in
            }
        }
        else
        {
            alert(text: "Please,login to like this post.")
        }
    }
    
    func commentBtnAction(_ sender: UIButton)
    {
        //        let cvc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        //        self.navigationController?.pushViewController(cvc, animated: true)
    }
    
    func shareBtnAction(_ sender: UIButton)
    {
        let textToShare = ["\((self.dataArray.object(at: sender.tag) as! NSDictionary).object(forKey: "share_url") as! String)"]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func alert(text: String)
    {
        let alert = FCAlertView()
        alert.blurBackground = false
        alert.cornerRadius = 15
        alert.bounceAnimations = true
        alert.dismissOnOutsideTouch = false
        alert.delegate = self
        alert.makeAlertTypeWarning()
        alert.showAlert(withTitle: "Braingroom", withSubtitle: text , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
        alert.hideDoneButton = true;
        alert.addButton("OK", withActionBlock: {
        })
    }
    
    @IBAction func menuBtnAction(_ sender: Any)
    {
        AFWrapperClass.viewSlideInFromRightToLeft(view: sideMenuView)
        sideMenuView.isHidden = false
    }
    @IBAction func postBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func menuCloseBackBtnAction(_ sender: Any)
    {
        AFWrapperClass.viewSlideInFromLeftToRight(view: sideMenuView)
        sideMenuView.isHidden = true
    }
    @IBAction func sideMenuCloseBtnAction(_ sender: Any)
    {
        AFWrapperClass.viewSlideInFromLeftToRight(view: sideMenuView)
        sideMenuView.isHidden = true
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
            self.isLike = true
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.postsApiHitting()
            
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

extension BuyAndSellVC : UISearchBarDelegate {
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
            searchBar .resignFirstResponder()
    }
}
