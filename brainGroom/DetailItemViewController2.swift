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

class DetailItemViewController2: UIViewController, FCAlertViewDelegate, CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var catID = String()
    var myVideoURL = String()
    
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    
    @IBOutlet weak var vidBtn: UIButton!
    @IBOutlet weak var vidImage: UIImageView!
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
    @IBOutlet weak var mapView: GMSMapView!
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
                self.providerName.text = ((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "class_provided_by") as! String)
                self.providerImage.sd_setImage(with: URL(string: ((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "class_provider_pic") as! String)), placeholderImage: nil)
                self.vidImage.sd_setImage(with: URL(string: ((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "photo") as! String)), placeholderImage: nil)
                
                if(((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "video")) is NSNull)
                {
                    self.vidBtn.isHidden = true
                }
                else
                {
                    self.vidBtn.isHidden = false
                    self.myVideoURL = (((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "video") as! String
                }
                self.itemNameLbl.text = ((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "class_topic") as! String)
                
                self.priceLbl.text = (((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "vendorClasseLevelDetail") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "price") as? NSString as String?
                self.sessionLbl.text = String.init(format: "%@ Sessions, %@", ((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "no_of_session") as! String), ((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "class_duration") as! String))
                self.locationBtn.setTitle((((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "location") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "locality") as? String, for: .normal)
                let lat = (((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "location") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "latitude") as! NSString
                let long = (((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "location") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "longitude") as! NSString
                
               
                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: long.doubleValue)
                marker.title = (((((dic.object(forKey: "braingroom")) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "location") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "location_area") as? String
                marker.icon = UIImage(named: "pin")
                marker.map = self.mapView
                
                let camera = GMSCameraPosition.camera(withLatitude: lat.doubleValue, longitude: long.doubleValue, zoom: 6.0)
                self.mapView.camera = camera
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
   
    
    // Get Video ID from URL
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
//        videoView.load(withVideoId: videodID, playerVars: [
//            "controls" : 0,
//            "playsinline" : 1,
//            "autohide" : 1,
//            "showinfo" : 0,
//            "modestbranding" : 0])
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
    @IBAction func videoBtnAct(_ sender: Any)
    {
        vidImage.isHidden = true
        vidBtn.isHidden = true
        print(extractYoutubeIdFromLink(link: myVideoURL)!)
        videoPlayer.loadVideoID(extractYoutubeIdFromLink(link: myVideoURL)!)
//        videoPlayer.loadVideoURL(myVideoURL as URL)
//        videoPlayer.play()
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
