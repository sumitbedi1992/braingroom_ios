//
//  CateloguesViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 05/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import SDWebImage
import FCAlertView


class itemCell1 : UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descripitionLbl: UILabel!
}


class CateloguesViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FCAlertViewDelegate {

    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    var itemsArray = NSArray()
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.dataFromServer()
    }
    
    
    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@getCategory",Constants.mainURL)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)

        AFWrapperClass.requestPOSTURL(baseURL, params: nil, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.itemsArray = dic.object(forKey: "braingroom") as! NSArray

                if (self.itemsArray.count > 0)
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
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
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
            self.appDelegate.displayServerError()
//            let alert = FCAlertView()
//            alert.blurBackground = false
//            alert.cornerRadius = 15
//            alert.bounceAnimations = true
//            alert.dismissOnOutsideTouch = false
//            alert.delegate = self
//            alert.makeAlertTypeWarning()
//            alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//            alert.hideDoneButton = true;
//            alert.addButton("OK", withActionBlock: {
//            })
        }
    }
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
//MARK: ---------------------- CV Delegates & DataSource ----------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        vc.catID = ((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "id") as? String)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath as IndexPath) as! itemCell1
        
        cell.descripitionLbl.text = (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "category_name") as? String
        
        print((itemsArray[indexPath.row] as! NSDictionary).object(forKey: "category_image")!)
        
        cell.imgView.sd_setImage(with: URL(string: (itemsArray[indexPath.row] as! NSDictionary).object(forKey: "category_image") as! String), placeholderImage: UIImage.init(named: "chocolate1Dca410A2"))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: itemCollectionView.bounds.size.height/3-5);
    }
    
//MARK: ---------------------- Button actions ----------------------------
    @IBAction func notificationBtnAction(_ sender: Any)
    {
        if appDelegate.userId == ""
        {
            let alert = FCAlertView()
            alert.blurBackground = false
            alert.cornerRadius = 15
            alert.bounceAnimations = true
            alert.dismissOnOutsideTouch = false
            alert.delegate = self
            alert.makeAlertTypeCaution()
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please login to see your Notifications", withCustomImage: nil, withDoneButtonTitle:"OK", andButtons: nil)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func onlineWebinarBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityItemsVC") as! CommunityItemsVC
//        vc.catID = ((self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"id")) as! String
        vc.searchKey = ""
        vc.isOnline = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func groupClassBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GetCommunityVC") as! GetCommunityVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
