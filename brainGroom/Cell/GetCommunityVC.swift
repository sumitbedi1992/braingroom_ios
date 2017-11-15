
//
//  GetCommunityVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 23/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView
import SDWebImage

class communityCVCell: UICollectionViewCell
{
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        perform(#selector(self.round), with:nil, afterDelay:0.02)
    }
    
    func round()
    {
        self.thumbImage.layer.cornerRadius = self.thumbImage.frame.size.height/2
        self.thumbImage.layer.masksToBounds = true
    }
}

class GetCommunityVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FCAlertViewDelegate
{

    @IBOutlet weak var CV: UICollectionView!
    @IBOutlet weak var CVHeightConstraint: NSLayoutConstraint!
    
    var dataArray = NSArray()
    let alert = FCAlertView()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        setAlertViewData(alert)
        alert.delegate = self
        self.dataFromServer()
        

    }
    
//MARK: --------------------------- API Hitting --------------------------
    func dataFromServer()
    {
        let baseURL: String  = String(format:"%@getCommunity", Constants.mainURL)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: nil, success: { (responseDict) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.dataArray = dic["braingroom"] as! NSArray
                self.CV.reloadData()
                self.CVHeightConstraint.constant = self.CV.collectionViewLayout.collectionViewContentSize.height
                self.CV.layoutIfNeeded()
            }
            else
            {
                self.alert.makeAlertTypeWarning()
                self.alert.showAlert(withTitle: "Braingroom", withSubtitle: "" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                self.alert.hideDoneButton = true;
                self.alert.addButton("OK", withActionBlock: {
                })
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alert.makeAlertTypeWarning()
            self.alert.showAlert(withTitle: "Braingroom", withSubtitle: error.localizedDescription, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
            self.alert.hideDoneButton = true;
            self.alert.addButton("OK", withActionBlock: {
            })
        }
    }

// MARK: -------------------- UICollectionViewDataSource ----------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "communityCVCell", for: indexPath as IndexPath) as! communityCVCell
        let partPic = URL(string: ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"community_banner")) as! String)
        if partPic == nil
        {
            cell.thumbImage.image = UIImage.init(named: "")
        }
        else
        {
            cell.thumbImage?.sd_setImage(with: partPic, placeholderImage: UIImage.init(named: ""))
        }
        cell.titleLbl.text = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"community_name")) as? String
        return cell
    }
    
// MARK: -------------------- UICollectionViewDelegate ---------------------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        
        },
        completion: { finished in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,
            animations: {
                cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                        },
            completion: { finished in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityItemsVC") as! CommunityItemsVC
                vc.catID = ((self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"id")) as! String
                vc.searchKey = ""
                vc.isOnline = false
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.CV.frame.size.width/3-1, height: self.CV.frame.size.width/3-1);
    }

    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }
    
}
