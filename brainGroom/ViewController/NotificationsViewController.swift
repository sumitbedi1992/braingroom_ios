//
//  NotificationsViewController.swift
//  brainGroom
//
//  Created by Satya Mahesh on 20/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class notificationsCell: UITableViewCell
{
    @IBOutlet weak var notofoctionLbl: UILabel!
}

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate
{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var notificationsTable: UITableView!
    
    var notificationsArray = NSArray()
    let alert = FCAlertView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setAlertViewData(alert)
        alert.delegate = self
        
       dataFromServer()
        
        // Along with auto layout, these are the keys for enabling variable cell height
        notificationsTable.estimatedRowHeight = 44.0
        notificationsTable.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@getUserNotifications",Constants.mainURL)
        
                let innerParams : [String: String] = [
                    "user_id": appDelegate.userId as String,
//                    "user_id": "1133"
                    ]
                let params : [String: AnyObject] = [
                    "braingroom": innerParams as AnyObject
                ]
                print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.notificationsArray = dic.object(forKey: "braingroom") as! NSArray
                
                if (self.notificationsArray.count > 0)
                {
                    self.notificationsTable.delegate = self
                    self.notificationsTable.dataSource = self
                    self.notificationsTable.reloadData()
                }
                else
                {
                    self.alert.makeAlertTypeWarning()
                    self.alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                    self.alert.hideDoneButton = true;
                    self.alert.addButton("OK", withActionBlock: {
                    })
                }
            }
            else
            {
                self.alert.makeAlertTypeWarning()
                self.alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                self.alert.hideDoneButton = true;
                self.alert.addButton("OK", withActionBlock: {
                })
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alert.makeAlertTypeWarning()
            self.alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            self.alert.hideDoneButton = true;
            self.alert.addButton("OK", withActionBlock: {
            })
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationsArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.notificationsTable.dequeueReusableCell(withIdentifier: "notificationCell") as! notificationsCell
        cell.notofoctionLbl.text = (self.notificationsArray[indexPath.row] as! NSDictionary).value(forKey: "description") as? String
        
        cell.selectionStyle = .none
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
