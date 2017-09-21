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

    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad()
    {
        appDelegate.userId = "111"
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        
        self.addChildViewController(vc)
        vc.view.frame = CGRect(x: 10, y: 0, width: self.container.frame.size.width-20, height: self.container.frame.size.height)
        self.container.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
        self.userImageLbl.layer.cornerRadius = self.userImageLbl.frame.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        menuCloseBtn.isHidden = false
        super.viewDidLoad()
        
        if appDelegate.userId == ""
        {
            menuArray = ["Home","Login","Register","FAQ","Terms and Conditions","Contact Us"]
            imageArray = ["home","login","comment","FAQ","terms and Condition","contact us"]
            userEmailLbl.text = "Hello Learner!"
            userNameLbl.text = "Please Login to Braingroom"
            userImageLbl.image = UIImage.init(named: "imm")
        }
        else
        {
            
                menuArray = ["Home","My Profile","Wishlist","Booking History","Change Password","Logout","FAQ","Terms and Conditions","Contact Us","Competitions"]
                imageArray = ["home","my profile","wishlist","booking history","change password","login","FAQ","terms and Condition","contact us","competition"]
        
            
            print(appDelegate.userData)

            
//            userNameLbl.text = (appDelegate.userData.value(forKey:"name") as? String)?.capitalized
//            userEmailLbl.text = UserDefaults.standard.value(forKey: "user_email") as? String
////            userImageLbl.image = UIImage.init(named: "imm")
//            userImageLbl.sd_setImage(with: URL(string: appDelegate.userData.value(forKey:"profile_pic") as! String), placeholderImage: UIImage.init(named: "imm"))

        }
        
        TV.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool)
    {
//        self.closeMenuBtnAction(self)
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
//        var vc =  UIViewController()
        if appDelegate.userId == ""
        {
            switch indexPath.row
            {
            case 0:
                self.searchBtn.isHidden = false
                self.notificationBtn.isHidden = false
                
                let view1 = self.childViewControllers.last

                view1?.willMove(toParentViewController: nil)
                view1?.view.removeFromSuperview()
                view1?.removeFromParentViewController()
//                view.removeFromSuperview()
//                view?.removeFromParentViewController()
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                self.addChildViewController(vc)
                vc.view.frame = CGRect(x: 10, y: 0, width: self.container.frame.size.width-20, height: self.container.frame.size.height)
                self.container.addSubview((vc.view)!)
                vc.didMove(toParentViewController: self)
                
            case 1:
                
                self.searchBtn.isHidden = true
                self.notificationBtn.isHidden = true
                
                let view1 = self.childViewControllers.last
                
                view1?.willMove(toParentViewController: nil)
                view1?.view.removeFromSuperview()
                view1?.removeFromParentViewController()
                
//                let view = self.childViewControllers.last
//                view?.removeFromParentViewController()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.addChildViewController(vc)
                vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
                self.container.addSubview((vc.view)!)
                vc.didMove(toParentViewController: self)
                
//                vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                
                self.searchBtn.isHidden = true
                self.notificationBtn.isHidden = true
                
                
                let view1 = self.childViewControllers.last
                
                view1?.willMove(toParentViewController: nil)
                view1?.view.removeFromSuperview()
                view1?.removeFromParentViewController()
                
//                let view = self.childViewControllers.last
//                view?.removeFromParentViewController()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                self.addChildViewController(vc)
                vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
                self.container.addSubview((vc.view)!)
                vc.didMove(toParentViewController: self)

            case 3:
                
                self.searchBtn.isHidden = true
                self.notificationBtn.isHidden = true
                let view1 = self.childViewControllers.last
                view1?.willMove(toParentViewController: nil)
                view1?.view.removeFromSuperview()
                view1?.removeFromParentViewController()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
                self.addChildViewController(vc)
                vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
                self.container.addSubview((vc.view)!)
                vc.didMove(toParentViewController: self)
                
            case 4:
                
                self.searchBtn.isHidden = true
                self.notificationBtn.isHidden = true
                
                let view1 = self.childViewControllers.last
                
                view1?.willMove(toParentViewController: nil)
                view1?.view.removeFromSuperview()
                view1?.removeFromParentViewController()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
                self.addChildViewController(vc)
                vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
                self.container.addSubview((vc.view)!)
                vc.didMove(toParentViewController: self)
//                        vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
//                        self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                
                self.searchBtn.isHidden = true
                self.notificationBtn.isHidden = true
                
                let view1 = self.childViewControllers.last
                
                view1?.willMove(toParentViewController: nil)
                view1?.view.removeFromSuperview()
                view1?.removeFromParentViewController()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                self.addChildViewController(vc)
                vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
                self.container.addSubview((vc.view)!)
                vc.didMove(toParentViewController: self)
                
//                vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
//                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
        else
        {
        switch indexPath.row
        {
        case 0:
            self.searchBtn.isHidden = false
            self.notificationBtn.isHidden = false
            let view1 = self.childViewControllers.last
            
            view1?.willMove(toParentViewController: nil)
            view1?.view.removeFromSuperview()
            view1?.removeFromParentViewController()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 10, y: 0, width: self.container.frame.size.width-20, height: self.container.frame.size.height)
            self.container.addSubview((vc.view)!)
            vc.didMove(toParentViewController: self)
            
        case 1:
            self.searchBtn.isHidden = true
            self.notificationBtn.isHidden = true
            let view1 = self.childViewControllers.last
            
            view1?.willMove(toParentViewController: nil)
            view1?.view.removeFromSuperview()
            view1?.removeFromParentViewController()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview((vc.view)!)
            vc.didMove(toParentViewController: self)
//            vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            
            self.searchBtn.isHidden = true
            self.notificationBtn.isHidden = true
            
            let view1 = self.childViewControllers.last
            
            view1?.willMove(toParentViewController: nil)
            view1?.view.removeFromSuperview()
            view1?.removeFromParentViewController()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListViewController") as! WishListViewController
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview((vc.view)!)
            vc.didMove(toParentViewController: self)
            
//            vc = self.storyboard?.instantiateViewController(withIdentifier: "WishListViewController") as! WishListViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            self.searchBtn.isHidden = true
            self.notificationBtn.isHidden = true
            
            let view1 = self.childViewControllers.last
            
            view1?.willMove(toParentViewController: nil)
            view1?.view.removeFromSuperview()
            view1?.removeFromParentViewController()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookmarksViewController") as! BookmarksViewController
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview((vc.view)!)
            vc.didMove(toParentViewController: self)
//            vc = self.storyboard?.instantiateViewController(withIdentifier: "BookmarksViewController") as! BookmarksViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            
            if (appDelegate.userData.value(forKey: "login_type") as! String == "direct")
            {
            self.searchBtn.isHidden = true
            self.notificationBtn.isHidden = true
                let view1 = self.childViewControllers.last
                
                view1?.willMove(toParentViewController: nil)
                view1?.view.removeFromSuperview()
                view1?.removeFromParentViewController()
                
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview((vc.view)!)
            vc.didMove(toParentViewController: self)
            }
            else
            {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeCaution()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "You are logged in with Social Login", withCustomImage: nil, withDoneButtonTitle:"OK", andButtons: nil)
            }

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
                
                self.searchBtn.isHidden = false
                self.notificationBtn.isHidden = false
                let view = self.childViewControllers.last
                view?.removeFromParentViewController()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                self.addChildViewController(vc)
                vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
                self.container.addSubview((vc.view)!)
                vc.didMove(toParentViewController: self)
                
            })
            alert.addButton("No, Thanks", withActionBlock: {
            })
        case 6:
            self.searchBtn.isHidden = true
            self.notificationBtn.isHidden = true
            
            let view1 = self.childViewControllers.last
            
            view1?.willMove(toParentViewController: nil)
            view1?.view.removeFromSuperview()
            view1?.removeFromParentViewController()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview((vc.view)!)
            vc.didMove(toParentViewController: self)
        case 7:
            
            self.searchBtn.isHidden = true
            self.notificationBtn.isHidden = true

            let view1 = self.childViewControllers.last
            
            view1?.willMove(toParentViewController: nil)
            view1?.view.removeFromSuperview()
            view1?.removeFromParentViewController()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview((vc.view)!)
            vc.didMove(toParentViewController: self)
            
//            vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
//            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            
            self.searchBtn.isHidden = true
            self.notificationBtn.isHidden = true
            
            let view1 = self.childViewControllers.last
            
            view1?.willMove(toParentViewController: nil)
            view1?.view.removeFromSuperview()
            view1?.removeFromParentViewController()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.addChildViewController(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview((vc.view)!)
            vc.didMove(toParentViewController: self)
//            vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
//            self.navigationController?.pushViewController(vc, animated: true)
        case 9:
            UIApplication.shared.openURL(URL(string: "https://www.braingroom.com/")!)

        default:
            break
        }
        }
        
        self.closeMenuBtnAction(self)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45
    }
    
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
    
    @IBAction func searchBtnAction(_ sender: Any)
    {
        
    }


}
