//
//  FilterViewController.swift
//  brainGroom
//
//  Created by Satya Mahesh on 20/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit


class OptionTVCell: UITableViewCell
{
    
    @IBOutlet weak var selectedRadioView: UIViewX!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
    }
}
class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
   @IBOutlet weak var keyWordTF: ACFloatingTextfield!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!

    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var segmentsLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var localityLbl: UILabel!
    @IBOutlet weak var communitiesLbl: UILabel!
    @IBOutlet weak var classTypeLbl: UILabel!
    @IBOutlet weak var classScheduleLbl: UILabel!
    @IBOutlet weak var vendorListLbl: UILabel!
    
    @IBOutlet weak var TV: UITableView!
    
    @IBOutlet weak var optionsView: UIView!
    
    @IBOutlet weak var optionTitleLbl: UILabel!
    
    @IBOutlet weak var selectionTVView: UIViewX!
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePicker2: UIDatePicker!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var startTime = String()
    var endTime = String()
    var categoryIdStr = String()
    var segmentIdStr = String()
    var cityIdStr = String()
    var localityIdStr = String()
    var communitiesIdStr = String()
    var classTypeIdStr = String()
    var classScheduleIdStr = String()
    var vendorListIdStr = String()
    
    var dataArray = NSArray()
    var selectedOption = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        optionsView.isHidden = true
        cityLbl.text = "Chennai"
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        if appDelegate.SignUpLocation != ""
        {
            localityLbl.text = appDelegate.SignUpLocation as String
        }
    }
    
//MARK: ------------------------ Option Btn Actions ---------------------------
    func handleDatePicker(_ sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        startTimeLbl.text = dateFormatter.string(from: sender.date)
        startTime = dateFormatter.string(from: sender.date)
    }
    
    func handleDatePicker2(_ sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        endTimeLbl.text = dateFormatter.string(from: sender.date)
        endTime = dateFormatter.string(from: sender.date)
    }

    @IBAction func startTimeBtnAction(_ sender: UIButton)
    {
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
        
        optionsView.isHidden = false
        datePickerView.isHidden = false
        selectionTVView.isHidden = true
        datePicker2.isHidden = true
        datePicker.isHidden = false
    }
    
    @IBAction func endTimeBtnAction(_ sender: Any)
    {
        datePicker2.datePickerMode = UIDatePickerMode.date
        datePicker2.minimumDate = Date()
        datePicker2.addTarget(self, action: #selector(self.handleDatePicker2(_:)), for: UIControlEvents.valueChanged)
        
        optionsView.isHidden = false
        datePickerView.isHidden = false
        selectionTVView.isHidden = true
        datePicker.isHidden = true
        datePicker2.isHidden = false
    }
    
    @IBAction func categoryBTnAction(_ sender: Any)
    {
        displayOptionsTV()
        optionTitleLbl.text = "Category"
        optionsApiHitting(type: "getCategory")
        selectedOption = 1
    }
    @IBAction func segmentBtnAction(_ sender: Any)
    {
        displayOptionsTV()
        optionTitleLbl.text = "Segments"
        segmentApiHitting(id: categoryIdStr)
        selectedOption = 2
    }
    @IBAction func cityBtynAction(_ sender: Any)
    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
//        vc.keyForApi = "city"
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func localityBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
        vc.keyForApi = "location"
        vc.fromFilter = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func communitiesBtnAction(_ sender: Any)
    {
        displayOptionsTV()
        optionTitleLbl.text = "Communities"
        optionsApiHitting(type: "getCommunity")
        selectedOption = 3
    }
    @IBAction func classTypeBtnAction(_ sender: Any)
    {
        displayOptionsTV()
        optionTitleLbl.text = "Class Type"
        dataArray = [["id": "1","class_type": "Workshop"],["id": "2","class_type": "Seminar"],["id": "3","class_type": "Webinar"],["id": "4","class_type": "Classes"],["id": "5","class_type": "Activity"]]
        selectedOption = 4
        TV.reloadData()
        
    }
    @IBAction func classScheduleBtnAction(_ sender: Any)
    {
        displayOptionsTV()
        optionTitleLbl.text = "Class Schedule"
        dataArray = [["id": "1","class_schedule": "Fixed"],["id": "2","class_schedule": "Flexible"]]
        selectedOption = 5
        TV.reloadData()
    }
    @IBAction func vendorListBtnAction(_ sender: Any)
    {
        displayOptionsTV()
        optionTitleLbl.text = "Vendor List"
        optionsApiHitting(type: "getVendor")
        selectedOption = 6
    }
    
    func displayOptionsTV()
    {
        optionsView.isHidden = false
        selectionTVView.isHidden = false
        datePickerView.isHidden = true
    }
//MARK: ------------------------ TV Delegate & DataSource ---------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    

//MARK: ------------------------ API Hitting ------------------------------
    func optionsApiHitting(type: String)
    {
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,type)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: nil, success: { (responseDict) in
        
        AFWrapperClass.svprogressHudDismiss(view: self)
        let dic:NSDictionary = responseDict as NSDictionary
        if (dic.object(forKey: "res_code")) as! String == "1"
        {
            self.dataArray = dic["braingroom"] as! NSArray
            self.TV.reloadData()
        }
        else
        {
                
        }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
    }
    
    func segmentApiHitting(id: String)
    {
        let baseURL: String  = String(format:"%@getSegment",Constants.mainURL)
        
        let innerParams : [String: String] = [
            "category_id": "\(id)"
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.dataArray = dic["braingroom"] as! NSArray
                self.TV.reloadData()
            }
        }) { (error) in
        }
    }
