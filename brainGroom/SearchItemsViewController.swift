//
//  SearchItemsViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 16/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class SearchItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,FCAlertViewDelegate
{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    var keyForApi = String()
    var resulrArray = NSArray()
    var filteredArray = NSArray()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var selectedItemsLbl: UILabel!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        selectedItemsLbl.text = "Selected Item"
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        self.serverHittingMethod(string: "")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if keyForApi == "college"
        {
            self.serverHittingMethod(string: searchText)
        }
        else
        {
            let searchPredicate = NSPredicate(format: "name contains[cd] %@", searchText)
            
            filteredArray = (self.resulrArray as NSArray).filtered(using: searchPredicate) as NSArray
            if searchText.characters.count == 0
            {
                filteredArray = resulrArray
            }
            resultTableView.reloadData()
        }
    }
    
    func serverHittingMethod(string : String)
    {
        var strr = String()
        var innerParams = [String: String]()

        
        if keyForApi == "college"
        {
            strr = "getInstitions"
            innerParams = [
                "search_key": string
            ]
        }
        else if keyForApi == "country"
        {
            strr = "getCountry"
            innerParams = [
                "search_key": string
            ]
        }
        else if keyForApi == "state"
        {
            strr = "getState"
            innerParams = [
                "country_id": appDelegate.signUpCountryID as String
            ]
        }
        else if keyForApi == "city"
        {
            strr = "getCity"
            innerParams = [
                "state_id": appDelegate.signUpStateID as String
            ]
        }
        else if keyForApi == "location"
        {
            strr = "getLocality"
            innerParams = [
                "city_id": appDelegate.signUpCityID as String
            ]
        }
        
//        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        
        
        
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,strr)

        print(params)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
//            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            
            if (dic.object(forKey: "braingroom") as! NSArray).count > 0
            {
                self.resulrArray = (dic.object(forKey: "braingroom") as! NSArray)
                self.filteredArray = (dic.object(forKey: "braingroom") as! NSArray)
                self.resultTableView.delegate = self
                self.resultTableView.dataSource = self
                self.resultTableView.reloadData()
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
                alert.showAlert(withTitle: "Braingroom", withSubtitle: dic.object(forKey: "res_msg") as! String , withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
            }
            
        }) { (error) in
//            AFWrapperClass.svprogressHudDismiss(view: self)
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
    
    
    
    @IBAction func saveBtn(_ sender: Any)
    {
        if keyForApi == "college"
        {
            if appDelegate.signUpUGCollege == ""
            {
                
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if keyForApi == "country"
        {
            if appDelegate.signUpCountry == ""
            {
                
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if keyForApi == "state"
        {
            if appDelegate.signUpState == ""
            {
                
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if keyForApi == "city"
        {
            if appDelegate.signUpCity == ""
            {
                
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if keyForApi == "location"
        {
            if appDelegate.SignUpLocation == ""
            {
                
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
    
    }
    @IBAction func clearBtn(_ sender: Any)
    {
        selectedItemsLbl.text = "Selected Item"
        
        if keyForApi == "college"
        {
            appDelegate.signUpUGCollege = ""
            appDelegate.signUpUGCollegeID = ""
        }
        else if keyForApi == "country"
        {
            appDelegate.signUpCountry = ""
            appDelegate.signUpCountryID = ""
        }
        else if keyForApi == "state"
        {
            appDelegate.signUpState = ""
            appDelegate.signUpStateID = ""
        }
        else if keyForApi == "city"
        {
            appDelegate.signUpCity = ""
            appDelegate.signUpCityID = ""
        }
        else if keyForApi == "location"
        {
            appDelegate.SignUpLocation = ""
            appDelegate.SignUpLocationID = ""
        }
        
    }

    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if keyForApi == "college"
        {
            return resulrArray.count
        }
        else
        {
            return filteredArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = self.resultTableView.dequeueReusableCell(withIdentifier: "Cell")!

        var name = String()
        
        if keyForApi == "college"
        {
            name = ((resulrArray[indexPath.row] as! NSDictionary).value(forKey: "college_name") as? String)!
        }
        else
        {
            name = ((filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as? String)!
        }
        
        cell.textLabel?.text = name
        
     return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if keyForApi == "college"
        {
            selectedItemsLbl.text = (resulrArray[indexPath.row] as! NSDictionary).value(forKey: "college_name") as? String
            self.view.endEditing(true)
            appDelegate.signUpUGCollegeID = (resulrArray[indexPath.row] as! NSDictionary).value(forKey: "id") as! NSString
            appDelegate.signUpUGCollege = (resulrArray[indexPath.row] as! NSDictionary).value(forKey: "college_name") as! NSString
        }
        else if keyForApi == "country"
        {
            selectedItemsLbl.text = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as? String
            self.view.endEditing(true)
            appDelegate.signUpCountryID = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "id") as! NSString
            appDelegate.signUpCountry = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as! NSString
        }
        else if keyForApi == "state"
        {
            selectedItemsLbl.text = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as? String
            self.view.endEditing(true)
            appDelegate.signUpStateID = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "id") as! NSString
            appDelegate.signUpState = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as! NSString
        }
        else if keyForApi == "city"
        {
            selectedItemsLbl.text = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as? String
            self.view.endEditing(true)
            appDelegate.signUpCityID = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "id") as! NSString
            appDelegate.signUpCity = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as! NSString
        }
        else if keyForApi == "location"
        {
            selectedItemsLbl.text = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as? String
            self.view.endEditing(true)
            appDelegate.SignUpLocationID = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "id") as! NSString
            appDelegate.SignUpLocation = (filteredArray[indexPath.row] as! NSDictionary).value(forKey: "name") as! NSString
        }
        
    }
}
