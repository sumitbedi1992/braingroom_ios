//
//  MyProfileViewController.swift
//  brainGroom
//
//  Created by Satya Mahesh on 19/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView


class itemCellTable123 : UICollectionViewCell
{
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
    
    @IBOutlet weak var sessionsLbl: UILabel!
}

class itemCellTable24 : UICollectionViewCell
{
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
  
}


class MyProfileViewController: UIViewController,FCAlertViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    @IBOutlet weak var classBtn: UIButton!
    @IBOutlet weak var movingLbl: UILabel!
    @IBOutlet weak var imageBtn: UIButtonX!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var imageview: UIImageViewX!
    @IBOutlet weak var nameTF: ACFloatingTextfield!
    @IBOutlet weak var localityTF: ACFloatingTextfield!
    @IBOutlet weak var cityTF: ACFloatingTextfield!
    @IBOutlet weak var interestsTF: ACFloatingTextfield!
    @IBOutlet weak var institutionTF: ACFloatingTextfield!
    @IBOutlet weak var expertiseTF: ACFloatingTextfield!
    @IBOutlet weak var addressTF: ACFloatingTextfield!
    @IBOutlet weak var descriptionTF: ACFloatingTextfield!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isTable = Bool()
    var vendorID = String()
    var classesArray = NSArray()
    var reviewArray = NSArray()

    let alert = FCAlertView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setAlertViewData(alert)
        alert.delegate = self
        
        nameTF.isUserInteractionEnabled = false
        localityTF.isUserInteractionEnabled = false
        cityTF.isUserInteractionEnabled = false
        interestsTF.isUserInteractionEnabled = false
        institutionTF.isUserInteractionEnabled = false
        expertiseTF.isUserInteractionEnabled = false
        addressTF.isUserInteractionEnabled = false
        descriptionTF.isUserInteractionEnabled = false
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        self.dataFromserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataFromserver()
    {
        let baseURL: String  = String(format:"%@VendorProfile",Constants.mainURL)
        let innerParams : [String: String] = [
            "id": self.vendorID,
            "follower_id": self.appDelegate.userId as String
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                if((dic.object(forKey: "braingroom")) as! NSArray).count > 0
                {
                    let dict : NSDictionary = ((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary
                    
                    self.imageview.sd_setImage(with: URL(string:(dict.value(forKey: "profile_image") as? String)!)!, placeholderImage: UIImage.init(named: "imm"))
                    self.classesArray = dict.value(forKey: "classes") as! NSArray
                    self.reviewArray = dict.value(forKey: "review") as! NSArray
                    self.nameTF.text = dict.value(forKey: "name") as? String
                    self.localityTF.text = dict.value(forKey: "locality") as? String
                    self.cityTF.text = dict.value(forKey: "city") as? String
                    self.interestsTF.text = dict.value(forKey: "interest") as? String
                    self.institutionTF.text = dict.value(forKey: "institution") as? String
                    self.expertiseTF.text = dict.value(forKey: "expertise_area") as? String
                    self.addressTF.text = dict.value(forKey: "address") as? String
                    self.descriptionTF.text = dict.value(forKey: "description") as? String
                }
                else
                {
                    self.alert.makeAlertTypeWarning()
                    self.alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    self.alert.hideDoneButton = true;
                    self.alert.addButton("OK", withActionBlock: {
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

    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func profileClassReviewBtnAct(_ sender: UIButton)
    {
        if sender.tag == 0
        {
         // profile
            self.scrollView.isHidden = false
            self.itemCollectionView.isHidden = true
        }
        else if sender.tag == 1
        {
            // Classes
            self.scrollView.isHidden = true
            self.itemCollectionView.isHidden = false
                isTable = false
            itemCollectionView.delegate = self
            itemCollectionView.dataSource = self
            itemCollectionView.reloadData()
        }
        else if sender.tag == 2
        {
            // Review
            self.scrollView.isHidden = true
            self.itemCollectionView.isHidden = false
                isTable = true
            itemCollectionView.delegate = self
            itemCollectionView.dataSource = self
            itemCollectionView.reloadData()
        }
        UIView.animate(withDuration: 0.5) {
            self.movingLbl.frame = CGRect(x: sender.frame.origin.x, y: sender.frame.size.height-2, width: sender.frame.size.width, height: 2)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (isTable == false)
        {
            return classesArray.count
        }
        else
        {
            return reviewArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            if (isTable == false)
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell123", for: indexPath as IndexPath) as! itemCellTable123
//                cell.amountLbl.text = String.init(format: "Rs.%@", (classesArray[indexPath.row] as! NSDictionary).value(forKey: "price") as! String)
                cell.imgView.sd_setImage(with: URL(string: (classesArray[indexPath.row] as! NSDictionary).value(forKey: "photo") as! String), placeholderImage: UIImage.init(named: "imm"))
                cell.descripitionLbl.text = String.init(format: "%@", (classesArray[indexPath.row] as! NSDictionary).value(forKey: "class_topic") as! String)
                if (classesArray[indexPath.row] as! NSDictionary)["location"] != nil
                {
                    cell.onlineLbl.text = String.init(format: "%@", (classesArray[indexPath.row] as! NSDictionary).value(forKey: "location") as! String)
                }
                else
                {
                    cell.onlineLbl.text = "Online"
                }
                
                cell.sessionsLbl.text = String.init(format: "%@", (classesArray[indexPath.row] as! NSDictionary).value(forKey: "class_topic") as! String)
//                cell.flexBtn.setTitle(String.init(format: "%@", (classesArray[indexPath.row] as! NSDictionary).object(forKey: "class_type_data") as! String), for: .normal)
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell234", for: indexPath as IndexPath) as! itemCellTable24
                cell.descripitionLbl.text = (reviewArray[indexPath.row] as! NSDictionary).value(forKey: "text") as? String
                cell.headingLbl.text = (reviewArray[indexPath.row] as! NSDictionary).value(forKey: "by") as? String
                
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
        if (isTable == false)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailItemViewController2") as! DetailItemViewController2
            vc.catID = ((classesArray[indexPath.row] as! NSDictionary).object(forKey: "id") as? String)!
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            if (isTable == false)
            {
                return CGSize(width: itemCollectionView.bounds.size.width-10, height: itemCollectionView.bounds.size.height/4);
            }
            else
            {
                return CGSize(width: itemCollectionView.bounds.size.width-10, height: itemCollectionView.bounds.size.height/4);
            }
    }
    
}
