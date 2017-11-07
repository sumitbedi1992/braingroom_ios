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

    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
    func dataFromServer()
    {
        let innerParams : [String: String]
        var baseURL: String  = String(format:"%@generalFilter/",Constants.mainURL)
        if isOnline == true
        {
            innerParams  = [
                "catlog":"",
                "search_cat_id": "",
                "class_provider":"",
                "class_schedule":"",
                "class_type":"2",
                "community_id": "",
                "end_date":"",
                "gift_id":"",
                "search_key": "",
                "location_id":"",
                "logged_in_userid":"",
                "search_seg_id":"",
                "price_sort_status":"",
                "sort_by_latest":"",
                "start_date":""
            ]
        }
        
        else
        {
         if searchKey != ""
            {
                innerParams  = [
                    "catlog":"",
                    "search_cat_id": self.catID as String,
                    "class_provider":"",
                    "class_schedule":"",
                    "class_type":"",
                    "community_id":"",
                    "end_date":"",
                    "gift_id":"",
                    "search_key": self.searchKey as String,
                    "location_id":"",
                    "logged_in_userid":"",
                    "search_seg_id":"",
                    "price_sort_status":"",
                    "sort_by_latest":"",
                    "start_date":""
                ]
            }
         else {
        innerParams  = [
            "catlog":"",
            "search_cat_id": "",
            "class_provider":"",
            "class_schedule":"",
            "class_type":"",
            "community_id": self.catID,
            "end_date":"",
            "gift_id":"",
            "search_key": "",
            "location_id":"",
            "logged_in_userid":"",
            "search_seg_id":"",
            "price_sort_status":"",
            "sort_by_latest":"",
            "start_date":""
        ]
            }
        }
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        baseURL  = String(format:"%@generalFilter",Constants.mainURL)
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
                self.itemsArray = ((dic.object(forKey: "braingroom")) as! NSArray).mutableCopy() as! NSMutableArray
                self.itemCollectionView.reloadData()
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
            cell.amountLbl.text = String.init(format: "Rs.%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "price") as! String)
            if ((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "pic_name")) as! String != "0"
            {
            cell.imgView.sd_setImage(with: URL(string: (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "pic_name") as! String), placeholderImage: nil)
            }
            cell.descripitionLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_topic") as! String)
            if self.isOnline == false
            {
                cell.onlineLbl.text = String.init(format: "%@", (((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "vendorClasseLocationDetail") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "locality") as! String)
            }
            else
            {
                cell.onlineLbl.text = "Online"
            }
            cell.sessionsLbl.text = String.init(format: "%@ Sessions, %@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "no_of_session") as! String, (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_duration") as! String)
            cell.flexBtn.setTitle(String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_type_data") as! String), for: .normal)
                
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
            cell.amountLbl.text = String.init(format: "Rs.%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "price") as! String)
            if ((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "pic_name")) as! String != "0"
            {
                cell.imgView.sd_setImage(with: URL(string: (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "pic_name") as! String), placeholderImage: nil)
            }
            cell.descripitionLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_topic") as! String)
            if self.isOnline == false
            {
                cell.onlineLbl.text = String.init(format: "%@", (((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "vendorClasseLocationDetail") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "locality") as! String)
            }
            else
            {
                cell.onlineLbl.text = "Online"
            }
            cell.sessionsLbl.text = String.init(format: "%@ Sessions, %@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "no_of_session") as! String, (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_duration") as! String)
            cell.flexBtn.setTitle(String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_type_data") as! String), for: .normal)
                
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
            return CGSize(width: itemCollectionView.bounds.size.width/2-2, height: itemCollectionView.bounds.size.height/1.7);
        }
        else
        {
            return CGSize(width: itemCollectionView.bounds.size.width-5, height: itemCollectionView.bounds.size.height/4);
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
        self.navigationController?.pushViewController(fvc, animated: true)
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
