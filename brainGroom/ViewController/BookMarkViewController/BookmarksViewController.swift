//
//  BookmarksViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 06/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class itemCell3 : UICollectionViewCell
{
    
    @IBOutlet weak var flexBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var sessionsLbl: UILabel!
}


class BookmarksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FCAlertViewDelegate {
    
    var itemsArray = NSArray()
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var fromSocial = Bool()
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dataFromServer()
    }

    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@bookingHistory",Constants.mainURL)
        
        let innerParams : [String: String] = [
            "id" : userId() as String
//            "id" : "1531"
            
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
                self.itemsArray = dic.object(forKey: "braingroom") as! NSArray
                if(self.itemsArray.count > 0)
                {
                    self.itemCollectionView.delegate = self
                    self.itemCollectionView.dataSource = self
                    self.itemCollectionView.reloadData()
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
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: "No Bookings made" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    alert.hideDoneButton = true;
                    alert.addButton("OK", withActionBlock: {
                    })
                }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath as IndexPath) as! itemCell3
        if (((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_detail") as! NSDictionary).object(forKey: "photo")) as? Int == 0
        {
            cell.imgView.image = UIImage.init(named: "chocolate1Dca410A2")
        }
        else
        {
            cell.imgView.sd_setImage(with: URL(string: ((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_detail") as! NSDictionary).object(forKey: "photo") as! String), placeholderImage: UIImage.init(named: "imm"))
        }
        
        cell.descripitionLbl.text = String.init(format: "%@", ((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_detail") as! NSDictionary).object(forKey: "class_summary") as! String)
        cell.onlineLbl.text = ((((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_detail") as! NSDictionary).value(forKey: "VendorClasseLocationDetail") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "locality") as? String
        cell.amountLbl.text = String.init(format: "Rs.%@",((((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_detail") as! NSDictionary).value(forKey: "VendorClasseLevelDetail") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "price") as! String)
        cell.sessionsLbl.text = String.init(format: "Sessions %@",((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_detail") as! NSDictionary).value(forKey: "no_of_session") as! String)
        cell.flexBtn.setTitle(((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_detail") as! NSDictionary).value(forKey: "class_type_data") as? String, for: .normal)
        
        cell.layer.masksToBounds = false;
        cell.layer.shadowOpacity = 0.75;
        cell.layer.shadowRadius = 5.0;
        cell.layer.shadowOffset = CGSize.zero;
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowPath = UIBezierPath.init(rect: cell.bounds).cgPath
        cell.contentView.backgroundColor = UIColor.white
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: itemCollectionView.bounds.size.height/1.8)
    }
    
}
