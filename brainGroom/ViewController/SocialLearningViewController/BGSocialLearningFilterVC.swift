//
//  BGSocialLearningFilterVC.swift
//  brainGroom
//
//  Created by Vignesh Kumar on 12/11/17.
//  Copyright © 2017 CodeLiners. All rights reserved.
//

import UIKit

class BGSocialLearningFilterVC: UIViewController //,UITableViewDelegate,UITableViewDataSource
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
    
    @IBOutlet weak var lblCategorySelected: UILabel!
    @IBOutlet weak var lblGroupSelected: UILabel!
    @IBOutlet weak var lblCollegeSelected: UILabel!
    
    @IBOutlet weak var lblPostBySelected: UILabel!
    @IBOutlet weak var lblCountrySelected: UILabel!
    @IBOutlet weak var lblStateSelected: UILabel!
    @IBOutlet weak var lblCitySelected: UILabel!
    @IBOutlet weak var lblLocalitySelected: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Custom Methods
    
    @IBAction func btnCategoryAction(_ sender: Any) {
        loadSection = InputType.Ecategory.rawValue
    }
    
   
    @IBAction func btnGroupAction(_ sender: Any) {
        loadSection = InputType.EGroups.rawValue
    }
    

    @IBAction func btnCollegeAction(_ sender: Any) {
        loadSection = InputType.ECollege.rawValue
    }
    
    @IBAction func btnpostAction(_ sender: Any) {
        loadSection = InputType.EPostBy.rawValue
    }
    
    @IBAction func btnCountryAction(_ sender: Any) {
        loadSection = InputType.ECountry.rawValue
    }
    
    @IBAction func btnStateAction(_ sender: Any) {
        
        loadSection = InputType.EState.rawValue
    }
    
    @IBAction func btnCityAction(_ sender: Any) {
        
        loadSection = InputType.ECity.rawValue
    }
    
    @IBAction func btnLocalityAction(_ sender: Any) {
        loadSection = InputType.ELocality.rawValue
    }
    
    
    //MARK: UITableview Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch loadSection {
        case InputType.Ecategory.rawValue:
            return 5
            
        case InputType.EGroups.rawValue:
            return 3
            
        case InputType.ECollege.rawValue:
            return 2
        default:
            return 10
        }
        
    }
     /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTVCell") as! OptionTVCell
    
    if selectedOption == 1
    {
    cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
    if categoryIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
    cell.selectedRadioView.isHidden = false
    } else {
    cell.selectedRadioView.isHidden = true
    }
    }else if selectedOption == 2
    {
    cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
    if segmentIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
    cell.selectedRadioView.isHidden = false
    } else {
    cell.selectedRadioView.isHidden = true
    }
    }
    else if selectedOption == 3
    {
    cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "community_name") as? String
    if communitiesIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
    cell.selectedRadioView.isHidden = false
    } else {
    cell.selectedRadioView.isHidden = true
    }
    }else if selectedOption == 4
    {
    cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "class_type") as? String
    if classTypeIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
    cell.selectedRadioView.isHidden = false
    } else {
    cell.selectedRadioView.isHidden = true
    }
    }else if selectedOption == 5
    {
    cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "class_schedule") as? String
    if classScheduleIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
    cell.selectedRadioView.isHidden = false
    } else {
    cell.selectedRadioView.isHidden = true
    }
    }else if selectedOption == 6
    {
    cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
    if vendorListIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
    cell.selectedRadioView.isHidden = false
    } else {
    cell.selectedRadioView.isHidden = true
    }
    }
    
    return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectedOption == 1
        {
            categoryIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            categoryLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
            
        }else if selectedOption == 2
        {
            segmentIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            segmentsLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
        }
        else if selectedOption == 3
        {
            communitiesIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            communitiesLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "community_name") as? String
        }
        else if selectedOption == 4
        {
            classTypeIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            classTypeLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "class_type") as? String
        }
        else if selectedOption == 5
        {
            classScheduleIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            classScheduleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "class_schedule") as? String
        }
        else if selectedOption == 6
        {
            vendorListIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            vendorListLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String
        }
        
        self.TV.reloadData()
        
        print("categoryIdStr=\(categoryIdStr)\n,segmentIdStr=\(segmentIdStr)\n,communitiesIdStr=\(communitiesIdStr)\n,classTypeIdStr=\(classTypeIdStr)\n,classScheduleIdStr=\(classScheduleIdStr)\n,vendorListIdStr=\(vendorListIdStr)")
        
    }
 */
    

}
