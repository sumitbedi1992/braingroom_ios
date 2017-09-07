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
    @IBOutlet weak var menuCloseBtn: UIButton!
    
    @IBOutlet weak var sideMenuView: UIView!
    var menuArray = NSMutableArray()

    
    
    override func viewDidLoad()
    {
        menuCloseBtn.isHidden = false
        super.viewDidLoad()
        menuArray = ["My Profile","Wishlist","Booking History","Change Password","Catalogue","Logout","FAQ","Terms and Conditions","Contact Us","Competitions"]

        self.userImageLbl.layer.cornerRadius = self.userImageLbl.frame.width/2
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var vc =  UIViewController()
        
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
            AFWrapperClass.alert("Bridegroom", message: "Comming Soon...", view: self)

        case 5:
            vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            UIApplication.shared.openURL(URL(string: "https://www.braingroom.com/Faq")!)

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45
    }


}
