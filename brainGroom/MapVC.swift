//
//  MapVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 12/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import GoogleMaps
import FCAlertView


class CVCell : UICollectionViewCell
{
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateAndTimeLbl: UILabel!
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var descLbl: UILabel!
}

class MapVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate, FCAlertViewDelegate
{
    
    @IBOutlet weak var mapVW: GMSMapView!
    @IBOutlet weak var CV: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    
    lazy var mapView = GMSMapView()
    
    var locationManager = CLLocationManager()
    
    var latitude = Double()
    var longitude = Double()
    
    var dataArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
//        if CLLocationManager.locationServicesEnabled()
//        {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
//        }
        CV.isHidden = true
        latitude = 12.960184
        longitude = 80.242936
        
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2DMake(12.960184, 80.242936)
        //        marker.snippet = "Hello World"
        ////        marker.appearAnimation = .pop
        //        marker.icon = #imageLiteral(resourceName: "pinPlaceholder")
        //        marker.map = mapView
        
    }
    //MARK: ------------------------ Location Delegate ----------------------------
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
                let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//                latitude = locValue.latitude
//                longitude = locValue.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude:longitude, zoom: 12);
        self.mapVW.camera = camera
        self.mapVW.addSubview(gradientView)
        
        locationManager.stopUpdatingLocation()
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        self.dataFromServer()
    }
    //MARK: --------------------------- API Hitting --------------------------
    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@exploreDashboard",Constants.mainURL)
        let innerParams : [String: String] = [
            "lat": String(format:"%f",latitude),
            "lng" : String(format:"%f",longitude)
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
                self.dataArray = dic["braingroom"] as! NSArray
                if (self.dataArray.count > 0)
                {
                for i in 0..<self.dataArray.count
                {
                    let latStr = String(format:"%@",(self.dataArray.object(at: i) as! NSDictionary).object(forKey: "latitude") as! String)
                    let lonStr = String(format:"%@",(self.dataArray.object(at: i) as! NSDictionary).object(forKey: "longitude") as! String)
                    
                    let lat: Double = Double(latStr) ?? 0.0
                    let lon: Double = Double(lonStr) ?? 0.0
                    
                    let center = CLLocationCoordinate2D(latitude:lat, longitude:lon)
                   
                    let marker = GMSMarker()
                    marker.position = center
                    marker.snippet = (self.dataArray.object(at: i) as! NSDictionary).object(forKey: "class_topic") as? String
                    marker.appearAnimation = .pop
                    marker.icon = UIImage.init(named: "pin")
                    marker.icon = GMSMarker.markerImage(with: AFWrapperClass.colorWithHexString(((self.dataArray.object(at: i) as! NSDictionary).object(forKey: "color_code") as? String)!))
                    marker.map = self.mapVW
                    
                    
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
                    alert.showAlert(withTitle: "Braingroom", withSubtitle: "No results found in your location" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
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
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
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
    
    //MARK: ----------------------- CV Delegates & DataSource -----------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CVCell
        
        cell.backView.layer.cornerRadius = 10
        cell.backView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: CV.bounds.size.width/2, height: CV.bounds.size.height/1.1);
    }
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}


