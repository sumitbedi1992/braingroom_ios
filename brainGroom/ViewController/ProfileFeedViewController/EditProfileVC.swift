//
//  EditProfileVC.swift
//  brainGroom
//
//  Created by Keyur on 09/11/17.
//  Copyright © 2017 CodeLiners. All rights reserved.
//

import UIKit
import FCAlertView

class EditProfileVC: UIViewController, FCAlertViewDelegate, UITableViewDelegate, UITableViewDataSource {

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
    
    @IBOutlet var interestContainerView: UIView!
    @IBOutlet weak var interestTblView: UITableView!
    @IBOutlet weak var constraintHeightIntersetTblView: NSLayoutConstraint!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var gender  = String()
    var dob  = String()
    var datePicker : UIDatePicker!
    var interestArray = NSArray()
    var selectedInterestArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dobPicker.datePickerMode = UIDatePickerMode.date
        dobPicker.maximumDate = Date()
        dobPicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: UIControlEvents.valueChanged)
        
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(setDataValue), userInfo: nil, repeats: false)
        
        interestTblView.delegate = self
        interestTblView.dataSource = self
        interestTblView.register(UINib.init(nibName: "CustomSelectionCell", bundle: nil), forCellReuseIdentifier: "CustomSelectionCell")
        interestArray = NSArray()
        selectedInterestArray = NSMutableArray()
        serverCalledForInterest()
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
        if appDelegate.SignUpInterests == ""
        {
            interestLBL.text = "Select Item"
        }
        else
        {
            interestLBL.text = appDelegate.SignUpInterests as String
        }
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
        appDelegate.userData = appDelegate.getLoginUserData()
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
        else if appDelegate.userData.value(forKey:"gender") as? String == "2"
        {
            genderLBL.text = "Female"
            gender = "2"
        }
        else
        {
            genderLBL.text = "Select Gender"
            gender = "0"
        }
        
        appDelegate.signUpCountryID = appDelegate.userData.object(forKey: "country_id") as! NSString
        if appDelegate.getLoginUserCountry() != ""
        {
            countryLBL.text = appDelegate.getLoginUserCountry()
            appDelegate.signUpCountry = countryLBL.text! as NSString
        }
        else if appDelegate.signUpCountryID != ""
        {
            //find country
            getCountryList(countyId: appDelegate.signUpCountryID as String)
        }

        appDelegate.signUpStateID = appDelegate.userData.object(forKey: "state_id") as! NSString
        if appDelegate.getLoginUserState() != ""
        {
            stateLBL.text = appDelegate.getLoginUserState()
            appDelegate.signUpState = stateLBL.text! as NSString
        }
        else
        {
            //find state
            getStateList(countyId: appDelegate.signUpStateID as String)
        }
        
        appDelegate.signUpCityID = appDelegate.userData.object(forKey: "city_id") as! NSString
        if appDelegate.getLoginUserCity() != ""
        {
            cityLBL.text = appDelegate.getLoginUserCity()
            appDelegate.signUpCity = cityLBL.text! as NSString
        }
        else
        {
            //find country
        }
        
        locationLBL.text = appDelegate.userData.object(forKey:"locality") as? String
        passoutYearTF.text = appDelegate.userData.object(forKey: "institute_poy1") as? String
        
        appDelegate.signUpUGCollege = appDelegate.userData.object(forKey: "institute_name1") as! NSString
        appDelegate.signUpUGCollegeID = appDelegate.userData.object(forKey: "institute_poy1") as! NSString
        collegeNameLBL.text = appDelegate.signUpUGCollege as String
        
        
        appDelegate.SignUpInterests = appDelegate.userData.object(forKey: "category_name") as! NSString
        appDelegate.SignUpInterestsID = appDelegate.userData.object(forKey: "category_id") as! NSString
        interestLBL.text = appDelegate.SignUpInterests as String
        
        let tempArr : NSArray = appDelegate.signUpUGCollegeID.components(separatedBy: ",") as NSArray
        
        for i in 0..<tempArr.count
        {
            let intersetID : String = (tempArr[i] as? String)!
            for i in 0..<interestArray.count
            {
                let dict : NSDictionary = interestArray[i] as! NSDictionary
                if dict["id"] as! String == intersetID
                {
                    selectedInterestArray.add(dict)
                    break
                }
            }
        }
        
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
            interestTblView.reloadData()
            constraintHeightIntersetTblView.constant = interestTblView.contentSize.height + 80
            AFWrapperClass.displaySubViewtoParentView(self.view, subview: interestContainerView)
