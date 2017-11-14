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
import GoogleMaps
import GooglePlaces
import YouTubePlayer
import MessageUI
import Messages

class DetailItemViewController2: UIViewController, FCAlertViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate
{
    let locationManager = CLLocationManager()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var catID = String()
    var price = String()
    var myVideoURL = String()
    var vendorID = String()
    var clsID = String()
    var isOnline = Bool()
    var dataDic = NSDictionary()
    
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    
    @IBOutlet weak var mapMainView: UIViewX!
    @IBOutlet weak var vidBtn: UIButton!
    @IBOutlet weak var vidImage: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var bookBtn: UIButton!
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
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var starLbl: UILabel!
    
    @IBOutlet weak var privateTutorView: UIView!
    
    @IBOutlet weak var nameTF: ACFloatingTextfield!
    @IBOutlet weak var mobileTF: ACFloatingTextfield!
    @IBOutlet weak var emailTF: ACFloatingTextfield!
    @IBOutlet weak var dateAndTimeTF: ACFloatingTextfield!
    @IBOutlet weak var requestDetailsTextView: UITextView!
    
    @IBOutlet weak var constraintHeightViewX: NSLayoutConstraint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        constraintHeightViewX.constant = 70
        mainScrollView.parallaxHeader.view = headerView
        mainScrollView.parallaxHeader.height = 200
        mainScrollView.parallaxHeader.mode = .fill
        mainScrollView.parallaxHeader.minimumHeight = 39
        mainScrollView.bounces = false
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        requestDetailsTextView.layer.cornerRadius = 5.0
        requestDetailsTextView.layer.borderWidth = 1.0
        requestDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        requestDetailsTextView.placeholder = "Tutor Request Details"
        
