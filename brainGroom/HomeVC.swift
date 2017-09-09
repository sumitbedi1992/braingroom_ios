//
//  HomeVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 12/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import Cosmos
import FCAlertView

class FeatureCVCell: UICollectionViewCell
{
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var titleView: UIView!
}

class MenuTVCell: UITableViewCell
{
    @IBOutlet weak var menuTitleLbl: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
}

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate
{

    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var userImageLbl: UIImageViewX!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var menuCloseBtn: UIButton!
    
    @IBOutlet weak var sideMenuView: UIView!
    var menuArray = NSMutableArray()
    var imageArray = NSMutableArray()

    
    override func viewDidLoad()
    {
        self.userImageLbl.layer.cornerRadius = self.userImageLbl.frame.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        menuCloseBtn.isHidden = false
        super.viewDidLoad()
        
        if appDelegate.userId == ""
        {
            menuArray = ["Login","Register","Catalogue","FAQ","Terms and Conditions","Contact Us"]
            imageArray = ["login","comment","catalogue-1","FAQ","terms and Condition","contact us"]
            userEmailLbl.text = "Hello Learner!"
            userNameLbl.text = "Please Login to Braingroom"
            userImageLbl.image = UIImage.init(named: "imm")
        }
        else
        {
        menuArray = ["My Profile","Wishlist","Booking History","Change Password","Catalogue","Logout","FAQ","Terms and Conditions","Contact Us","Competitions"]
        imageArray = ["my profile","wishlist","booking history","change password","catalogue-1","login","FAQ","terms and Condition","contact us","competition"]
            
            userNameLbl.text = "Krishna"
            userEmailLbl.text = "krishnakanthkesana@gmail.com"
            userImageLbl.image = UIImage.init(named: "imm")

        }
        
        
        TV.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        self.closeMenuBtnAction(self)
    }
    
    @IBAction func findClassesBtn(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CateloguesViewController") as! CateloguesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func commingSoonBtnAction(_ sender: Any)
    {
        AFWrapperClass.alert("Bridegroom", message: "Comming Soon...", view: self)

    }
    
    @IBAction func socialLearning(_ sender: Any)
    {
        AFWrapperClass.alert("Bridegroom", message: "Comming Soon...", view: self)
    }
    
    @IBAction func exploreBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func menuBtnAction(_ sender: Any)
    {
        AFWrapperClass.viewSlideInFromRightToLeft(view: sideMenuView)
        sideMenuView.isHidden = false;
    }
    @IBAction func closeMenuBtnAction(_ sender: Any)
    {
        AFWrapperClass.viewSlideInFromLeftToRight(view: sideMenuView)
        sideMenuView.isHidden = true
    }
//MARK: ----------------- TV Delegates & Datasource ---------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVCell", for: indexPath as IndexPath) as! MenuTVCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.menuTitleLbl.text = menuArray[indexPath.row] as? String
        cell.arrowImage.image = UIImage.init(named: imageArray[indexPath.row] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var vc =  UIViewController()
        if appDelegate.userId == ""
        {
            switch indexPath.row
            {
            case 0:
                vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeCaution()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Comming Soon...", withCustomImage: nil, withDoneButtonTitle:"OK", andButtons: nil)            case 3:
                    let alert = FCAlertView()
                    alert.blurBackground = false
                    alert.cornerRadius = 15
                    alert.bounceAnimations = true
                    alert.dismissOnOutsideTouch = false
                    alert.delegate = self
                    alert.makeAlertTypeCaution()
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: "Comming Soon...", withCustomImage: nil, withDoneButtonTitle:"OK", andButtons: nil)            case 4:
                        vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
                        self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
        else
        {
        switch indexPath.row
        {
        case 0:
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListViewController") as! WishListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            vc = self.storyboard?.instantiateViewController(withIdentifier: "BookmarksViewController") as! BookmarksViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let alert = FCAlertView()
            alert.blurBackground = false
            alert.cornerRadius = 15
            alert.bounceAnimations = true
            alert.dismissOnOutsideTouch = false
            alert.delegate = self
            alert.makeAlertTypeCaution()
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Comming Soon...", withCustomImage: nil, withDoneButtonTitle:"OK", andButtons: nil)
            
        case 5:
            
            let alert = FCAlertView()
            alert.blurBackground = false
            alert.cornerRadius = 15
            alert.bounceAnimations = true
            alert.dismissOnOutsideTouch = false
            alert.delegate = self
            alert.makeAlertTypeCaution()
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Are you sure, you want to Logout?", withCustomImage: nil, withDoneButtonTitle:nil, andButtons: nil)
            alert.hideDoneButton = true
            
            alert.addButton("Yes", withActionBlock: {
                
                UserDefaults.standard.set("", forKey: "user_id")
                self.appDelegate.userId = ""
                self.viewWillAppear(false)
            })
            alert.addButton("No, Thanks", withActionBlock: {
                
            })
            
        case 6:
            let alert = FCAlertView()
            alert.blurBackground = false
            alert.cornerRadius = 15
            alert.bounceAnimations = true
            alert.dismissOnOutsideTouch = false
            alert.delegate = self
            alert.makeAlertTypeCaution()
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Comming Soon...", withCustomImage: nil, withDoneButtonTitle:"OK", andButtons: nil)
        case 7:
            vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 9:
            UIApplication.shared.openURL(URL(string: "https://www.braingroom.com/")!)

        default:
            break
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45
    }


}
