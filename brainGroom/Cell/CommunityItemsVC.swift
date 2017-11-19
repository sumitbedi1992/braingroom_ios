//
//  CommunityItemsVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 24/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView
import SDWebImage

class itemCVCell : UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var flexBtn: UIButton!
    @IBOutlet weak var sessionsLbl: UILabel!
}

class itemCVCell2 : UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    @IBOutlet weak var flexBtn: UIButton!
    @IBOutlet weak var sessionsLbl: UILabel!
}


class CommunityItemsVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FCAlertViewDelegate
{

    var itemsArray = NSMutableArray()
    var catID = String()
    var searchKey = String()
    var index : Int = 0
    var isTable = Bool()
    var isOnline = Bool()
    var pageNumber : Int = 1
    var isNextPage : Bool = false
    
    var segmentId = String()
    var localityId = String()
    var communityId = String()
    var classTypeId = String()
    var classScheduleId = String()
    var vendorId = String()
    var startDate = String()
    var endDate = String()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var sortFilterView: UIViewX!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(filterClass), name: NSNotification.Name(rawValue: NOTIFICATION.UPDATE_FILTER_CLASS), object: nil)
        
        isTable = false
        
        self.dataFromServer()
        
    }
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterClass(noti : NSNotification)
    {
        pageNumber = 1
        isNextPage = true
        let dict : [String : AnyObject] = noti.object as! [String : AnyObject]
        print(dict)
        
        searchKey = dict["searchKey"] as? String ?? ""
        segmentId = dict["segmentId"] as? String ?? ""
        localityId = dict["localityId"] as? String ?? ""
        communityId = dict["communityId"] as? String ?? ""
        classTypeId = dict["classTypeId"] as? String ?? ""
        classScheduleId = dict["classScheduleId"] as? String ?? ""
        vendorId = dict["vendorId"] as? String ?? ""
        startDate = dict["startDate"] as? String ?? ""
        endDate = dict["endDate"] as? String ?? ""
        dataFromServer()
    }
    
    
    
    func dataFromServer()
    {
        let innerParams : [String: String]
        let baseURL: String  = String(format:"%@generalFilter/%d",Constants.mainURL,pageNumber)
        if isOnline == true
        {
            innerParams  = [
                "catlog":"",
                "search_cat_id": "",
                "class_provider": vendorId as String,
                "class_schedule": classScheduleId as String,
                "class_type": classTypeId as String,
                "community_id": communityId as String,
                "end_date": endDate as String,
                "gift_id":"",
                "search_key": searchKey as String,
                "location_id": localityId as String,
                "logged_in_userid":"",
                "search_seg_id": segmentId as String,
                "price_sort_status":"",
                "price_symbol": appDelegate.PRICE_SYMBOLE,
                "price_code": appDelegate.PRICE_CODE,
                "sort_by_latest":"",
                "start_date": startDate as String
            ]
        }
        
        else
        {
         if searchKey != ""
            {
                innerParams  = [
                    "catlog":"",
                    "search_cat_id": catID as String,
                    "class_provider": vendorId as String,
                    "class_schedule": classScheduleId as String,
                    "class_type": classTypeId as String,
                    "community_id": communityId as String,
                    "end_date": endDate as String,
                    "gift_id":"",
                    "search_key": searchKey as String,
                    "location_id": localityId as String,
                    "logged_in_userid":"",
                    "search_seg_id": segmentId as String,
                    "price_sort_status":"",
                    "price_symbol": appDelegate.PRICE_SYMBOLE,
                    "price_code": appDelegate.PRICE_CODE,
                    "sort_by_latest":"",
                    "start_date": startDate as String
                ]
            }
         else {
        innerParams  = [
            "catlog":"",
            "search_cat_id": "",
            "class_provider": vendorId as String,
            "class_schedule": classScheduleId as String,
            "class_type": classTypeId as String,
            "community_id": catID as String,
            "end_date": endDate as String,
            "gift_id":"",
            "search_key": searchKey as String,
            "location_id": localityId as String,
            "logged_in_userid":"",
            "search_seg_id": segmentId as String,
            "price_sort_status":"",
            "price_symbol": appDelegate.PRICE_SYMBOLE,
            "price_code": appDelegate.PRICE_CODE,
            "sort_by_latest":"",
            "start_date": startDate as String
        ]
            }
        }
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
//        baseURL  = String(format:"%@generalFilter",Constants.mainURL)
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                if ((dic.object(forKey: "braingroom")) as! NSArray).count > 0
                {
                    let tempArray = ((dic.object(forKey: "braingroom")) as! NSArray).mutableCopy() as! NSMutableArray
                    if self.pageNumber == 1
                    {
                        self.itemsArray = tempArray
                    }
                    else
                    {
                        self.itemsArray.addObjects(from: tempArray as! [Any])
                    }
                    
                    self.itemCollectionView.reloadData()
                }
                if let page = dic.object(forKey: "next_page")
                {
                    if (page is String) && (page as! String) == "-1"
                    {
                        self.isNextPage = false
                    }
                    else if self.pageNumber == page as! Int
                    {
                        self.isNextPage = false
                    }
                    else
                    {
                        self.pageNumber = page as! Int
                        self.isNextPage = true
                    }
                }
            }
            else
            {
                self.alertView(text: dic.object(forKey: "res_msg") as! String)
                
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
//            self.alertView(text: error.localizedDescription)
            self.appDelegate.displayServerError()
        }
    }

