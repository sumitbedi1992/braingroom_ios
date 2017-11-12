//
//  SearchVC.swift
//  brainGroom
//
//  Created by iOS_dev02 on 25/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class searchTVCell : UITableViewCell
{
    
    @IBOutlet weak var searchTextLbl: UILabel!
    @IBOutlet weak var defaultTextLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
}

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var TVHeightConstraint: NSLayoutConstraint!
    
    var defaultValues = [" in Fun & Recreation"," in Informative & Motivational"," in Health & Fitness"," in Kids & Teens"," in Education & Skill Development"," in Home Maintenance"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TVHeightConstraint.constant = 0
        
    }
    
    
//MARK : ------------------------------- TV Delegates & Datasource ------------------------------
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTVCell")  as!  searchTVCell

        cell.searchTextLbl.text = searchTF.text!
        if indexPath.row == 0
        {
            cell.defaultTextLbl.text = defaultValues[0]
        }else  if indexPath.row == 1
        {
            cell.defaultTextLbl.text = defaultValues[1]
        }
        else  if indexPath.row == 2
        {
            cell.defaultTextLbl.text = defaultValues[2]
        }else  if indexPath.row == 3
        {
            cell.defaultTextLbl.text = defaultValues[3]
        }else  if indexPath.row == 4
        {
            cell.defaultTextLbl.text = defaultValues[4]
        }else  if indexPath.row == 5
        {
            cell.defaultTextLbl.text = defaultValues[5]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityItemsVC") as! CommunityItemsVC
        vc.catID = String.init(format: "%d",  indexPath.row+1)
        vc.searchKey = searchTF.text!
        vc.isOnline = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
//MARK: --------------------------------- TF Action -----------------------------------
    @IBAction func searchTFAction(_ sender: Any)
    {
         if  searchTF.text?.characters.count == 0
         {
             TVHeightConstraint.constant = 0
        }
        else
         {
            TVHeightConstraint.constant = CGFloat(defaultValues.count * 40)
            TV.reloadData()
        }
    }
    
//MARK: --------------------------------- Button Action -----------------------------------
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated: true)
    }
    

}
