//
//  ItemViewController.swift
//  brainGroom
//
//  Created by Satya Mahesh on 21/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit


class itemCell : UICollectionViewCell
{
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
 
    @IBOutlet weak var sessionsLbl: UILabel!
}

class subCell : UICollectionViewCell
{
    @IBOutlet weak var subLbl: UILabelX!
}

class ItemViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    var subArray = NSMutableArray()
    var itemsArray = NSMutableArray()
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        subArray = ["","","","",""]
        
        itemsArray = ["+Robotics","+Maths","+Physics","+Psycology","+Chemistry","+Economics"];
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.reloadData()
        
        subCollectionView.delegate = self
        subCollectionView.dataSource = self
        subCollectionView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == itemCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! itemCell
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCell", for: indexPath as IndexPath) as! subCell
            cell.subLbl.text = itemsArray[indexPath.row] as? String
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == itemCollectionView
        {
        return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: itemCollectionView.bounds.size.height/1.7);
        }
        else
        {
            return CGSize(width: subCollectionView.bounds.size.width/3-10, height: subCollectionView.bounds.size.height-20);
        }
    }
}
