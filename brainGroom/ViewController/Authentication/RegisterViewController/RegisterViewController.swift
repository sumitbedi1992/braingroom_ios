//
//  RegisterViewController.swift
//  brainGroom
//
//  Created by Satya Mahesh on 19/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class RegisterViewController: UIViewController,FCAlertViewDelegate {

    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPWTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var passoutYearTF: UITextField!
    @IBOutlet weak var refferalCodeTF: UITextField!
    @IBOutlet weak var collegeNameLBL: UILabel!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTF.isSecureTextEntry = true
        confirmPWTF.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate.signUpUGCollege == ""
        {
            collegeNameLBL.text = "Select Item"
        }
        else
        {
            collegeNameLBL.text = appDelegate.signUpUGCollege as String
        }
    }
    
    @IBAction func backBTNTap(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpBTNTap(_ sender: UIButton)
    {
        if (fullNameTF.text?.characters.count)! >= 4
        {
            if AFWrapperClass.isValidEmail(emailTF.text!) == true
            {
                if (mobileNumberTF.text?.characters.count)! == 10
                {
                    if (passwordTF.text?.characters.count)! > 5 && (confirmPWTF.text?.characters.count)! > 5
                    {
                        if passwordTF.text == confirmPWTF.text
                        {
                            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)

                            let baseURL: String  = String(format:"%@BuyerRegistration",Constants.mainURL)
                            
                            let innerParams : [String: String] = [
                                "name":fullNameTF.text!,
                                "email": emailTF.text!,
                                "password": passwordTF.text!,
                                "mobile_no": mobileNumberTF.text!,
                                "country" : "",
                                "state" : "",
                                "city" : "",
                                "locality" : "",
                                "category_id" : "",
                                "d_o_b" : "",
                                "gender" : "",
                                "profile_image" : "",
                                "community_id" : "",
                                "school_id" : "",
                                "institute_name1" : appDelegate.signUpUGCollege as String,
                                "institute_poy1" : passoutYearTF.text!,
                                "institute_name2" : "",
                                "institute_poy2" : "",
                                "referal_code" : refferalCodeTF.text!,
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
                                        self.appDelegate.signUpEmail = self.emailTF.text! as NSString
                                        self.appDelegate.signUpPassword = self.passwordTF.text! as NSString
                                        self.appDelegate.signUpMobileNumber = self.mobileNumberTF.text! as NSString
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
                        else
                        {
                            let alert = FCAlertView()
                            alert.blurBackground = false
                            alert.cornerRadius = 15
                            alert.bounceAnimations = true
                            alert.dismissOnOutsideTouch = false
                            alert.delegate = self
                            alert.makeAlertTypeWarning()
                            alert.showAlert(withTitle: "CabScout", withSubtitle: "Both passwords are not matched", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                        alert.showAlert(withTitle: "CabScout", withSubtitle: "Minimum password length should 6 characters", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                    alert.showAlert(withTitle: "CabScout", withSubtitle: "Please enter valid mobile number", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                alert.showAlert(withTitle: "CabScout", withSubtitle: "Please enter a valid email Id", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
            alert.showAlert(withTitle: "CabScout", withSubtitle: "Please enter Valid Name", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            
        }
        
    }
    
    @IBAction func nextBTNTap(_ sender: UIButton)
    {
        if (fullNameTF.text?.characters.count)! >= 4
        {
            if AFWrapperClass.isValidEmail(emailTF.text!) == true
            {
                if (mobileNumberTF.text?.characters.count)! == 10
                {
                    if (passwordTF.text?.characters.count)! > 5 && (confirmPWTF.text?.characters.count)! > 5
                    {
                        if passwordTF.text == confirmPWTF.text
                        {
                            appDelegate.signUpFullName = fullNameTF.text! as NSString
                            appDelegate.signUpEmail = emailTF.text! as NSString
                            appDelegate.signUpMobileNumber = mobileNumberTF.text! as NSString
                            appDelegate.signUpPassword = passwordTF.text! as NSString
                            appDelegate.signUpReferralCode = refferalCodeTF.text! as NSString
                            appDelegate.signUpPassout = passoutYearTF.text! as NSString
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController2") as! RegisterViewController2
                            self.navigationController?.pushViewController(vc, animated: true)
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
                            alert.showAlert(withTitle: "CabScout", withSubtitle: "Both passwords are not matched", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                        alert.showAlert(withTitle: "CabScout", withSubtitle: "Minimum password length should 6 characters", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                    alert.showAlert(withTitle: "CabScout", withSubtitle: "Please enter valid mobile number", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                alert.showAlert(withTitle: "CabScout", withSubtitle: "Please enter a valid email Id", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
            alert.showAlert(withTitle: "CabScout", withSubtitle: "Please enter Valid Name", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            
        }
    }
    
    @IBAction func selectColegeBTNTap(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
        vc.keyForApi = "college"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
