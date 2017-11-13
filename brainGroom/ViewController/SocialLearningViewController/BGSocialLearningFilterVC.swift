//
//  BGSocialLearningFilterVC.swift
//  brainGroom
//
//  Created by Vignesh Kumar on 12/11/17.
//  Copyright © 2017 CodeLiners. All rights reserved.
//

import UIKit

class SocialFilterPopupCell: UITableViewCell
{
    
    @IBOutlet weak var selectedRadioView: UIViewX!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
    }
}
class BGSocialLearningFilterVC: UIViewController ,UITableViewDelegate,UITableViewDataSource
{

    
    enum InputType : String {
       case Ekeyword = "Keyword",
        Ecategory = "Category",
        EGroups = "Groups",
        ECollege = "College",
        EPostBy = "Post By",
        ECountry = "Country",
        EState = "State",
        ECity = "City",
        ELocality = "Locality"
        
    }
    var loadSection : String!
    
    var selectedCategory :String!
    var selectedGroups :String!
    var selectedCollege :String!
    var selectedPostBy :String!
    var selectedCountry :String!
    var selectedState :String!
    var selectedCity :String!
    var selectedLocality :String!
    
    var socialFiltercell  :SocialFilterPopupCell!
    
    @IBOutlet weak var lblCategorySelected: UILabel!
    @IBOutlet weak var lblGroupSelected: UILabel!
    @IBOutlet weak var lblCollegeSelected: UILabel!
    
    @IBOutlet weak var lblPostBySelected: UILabel!
    @IBOutlet weak var lblCountrySelected: UILabel!
    @IBOutlet weak var lblStateSelected: UILabel!
    @IBOutlet weak var lblCitySelected: UILabel!
    @IBOutlet weak var lblLocalitySelected: UILabel!
    
    @IBOutlet weak var txtKeywordSearch: ACFloatingTextfield!
    
    @IBOutlet weak var tblViewPopUp: UITableView!
    @IBOutlet weak var lblHeaderPopUp: UILabel!
    @IBOutlet weak var viewTableHolder: UIViewX!
    @IBOutlet weak var viewTransparent: UIView!
    var dataArray = NSArray()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          displayPopUp(true)
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
      
       
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Custom Methods
    
    func rightButtonAction(sender: UIBarButtonItem) {
        
        
        let filterParameters = ["author_id":"\(selectedPostBy)",   // Post By
            "categ_id":"\(selectedCategory)",  // Category
            "city_id":"\(selectedCity)",
            "country_id":"\(selectedCountry)",
            "group_id":"\(selectedGroups)",   // All group
            "institute_id":"\(selectedCollege)",// College Id
            "locality_id":"\(selectedLocality)",
            "major_categ":currenMajorForum,
            "minor_categ":currenMinorForum,
            "search_query":"",
            "seg_id":"",  //Segment id
            "state_id":"\(selectedState)",
            "user_id":appDelegate.userId as String,
]
        
       
      let  params = [
            "braingroom": filterParameters as AnyObject
        ]
    
        let type = "getConnectFeedsData"
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,type)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject], success: { (responseDict) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
//                self.dataArray = dic["braingroom"] as! NSArray
//                self.tblViewPopUp.reloadData()
//               pass array to parent class and nav
                
             self.navigationController?.popViewController(animated: true)
            }
            else
            {
                
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
    }
   
    
    @IBAction func btnDonePopUp(_ sender: Any) {
        displayPopUp(true)
    }
    
    
    @IBAction func btnCategoryAction(_ sender: Any) {
        loadSection = InputType.Ecategory.rawValue
        lblHeaderPopUp.text = "Category"
        fetchWebServiceCall(ofType: "getCategory", with: nil)
    }
    
    
    func displayPopUp(_ isHidden: Bool)  {
        viewTransparent.isHidden = isHidden
        viewTableHolder.isHidden = isHidden
    }
   
    @IBAction func btnGroupAction(_ sender: Any) {
        
        loadSection = InputType.EGroups.rawValue //getConnectData
        lblHeaderPopUp.text = "Groups"
        fetchWebServiceCall(ofType: "getConnectData",with: selectedCategory)
    }
    

    @IBAction func btnCollegeAction(_ sender: Any) {
        loadSection = InputType.ECollege.rawValue
        lblHeaderPopUp.text = "Colleges"
        fetchWebServiceCall(ofType: "getInstitions",with:  selectedGroups)
    }
    
    @IBAction func btnpostAction(_ sender: Any) {
        loadSection = InputType.EPostBy.rawValue
        lblHeaderPopUp.text = "Colleges"
        fetchWebServiceCall(ofType: "getUsers",with:  selectedCategory)
    }
    
    @IBAction func btnCountryAction(_ sender: Any) {
        loadSection = InputType.ECountry.rawValue
        lblHeaderPopUp.text = "Colleges"
        fetchWebServiceCall(ofType: "getCountry",with: selectedCategory)
    }
    
    @IBAction func btnStateAction(_ sender: Any) {
        
        loadSection = InputType.EState.rawValue
        lblHeaderPopUp.text = "States"
        fetchWebServiceCall(ofType: "getState",with: selectedCountry)
        
    }
    
    @IBAction func btnCityAction(_ sender: Any) {
        
        loadSection = InputType.ECity.rawValue
        lblHeaderPopUp.text = "City"
        fetchWebServiceCall(ofType: "getCity",with: selectedState)
    }
    
    @IBAction func btnLocalityAction(_ sender: Any) {
        loadSection = InputType.ELocality.rawValue
        lblHeaderPopUp.text = "Locality"
        fetchWebServiceCall(ofType: "getLocality",with: selectedCity)
        
    }
    
    
    //MARK: UITableview Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       socialFiltercell = tableView.dequeueReusableCell(withIdentifier: "SocialFilterPopupCell") as! SocialFilterPopupCell
    
        switch loadSection {
        case InputType.Ecategory.rawValue:
            socialFiltercell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
            if selectedCategory == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                socialFiltercell.selectedRadioView.isHidden = false
            } else {
                socialFiltercell.selectedRadioView.isHidden = true
            }
            
          break
            
        case InputType.EGroups.rawValue:
                socialFiltercell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "group_name") as? String
                if selectedGroups == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String  {
                    socialFiltercell.selectedRadioView.isHidden = false
                } else {
                    socialFiltercell.selectedRadioView.isHidden = true
            }
            
            break
            
        case InputType.ECollege.rawValue:
            
                socialFiltercell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "college_name") as? String
               if selectedCollege == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
                {
                    socialFiltercell.selectedRadioView.isHidden = false
                } else {
                    socialFiltercell.selectedRadioView.isHidden = true
            }
            break
            
        case InputType.EPostBy.rawValue:
            
            socialFiltercell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String
            if selectedPostBy == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                socialFiltercell.selectedRadioView.isHidden = false
            } else {
                socialFiltercell.selectedRadioView.isHidden = true
            }
            break
       
        case InputType.ECountry.rawValue:
            
            socialFiltercell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            if selectedCountry == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                socialFiltercell.selectedRadioView.isHidden = false
            } else {
                socialFiltercell.selectedRadioView.isHidden = true
            }
            break
        case InputType.EState.rawValue:
            
            socialFiltercell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            if selectedState == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                socialFiltercell.selectedRadioView.isHidden = false
            } else {
                socialFiltercell.selectedRadioView.isHidden = true
            }
            break
            
        case InputType.ECity.rawValue:
            
            socialFiltercell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            if selectedCity == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                socialFiltercell.selectedRadioView.isHidden = false
            } else {
                socialFiltercell.selectedRadioView.isHidden = true
            }
            break
        case InputType.ELocality.rawValue:
            
            socialFiltercell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            if selectedLocality == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                socialFiltercell.selectedRadioView.isHidden = false
            } else {
                socialFiltercell.selectedRadioView.isHidden = true
            }
            break
        default:
            break
        }
    
        return socialFiltercell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        switch loadSection {
        case InputType.Ecategory.rawValue:
            
            
            lblCategorySelected.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
            selectedCategory = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
  
            break
            
        case InputType.EGroups.rawValue:
            
            
            lblGroupSelected.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "group_name") as? String
             selectedGroups = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "segment_id") as? String
            break
        case InputType.ECollege.rawValue:
            
            
            lblCollegeSelected.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "college_name") as? String
             selectedCollege = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
           
            break
        case InputType.EPostBy.rawValue:
                
            lblPostBySelected.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "first_name") as? String
            selectedPostBy = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
                
            break
        case InputType.ECountry.rawValue:
                
            lblCountrySelected.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
             selectedCountry = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
            break
        case InputType.EState.rawValue:
            
            lblStateSelected.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            selectedState = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String

            break
        case InputType.ECity.rawValue:
            
            
            lblCitySelected.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
             selectedCity = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
           
            break
        case InputType.ELocality.rawValue:
            
            
            lblLocalitySelected.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
            selectedLocality = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
            
            break
            
        default:
            break
        }
        self.tblViewPopUp.reloadData()

