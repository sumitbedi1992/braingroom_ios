//
//  RegisterViewController2.swift
//  brainGroom
//
//  Created by Satya Mahesh on 19/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class RegisterViewController2: UIViewController {

    @IBOutlet weak var dobPicker: UIDatePicker!
    
    @IBOutlet weak var dobLBL: UILabel!
    
    @IBOutlet weak var genderLBL: UILabel!
    
    @IBOutlet weak var interestLBL: UILabel!
    
    @IBOutlet weak var countryLBL: UILabel!
    
    @IBOutlet weak var stateLBL: UILabel!
    
    @IBOutlet weak var cityLBL: UILabel!
    
    @IBOutlet weak var locationLBL: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBTNTap(_ sender: UIButton) {
    }

    @IBAction func selectTypesBTNTap(_ sender: UIButton) {
    }

    @IBAction func doneBTNTap(_ sender: Any) {
    }
    @IBAction func signUpBTNTap(_ sender: Any) {
    }
}
