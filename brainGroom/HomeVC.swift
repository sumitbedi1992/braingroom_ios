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

    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var menuViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCloseBtn: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.menuViewWidthConstraint.constant = 0
        self.menuCloseBtn.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        
        self.closeMenuBtnAction(self)
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
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVCell", for: indexPath as IndexPath) as! MenuTVCell
    
        if indexPath.item == 0
        {
            cell.menuTitleLbl.text = "My Profile"
        }
        else if indexPath.item == 1
        {
            cell.menuTitleLbl.text = "Map View"
        }
        else if indexPath.item == 2
        {
            cell.menuTitleLbl.text = "Booking History"
        }
        else if indexPath.item == 3
        {
            cell.menuTitleLbl.text = "Wishlist"
        }
        else if indexPath.item == 4
        {
            cell.menuTitleLbl.text = "Catalogue"
        }
        else if indexPath.item == 5
        {
            cell.menuTitleLbl.text = "Competitions"
        }
        else if indexPath.item == 6
        {
            cell.menuTitleLbl.text = "Links"
        }
        else if indexPath.item == 7
        {
            cell.menuTitleLbl.text = "Change Password"
        }
        else if indexPath.item == 8
        {
            cell.menuTitleLbl.text = "Logout"
        }
        else if indexPath.item == 9
        {
            cell.menuTitleLbl.text = "FAQ"
        }
        else if indexPath.item == 10
        {
            cell.menuTitleLbl.text = "Terms and Conditions"
        }
        else if indexPath.item == 11
        {
            cell.menuTitleLbl.text = "Contact Us"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var vc =  UIViewController()
        if indexPath.item == 0
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        }
        else if indexPath.item == 1
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        }
        else if indexPath.item == 2
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        }
        else if indexPath.item == 3
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListVC") as! WishListVC
        }
        else if indexPath.item == 4
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        }
        else if indexPath.item == 5
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        }
        else if indexPath.item == 6
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        }
        else if indexPath.item == 7
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        }
        else if indexPath.item == 8
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        }
        else if indexPath.item == 9
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        }
        else if indexPath.item == 10
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
        }
        else if indexPath.item == 11
        {
            vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        }
        
        self.present(vc, animated: true, completion: nil)

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }


}
