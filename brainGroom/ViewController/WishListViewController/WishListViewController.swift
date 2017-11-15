//
//  WishListViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 06/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class itemCell2 : UICollectionViewCell
{
    @IBOutlet weak var wishListBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var sessionsLbl: UILabel!
    @IBOutlet weak var flexBtn: UIButton!
}

class WishListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FCAlertViewDelegate {
    
    var itemsArray = NSMutableArray()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var fromSocial = Bool()
    var fromLoad = Bool()
    
    let alert = FCAlertView()
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateWishlistData), name: NSNotification.Name(rawValue: NOTIFICATION.UPDATE_WISHLIST_CLASS), object: nil)
        
        setAlertViewData(alert)
        alert.delegate = self

        
        fromLoad = true
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        
        dataFromServer()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onUpdateWishlistData(noti:Notification)
    {
        let dict : [String : AnyObject] = noti.object as! [String : AnyObject]
        if dict["isWishlist"] as! Int == 1
        {
            fromLoad = true
            dataFromServer()
        }
        else
        {
            if let class_id = dict["class_id"]
            {
                let tempArray : NSMutableArray = NSMutableArray()
                for i in 0..<itemsArray.count
                {
                    let tempDict : NSDictionary = itemsArray.object(at: i) as! NSDictionary
                    if (tempDict.value(forKey: "id") as! String) != class_id as! String
                    {
                        tempArray.add(tempDict)
                    }
                }
                itemsArray = NSMutableArray(array: tempArray)
            }
            itemCollectionView.reloadData()
        }
    }
    
    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@getAllWishList",Constants.mainURL)
        
        let innerParams : [String: String] = [
            "uuid": (appDelegate.userData as NSDictionary).value(forKey: "uuid") as! String,
//            "uuid": "fas_58b50efabe904"

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
                if (dic.object(forKey: "braingroom") as! NSArray).count > 0 {
                    if self.fromLoad == true {
                        self.fromLoad = false
                        self.itemsArray.removeAllObjects()
                        

                        self.itemsArray.addObjects(from:(dic.object(forKey: "braingroom") as? Array<Any>)!)
                        
//                        self.itemsArray = self.itemsArray.addingObjects(from: dic.object(forKey: "braingroom") as! [Any]) as! NSMutableArray
                    }else
                    {
                        self.itemsArray = self.itemsArray.addingObjects(from: dic.object(forKey: "braingroom") as! [Any]) as! NSMutableArray
                    }
                    self.itemCollectionView.reloadData()

                }else {
                    self.alert.makeAlertTypeWarning()
                    self.alert.showAlert(withTitle: "Braingroom", withSubtitle: "No items in Wishlist" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    self.alert.hideDoneButton = true;
                    self.alert.addButton("OK", withActionBlock: {
                        self.itemCollectionView .reloadData()
                    })

                }
            }
            else
            {
                self.alert.makeAlertTypeWarning()
                self.alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                self.alert.hideDoneButton = true;
                self.alert.addButton("OK", withActionBlock: {
                })
                
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alert.makeAlertTypeWarning()
            self.alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            self.alert.hideDoneButton = true;
            self.alert.addButton("OK", withActionBlock: {
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath as IndexPath) as! itemCell2
        
        let dict : NSDictionary = itemsArray[indexPath.row] as! NSDictionary
        
        
        cell.imgView.sd_setImage(with: URL(string: dict.object(forKey: "pic_name") as! String), placeholderImage: UIImage.init(named: "imm"))
        cell.descripitionLbl.text = String.init(format: "%@", dict.object(forKey: "class_summary") as! String)
        
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
        
        cell.amountLbl.text = "Rs. 0"
        if let amountArr : NSArray = dict.object(forKey: "VendorClasseLevelDetail") as? NSArray
        {
            if amountArr.count != 0
            {
                if let amountDict : NSDictionary = amountArr.object(at: 0) as? NSDictionary
                {
                    cell.amountLbl.text = String.init(format: "Rs.%@",amountDict.value(forKey: "price") as! String)
                }
            }
        }
        
        
        cell.sessionsLbl.text = String.init(format: "Sessions %@", (dict.value(forKey: "no_of_session") as! String))
        cell.flexBtn.setTitle(dict.value(forKey: "class_type_data") as? String, for: .normal)
        cell.wishListBtn.setImage(UIImage.init(named: "heart"), for: .normal)
        
        cell.wishListBtn.addTarget(self, action: #selector (wishlistAction(sender:)), for: .touchUpInside)
        
        cell.layer.masksToBounds = false;
        cell.layer.shadowOpacity = 0.75;
        cell.layer.shadowRadius = 5.0;
        cell.layer.shadowOffset = CGSize.zero;
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowPath = UIBezierPath.init(rect: cell.bounds).cgPath
        
        cell.contentView.backgroundColor = UIColor.white
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dict : NSDictionary = itemsArray[indexPath.row] as! NSDictionary
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailItemViewController2") as! DetailItemViewController2
        vc.catID = (dict.object(forKey: "id") as? String)!
        //vc.price = (dict.object(forKey: "price") as? String)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func wishlistAction(sender : UIButton)
    {
        let button = sender
        let cell = button.superview?.superview as? UICollectionViewCell
        let indexPath = itemCollectionView.indexPath(for: cell!)
    
        let baseURL: String  = String(format:"%@addWishList",Constants.mainURL)
            
            let innerParams : [String: String] = [
                "uuid": (appDelegate.userData as NSDictionary).value(forKey: "uuid") as! String,
                "class_id" : (itemsArray[indexPath!.row] as! NSDictionary).value(forKey: "id") as! String
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
                if (dic.object(forKey: "res_id")) as! String == "1"
                {
                    self.itemsArray.removeObject(at: (indexPath?.row)!)
                    self.itemCollectionView.reloadData()
                }
                else
                {
                     self.alert.makeAlertTypeWarning()
                    self.alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    self.alert.hideDoneButton = true;
                    self.alert.addButton("OK", withActionBlock: {
                        
                    })
                    
                }
            }) { (error) in
                AFWrapperClass.svprogressHudDismiss(view: self)
                self.alert.makeAlertTypeWarning()
                self.alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                self.alert.hideDoneButton = true;
                self.alert.addButton("OK", withActionBlock: {
                })
            }
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: itemCollectionView.bounds.size.height/1.8)
    }

}
