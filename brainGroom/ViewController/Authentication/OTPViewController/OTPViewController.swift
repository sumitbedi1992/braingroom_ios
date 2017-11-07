//
//  OTPViewController.swift
//  brainGroom
//
//  Created by iOS_dev02 on 09/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class OTPViewController: UIViewController,FCAlertViewDelegate {

    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var otpTF: UITextFieldX!
    @IBOutlet weak var mobileNumberTF: UITextField!
    
    var isSocial = Bool()
    var emailStringSocial = String()
    var nameStringSocial = String()
    var IDStringSocial = String()
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var fromSocial = Bool()
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if fromSocial == true
        {
            headerViewHeightConstraint.constant = 55
        }
        else
        {
            headerViewHeightConstraint.constant = 0
        }
        
        
        mobileNumberTF.text = appDelegate.signUpMobileNumber as String
        self.resendOtpTap(self)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    @IBAction func backBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func editMobileTap(_ sender: Any)
    {
        mobileNumberTF.isUserInteractionEnabled = true
        mobileNumberTF.becomeFirstResponder()
    }
    
    @IBAction func resendOtpTap(_ sender: Any)
    {
        mobileNumberTF.isUserInteractionEnabled = false
        let baseURL: String  = String(format:"%@sendOTP",Constants.mainURL)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        let innerParams : [String: String] = [
            "mobile": mobileNumberTF.text!,
            "referal_code": "",
            "user_id": appDelegate.tempUser as String,
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary

                if (dic.object(forKey: "braingroom") as! NSArray).count > 0
                {
                    let alert = FCAlertView()
                    alert.blurBackground = false
                    alert.cornerRadius = 15
                    alert.bounceAnimations = true
                    alert.dismissOnOutsideTouch = false
                    alert.delegate = self
                    alert.makeAlertTypeSuccess()
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    alert.hideDoneButton = true;
                    alert.addButton("OK", withActionBlock: {
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
            alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            alert.hideDoneButton = true;
            alert.addButton("OK", withActionBlock: {
            })
        }
    }
    @IBAction func verifyOTPTap(_ sender: Any)
    {
        if (otpTF.text?.characters.count)! > 0
        {
            let baseURL: String  = String(format:"%@verifyOTP",Constants.mainURL)
            
            let innerParams : [String: String] = [
                "user_id": appDelegate.tempUser as String,
                "otp": otpTF.text!,
                ]
            let params : [String: AnyObject] = [
                "braingroom": innerParams as AnyObject
            ]
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            
            print(params)
            
            AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
                
                print("DDD: \(responseDict)")
                AFWrapperClass.svprogressHudDismiss(view: self)
                let dic:NSDictionary = responseDict as NSDictionary
//                if (dic.object(forKey: "res_code")) as! String == "1"
//                {
                    if (dic.object(forKey: "braingroom") as! NSArray).count > 0
                    {
                        let alert = FCAlertView()
                        alert.blurBackground = false
                        alert.cornerRadius = 15
                        alert.bounceAnimations = true
                        alert.dismissOnOutsideTouch = false
                        alert.delegate = self
                        alert.makeAlertTypeSuccess()
                        alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                        alert.hideDoneButton = true;
                        alert.addButton("OK", withActionBlock: {
                            
                            if self.isSocial == true
                            {
                                self.socialLoginMethod()
                            }
                            else
                            {
                                self.loginFunction()
                            }
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
                alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
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
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please enter a valid OTP", withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            alert.hideDoneButton = true;
            alert.addButton("OK", withActionBlock: {
            })
        }
    }
    
    
    func socialLoginMethod () -> Void
    {
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let baseURL: String  = String(format:"%@socialLogin",Constants.mainURL)
        let innerParams : [String: String] = [
            "email": emailStringSocial,
            "first_name": nameStringSocial,
            "ip_address":"",
            "last_name":"",
            "address_latitude":"",
            "address_longitude":"",
            "phone":"",
            "reg_id":"dboWpy5gtRg:APA91bHhX6em8hhQds-Rbt00ksTIpcRAez0jDVzbNSnwguixuX12PBa5u_A5CRGCSSzN5l0xQ7T_j3kOFYc6Sr4TpCBrqjS5_1a6TGFMA2NWhZ9ICIBtZSAOSiA7ZCvDkq_WhEJyC9NE",
            "social_network_id": IDStringSocial,
            "user_type":"2"
            
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            //                    if (dic.object(forKey: "res_code")) as! String == "1"
            //                    {
            if (dic.object(forKey: "braingroom") as! NSArray).count > 0
            {
                if ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "is_mobile_verified") as! Int == 1
                {
                    let alert = FCAlertView()
                    alert.blurBackground = false
                    alert.cornerRadius = 15
                    alert.bounceAnimations = true
                    alert.dismissOnOutsideTouch = false
                    alert.delegate = self
                    alert.makeAlertTypeSuccess()
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    alert.hideDoneButton = true;
                    alert.addButton("OK", withActionBlock: {
                        
                        let userId = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "id") as! String
                        UserDefaults.standard.set(userId , forKey: "user_id")
                        UserDefaults.standard.set(self.emailStringSocial , forKey: "user_email")
                        self.appDelegate.userId = userId as NSString
                        self.appDelegate.userData = (((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        for key in self.appDelegate.userData.allKeys
                        {
                            if (self.appDelegate.userData[key] is NSNull)
                            { // NSNull is a singleton, so this check is sufficient
                                self.appDelegate.userData.setValue("", forKey: key as! String)
                            }
                        }
                        
                        print(self.appDelegate.userData)
                        
                        UserDefaults.standard.set(self.appDelegate.userData, forKey: "userData")
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
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
    
    func loginFunction()
    {
        let baseURL: String  = String(format:"%@login",Constants.mainURL)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)

        let innerParams : [String: String] = [
            "email": appDelegate.signUpEmail as String,
            "latitude": "",
            "longitude": "",
            "password": appDelegate.signUpPassword as String,
            "reg_id": "",
            "social_network_id": ""
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
//            if (dic.object(forKey: "res_code")) as! String == "1"
//            {
                if (dic.object(forKey: "braingroom") as! NSArray).count > 0
                {
                if ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "is_mobile_verified") as! Int == 1
                {
                    let alert = FCAlertView()
                    alert.blurBackground = false
                    alert.cornerRadius = 15
                    alert.bounceAnimations = true
                    alert.dismissOnOutsideTouch = false
                    alert.delegate = self
                    alert.makeAlertTypeSuccess()
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    alert.hideDoneButton = true;
                    alert.addButton("OK", withActionBlock: {
                        
                        let userId = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "id") as! String
                        let mobile = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "mobile") as! String
                        UserDefaults.standard.set(userId , forKey: "user_id")
                        UserDefaults.standard.set(mobile, forKey: "userMobile")
                        self.appDelegate.userId = userId as NSString
                        self.appDelegate.userData = (((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        for key in self.appDelegate.userData.allKeys
                        {
                            if (self.appDelegate.userData[key] is NSNull)
                            { // NSNull is a singleton, so this check is sufficient
                                self.appDelegate.userData.setValue("", forKey: key as! String)
                            }
                        }
                        
                        UserDefaults.standard.set(self.appDelegate.signUpEmail, forKey: "user_email")
                        UserDefaults.standard.set(self.appDelegate.userData, forKey: "userData")
                        
        
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
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
                    alert.makeAlertTypeSuccess()
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: "OTP Not verified, Please try again", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
                }
//                }
//                else
//                {
//                    let alert = FCAlertView()
//                    alert.blurBackground = false
//                    alert.cornerRadius = 15
//                    alert.bounceAnimations = true
//                    alert.dismissOnOutsideTouch = false
//                    alert.delegate = self
//                    alert.makeAlertTypeWarning()
//                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
//                }
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
                self.navigationController?.popViewController(animated: true)
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
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}
