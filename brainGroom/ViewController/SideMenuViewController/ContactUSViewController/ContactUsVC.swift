//
//  ContactUsVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 12/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import MessageUI


class ContactUsVC: UIViewController,MFMailComposeViewControllerDelegate {
    
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
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }

    @IBAction func phoneBtnAction(_ sender: Any)
    {
        let actionSheetController = UIAlertController(title: nil, message: "Select Number to call", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let actionButton = UIAlertAction(title: "Help Desk: 044 49507392", style: .default) { action -> Void in
            if let url = URL(string: "tel://04449507392"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        actionSheetController.addAction(actionButton)
        
        let saveActionButton1 = UIAlertAction(title: "Contact: 9962584477", style: .default) { action -> Void in
            if let url = URL(string: "tel://9962084477"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        actionSheetController.addAction(saveActionButton1)
        
        let saveActionButton = UIAlertAction(title: "Contact: 9962084477", style: .default) { action -> Void in
            if let url = URL(string: "tel://9962084477"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Transaction Related :7550021666", style: .default) { action -> Void in
            if let url = URL(string: "tel://7550021666"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func sendEmail(str : String ) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([str])
            mail.setSubject("Support")
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mailBtn(_ sender: Any)
    {
        
        let actionSheetController = UIAlertController(title: nil, message: "Select from Options", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let actionButton = UIAlertAction(title: "contactus@braingroom.com", style: .default) { action -> Void in
            self.sendEmail(str: "contactus@braingroom.com")
        }
        actionSheetController.addAction(actionButton)
        
        let saveActionButton1 = UIAlertAction(title: "Posting Queries: manoj@braingroom.com", style: .default) { action -> Void in
            self.sendEmail(str: "manoj@braingroom.com")

        }
        actionSheetController.addAction(saveActionButton1)
        
        let saveActionButton = UIAlertAction(title: "Posting Queries: sangeetha@braingroom.com", style: .default) { action -> Void in
            self.sendEmail(str: "sangeetha@braingroom.com")
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Posting Queries: sheela@braingroom.com", style: .default) { action -> Void in
            self.sendEmail(str: "sheela@braingroom.com")
                   }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    

}
