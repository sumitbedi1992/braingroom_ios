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
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var DeviceToken = String()
    var faceBookDic = NSDictionary()
    var emailStringSocial = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
            DeviceToken = ""
        }else{
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
                let baseURL: String  = String(format:"%@userLogin",Constants.mainURL)
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
                    if (dic.object(forKey: "res_code")) as! String == "1"
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
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.faceBookDic = result as! [String : AnyObject] as NSDictionary
                    self.emailStringSocial = self.faceBookDic.object(forKey: "email") as! String
                    AFWrapperClass.alert("BrainGroom", message:"FB Login Success \n Name:- \(self.faceBookDic.object(forKey: "first_name") as! String)", view: self)
                    //                    self.socialLoginMethod()
                }
            })
        }
    }
    
 /*   func socialLoginMethod () -> Void
    {
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
            DeviceToken = ""
        }else{
            DeviceToken  = UserDefaults.standard.object(forKey: "DeviceToken") as! String
            
            print("VC DEVICE TKN:\(DeviceToken)")
        }
        let baseURL: String  = String(format: "%@login/",Constants.mainURL)
        let params = "mobile=\(self.emailStringSocial)&is_social=\("1")&device_type=ios&device_id=\(DeviceToken)"
     AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)

     
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    
                    let id:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "user_id") as! String
                    
                    UserDefaults.standard.set(id, forKey: "saveUserID")
                    UserDefaults.standard.synchronize()
                    
                    let registerIsSocial:String = (responceDic.object(forKey: "data") as! NSDictionary ).object(forKey: "is_social") as! String
                    
                    UserDefaults.standard.set(registerIsSocial, forKey: "saveRegSocial")
                    UserDefaults.standard.synchronize()
                    
                    UserDefaults.standard.set("LoginSuccess", forKey: "success")
                    UserDefaults.standard.synchronize()
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "User not register with  Kinder Drop. Please register..", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            print(error.localizedDescription)
        }
    }
    */
    
    
    @IBAction func googleLogin(_ sender: Any)
    {
        GIDSignIn.sharedInstance().signOut()
        let sighIn:GIDSignIn = GIDSignIn.sharedInstance()
        sighIn.delegate = self;
        sighIn.uiDelegate = self;
        sighIn.shouldFetchBasicProfile = true
        sighIn.scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/userinfo.profile","https://www.googleapis.com/auth/plus.me"];
        sighIn.clientID = "46561143796-gdsmiesg1nb53uu42v7cbg1k8nu9vsit.apps.googleusercontent.com"
        sighIn.signIn()
        GIDSignIn.sharedInstance().signOut()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        AFWrapperClass.svprogressHudDismiss(view: self);
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            return
        }
        reportAuthStatus()
//        AFWrapperClass.svprogressHudShow(title: "Getting Details...", view: self)
        
        emailStringSocial = user.profile.email
        AFWrapperClass.alert("BrainGroom", message:"FB Login Success \n Name:- \(user.profile.givenName!)", view: self)
//        self.socialLoginMethod()
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
    
    @IBAction func forgotPassword(_ sender: Any)
    {
        
    }
}