//MARK: -------------------- CV Delegate & DataSource --------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if isTable == false
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCVCell", for: indexPath as IndexPath) as! itemCVCell
            let dict : NSDictionary = itemsArray[indexPath.row] as! NSDictionary
            
            var strPrice : String = ""
            if (dict.object(forKey: "price") is Int)
            {
                strPrice = String(format: "%d", (dict.value(forKey: "price") as? Int)!)
            }
            else
            {
                strPrice = (dict.object(forKey: "price") as? String)!
            }
            
            if strPrice != "" && strPrice != "0"
            {
                cell.amountLbl.text = String.init(format: "Rs.%@", strPrice)
            }else{
                cell.amountLbl.text = "Free"
            }
            
            if let pic = (dict.object(forKey: "pic_name"))
            {
                if (pic is String) && (pic as! String) != "0"
                {
                    cell.imgView.sd_setImage(with: URL(string: (pic as! String)), placeholderImage: nil)
                }
            }
            cell.descripitionLbl.text = String.init(format: "%@", dict.object(forKey: "class_topic") as! String)
            if self.isOnline == false
            {
                if let locationArr : NSArray = dict.object(forKey: "vendorClasseLocationDetail") as? NSArray
                {
                    if locationArr.count != 0
                    {
                        if let locationDict : NSDictionary = locationArr.object(at: 0) as? NSDictionary
                        {
                            cell.onlineLbl.text = String.init(format: "%@", locationDict.value(forKey: "locality") as! String)
                        }
                    }
                }
            }
            else
            {
                cell.onlineLbl.text = "Online"
            }
            cell.sessionsLbl.text = String.init(format: "%@ Sessions, %@", dict.object(forKey: "no_of_session") as! String, dict.object(forKey: "class_duration") as! String)
            cell.flexBtn.setTitle(String.init(format: "%@", dict.object(forKey: "class_type_data") as! String), for: .normal)
                
            cell.layer.masksToBounds = false;
            cell.layer.shadowOpacity = 0.75;
            cell.layer.shadowRadius = 5.0;
            cell.layer.shadowOffset = CGSize.zero;
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowPath = UIBezierPath.init(rect: cell.bounds).cgPath
                
            cell.contentView.backgroundColor = UIColor.white
            return cell
        }
        else
        {
                
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCVCell2", for: indexPath as IndexPath) as! itemCVCell2
            let dict : NSDictionary = itemsArray[indexPath.row] as! NSDictionary
            
            
            var strPrice : String = ""
            if (dict.object(forKey: "price") is Int)
            {
                strPrice = String(format: "%d", dict.value(forKey: "price") as! Int)
            }
            else
            {
                strPrice = (dict.object(forKey: "price") as? String)!
            }
            
            if strPrice != "" && strPrice != "0"
            {
                cell.amountLbl.text = String.init(format: "Rs.%@", strPrice)
            }else{
                cell.amountLbl.text = "Free"
            }
            
            
            if (dict.object(forKey: "pic_name")) as! String != "0"
            {
                cell.imgView.sd_setImage(with: URL(string: dict.object(forKey: "pic_name") as! String), placeholderImage: nil)
            }
            cell.descripitionLbl.text = String.init(format: "%@",  dict.object(forKey: "class_topic") as! String)
            if self.isOnline == false
            {
                if let locationArr : NSArray = dict.object(forKey: "vendorClasseLocationDetail") as? NSArray
                {
                    if locationArr.count != 0
                    {
                        if let locationDict : NSDictionary = locationArr.object(at: 0) as? NSDictionary
                        {
                            cell.onlineLbl.text = String.init(format: "%@", locationDict.value(forKey: "locality") as! String)
                        }
                    }
                }
            }
            else
            {
                cell.onlineLbl.text = "Online"
            }
            cell.sessionsLbl.text = String.init(format: "%@ Sessions, %@", dict.object(forKey: "no_of_session") as! String, dict.object(forKey: "class_duration") as! String)
            cell.flexBtn.setTitle(String.init(format: "%@", dict.object(forKey: "class_type_data") as! String), for: .normal)
                
            cell.layer.masksToBounds = false;
            cell.layer.shadowOpacity = 0.75;
            cell.layer.shadowRadius = 5.0;
            cell.layer.shadowOffset = CGSize.zero;
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowPath = UIBezierPath.init(rect: cell.bounds).cgPath
            
            cell.contentView.backgroundColor = UIColor.white
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == itemCollectionView
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailItemViewController2") as! DetailItemViewController2
            if isOnline == true
            {
                vc.isOnline = true
            }
            vc.catID = ((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "id") as? String)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if isTable == false
        {
            //TODO: Vignedh
            //return CGSize(width: 167, height:258);
            return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: (itemCollectionView.bounds.size.height/1.9) > 260 ? itemCollectionView.bounds.size.height/2:260);
        }
        else
        {
            return CGSize(width: itemCollectionView.bounds.size.width-10, height: 127);
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if indexPath.row == itemsArray.count - 1 && isNextPage == true
        {
            dataFromServer()
        }
    }