        self.dataFromServer()
    }
    
    //MARK: - Service Called
    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@viewClassDetail",Constants.mainURL)
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
                    self.dataDic = (((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary)
                
                    let attributedString : NSMutableAttributedString = (self.dataDic.value(forKey: "class_summary") as! String).htmlAttributedString() as! NSMutableAttributedString
                    let s = attributedString.string
                    self.aboutTheClassLbl.text = s
                
                    if let provider = self.dataDic.value(forKey: "class_provider_id")
                    {
                        self.vendorID = provider as? String ?? ""
                        if let provider = self.dataDic.value(forKey: "class_provided_by")
                        {
                            self.providerName.text = provider as? String ?? ""
                        }
                        if let provider = self.dataDic.value(forKey: "class_provider_pic")
                        {
                            self.providerImage.sd_setImage(with: URL(string: provider as? String ?? ""), placeholderImage: UIImage.init(named: "imm"))
                        }
                    }
                
                
                
                
                    if let strUrl = self.dataDic.value(forKey: "photo")
                    {
                        self.vidImage.sd_setBackgroundImage(with: URL(string: strUrl as! String), for: .normal, completed: { (image, error, SDImageCacheType, url) in
                            if error == nil
                            {
                                self.vidImage.setBackgroundImage(image, for: .normal)
                            }
                            else
                            {
                                self.vidImage.setBackgroundImage(UIImage.init(named: "chocolate1Dca410A2"), for: .normal)
                            }
                        })
                    }
                    else
                    {
                        self.vidImage.setBackgroundImage(UIImage.init(named: "chocolate1Dca410A2"), for: .normal)
                    }
                
    //                vidBtn.sd_setBackgroundImage(with: URL(string: (self.dataDic.value(forKey: "photo") as! String)), for: UIControlState.normal, placeholderImage: nil, completed: { (image, error, SDImageCacheType, url) in
    //                    vidBtn.setBackgroundImage(image, for: UIControlState.normal)
    //                })
                
                    //self.vidImage.sd_setImage(with: URL(string: (self.dataDic.value(forKey: "photo") as! String)), placeholderImage: UIImage.init(named: "chocolate1Dca410A2"))
                
                    if((self.dataDic.value(forKey: "video")) is NSNull)
                    {
                        self.vidBtn.isHidden = true
                    }
                    else
                    {
                        if (self.dataDic.value(forKey: "video") as! String).range(of: "youtube") != nil {
                            self.vidBtn.isHidden = false
                            self.myVideoURL = self.dataDic.value(forKey: "video") as! String
                            self.videoPlayer.loadVideoID(self.extractYoutubeIdFromLink(link: self.myVideoURL)!)
                        }
                        else
                        {
                            self.vidBtn.isHidden = true
                        }
                    }
                    self.itemNameLbl.text = (self.dataDic.value(forKey: "class_topic") as! String)
                    self.clsID = (self.dataDic.value(forKey: "id") as! String)
                
                    self.starLbl.text = String.init(format: "%d",(self.dataDic.value(forKey: "rating") as! Int))
                
                
                    self.bookBtn.setTitle("BOOK FOR FREE", for: .normal)
                    if let strPrice : String = ((self.dataDic.value(forKey: "vendorClasseLevelDetail") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "price") as? String
                    {
                        if strPrice != "" && strPrice != "0"
                        {
                            self.priceLbl.text = "Rs. " + strPrice
                            self.price = strPrice
                            self.bookBtn.setTitle("BOOK NOW", for: .normal)
                        }
                        else
                        {
                            self.priceLbl.text = "Free"
                            self.price = "0"
                            
                        }
                    }else{
                        self.priceLbl.text = "Free"
                        self.price = "0"
                    }
                
                    self.sessionLbl.text = String.init(format: "%@ Sessions, %@", (self.dataDic.value(forKey: "no_of_session") as! String), (self.dataDic.value(forKey: "class_duration") as! String))
                
                
                    if self.isOnline == true
                    {
                        self.locationBtn.setTitle("Online" , for: .normal)
    //                    self.mapMainView.frame = CGRect(x: self.mapMainView.frame.origin.x , y: self.mapMainView.frame.origin.y, width: self.mapMainView.frame.size.width, height: 0)
                        self.mapHeight.constant = 0
                        self.mapMainView.isHidden = true
                    }
                    else
                    {
                        if let locationDict : NSDictionary = (self.dataDic.value(forKey: "location") as? NSArray)?.object(at: 0) as? NSDictionary
                        {
                            self.locationBtn.setTitle(locationDict.value(forKey: "locality") as? String, for: .normal)
                            
                            let lat = locationDict.value(forKey: "latitude") as! NSString
                            let long = locationDict.value(forKey: "longitude") as! NSString
                            
                            // Creates a marker in the center of the map.
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: long.doubleValue)
                            marker.title = locationDict.value(forKey: "location_area") as? String
                            marker.icon = UIImage(named: "pin")
                            marker.map = self.mapView
                            
                            let camera = GMSCameraPosition.camera(withLatitude: lat.doubleValue, longitude: long.doubleValue, zoom: 6.0)
                            self.mapView.camera = camera
                        }
                    }
                
                if self.dataDic.value(forKey: "wishlist") != nil
                {
                    if Int(self.dataDic.value(forKey: "wishlist") as! String) == 1
                    {
                        self.favBtn.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                    }
                    else
                    {
                        self.favBtn.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
                    }
                }
                else
                {
                    self.favBtn.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
                }
                }
            }
            else
            {
                self.alert(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alert(text: error.localizedDescription)
        }
    }
   
    
    //MARK: - Get Video ID from URL
    func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }

    //MARK: - Button click event
    @IBAction func shareBtnAction(_ sender: Any)
    {
        if let shareUrl = dataDic.value(forKey: "detail_class_link")
        {
            var objectsToShare = [AnyObject]()
            
            let strShare = "Checkout this class I found at Braingroom : \n" + (shareUrl as! String)
                objectsToShare.append(strShare as AnyObject)
            
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func favBtnAction(_ sender: Any)
    {
        
        if appDelegate.userId != ""
        {
        let baseURL: String  = String(format:"%@addWishList",Constants.mainURL)
        
        let innerParams : [String: String] = [
            "uuid": (appDelegate.userData as NSDictionary).value(forKey: "uuid") as! String,
//            "uuid": "fas_58b50efabe904",
            "class_id" : self.clsID
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
            if (dic.object(forKey: "res_id")) as! String == "1"
            {
                var dict : [String : AnyObject] = [String : AnyObject]()
                dict["class_id"] = self.clsID as AnyObject
                if dic.object(forKey: "res_msg") as! String == "Added to Wishlist"
                {
                    self.favBtn.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                    AFWrapperClass.showToast(title: "Added to Wishlist", view: self.view)
                    dict["isWishlist"] = 1 as AnyObject
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.UPDATE_WISHLIST_CLASS), object: dict)
                }
                else
                {
                    self.favBtn.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
                    AFWrapperClass.showToast(title: "Removed from Wishlist", view: self.view)
                    dict["isWishlist"] = 0 as AnyObject
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.UPDATE_WISHLIST_CLASS), object: dict)
                }
            }
            else
            {
                self.alert(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alert(text: error.localizedDescription)
        }
        }
        else
        {
            self.showalert("BrainGroom", message: "Please login to add in wishlist")
        }
    }
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
   

    @IBAction func providerBtnAct(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        vc.vendorID = self.vendorID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func bookNowBtn(_ sender: Any)
    {
        let bvc = self.storyboard?.instantiateViewController(withIdentifier:"BookingVC") as! BookingVC
        bvc.dataDict = self.dataDic
        bvc.price = price
        if isOnline == true
        {
            bvc.isOnline = true
        }
        self.navigationController!.pushViewController(bvc, animated:true)
    }
    @IBAction func giftClassBtn(_ sender: Any)
    {
        let bvc = self.storyboard?.instantiateViewController(withIdentifier:"BookingVC") as! BookingVC
        bvc.dataDict = self.dataDic
        self.navigationController!.pushViewController(bvc, animated:true)
    }
    @IBAction func locationBtnAct(_ sender: Any)
    {
        if let address = ((self.dataDic.value(forKey: "location") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "location_area") as? String
        {
            let alertConfirmation = UIAlertController(title: "", message: (address ), preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction (title: "DISMISS", style: UIAlertActionStyle.cancel, handler: nil)
            alertConfirmation.addAction(dismissAction)
            
            self.present(alertConfirmation, animated: true, completion: nil)
        }
    }
    @IBAction func privateTutorBtnAct(_ sender: Any)
    {
        privateTutorView.isHidden = false
    }
    @IBAction func contactUsBtn(_ sender: Any)
    {
        let actionSheetController = UIAlertController(title: nil, message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let actionButton = UIAlertAction(title: "044-49507392", style: .default) { action -> Void in
            if let url = URL(string: "tel://04449507392"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        actionSheetController.addAction(actionButton)
        
        let saveActionButton = UIAlertAction(title: "044-65556012", style: .default) { action -> Void in
            if let url = URL(string: "tel://04465556012"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "044-65556013", style: .default) { action -> Void in
            if let url = URL(string: "tel://04465556013"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    @IBAction func postQuery(_ sender: Any)
    {
        
    }
    @IBAction func videoBtnAct(_ sender: Any)
    {
        vidImage.isHidden = true
        vidBtn.isHidden = true
        print(extractYoutubeIdFromLink(link: myVideoURL)!)
    }
    
    @IBAction func privateTutorSubmitBtnAction(_ sender: Any)
    {
        if nameTF.text!.characters.count != 0 && mobileTF.text!.characters.count != 0 && emailTF.text!.characters.count != 0 && dateAndTimeTF.text!.characters.count != 0 && requestDetailsTextView.text!.characters.count != 0
        {
//            let strBody : String = String(format: "Name : %@\nMobile : %@\nEmail : %@\nDate & Time : %@\nRequest : %@", nameTF.text!,mobileTF.text!,emailTF.text!,dateAndTimeTF.text!,requestDetailsTextView.text!)
//            if !MFMailComposeViewController.canSendMail() {
//                print("Mail services are not available")
//                return
//            }
//            sendEmail(strBody)
            contactToAdmin()
        }
        else
        {
            self.alert(text: "Please, Fill all fields.")
        }
    }
    
    @IBAction func privateTutorCloseBtnAction(_ sender: Any)
    {
        privateTutorView.isHidden = true
    }
    
    
    func contactToAdmin()
    {
        let baseURL: String  = String(format:"%@contactAdmin",Constants.mainURL)
        let innerParams : [String: String] = [
            "name":nameTF.text!,
            "mobile":mobileTF.text!,
            "email":emailTF.text!,
            "message":requestDetailsTextView.text!,
            "datetime":dateAndTimeTF.text!
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
            if (dic.object(forKey: "res_code")) as! Int == 1
            {
                if((dic.object(forKey: "braingroom")) as! NSArray).count > 0
                {
                    self.privateTutorView.isHidden = true
                    self.nameTF.text = ""
                    self.mobileTF.text = ""
                    self.emailTF.text = ""
                    self.dateAndTimeTF.text = ""
                    self.requestDetailsTextView.text = ""
                    AFWrapperClass.showToast(title: "Email sent successfully.", view: self.view)
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
    
    func sendEmail(_ body : String) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["contactus@braingroom.com"])
        composeVC.setSubject("BrainGrrom")
        composeVC.setMessageBody(body, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
        
        switch (result) {
            case .saved:
                // Add code on save mail to draft.
                break;
            case .sent:
                // Add code on sent a mail.
                AFWrapperClass.showToast(title: "Email sent successfully.", view: self.view)
                break;
            case .cancelled:
                // Add code on cancel a mail.
                AFWrapperClass.showToast(title: "Email failed.", view: self.view)
                break;
            case .failed:
                // Add code on failed to send a mail.
                break;
        }
        
        privateTutorView.isHidden = true
        nameTF.text = ""
        mobileTF.text = ""
        emailTF.text = ""
        dateAndTimeTF.text = ""
        requestDetailsTextView.text = ""
        
    }
    
    func alert(text: String)
    {
        let alert = FCAlertView()
        alert.blurBackground = false
        alert.cornerRadius = 15
        alert.bounceAnimations = true
        alert.dismissOnOutsideTouch = false
        alert.delegate = self
        alert.makeAlertTypeWarning()
        alert.showAlert(withTitle: "Braingroom", withSubtitle: text , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
        alert.hideDoneButton = true;
        alert.addButton("OK", withActionBlock: {
        })
    }
    
    func alertSuccessView(text: String)
    {
        let alert = FCAlertView()
        alert.blurBackground = false
        alert.cornerRadius = 15
        alert.bounceAnimations = true
        alert.dismissOnOutsideTouch = false
        alert.delegate = self
        alert.makeAlertTypeSuccess()
        alert.showAlert(withTitle: "Braingroom", withSubtitle: text , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
        alert.hideDoneButton = true;
        alert.addButton("OK", withActionBlock: {
        })
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
