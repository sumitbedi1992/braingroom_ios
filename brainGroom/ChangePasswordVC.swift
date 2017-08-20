//
//  ChangePasswordVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 20/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if oldPasswordTF.text == "" {
            AFWrapperClass.alert("Bridegroom", message: "Enter old password", view: self)
        }
        else if newPasswordTF.text == "" {
            AFWrapperClass.alert("Bridegroom", message: "Enter new password", view: self)

        }
        else if confirmPasswordTF.text == "" {
            AFWrapperClass.alert("Bridegroom", message: "Enter confirm password", view: self)

        }
        else if newPasswordTF.text != confirmPasswordTF.text {
            AFWrapperClass.alert("Bridegroom", message: "new password and confirm new Password does not matched", view: self)

        }
        else{
            print("password changed")
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}
