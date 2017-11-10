//
//  EditProfileVC.swift
//  brainGroom
//
//  Created by Keyur on 09/11/17.
//  Copyright © 2017 CodeLiners. All rights reserved.
//

import UIKit
import FCAlertView

class EditProfileVC: UIViewController, FCAlertViewDelegate {

    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var passoutYearTF: UITextField!
    @IBOutlet weak var collegeNameLBL: UILabel!
    
    @IBOutlet weak var dobTxt: UITextField!
    @IBOutlet weak var genderLBL: UILabel!
    @IBOutlet weak var interestLBL: UILabel!
    @IBOutlet weak var countryLBL: UILabel!
    @IBOutlet weak var stateLBL: UILabel!
    @IBOutlet weak var cityLBL: UILabel!
    @IBOutlet weak var locationLBL: UILabel!
    
    @IBOutlet var genderView: UIView!
    @IBOutlet weak var femaleIMG: UIImageView!
    @IBOutlet var maleIMG: UIImageView!
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var viewPicker: UIView!
    
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var doneView: UIView!
    
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var gender  = String()
    var dob  = String()
    var datePicker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dobPicker.datePickerMode = UIDatePickerMode.date
        dobPicker.maximumDate = Date()
        dobPicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        if appDelegate.signUpCountry == ""
        {
            countryLBL.text = "Select Item"
        }
        else
        {
            countryLBL.text = appDelegate.signUpCountry as String
        }
        if appDelegate.signUpCity == ""
        {
            cityLBL.text = "Select Item"
        }
        else
        {
            cityLBL.text = appDelegate.signUpCity as String
        }
        if appDelegate.signUpState == ""
        {
            stateLBL.text = "Select Item"
        }
        else
        {
            stateLBL.text = appDelegate.signUpState as String
        }
        if appDelegate.SignUpLocation == ""
        {
            locationLBL.text = "Select Item"
        }
        else
        {
            locationLBL.text = appDelegate.SignUpLocation as String
        }
        if appDelegate.signUpUGCollege == ""
        {
            collegeNameLBL.text = "Select Item"
        }
        else
        {
            collegeNameLBL.text = appDelegate.signUpUGCollege as String
        }
        setDataValue()
    }
    
    func handleDatePicker(_ sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dobTxt.text = dateFormatter.string(from: sender.date)
        dob = dateFormatter.string(from: sender.date)
    }
    
    func setDataValue()
    {
        print(appDelegate.userData)
        fullNameTF.text = appDelegate.userData.value(forKey:"name") as? String
        emailTF.text = appDelegate.userData.value(forKey:"email") as? String
        mobileNumberTF.text = appDelegate.userData.value(forKey:"contact_no") as? String
        dobTxt.text = appDelegate.userData.value(forKey:"d_o_b") as? String
        if appDelegate.userData.value(forKey:"gender") as? String == "1"
        {
            genderLBL.text = "Male"
            gender = "1"
        }
        else if appDelegate.userData.value(forKey:"gender") as? String == "1"
        {
            genderLBL.text = "Female"
            gender = "0"
        }
        else
        {
            genderLBL.text = "Select Gender"
            gender = "1"
        }
        countryLBL.text = appDelegate.userData.object(forKey: "country_id") as? String
        stateLBL.text = appDelegate.userData.object(forKey:"state_id") as? String
        cityLBL.text = appDelegate.userData.object(forKey:"city") as? String
        locationLBL.text = appDelegate.userData.object(forKey:"locality") as? String
        
    }
    
    @IBAction func clickToBack(_ sender: Any)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func selectTypesBTNTap(_ sender: UIButton)
    {
        self.view.endEditing(true)
        switch sender.tag
        {
        case 1:
            genderView.isHidden = true
            
            AFWrapperClass.dampingEffect(view: animateView)
            doneView.isHidden = false
            dobPicker.isHidden = false
            viewPicker.isHidden = false
            animateView.isHidden = false
        case 2:
            doneView.isHidden = true
            dobPicker.isHidden = true
            viewPicker.isHidden = true
            AFWrapperClass.dampingEffect(view: animateView)
            genderView.isHidden = false
            animateView.isHidden = false
        case 3:
            break
        case 4:
            let vc = appDelegate.mainStoryboard().instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
            vc.keyForApi = "country"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            if appDelegate.signUpCountryID == ""
            {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please select Country", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            else
            {
                let vc = appDelegate.mainStoryboard().instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
                vc.keyForApi = "state"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 6:
            if appDelegate.signUpStateID == ""
            {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please select State", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            else
            {
                let vc = appDelegate.mainStoryboard().instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
                vc.keyForApi = "city"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 7:
            if appDelegate.signUpCityID == ""
            {
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.showAlert(withTitle: "Braingroom", withSubtitle: "Please select country", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            else
            {
                let vc = appDelegate.mainStoryboard().instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
                vc.keyForApi = "location"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 8:
            let vc = appDelegate.mainStoryboard().instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
            vc.keyForApi = "college"
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
    
    @IBAction func doneBTNTap(_ sender: Any)
    {
        animateView.isHidden = true
    }
    
    @IBAction func maleFemaleBTNTap(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            femaleIMG.image = UIImage.init(named: "radio-off")
            maleIMG.image = UIImage.init(named: "radio-on-button")
            gender = "1"
        }
        else
        {
            maleIMG.image = UIImage.init(named: "radio-off")
            femaleIMG.image = UIImage.init(named: "radio-on-button")
            gender = "0"
        }
        
    }
    
    @IBAction func genderOkCancelBTNTap(_ sender: UIButton)
    {
        //        if sender.tag == 0
        //        {
        //            self.genderLBL.text = gender
        //        }
        //        else
        //        {
        if gender.characters.count > 0
        {
            self.genderLBL.text = gender
        }
        else
        {
            self.genderLBL.text = "Select Item"
            
        }
        animateView.isHidden = true
        //        }
    }
    
    @IBAction func clickToSave(_ sender: Any)
    {
        self.view.endEditing(true)
        
        
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let baseURL: String  = String(format:"%@updateProfile",Constants.mainURL)
        
        let innerParams : [String: String] = [
            "address":locationLBL.text!,
            "area_of_expertise":appDelegate.userData.value(forKey:"area_of_expertise") as? String ?? "",
            "category_id":appDelegate.userData.value(forKey:"category_id") as? String ?? "",
            "city_id":appDelegate.signUpCityID as String,
            "community_id":appDelegate.userData.value(forKey:"community_id") as? String ?? "",
            "country_id":appDelegate.signUpCountryID as String,
            "description":appDelegate.userData.value(forKey:"description") as? String ?? "",
            "dob":dobTxt.text!,
            "email":emailTF.text!,
            "expertise_area":appDelegate.userData.value(forKey:"expertise_area") as? String ?? "",
            "first_name":fullNameTF.text!,
            "gender":gender,
            "institution_name":collegeNameLBL.text!,
            "locality_id":appDelegate.SignUpLocationID as String,
            "mobile":mobileNumberTF.text!,
            "official_reg_id":appDelegate.userData.value(forKey:"official_reg_id") as? String ?? "",
            "primary_verification_media1":appDelegate.userData.value(forKey:"primary_verification_media1") as? String ?? "",
            "primary_verification_media2":appDelegate.userData.value(forKey:"primary_verification_media2") as? String ?? "",
            "profile_image":appDelegate.userData.value(forKey:"profile_image") as? String ?? "",
            "registration_id":appDelegate.userData.value(forKey:"registration_id") as? String ?? "",
            "secoundary_verification_media1":appDelegate.userData.value(forKey:"secoundary_verification_media1") as? String ?? "",
            "secoundary_verification_media2":appDelegate.userData.value(forKey:"secoundary_verification_media2") as? String ?? "",
            "secoundary_verification_media3":appDelegate.userData.value(forKey:"secoundary_verification_media3") as? String ?? "",
            "state_id":appDelegate.signUpStateID as String,
            "institute_poy1":appDelegate.userData.value(forKey:"institute_poy1") as? String ?? "",
            "uuid":appDelegate.userData.value(forKey:"uuid") as? String ?? ""
        ]
        
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.appDelegate.getUserProfile()
                AFWrapperClass.showToast(title: "Profile update successfully", view: self.appDelegate.window!)
                self.navigationController?.popViewController(animated: true)
                
            }
            else
            {
                AFWrapperClass.showToast(title: "Failed to update", view: self.appDelegate.window!)
                self.navigationController?.popViewController(animated: true)
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
            alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
        }
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

}