//MARK: ------------------- Button Action ----------------------
    @IBAction func CVStyleBtnAction(_ sender: Any)
    {
        if isTable == false
        {
            isTable = true
        }
        else
        {
            isTable = false
        }
        itemCollectionView.reloadData()
    }
    @IBAction func filterBtnAction(_ sender: Any)
    {
        let fvc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        fvc.categoryIdStr = catID
        self.navigationController?.pushViewController(fvc, animated: true)
    }

   
    @IBAction func sortBtnAction(_ sender: UIButton)
    {
        let actionSheetController = UIAlertController(title: nil, message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let actionButton = UIAlertAction(title: "Price Low-High", style: .default) { action -> Void in
            self.sortActionToServer(str: "2")
            
        }
        actionSheetController.addAction(actionButton)
        
        let saveActionButton = UIAlertAction(title: "Price High-Low", style: .default) { action -> Void in
            self.sortActionToServer(str: "1")
        }
        actionSheetController.addAction(saveActionButton)
        
        if let popoverPresentationController = actionSheetController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            let tempRect : CGRect = CGRect(x: sender.frame.origin.x, y: sortFilterView.frame.origin.y, width: sender.bounds.size.width, height: sender.bounds.size.height)
            popoverPresentationController.sourceRect = tempRect
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func sortActionToServer(str: String)
    {
        let baseURL  = String(format:"%@generalFilter/%d",Constants.mainURL, pageNumber)
        let innerParams  = [
            "catlog":"",
            "search_cat_id": catID as String,
            "class_provider":"",
            "class_schedule":"",
            "class_type":"",
            "community_id":"",
            "end_date":"",
            "gift_id":"",
            "search_key": "",
            "location_id":"",
            "logged_in_userid":"",
            "search_seg_id":"",
            "price_sort_status": str,
            "price_symbol": appDelegate.PRICE_SYMBOLE,
            "price_code": appDelegate.PRICE_CODE,
            "sort_by_latest":"",
            "start_date":""
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            print("Sort Responce:---> \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.itemsArray.removeAllObjects()
                let tempArray = ((dic.object(forKey: "braingroom")) as! NSArray).mutableCopy() as! NSMutableArray
                if self.pageNumber == 1
                {
                    self.itemsArray = tempArray
                }
                else
                {
                    self.itemsArray.addObjects(from: tempArray as! [Any])
                }
                
                if(self.itemsArray.count > 0)
                {
                    self.itemCollectionView.delegate = self
                    self.itemCollectionView.dataSource = self
                    self.itemCollectionView.reloadData()
                }
                if let page = dic.object(forKey: "next_page")
                {
                    if (page is String) && (page as! String) == "-1"
                    {
                        self.isNextPage = false
                    }
                    else if self.pageNumber == page as! Int
                    {
                        self.isNextPage = false
                    }
                    else
                    {
                        self.pageNumber = page as! Int
                        self.isNextPage = true
                    }
                }
            }
            else
            {
                self.alertView(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
//            self.alertView(text: error.localizedDescription)
            self.appDelegate.displayServerError()
        }
    }
    
//MARK: ----------------------- Alert ----------------------
    func alertView(text: String)
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

}
