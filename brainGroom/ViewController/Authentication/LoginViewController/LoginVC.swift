//
//  LoginVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 12/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FCAlertView

class LoginVC: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate,FCAlertViewDelegate
{
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotPasswordTF: ACFloatingTextfield!
    @IBOutlet weak var forgotPasswordAnimationView: UIView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var DeviceToken = String()
    var faceBookDic = [String : Any]()
    var emailStringSocial = String()
    var nameStringSocial = String()
    var IDStringSocial = String()
    
    var fromSocial = Bool()

    @IBOutlet var headerView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if fromBooking() != true || fromSocial != true
        {
            headerView.isHidden = true
        }
        else
        {
            headerView.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
            DeviceToken = ""
        }
        else
        {
            DeviceToken  = UserDefaults.standard.object(forKey: "DeviceToken") as! String
            print("VC DEVICE TKN:\(DeviceToken)")
        }
    }
    
    @IBAction func skipBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registenAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func normalLogin(_ sender: Any)
    {
        if (userNameTF.text?.characters.count)! > 5
        {
            if (passwordTF.text?.characters.count)! > 5
            {
                AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                
                let baseURL: String  = String(format:"%@login",Constants.mainURL)
                let innerParams : [String: String] = [
                    "email":userNameTF.text!,
                    "latitude": "",
                    "longitude": "",
                    "password": passwordTF.text!,
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
                                UserDefaults.standard.set(self.userNameTF.text , forKey: "user_email")
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
                                
                                //appDelegate.getUserProfile()
                                
                                print("From Booking ---> \(fromBooking())")
                                if fromBooking() != true
                                {
                                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                                else
                                {
                                    _=self.navigationController?.popViewController(animated: true)
                                }
                                
                            })
                        }
                        else
                        {
                            self.appDelegate.tempUser = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "id") as! String as NSString
                            self.appDelegate.signUpEmail = self.userNameTF.text! as NSString
                            self.appDelegate.signUpPassword = self.passwordTF.text! as NSString
                            self.appDelegate.signUpMobileNumber = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "mobile") as! String as NSString
                            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                            self.navigationController?.pushViewController(viewController, animated: true)
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
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Password must contain minimum 6 characters", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please enter registered emailID", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
        }
    }

    @IBAction func fbLogin(_ sender: Any)
    {
        FacebookHelper .shared .loginWithFacebook(fromViewController: self, successblock: { (result) in
            
//            UserDefaults .standard .set(result, forKey: "FbuserInfo")
            // UserDefaults .standard .set(true, forKey: isLoggedin)
            //   UserDefaults .standard .synchronize()
            
//            let dict = ["social_type":"facebook","email":result["email"]!,"social_id":result["id"]!,"user_name":result["first_name"]!] as [String : Any]
            //            self.sendSocialMediaLoginDetailToServer(param: dict)
            
            self.faceBookDic = result
            self.emailStringSocial = (self.faceBookDic["email"] as? String)!
            self.nameStringSocial = (self.faceBookDic["first_name"] as? String)!
            self.IDStringSocial = (self.faceBookDic["id"] as? String)!
            self.socialLoginMethod()
            
            
        }) { (error) in
            
        }
        
//        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
//            if (error == nil){
//                let fbloginresult : FBSDKLoginManagerLoginResult = result!
//                if fbloginresult.grantedPermissions != nil {
//                    if(fbloginresult.grantedPermissions.contains("email"))
//                    {
//                        self.getFBUserData()
//                        fbLoginManager.logOut()
//                    }
//                }
//            }
//        }
    }
    
//    func getFBUserData()
//    {
//        if((FBSDKAccessToken.current()) != nil){
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//                    self.faceBookDic = result as! [String : AnyObject] as NSDictionary
//                    self.emailStringSocial = self.faceBookDic.object(forKey: "email") as! String
//                    self.nameStringSocial = self.faceBookDic.object(forKey: "first_name") as! String
//                    self.IDStringSocial = self.faceBookDic.object(forKey: "id") as! String
//                    self.socialLoginMethod()
//                }
//            })
//        }
//    }
    
    @IBAction func googleLogin(_ sender: Any)
    {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn .sharedInstance().delegate = self
        GIDSignIn .sharedInstance().uiDelegate = self
        
        GIDSignIn .sharedInstance() .signIn()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!)
    {
        AFWrapperClass.svprogressHudDismiss(view: self);
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!)
    {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            return
        }
        reportAuthStatus()
