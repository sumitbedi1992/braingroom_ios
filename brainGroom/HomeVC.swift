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

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var CV: UICollectionView!
    @IBOutlet weak var menuViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCloseBtn: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        
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
            cell.arrowImage.isHidden = false
        }
        else if indexPath.item == 1
        {
            cell.menuTitleLbl.text = "Map View"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 2
        {
            cell.menuTitleLbl.text = "Booking History"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 3
        {
            cell.menuTitleLbl.text = "Wishlist"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 4
        {
            cell.menuTitleLbl.text = "Catalogue"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 5
        {
            cell.menuTitleLbl.text = "Competitions"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 6
        {
            cell.menuTitleLbl.text = "Links"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 7
        {
            cell.menuTitleLbl.text = "Change Password"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 8
        {
            cell.menuTitleLbl.text = "Logout"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 9
        {
            cell.menuTitleLbl.text = "FAQ"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 10
        {
            cell.menuTitleLbl.text = "Terms and Conditions"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 11
        {
            cell.menuTitleLbl.text = "Contact Us"
            cell.arrowImage.isHidden = true
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
//MARK: ----------------- CV Delegates & Datasource ---------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCVCell", for: indexPath as IndexPath) as! FeatureCVCell
        
        cell.backView.layer.cornerRadius = 10
        
        if indexPath.item == 0
        {
            cell.thumbImage.image = UIImage.init(named: "cookingclass172Ef0672")
        }
        else
        {
            cell.thumbImage.image = UIImage.init(named: "chocolate1Dca410A2")
            cell.titleView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: CV.bounds.size.width/2, height: CV.bounds.size.height);
    }


}