//        print("categoryIdStr=\(categoryIdStr)\n,segmentIdStr=\(segmentIdStr)\n,communitiesIdStr=\(communitiesIdStr)\n,classTypeIdStr=\(classTypeIdStr)\n,classScheduleIdStr=\(classScheduleIdStr)\n,vendorListIdStr=\(vendorListIdStr)")

    }
    
    func formHeaderSection(_ id : String?) -> [String:Any] {
    
        if id == nil {
            return [:]
        }
    let  params : [String:Any]
        
    switch loadSection {
    
    case InputType.EGroups.rawValue:

        let innerParams : [String: String] = [
        "category_id": "\(id!)"
        ]
         params = [
        "braingroom": innerParams as AnyObject
        ]
        return params
        
        
    case InputType.ECollege.rawValue:
        
        let innerParams : [String: String] = [
            "search_key": "Ind"
        ]
        params = [
            "braingroom": innerParams as AnyObject
        ]
        return params
       
    case InputType.EPostBy.rawValue:
        
//        "search_user": "demo",
//        "user_type": 2,
//        "with_post": ""
        
        
        let innerParams : [String: Any] = [
            "search_user": "",
            "user_type" : 2,
            "with_post" : ""
            
        ]
        params = [
            "braingroom": innerParams as AnyObject
        ]
        return params
        
       
    case InputType.EState.rawValue:
        
        let innerParams : [String: String] = [
            "country_id": "\(id!)"
        ]
        params = [
            "braingroom": innerParams as AnyObject
        ]
        return params
        
    case InputType.ECity.rawValue:
        
        let innerParams : [String: String] = [
            "state_id": "\(id!)"
        ]
        params = [
            "braingroom": innerParams as AnyObject
        ]
        return params
      
    case InputType.ELocality.rawValue:
        
        let innerParams : [String: String] = [
            "city_id": "\(id!)"
        ]
         params = [
            "braingroom": innerParams as AnyObject
        ]
        return params
       
        
     default:
        break
    
    }
        return [:]
    }
    
    //MARK: Webservice call
    func fetchWebServiceCall(ofType type: String,with parameter:String?)  {
     
    
        let params = formHeaderSection(parameter)
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,type)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject], success: { (responseDict) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.dataArray = dic["braingroom"] as! NSArray
                self.tblViewPopUp.reloadData()
                self.displayPopUp(false)
            }
            else
            {
                
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
    }

}