//MARK: ------------------------ Back & close Btn Action -----------------------------
    
    @IBAction func optionsDoneBtnAction(_ sender: Any)
    {
        optionsView.isHidden = true
    }
    
    @IBAction func datePickerDoneBtnAction(_ sender: Any)
    {
        optionsView.isHidden = true
    }
    @IBAction func doneBtnAction(_ sender: Any)
    {
        let ivc = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        ivc.catID = categoryIdStr
        ivc.searchKey = keyWordTF.text!
        ivc.segmentId = segmentIdStr
        ivc.localityId = appDelegate.SignUpLocationID as String
        ivc.communityId = communitiesIdStr
        ivc.classTypeId = classTypeIdStr
        ivc.classScheduleId = classScheduleIdStr
        ivc.vendorId = vendorListIdStr
        ivc.startDate = startTime
        ivc.endDate = endTime
        
        if (categoryIdStr == "" && keyWordTF.text == "" && segmentIdStr == "" && (appDelegate.SignUpLocationID as String) == "" && communitiesIdStr == "" && classTypeIdStr == "" && classScheduleIdStr == "" && vendorListIdStr == "" && startTime == "" && endTime == "")
        {
            ivc.isFilterData = false
            ivc.catID = "1"
        }
        else
        {
            ivc.isFilterData = true
        }
        
        self.navigationController?.pushViewController(ivc, animated: true)
    }
    
    @IBAction func refreshBtnAction(_ sender: Any)
    {
        startTimeLbl.text = "Select Date"
        endTimeLbl.text = "Select Date"
        categoryLbl.text = "Select Category"
        segmentsLbl.text = "Select Segment"
        cityLbl.text = "Chennai"
        localityLbl.text = "Select Locality"
        communitiesLbl.text = "Select Communities"
        classTypeLbl.text = "Select Class Type"
        classScheduleLbl.text = "Select Class Schedule"
        vendorListLbl.text = "Select Vendor List"
        
        startTime = ""
        endTime = ""
        categoryIdStr = ""
        segmentIdStr = ""
        cityIdStr = ""
        localityIdStr = ""
        communitiesIdStr = ""
        classTypeIdStr = ""
        classScheduleIdStr = ""
        vendorListIdStr = ""
        
        keyWordTF.text = ""
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
