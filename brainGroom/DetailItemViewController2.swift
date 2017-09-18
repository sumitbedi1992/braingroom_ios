//
//  DetailItemViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 18/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import MXSegmentedPager
import FCAlertView

class DetailItemViewController2: UIViewController, FCAlertViewDelegate
{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    var catID = String()

    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var sessionLbl: UILabel!
    @IBOutlet weak var aboutTheClassLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerImage: UIImageViewX!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var starLbl: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mainScrollView.parallaxHeader.view = headerView
        mainScrollView.parallaxHeader.height = 200
        mainScrollView.parallaxHeader.mode = .fill
        mainScrollView.parallaxHeader.minimumHeight = 39
        mainScrollView.bounces = false
        
        self.dataFromServer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@viewClassDetail",Constants.mainURLProd)
        let innerParams : [String: String] = [
            "id": catID as String,
            "user_id" : appDelegate.userId as String,
            "is_Catalogue": "0"
            ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
               if((dic.object(forKey: "braingroom")) as! NSArray).count > 0
               {
                let attributedString : NSMutableAttributedString = ((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "class_summary") as! String).htmlAttributedString() as! NSMutableAttributedString
                let s = attributedString.string
                
                self.aboutTheClassLbl.text = s
                
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
            })
        }
    }

    @IBAction func shareBtnAction(_ sender: Any)
    {
        
    }
    @IBAction func favBtnAction(_ sender: Any)
    {
        
    }
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
   

    @IBAction func providerBtnAct(_ sender: Any)
    {
        
    }
    @IBAction func bookNowBtn(_ sender: Any)
    {
        
    }
    @IBAction func giftClassBtn(_ sender: Any)
    {
        
    }
    
    @IBAction func locationBtnAct(_ sender: Any)
    {
        
    }
    
    @IBAction func privateTutorBtnAct(_ sender: Any)
    {
        
    }
    @IBAction func contactUsBtn(_ sender: Any)
    {
        
    }
    
    @IBAction func postQuery(_ sender: Any)
    {
        
    }
    
}


extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil) else { return nil }
        return html
    }
}
