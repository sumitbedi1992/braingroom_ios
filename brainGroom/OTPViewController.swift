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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        mobileNumberTF.text = appDelegate.signUpMobileNumber as String
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
//            if (dic.object(forKey: "res_code")) as! Int == 1
//            {
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
//            }
//            else
//            {
//                let alert = FCAlertView()
//                alert.blurBackground = false
//                alert.cornerRadius = 15
//                alert.bounceAnimations = true
//                alert.dismissOnOutsideTouch = false
//                alert.delegate = self
//                alert.makeAlertTypeWarning()
//                alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//                alert.hideDoneButton = true;
//                alert.addButton("OK", withActionBlock: {
//                })
//                
//            }
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
                            self.loginFunction()
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
//                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//                    alert.hideDoneButton = true;
//                    alert.addButton("OK", withActionBlock: {
//                    })
//                    
//                }
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
    
    
    func loginFunction()
    {
        let baseURL: String  = String(format:"%@userLogin",Constants.mainURL)
        
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
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                if (dic.object(forKey: "braingroom") as! NSArray).count > 0
                {
                if ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "is_mobile_verified") as! String == "1"
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
                        self.appDelegate.userId = userId as NSString
                        self.appDelegate.userData = ((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary
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
