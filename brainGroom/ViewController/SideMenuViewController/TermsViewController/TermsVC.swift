//
//  TermsVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 12/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class TermsVC: UIViewController
{

    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var fromSocial = Bool()
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromSocial == true
        {
            headerViewHeightConstraint.constant = 55
        }
        else
        {
            headerViewHeightConstraint.constant = 0
        }

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

    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)

    }
}
