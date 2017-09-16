//
//  RegisterViewController2.swift
//  brainGroom
//
//  Created by Satya Mahesh on 19/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class RegisterViewController2: UIViewController, FCAlertViewDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate


    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var dobLBL: UILabel!
    @IBOutlet weak var genderLBL: UILabel!
    @IBOutlet weak var interestLBL: UILabel!
    @IBOutlet weak var countryLBL: UILabel!
    @IBOutlet weak var stateLBL: UILabel!
    @IBOutlet weak var cityLBL: UILabel!
    @IBOutlet weak var locationLBL: UILabel!
    @IBOutlet var genderView: UIView!
    @IBOutlet weak var femaleIMG: UIImageView!
    @IBOutlet var maleIMG: UIImageViewX!
    @IBOutlet weak var animateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate.signUpCountry == ""
        {
            countryLBL.text = "Select Item"
        }
        else
        {
            countryLBL.text = appDelegate.signUpCountry as String
        }
        if appDelegate.signUpCity == ""
        {
            cityLBL.text = "Select Item"
        }
        else
        {
            cityLBL.text = appDelegate.signUpCity as String
        }
        if appDelegate.signUpState == ""
        {
            stateLBL.text = "Select Item"
        }
        else
        {
            stateLBL.text = appDelegate.signUpState as String
        }
        if appDelegate.SignUpLocation == ""
        {
            locationLBL.text = "Select Item"
        }
        else
        {
            locationLBL.text = appDelegate.SignUpLocation as String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBTNTap(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func selectTypesBTNTap(_ sender: UIButton)
    {
        switch sender.tag
        {
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
                vc.keyForApi = "country"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            if appDelegate.signUpCountryID == ""
            {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please select Country", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
                vc.keyForApi = "state"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 6:
            if appDelegate.signUpStateID == ""
            {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please select State", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            else
            {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
            vc.keyForApi = "city"
            self.navigationController?.pushViewController(vc, animated: true)
            }
        case 7:
            if appDelegate.signUpCityID == ""
            {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please select country", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            else
            {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
            vc.keyForApi = "location"
            self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }

    @IBAction func doneBTNTap(_ sender: Any)
    {
        
    }
    @IBAction func signUpBTNTap(_ sender: Any)
    {
        let baseURL: String  = String(format:"%@BuyerRegistration",Constants.mainURL)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)

        let innerParams : [String: String] = [
            "name": appDelegate.signUpFullName as String,
            "email": appDelegate.signUpEmail as String,
            "password": appDelegate.signUpPassword as String,
            "mobile_no": appDelegate.signUpMobileNumber as String,
            "country" : appDelegate.signUpCountry as String,
            "state" : appDelegate.signUpState as String,
            "city" : appDelegate.signUpCity as String,
            "locality" : appDelegate.SignUpLocation as String,
            "category_id" : appDelegate.SignUpInterests as String,
            "d_o_b" : appDelegate.signUpDOB as String,
            "gender" : appDelegate.signUpGender as String,
            "profile_image" : "",
            "community_id" : "",
            "school_id" : "",
            "institute_name1" : appDelegate.signUpUGCollege as String,
            "institute_poy1" : appDelegate.signUpPassout as String,
            "institute_name2" : "",
            "institute_poy2" : "",
            "referal_code" : appDelegate.signUpReferralCode as String,
            "latitude" : "",
            "longitude" : ""
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                if (dic.object(forKey: "braingroom") as! NSArray).count > 0
                {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeSuccess()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Registration Successful, Please verify your Mobile Number", withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                alert.hideDoneButton = true;
                alert.addButton("OK", withActionBlock: {
                    self.appDelegate.tempUser = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "user_id") as! String as NSString
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                })
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
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
            alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
        }
        
    }
    @IBAction func maleFemaleBTNTap(_ sender: UIButton)
    {
        
    }
    @IBAction func genderOkCancelBTNTap(_ sender: UIButton)
    {
        
    }
    
}