//            let vc = appDelegate.mainStoryboard().instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
//            vc.keyForApi = "interest"
//            self.navigationController?.pushViewController(vc, animated: true)
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
                alert.showAlert(in: appDelegate.window, withTitle: "Braingroom", withSubtitle: "Please select Country", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                alert.showAlert(in: appDelegate.window, withTitle: "Braingroom", withSubtitle: "Please select State", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
                alert.showAlert(in: appDelegate.window, withTitle: "Braingroom", withSubtitle: "Please select country", withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
            gender = "2"
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
            if gender == "1"
            {
                self.genderLBL.text = "Male"
            }
            else
            {
                self.genderLBL.text = "Female"
            }
            
        }
        else
        {
            self.genderLBL.text = "Select Item"
            
        }
        animateView.isHidden = true
        //        }
    }
    
    @IBAction func clickToDone(_ sender: Any)
    {
        var tempStr : String = ""
        for i in 0..<selectedInterestArray.count
        {
            let dict : NSDictionary = interestArray[i] as! NSDictionary
            if tempStr == ""
            {
                tempStr = (dict.value(forKey: "category_name") as? String)!
            }
            else
            {
                tempStr = tempStr + "," + (dict.value(forKey: "category_name") as? String)!
            }
        }
        
        if tempStr == ""
        {
            appDelegate.SignUpInterests = ""
            interestLBL.text = "Select Item"
        }
        else
        {
            appDelegate.SignUpInterests = tempStr as NSString
            interestLBL.text = appDelegate.SignUpInterests as String
        }
        
        interestContainerView.removeFromSuperview()
    }
    
    @IBAction func clickToSave(_ sender: Any)
    {
        self.view.endEditing(true)
        let tempArr : NSMutableArray = NSMutableArray()
        for i in 0..<selectedInterestArray.count
        {
            let dict : NSDictionary = interestArray[i] as! NSDictionary
            tempArr.add(dict["id"])
        }
        let interstIDs : String = tempArr.componentsJoined(by: ",")
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let baseURL: String  = String(format:"%@updateProfile",Constants.mainURL)
        
        let innerParams : [String: String] = [
            "address":locationLBL.text!,
            "area_of_expertise":appDelegate.userData.value(forKey:"area_of_expertise") as? String ?? "",
            "category_id":interstIDs,
            "city_id":appDelegate.signUpCityID as? String ?? "",
            "community_id":appDelegate.userData.value(forKey:"community_id") as? String ?? "",
            "country_id":appDelegate.signUpCountryID as? String ?? "",
            "description":appDelegate.userData.value(forKey:"description") as? String ?? "",
            "dob":dobTxt.text!,
            "email":emailTF.text!,
            "expertise_area":appDelegate.userData.value(forKey:"expertise_area") as? String ?? "",
            "first_name":fullNameTF.text!,
            "gender":gender,
            "institution_name":collegeNameLBL.text!,
            "locality_id":appDelegate.SignUpLocationID as? String ?? "",
            "mobile":mobileNumberTF.text!,
            "official_reg_id":appDelegate.userData.value(forKey:"official_reg_id") as? String ?? "",
            "primary_verification_media1":appDelegate.userData.value(forKey:"primary_verification_media1") as? String ?? "",
            "primary_verification_media2":appDelegate.userData.value(forKey:"primary_verification_media2") as? String ?? "",
            "profile_image":appDelegate.userData.value(forKey:"profile_image") as? String ?? "",
            "registration_id":appDelegate.userData.value(forKey:"registration_id") as? String ?? "",
            "secoundary_verification_media1":appDelegate.userData.value(forKey:"secoundary_verification_media1") as? String ?? "",
            "secoundary_verification_media2":appDelegate.userData.value(forKey:"secoundary_verification_media2") as? String ?? "",
            "secoundary_verification_media3":appDelegate.userData.value(forKey:"secoundary_verification_media3") as? String ?? "",
            "state_id":appDelegate.signUpStateID as? String ?? "",
            "institute_poy1":passoutYearTF.text!,
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
                self.appDelegate.signUpPassout = (self.passoutYearTF.text as? NSString)!
                self.appDelegate.setLoginUserCountry(value: self.appDelegate.signUpCountry as String)
                self.appDelegate.setLoginUserState(value: self.appDelegate.signUpState as String)
                self.appDelegate.setLoginUserCity(value: self.appDelegate.signUpCity as String)
                self.appDelegate.setLoginUserCategory(value: self.appDelegate.SignUpInterests as String)
                self.appDelegate.setLoginUserCollage(value: self.appDelegate.signUpUGCollege as String)
                
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
    
    func getCountryList(countyId : String)
    {
        var innerParams = [String: String]()
        innerParams = [:]
        
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        let baseURL: String  = String(format:"%@getCountry",Constants.mainURL)
        print(params)
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            
            let dic:NSDictionary = responseDict as NSDictionary
            
            if (dic.object(forKey: "braingroom") as! NSArray).count > 0
            {
                let resulrArray : NSArray = dic.object(forKey: "braingroom") as! NSArray
                for i in 0..<resulrArray.count
                {
                    let dict : NSDictionary = resulrArray[i] as! NSDictionary
                    if dict.value(forKey: "id") as! String == countyId
                    {
                        self.appDelegate.signUpCountryID = dict.value(forKey: "id") as! NSString
                        self.appDelegate.signUpCountry = dict.value(forKey: "name") as! NSString
                        self.appDelegate.setLoginUserCountry(value: self.appDelegate.signUpCountry as String)
                        self.countryLBL.text = self.appDelegate.getLoginUserCountry()
                        break
                    }
                }
            }
            else
            {
                print(dic.object(forKey: "res_msg"))
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getStateList(countyId : String)
    {
        var innerParams = [String: String]()
        innerParams = [:]
        
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        let baseURL: String  = String(format:"%@getState",Constants.mainURL)
        print(params)
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            
            let dic:NSDictionary = responseDict as NSDictionary
            
            if (dic.object(forKey: "braingroom") as! NSArray).count > 0
            {
                let resulrArray : NSArray = dic.object(forKey: "braingroom") as! NSArray
                for i in 0..<resulrArray.count
                {
                    let dict : NSDictionary = resulrArray[i] as! NSDictionary
                    if dict.value(forKey: "id") as! String == countyId
                    {
                        self.appDelegate.signUpStateID = dict.value(forKey: "id") as! NSString
                        self.appDelegate.signUpState = dict.value(forKey: "name") as! NSString
                        self.appDelegate.setLoginUserState(value: self.appDelegate.signUpState as String)
                        self.stateLBL.text = self.appDelegate.getLoginUserState()
                        break
                    }
                }
            }
            else
            {
                print(dic.object(forKey: "res_msg"))
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return interestArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : CustomSelectionCell = interestTblView.dequeueReusableCell(withIdentifier: "CustomSelectionCell") as! CustomSelectionCell
        let dict : NSDictionary = interestArray[indexPath.row] as! NSDictionary
        cell.titleLbl?.text = (dict.value(forKey: "category_name") as? String)!
        if selectedInterestArray.contains(dict) == true
        {
            cell.radioBtn.isSelected = true
        }
        else
        {
            cell.radioBtn.isSelected = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict : NSDictionary = interestArray[indexPath.row] as! NSDictionary
        if selectedInterestArray.contains(dict) == false
        {
            selectedInterestArray.add(dict)
        }
        else
        {
            selectedInterestArray.remove(dict)
        }
        
        interestTblView.reloadData()
    }
    func serverCalledForInterest()
    {
        let innerParams = [String: String]()
        
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        
        let baseURL: String  = String(format:"%@getCategory",Constants.mainURL)
        
        print(params)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "braingroom") as! NSArray).count > 0
            {
                self.interestArray = (dic.object(forKey: "braingroom") as! NSArray)
                self.interestTblView.reloadData()
            }
            else
            {
            
            }
            
        }) { (error) in
            
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
