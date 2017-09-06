//
//  HomeVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 12/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import Cosmos

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

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var userImageLbl: UIImageViewX!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var menuViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCloseBtn: UIButton!
    
    var menuArray = NSMutableArray()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        menuArray = ["My Profile","Wishlist","Booking History","Change Password","Catalogue","Logout","FAQ","Terms and Conditions","Contact Us","Competitions"]

        self.userImageLbl.layer.cornerRadius = self.userImageLbl.frame.width/2
        self.menuViewWidthConstraint.constant = 0
        self.menuCloseBtn.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        
        self.closeMenuBtnAction(self)
    }
    
    @IBAction func findClassesBtn(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CateloguesViewController") as! CateloguesViewController
        self.present(vc, animated: true, completion: nil)
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
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func menuBtnAction(_ sender: Any)
    {
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            //Set x position what ever you want
            self.menuViewWidthConstraint.constant = 240
            self.menuCloseBtn.isHidden = false
            
        }, completion: nil)
        
    }
    @IBAction func closeMenuBtnAction(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            //Set x position what ever you want
            self.menuViewWidthConstraint.constant = 0
            self.menuCloseBtn.isHidden = true
            
        }, completion: nil)
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var vc =  UIViewController()
        if indexPath.item == 0
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.present(vc, animated: true, completion: nil)

        }
        
        else if indexPath.item == 1
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListViewController") as! WishListViewController
            self.present(vc, animated: true, completion: nil)

        }
        else if indexPath.item == 2
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "BookmarksViewController") as! BookmarksViewController
            self.present(vc, animated: true, completion: nil)

        }
        else if indexPath.item == 3
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.item == 4
        {
            AFWrapperClass.alert("Bridegroom", message: "Comming Soon...", view: self)

        }
        else if indexPath.item == 5
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(vc, animated: true, completion: nil)

        }
        else if indexPath.item == 6
        {
            UIApplication.shared.openURL(URL(string: "https://www.braingroom.com/Faq")!)
        }
        
        else if indexPath.item == 7
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            self.present(vc, animated: true, completion: nil)

        }
        else if indexPath.item == 8
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.present(vc, animated: true, completion: nil)

        }
        else if indexPath.item == 9
        {
            UIApplication.shared.openURL(URL(string: "https://www.braingroom.com/")!)
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45
    }


}
