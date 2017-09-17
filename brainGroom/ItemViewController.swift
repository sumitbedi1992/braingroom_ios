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
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    var subArray = NSArray()
    var itemsArray = NSMutableArray()
    var catID = String()
//    var segID = String()
    var index : Int = 0
    
    var isTable = Bool()
    
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        isTable = false
        // Do any additional setup after loading the view.
        self.dataFromServer()
        
    }
    
    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@getCategoryClass",Constants.mainURLProd)
        
                let innerParams : [String: String] = [
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
                self.subArray = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "segment") as! NSArray
                self.itemsArray = ((self.subArray.object(at: self.index) as! NSDictionary).object(forKey: "class") as! NSArray).mutableCopy() as! NSMutableArray
                
                if (self.subArray.count > 0)
                {
                    self.subCollectionView.delegate = self
                    self.subCollectionView.dataSource = self
                    self.subCollectionView.reloadData()
                }
                
                if(self.itemsArray.count > 0)
                {
                    self.itemCollectionView.delegate = self
                    self.itemCollectionView.dataSource = self
                    self.itemCollectionView.reloadData()
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
                cell.amountLbl.text = String.init(format: "Rs.%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "price") as! String)
                cell.imgView.sd_setImage(with: URL(string: (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "pic_name") as! String), placeholderImage: nil)
                cell.descripitionLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_summary") as! String)
                if (itemsArray[indexPath.row] as! NSDictionary)["locality_name"] != nil
                {
                    cell.onlineLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "locality_name") as! String)
                }
                else
                {
                    cell.onlineLbl.text = "Online"
                }
                
                cell.sessionsLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_topic") as! String)
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
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath as IndexPath) as! itemCellTable
                cell.amountLbl.text = String.init(format: "Rs.%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "price") as! String)
                cell.imgView.sd_setImage(with: URL(string: (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "pic_name") as! String), placeholderImage: nil)
                cell.descripitionLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_summary") as! String)
                if (itemsArray[indexPath.row] as! NSDictionary)["locality_name"] != nil
                {
                    cell.onlineLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "locality_name") as! String)
                }
                else
                {
                    cell.onlineLbl.text = "Online"
                }
                
                cell.sessionsLbl.text = String.init(format: "%@", (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "class_topic") as! String)
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
            cell.subLbl.text = String.init(format: "+%@",((subArray[indexPath.row] as? NSDictionary)?.object(forKey: "segment_name") as? String)!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == itemCollectionView
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailItemViewController2") as! DetailItemViewController2
//            vc.catID = ((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "id") as? String)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            self.index = indexPath.row
            if (self.subArray.object(at: self.index) as! NSDictionary).value(forKey: "class") != nil
            {
            self.itemsArray = ((self.subArray.object(at: self.index) as! NSDictionary).object(forKey: "class") as! NSArray).mutableCopy() as! NSMutableArray
            if(self.itemsArray.count > 0)
            {
                self.itemCollectionView.delegate = self
                self.itemCollectionView.dataSource = self
                self.itemCollectionView.reloadData()
            }
            }
            else
            {
                self.itemsArray.removeAllObjects()
                
                self.itemCollectionView.delegate = self
                self.itemCollectionView.dataSource = self
                self.itemCollectionView.reloadData()
            }
            self.subCollectionView.reloadData()

        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == itemCollectionView
        {
            if isTable == false
            {
                return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: itemCollectionView.bounds.size.height/1.7);
            }
            else
            {
                return CGSize(width: itemCollectionView.bounds.size.width-10, height: itemCollectionView.bounds.size.height/3);
            }
        }
        else
        {
            let font = UIFont.systemFont(ofSize: 18)
            let fontAttributes = [NSFontAttributeName: font]
            let testStr = String.init(format: "+%@",((subArray[indexPath.row] as? NSDictionary)?.object(forKey: "segment_name") as? NSString)!)
            let size: CGSize = testStr.size(attributes: fontAttributes)
            
            return CGSize(width: size.width+10, height: subCollectionView.bounds.size.height-25);
        }
    }
    @IBAction func collectionStyleBtn(_ sender: Any)
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
    @IBAction func sortBtnAction(_ sender: Any)
    {
        
    }
    
    @IBAction func filterBtnAction(_ sender: Any)
    {
        
    }
    
}
