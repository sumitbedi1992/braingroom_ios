//
//  HomeVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 12/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import Cosmos

class FeatureCVCell: UICollectionViewCell
{
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var titleView: UIView!
}

class MenuTVCell: UITableViewCell
{
    @IBOutlet weak var menuTitleLbl: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
}

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var CV: UICollectionView!
    @IBOutlet weak var menuViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCloseBtn: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
    @IBAction func menuBtnAction(_ sender: Any)
    {
        self.menuViewWidthConstraint.constant = 240
        self.menuCloseBtn.isHidden = false
    }
    @IBAction func closeMenuBtnAction(_ sender: Any)
    {
        self.menuViewWidthConstraint.constant = 0
        self.menuCloseBtn.isHidden = true
    }
//MARK: ----------------- TV Delegates & Datasource ---------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVCell", for: indexPath as IndexPath) as! MenuTVCell
    
        if indexPath.item == 0
        {
            cell.menuTitleLbl.text = "Home"
            cell.arrowImage.isHidden = false
        }
        else if indexPath.item == 1
        {
            cell.menuTitleLbl.text = "Map View"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 2
        {
            cell.menuTitleLbl.text = "Booking History"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 3
        {
            cell.menuTitleLbl.text = "Catalogue"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 4
        {
            cell.menuTitleLbl.text = "Competitions"
            cell.arrowImage.isHidden = true
        }
        else if indexPath.item == 5
        {
            cell.menuTitleLbl.text = "Links"
            cell.arrowImage.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
//MARK: ----------------- CV Delegates & Datasource ---------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCVCell", for: indexPath as IndexPath) as! FeatureCVCell
        
        cell.backView.layer.cornerRadius = 10
        
        if indexPath.item == 0
        {
            cell.thumbImage.image = UIImage.init(named: "cookingclass172Ef0672")
        }
        else
        {
            cell.thumbImage.image = UIImage.init(named: "chocolate1Dca410A2")
            cell.titleView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: CV.bounds.size.width/2, height: CV.bounds.size.height);
    }


}
