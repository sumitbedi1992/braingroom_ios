//
//  ChangePasswordVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 20/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class ChangePasswordVC: UIViewController,FCAlertViewDelegate {

    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var fromSocial = Bool()
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }
    
    let alert = FCAlertView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setAlertViewData(alert)
        alert.delegate = self
        
        if fromSocial == true
        {
            headerViewHeightConstraint.constant = 55
        }
        else
        {
            headerViewHeightConstraint.constant = 0
        }

        oldPasswordTF.isSecureTextEntry = true
        newPasswordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
        oldPasswordTF.placeholder = "Old Password"
        newPasswordTF.placeholder = "New Password"
        confirmPasswordTF.placeholder = "Confirm Password"
        oldPasswordTF.font = UIFont.systemFont(ofSize: 16)
        newPasswordTF.font = UIFont.systemFont(ofSize: 16)
        confirmPasswordTF.font = UIFont.systemFont(ofSize: 16)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func changePasswordBtnAction(_ sender: Any) {
        if (oldPasswordTF.text?.characters.count)! < 6 {
            
            alert.makeAlertTypeWarning()
            DispatchQueue.main.async {
                self.alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please enter Old password (Min 6 charecters)" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                self.alert.hideDoneButton = true;
                self.alert.addButton("OK", withActionBlock: {
                    //self.navigationController?.popViewController(animated: true)
                })
            }
            
            
        }
        else if (newPasswordTF.text?.characters.count)! < 6 {
            alert.makeAlertTypeWarning()
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please enter New password (Min 6 charecters)" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            alert.hideDoneButton = true;
            alert.addButton("OK", withActionBlock: {
            })
        }
        else if (confirmPasswordTF.text?.characters.count)! < 6 {
            alert.makeAlertTypeWarning()
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please confirm password (Min 6 charecters)" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            alert.hideDoneButton = true;
            alert.addButton("OK", withActionBlock: {
            })
        }
        else if newPasswordTF.text != confirmPasswordTF.text {
            alert.makeAlertTypeWarning()
            alert.showAlert(withTitle: "Braingroom", withSubtitle: "Both new and confirm password does not matched!)" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            alert.hideDoneButton = true;
            alert.addButton("OK", withActionBlock: {
            })
        }
        else{
            let baseURL: String  = String(format:"%@changePassword",Constants.mainURL)
            
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            
            let innerParams : [String: String] = [
                "uuid": (appDelegate.userData.value(forKey: "uuid") as? String)!,
                "old_password": oldPasswordTF.text!,
                "new_password":newPasswordTF.text!
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
//                if (dic.object(forKey: "braingroom") as! NSArray).count > 0
//                {
//                    
//                }
//                else
//                {
                
                DispatchQueue.main.async {
                    self.alert.makeAlertTypeSuccess()
                    self.alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    self.alert.hideDoneButton = true;
                    self.alert.addButton("OK", withActionBlock: {
                    })
                    
                }
                
//                }
            }) { (error) in
                AFWrapperClass.svprogressHudDismiss(view: self)
                self.alert.makeAlertTypeWarning()
                self.alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                self.alert.hideDoneButton = true;
                self.alert.addButton("OK", withActionBlock: {
                })
            }
        }
    }
}
