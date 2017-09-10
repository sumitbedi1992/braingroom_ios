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
    
    
    var signUpDOB = NSString()
    var signUpGender = NSString()
    var signUpCountry = NSString()
    var signUpState = NSString()
    var signUpCity = NSString()
    var SignUpLocation = NSString()
    var SignUpInterests = NSString()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpDOB = ""
        signUpGender = ""
        signUpCountry = ""
        signUpState = ""
        signUpCity = ""
        SignUpLocation = ""


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBTNTap(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func selectTypesBTNTap(_ sender: UIButton) {
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
            "country" : signUpCountry as String,
            "state" : signUpState as String,
            "city" : signUpCity as String,
            "locality" : SignUpLocation as String,
            "category_id" : SignUpInterests as String,
            "d_o_b" : signUpDOB as String,
            "gender" : signUpGender as String,
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
