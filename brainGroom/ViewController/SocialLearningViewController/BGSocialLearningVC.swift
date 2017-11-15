//
//  BGSocialLearningVC.swift
//  brainGroom
//
//  Created by Vignesh Kumar on 11/11/17.
//  Copyright © 2017 CodeLiners. All rights reserved.
//

import UIKit
import FCAlertView

let LearnerForum = "learners_forum"
let TutorsTalk = "tutors_talk"

let KnowledgeNugget = ("tips_tricks",LearnerForum)
let BuyAndSell = ("group_post",LearnerForum)
let FindLearningPartners = ("activity_request",LearnerForum)
let TuTorArticles = ("vendor_article",TutorsTalk)
let DiscussionForum = ("user_post",TutorsTalk)
var currentScreen : (key: String, val: String)? = nil

class BGSocialLearningVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,FCAlertViewDelegate {
 
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArray = NSMutableArray()
    var menuArray = NSArray()
    var imageArray = NSArray()
    
    var selectedIndex = IndexPath()
    
    var isLike = Bool()
    
    var indexOfPageToRequest = String()
    var pageCount = 1
    
    var arrCollectionViewData : Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "BGSocialLearningCollectionCell", bundle: nil), forCellWithReuseIdentifier: "socialLearningCell")
        
       // fetchWebServiceCall(with: KnowledgeNugget.0, and: KnowledgeNugget.1)
       
        arrCollectionViewData = ["Post Of the day","Knowledge & Nugget","Buy & Sell","Find learning Partners","Tutors Article","Discuss & Decide"]
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: COllectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCollectionViewData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : BGSocialLearningCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "socialLearningCell", for: indexPath) as! BGSocialLearningCollectionCell
        
        cell.backgroundColor = UIColor.red
        cell.lblCelltext.text = arrCollectionViewData[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    
        switch indexPath.row {
        case 1:
            fetchWebServiceCall(with: KnowledgeNugget.0, and: KnowledgeNugget.1)
            break
            
        case 2:
            fetchWebServiceCall(with: BuyAndSell.0, and: BuyAndSell.1)
            break
        case 3:
            fetchWebServiceCall(with: FindLearningPartners.0, and: FindLearningPartners.1)
            break
        case 4:
            fetchWebServiceCall(with: TuTorArticles.0, and: TuTorArticles.1)
            break
        case 5:
            fetchWebServiceCall(with: DiscussionForum.0, and: DiscussionForum.1)
            break
            
        default:
            break
        }
    }
    
    func fetchWebServiceCall(with minorCategory : String, and majorcategory: String)
        {
            currentScreen?.0 = minorCategory
            currentScreen?.1 = majorcategory
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
                "major_categ":majorcategory, //learners_forum
                "minor_categ":minorCategory,    //tips_tricks
                "search_query":"",
                "seg_id":"",
                "state_id":"",
                "user_id":userId()
            ]
            let params : [String: AnyObject] = [
                "braingroom": innerParams as AnyObject
            ]
            print(params)
            
            //        if self.isLike != true
            //        {
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            //        }
            AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
                
                
                print("Knowledge Post Response:---> \(responseDict)")
                AFWrapperClass.svprogressHudDismiss(view: self)
                let dic:NSDictionary = responseDict as NSDictionary
                if (dic.object(forKey: "res_code")) as! String == "1"
                {
                    // here "jsonData" is the dictionary encoded
                    if self.isLike == true
                    {
                        self.dataArray.removeAllObjects()
                        let array = dic["braingroom"] as! NSArray
                        self.dataArray.addObjects(from: array as! [Any])
                        self.indexOfPageToRequest = String(format:"%lu",dic.object(forKey: "next_page") as! Int)
                        self.tblview.reloadData()
                    }
                    else
                    {
                        let array = dic["braingroom"] as! NSArray
                        self.dataArray.addObjects(from: array as! [Any])
                        self.indexOfPageToRequest = String(format:"%lu",dic.object(forKey: "next_page") as! Int)
                       self.tblview.reloadData()
                    }
                }
                else
                {
                    //  self.alert(text: dic.object(forKey: "res_msg") as! String)
                }
            }) { (error) in
                AFWrapperClass.svprogressHudDismiss(view: self)
                //            self.alert(text: error.localizedDescription)
            }
        }
    
    func fetchNextSetOfData(with minorCategory:String,and majorCategory: String,_ page:String)
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
                "major_categ":minorCategory,    //"learners_forum",
                "minor_categ":majorCategory,  //"tips_tricks",
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
                    self.tblview.reloadData()
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
            pageCount += 1
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.size.height
            {
                print("IndexPage--->\(self.indexOfPageToRequest),PageCount--->\(self.pageCount)")
                if self.indexOfPageToRequest == String(format:"%d",pageCount)
                {
                    fetchNextSetOfData(with: currentScreen!.0, and: currentScreen!.1, indexOfPageToRequest)
                   // nextPagePostsApiHitting(page:indexOfPageToRequest)
                }
               self.tblview.reloadData()
            }
        }
        //MARK: ------------------------ TV Delegates & DataSource ---------------------------
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
                return self.dataArray.count
        
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BGSocialLearningTableCell") as! BGSocialLearningTableCell
            
            cell.lblUserName.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "vendor_name") as? String
            cell.lblCollegeName.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "institute_name") as? String
            
            cell.lblCategory.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "segment_name") as? String
            let timeStamp = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "date") as? String
            cell.lblDate.text = timeStampToDate(time: timeStamp!)
            
            
            //        cell.dateLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "date") as? String
            cell.lblSubCategory.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as? String
            cell.lblDescription.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String