//        AFWrapperClass.svprogressHudShow(title: "Getting Details...", view: self)
        
        emailStringSocial = user.profile.email
        nameStringSocial = user.profile.givenName
        IDStringSocial = user.userID
        
        self.socialLoginMethod()
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil)
        {
            
        }
        else
        {
            
        }
    }

    func reportAuthStatus() -> Void
    {
        let googleUser:GIDGoogleUser = GIDSignIn.sharedInstance().currentUser
        if (googleUser.authentication != nil)
        {
            // print("Status: Authenticated")
        }else
        {
            // print("Status: Not authenticated")
        }
    }
    func refreshUserInfo() -> Void
    {
        if GIDSignIn.sharedInstance().currentUser.authentication == nil {
            return
        }
        if !GIDSignIn.sharedInstance().currentUser.profile.hasImage {
            return
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
//                if ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "is_mobile_verified") as! Int == 1
//                {
                
                
                let alertController = UIAlertController(title: "Braingroom", message: dic.object(forKey: "res_msg") as? String, preferredStyle:.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                { action -> Void in
                    // Put your code here
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
                                            //appDelegate.getUserProfile()
                                            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                            self.navigationController?.pushViewController(viewController, animated: true)
                })
                self.present(alertController, animated: true, completion: nil)
                
//                DispatchQueue.main.async {
//                    let alert = FCAlertView()
//                    alert.blurBackground = false
//                    alert.cornerRadius = 15
//                    alert.bounceAnimations = true
//                    alert.dismissOnOutsideTouch = false
//                    alert.delegate = self
//                    alert.makeAlertTypeSuccess()
//                    alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//                    alert.hideDoneButton = true;
//                    alert.addButton("OK", withActionBlock: {
//
//                        let userId = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "id") as! String
//                        UserDefaults.standard.set(userId , forKey: "user_id")
//                        UserDefaults.standard.set(self.emailStringSocial , forKey: "user_email")
//                        self.appDelegate.userId = userId as NSString
//                        self.appDelegate.userData = (((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
//
//                        for key in self.appDelegate.userData.allKeys
//                        {
//                            if (self.appDelegate.userData[key] is NSNull)
//                            { // NSNull is a singleton, so this check is sufficient
//                                self.appDelegate.userData.setValue("", forKey: key as! String)
//                            }
//                        }
//
//                        print(self.appDelegate.userData)
//
//                        UserDefaults.standard.set(self.appDelegate.userData, forKey: "userData")
//                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                        self.navigationController?.pushViewController(viewController, animated: true)
//                    })
//                }
                
//                }
//                else
//                {
//                    self.appDelegate.tempUser = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "id") as! String as NSString
//                    if ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "mobile") != nil
//                    {
//                    self.appDelegate.signUpMobileNumber = ((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "mobile") as! String as NSString
//                    }
//                    else
//                    {
//                        self.appDelegate.signUpMobileNumber = ""
//                    }
//                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
//                    viewController.isSocial = true
//                    viewController.emailStringSocial = self.emailStringSocial
//                     viewController.nameStringSocial = self.nameStringSocial
//                    viewController.IDStringSocial = self.IDStringSocial
//                    self.navigationController?.pushViewController(viewController, animated: true)
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
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func forgotPassword(_ sender: Any)
    {
        self.forgotPasswordAnimationView.isHidden = false
        AFWrapperClass.dampingEffect(view: self.forgotPasswordAnimationView)
    }
    
    @IBAction func forgotPasswordOkCancelAction(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            if AFWrapperClass.isValidEmail(self.forgotPasswordTF.text!)
            {
                let baseURL: String  = String(format:"%@forgotPassword",Constants.mainURL)
                
                AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
                
                
                let innerParams : [String: String] = [
                    "email": self.forgotPasswordTF.text!
                    ]
                let params : [String: AnyObject] = [
                    "braingroom": innerParams as AnyObject
                ]
                print(params)
                AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
                    print("DDD: \(responseDict)")
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let dic:NSDictionary = responseDict as NSDictionary
                        let alert = FCAlertView()
                        alert.blurBackground = false
                        alert.cornerRadius = 15
                        alert.bounceAnimations = true
                        alert.dismissOnOutsideTouch = false
                        alert.delegate = self
                        alert.makeAlertTypeCaution()
                        alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                        alert.hideDoneButton = true;
                        alert.addButton("OK", withActionBlock:
                            {
                                self.forgotPasswordAnimationView.isHidden = true
                        })
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
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please enter a valid email ID", withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                alert.hideDoneButton = true;
                alert.addButton("OK", withActionBlock: {
                })
            }
        }
        else
        {
            self.forgotPasswordAnimationView.isHidden = true
        }
        
    }
    
}
