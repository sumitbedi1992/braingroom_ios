//
//  ItemViewController.swift
//  brainGroom
//
//  Created by Satya Mahesh on 21/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView


class itemCell : UICollectionViewCell
{
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var flexBtn: UIButton!
    
    @IBOutlet weak var sessionsLbl: UILabel!
}

class itemCellTable : UICollectionViewCell
{
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var flexBtn: UIButton!
    
    @IBOutlet weak var sessionsLbl: UILabel!
}


class subCell : UICollectionViewCell
{
    @IBOutlet weak var subLbl: UILabelX!
}

class ItemViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FCAlertViewDelegate
{
    @IBOutlet weak var btnList: UIButton!
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    var subArray = NSArray()
    var itemsArray = NSMutableArray()
    
    var index : Int = 0
    
    var isTable = Bool()
    var isSort = Bool()
    
    var catID = String()
    var searchKey = String()
    
    var segmentId = String()
    var localityId = String()
    var communityId = String()
    var classTypeId = String()
    var classScheduleId = String()
    var vendorId = String()
    var startDate = String()
    var endDate = String()
    var isFilterData : Bool = false
    var pageNumber : Int = 1
    var isNextPage : Bool = false    
    let alert = FCAlertView()
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    
    @IBOutlet weak var imgListGrid: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(filterClass), name: NSNotification.Name(rawValue: NOTIFICATION.UPDATE_FILTER_CLASS), object: nil)
        
        setAlertViewData(alert)
        alert.delegate = self

        isTable = false
        self.subCollectionView.delegate = self
        self.subCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        
        getSegmentOfCategory()
        
        self.imgListGrid.image = UIImage(named: "grid")
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
        if catID == dict["catID"] as? String ?? ""
        {
            if self.segmentId != ""
            {
                for i in 0..<self.subArray.count
                {
                    let newDict : NSDictionary = self.subArray.object(at: i) as! NSDictionary
                    if (newDict.object(forKey: "id") as! String) == self.segmentId
                    {
                        self.index = i
                        subCollectionView.reloadData()
                        break
                    }
                }
            }
            itemsArray = NSMutableArray()
            itemCollectionView.reloadData()
            getClassFromSegment()
        }
        else
        {
            self.index = 0
            subArray = NSArray()
            subCollectionView.reloadData()
            itemsArray = NSMutableArray()
            itemCollectionView.reloadData()
            if let newCatId = dict["catID"]
            {
                catID = newCatId as! String
            }
            
            getSegmentOfCategory()
        }
        
    }
    
    func getSegmentOfCategory()
    {
        let baseURL = String(format:"%@getSegment",Constants.mainURL)
        let innerParams  = [
            "category_id": catID as String,
            ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                if (dic.object(forKey: "res_msg")) as? String != "Record Not Found"
                {
                    self.itemsArray.removeAllObjects()
                    
                    if let segment = dic.object(forKey: "braingroom")
                    {
                        self.subArray = segment as! NSArray
                        
                        if self.itemsArray.count == 0 && self.subArray.count > 0
                        {
                            self.segmentId = ((self.subArray[0] as? NSDictionary)?.object(forKey: "id") as? String)!
                            self.subCollectionView.reloadData()
                            self.getClassFromSegment()
                        }
                    }
                    else
                    {
                        self.alertView(text: dic.object(forKey: "res_msg") as! String)
                    }
                }
                else
                {
                    self.alertView(text: dic.object(forKey: "res_msg") as! String)
                }
            }
            else
            {
                self.alertView(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alertView(text: error.localizedDescription)
        }
    }
    
    func getClassFromSegment()
    {
        let baseURL = String(format:"%@generalFilter/%d",Constants.mainURL,pageNumber)
        let innerParams  = [
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
            "sort_by_latest":"",
            "start_date": startDate as String]

        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                if (dic.object(forKey: "res_msg")) as? String != "Record Not Found"
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
                    if self.pageNumber == 1
                    {
                        self.itemCollectionView.setContentOffset(CGPoint.zero, animated: true)
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
            }
            else
            {
                self.alertView(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alertView(text: error.localizedDescription)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == itemCollectionView
        {
            return itemsArray.count
        }
        else
        {
            return subArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == itemCollectionView
        {
            if isTable == false
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! itemCell
                let dict : NSDictionary = itemsArray[indexPath.row] as! NSDictionary
                if (dict.object(forKey: "price") as! String) != ""
                {
                    cell.amountLbl.text = String.init(format: "Rs.%@", dict.object(forKey: "price") as! String)
                }else{
                    cell.amountLbl.text = "Free"
                }
                
                if let image = dict["pic_name"] as? String  {
                    cell.imgView.sd_setImage(with: URL(string: image), placeholderImage: nil)
                }
                cell.descripitionLbl.text = String.init(format: "%@", dict.object(forKey: "class_topic") as! String)
                if dict["locality_name"] != nil
                {
                    cell.onlineLbl.text = String.init(format: "%@", dict.object(forKey: "locality_name") as! String)
                }
                else
                {
                    cell.onlineLbl.text = "Online"
                }
                
                cell.sessionsLbl.text = String.init(format: "%@", dict.object(forKey: "class_topic") as! String)
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
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath as IndexPath) as! itemCellTable
                let dict : NSDictionary = itemsArray[indexPath.row] as! NSDictionary
                
                cell.amountLbl.text = String.init(format: "Rs.%@", dict.object(forKey: "price") as! String)
                
                if let image = dict["pic_name"] as? String  {
                    cell.imgView.sd_setImage(with: URL(string: image), placeholderImage: nil)
                }
                
                cell.descripitionLbl.text = String.init(format: "%@", dict.object(forKey: "class_topic") as! String)
                
                if dict["locality_name"] != nil
                {
                    cell.onlineLbl.text = String.init(format: "%@", dict.object(forKey: "locality_name") as! String)
                }
                else
                {
                    cell.onlineLbl.text = "Online"
                }
                
                cell.sessionsLbl.text = String.init(format: "%@", dict.object(forKey: "class_topic") as! String)
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
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCell", for: indexPath as IndexPath) as! subCell
            if indexPath.row == index
            {
                cell.subLbl.textColor = UIColor.white
                cell.subLbl.backgroundColor = AFWrapperClass.colorWithHexString("037AFF")
            }
            else
            {
                cell.subLbl.textColor = UIColor.black
                cell.subLbl.backgroundColor = UIColor.white
            }
            cell.subLbl.textAlignment = NSTextAlignment.center
            cell.subLbl.text = String(format: "+%@", ((subArray[indexPath.row] as? NSDictionary)?.object(forKey: "category_name") as? String)!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == itemCollectionView
        {
            let dict : NSDictionary = itemsArray[indexPath.row] as! NSDictionary
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailItemViewController2") as! DetailItemViewController2
            vc.catID = (dict.object(forKey: "id") as? String)!
            vc.price = (dict.object(forKey: "price") as? String)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            self.index = indexPath.row
            self.subCollectionView.reloadData()
            pageNumber = 1
            itemsArray = NSMutableArray()
            segmentId = ((subArray[self.index] as? NSDictionary)?.object(forKey: "id") as? String)!
            getClassFromSegment()
            
//            if (self.subArray.object(at: self.index) as! NSDictionary).value(forKey: "class") != nil
//            {
//                self.itemsArray = ((self.subArray.object(at: self.index) as! NSDictionary).object(forKey: "class") as! NSArray).mutableCopy() as! NSMutableArray
//                if(self.itemsArray.count > 0)
//                {
//                    self.itemCollectionView.delegate = self
//                    self.itemCollectionView.dataSource = self
//                    self.itemCollectionView.reloadData()
//                }
//            }
//            else
//            {
//                self.itemsArray.removeAllObjects()
//
//                self.itemCollectionView.delegate = self
//                self.itemCollectionView.dataSource = self
//                self.itemCollectionView.reloadData()
//            }
//            self.subCollectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == itemCollectionView
        {
            if isTable == false
            {
                //TODO: Vignedh
                //return CGSize(width: 167, height:258);
                return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: (itemCollectionView.bounds.size.height/1.8) > 258 ? itemCollectionView.bounds.size.height/1.8:258);
            }
            else
            {
                return CGSize(width: itemCollectionView.bounds.size.width-10, height: 127);
            }
        }
        else
        {
            let font = UIFont.systemFont(ofSize: 18)
            let fontAttributes = [NSFontAttributeName: font]
            let testStr = String(format: "+%@", ((subArray[indexPath.row] as? NSDictionary)?.object(forKey: "category_name") as? String)!)
            let size: CGSize = testStr.size(attributes: fontAttributes)
            
            return CGSize(width: size.width+10, height: 36);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == itemCollectionView
        {
            if indexPath.row == itemsArray.count-1 && isNextPage == true
            {
                getClassFromSegment()
            }
        }
    }
    
    @IBAction func collectionStyleBtn(_ sender: Any)
    {
        print(itemsArray)
        if isTable == false
        {
            isTable = true
            self.imgListGrid.image = UIImage(named:"menu")

        }
        else
        {
            isTable = false
           self.imgListGrid.image = UIImage(named:"grid")
        }
        itemCollectionView.reloadData()
    }
    @IBAction func sortBtnAction(_ sender: Any)
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
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func filterBtnAction(_ sender: Any)
    {
        let fvc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        fvc.categoryIdStr = catID
        fvc.segmentIdStr = segmentId
        self.navigationController?.pushViewController(fvc, animated: true)
    }
    
    func sortActionToServer(str: String)
    {
        let baseURL  = String(format:"%@generalFilter",Constants.mainURL)
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
                let array = dic.object(forKey: "braingroom") as! NSArray
                self.itemsArray =  NSMutableArray(array: array)
                if(self.itemsArray.count > 0)
                {
                    self.itemCollectionView.delegate = self
                    self.itemCollectionView.dataSource = self
                    self.itemCollectionView.reloadData()
                    if self.isTable {
                        self.isTable = true
                    } else{
                        self.isTable = false
                    }
                    
                    
                }
            }
            else
            {
                self.alertView(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alertView(text: error.localizedDescription)
        }
    }
    
    //MARK: ----------------------- Alert ----------------------
    func alertView(text: String)
    {
        alert.makeAlertTypeWarning()
        alert.showAlert(withTitle: "Braingroom", withSubtitle: text , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
        alert.hideDoneButton = true;
        alert.addButton("OK", withActionBlock: {
        })
    }
    
}