//            cell.likeCountLbl.text = String(format:"%lu",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "num_likes") as! Int)
//            cell.commentsCountLbl.text = String(format:"%lu comments",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "num_comments") as! Int)
            cell.userImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "vendor_image") as! String), for: .normal,placeholderImage: nil)
//
//            cell.postImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_image") as! String), placeholderImage: nil)
//
//            if (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "liked") as! Int == 1 {
//                cell.likeLbl.text = "liked"
//            }else {
//                cell.likeLbl.text = "like"
//            }
            
            //        cell.likeBtn.tag = indexPath.row
            //        cell.likeBtn.addTarget(self, action: #selector(self.likeUnlikeBtnAction(_:)), for: .touchUpInside)
            //        cell.commentBtn.tag = indexPath.row
            //        cell.commentBtn.addTarget(self, action: #selector(self.commentBtnAction(_:)), for: .touchUpInside)
//            cell.shareBtn.tag = indexPath.row
//            cell.shareBtn.addTarget(self, action: #selector(self.shareBtnAction(_:)), for: .touchUpInside)
//            
//
//            cell.likeBtn.tag = indexPath.row
//            cell.commentBtn.tag = indexPath.row
//
//            cell.onlikeTapped = {(likeid) -> Void in
//                let strID = (self.dataArray.object(at: likeid) as! NSDictionary).object(forKey: "id") as! String
//                self.likeWebService(strID)
//            }
//            
//            cell.onCommentTapped = {(commentid) -> Void in
//                let strID = (self.dataArray.object(at: commentid) as! NSDictionary).object(forKey: "id") as! String
//                self.commentWebService(strID)
//            }
//
            return cell
            
            
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            
            let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "PostDetailsVC") as! PostDetailsVC
            controller.data = dataArray .object(at: indexPath.row) as! [String : Any]
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 350
            
        }
    
    
   /*     func likeUnlikeBtnAction(_ sender: UIButton)
        {
            if userId() != ""
            {
                selectedIndex = IndexPath(row: sender.tag, section: 0)
     
                let cell = self.tblview.dequeueReusableCell(withIdentifier: "PostTVCell", for: selectedIndex) as! PostTVCell
     
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
                        if (dataArray.object(at:0) as! NSDictionary).object(forKey: "liked") as? String == "1"
                        {
                            cell.likeLbl.text = "liked"
                            self.tblview.reloadRows(at: [self.selectedIndex], with: .automatic)
                            self.isLike = true
                            self.postsApiHitting()
                            print("------>like<------")
                        }
                        else
                        {
                            cell.likeLbl.text = "Like"
                            self.tblview.reloadRows(at: [self.selectedIndex], with: .automatic)
                            self.isLike = true
                            self.postsApiHitting()
                            print("------>unlike<------")
                        }
                        self.tblview.reloadData()
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
            let cvc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
            cvc.postId = (self.dataArray.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as! String
            self.navigationController?.pushViewController(cvc, animated: true)
        }
     
        func shareBtnAction(_ sender: UIButton)
        {
            let textToShare = ["\((self.dataArray.object(at: sender.tag) as! NSDictionary).object(forKey: "share_url") as! String)"]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
            self.present(activityViewController, animated: true, completion: nil)
        }
        */
    
        @IBAction func postBtnAction(_ sender: Any)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
            self.navigationController?.pushViewController(vc, animated: true)
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
    
        func timeStampToDate(time: String) -> String
        {
            let date = NSDate(timeIntervalSince1970: Double(time)!)
            
            let dayTimePeriodFormatter =
                
                DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd/MMM/yyyy"
            
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            return dateString
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
                self.fetchWebServiceCall(with: "<#T##String#>", and: "<#T##String#>")
                
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
    
    @IBAction func btnSearchAction(_ sender: Any) {
        
        
        
        
    }
    
    @IBAction func btnbackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddPost(_ sender: Any) {
        
        let newPostObj = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        self.present(newPostObj, animated: true, completion: nil)
        
    }
}




//    extension KnowledgeAndNugget : UISearchBarDelegate {
//
//        func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
//            searchBar .resignFirstResponder()
//        }
//    }

 