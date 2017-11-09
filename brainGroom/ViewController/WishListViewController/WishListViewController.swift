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
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fromLoad = true
        dataFromServer()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        self.itemsArray = self.itemsArray.addingObjects(from: dic.object(forKey: "braingroom") as! [Any]) as! NSMutableArray
                    }else
                    {
                        self.itemsArray = self.itemsArray.addingObjects(from: dic.object(forKey: "braingroom") as! [Any]) as! NSMutableArray
                    }
                    self.itemCollectionView.delegate = self
                    self.itemCollectionView.dataSource = self
                    self.itemCollectionView.reloadData()

                }else {
                    let alert = FCAlertView()
                    alert.blurBackground = false
                    alert.cornerRadius = 15
                    alert.bounceAnimations = true
                    alert.dismissOnOutsideTouch = false
                    alert.delegate = self
                    alert.makeAlertTypeWarning()
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: "No items in Wishlist" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    alert.hideDoneButton = true;
                    alert.addButton("OK", withActionBlock: {
                        self.itemCollectionView .reloadData()
                    })

                }
                
                
                
//                if(self.itemsArray.count > 0)
//                {
//                    self.itemCollectionView.delegate = self
//                    self.itemCollectionView.dataSource = self
//                    self.itemCollectionView.reloadData()
//                }
//                else
//                {
//                let alert = FCAlertView()
//                alert.blurBackground = false
//                alert.cornerRadius = 15
//                alert.bounceAnimations = true
//                alert.dismissOnOutsideTouch = false
//                alert.delegate = self
//                alert.makeAlertTypeWarning()
//                alert.showAlert(withTitle: "Braingroom", withSubtitle: "No items in Wishlist" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//                alert.hideDoneButton = true;
//                alert.addButton("OK", withActionBlock: {
//                    self.itemCollectionView .reloadData()
//                })
//                }
            }
            else
            {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                alert.hideDoneButton = true;
                alert.addButton("OK", withActionBlock: {
                })
                
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            let alert = FCAlertView()
            alert.blurBackground = false
            alert.cornerRadius = 15
            alert.bounceAnimations = true
            alert.dismissOnOutsideTouch = false
            alert.delegate = self
            alert.makeAlertTypeWarning()
            alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            alert.hideDoneButton = true;
            alert.addButton("OK", withActionBlock: {
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
        cell.imgView.sd_setImage(with: URL(string: (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "pic_name") as! String), placeholderImage: UIImage.init(named: "imm"))
        cell.descripitionLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_summary") as! String)
        cell.onlineLbl.text = (((itemsArray[indexPath.row] as! NSDictionary).value(forKey: "VendorClasseLocationDetail") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "locality") as? String
        cell.amountLbl.text = String.init(format: "Rs.%@",(((itemsArray[indexPath.row] as! NSDictionary).value(forKey: "VendorClasseLevelDetail") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "price") as! String)
        cell.sessionsLbl.text = String.init(format: "Sessions %@", ((itemsArray[indexPath.row] as! NSDictionary).value(forKey: "no_of_session") as! String))
        cell.flexBtn.setTitle((itemsArray[indexPath.row] as! NSDictionary).value(forKey: "class_type_data") as? String, for: .normal)
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
    
    func wishlistAction(sender : UIButton)
    {
        let button = sender
        let cell = button.superview?.superview as? UICollectionViewCell
        let indexPath = itemCollectionView.indexPath(for: cell!)
    
        let baseURL: String  = String(format:"%@addWishList",Constants.mainURL)
            
            let innerParams : [String: String] = [
                "uuid": (appDelegate.userData as NSDictionary).value(forKey: "uuid") as! String,
//                "uuid": "fas_58b50efabe904",
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
                    self.dataFromServer()
                }
                else
                {
                    let alert = FCAlertView()
                    alert.blurBackground = false
                    alert.cornerRadius = 15
                    alert.bounceAnimations = true
                    alert.dismissOnOutsideTouch = false
                    alert.delegate = self
                    alert.makeAlertTypeWarning()
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    alert.hideDoneButton = true;
                    alert.addButton("OK", withActionBlock: {
                        
                    })
                    
                }
            }) { (error) in
                AFWrapperClass.svprogressHudDismiss(view: self)
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                alert.hideDoneButton = true;
                alert.addButton("OK", withActionBlock: {
                })
            }
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: itemCollectionView.bounds.size.height/1.8)
    }

}
