//
//  BookmarksViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 06/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit


class itemCell3 : UICollectionViewCell
{
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var descripitionLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var sessionsLbl: UILabel!
}


class BookmarksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var itemsArray = NSMutableArray()
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.reloadData()
        
        // Do any additional setup after loading the view.
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath as IndexPath) as! itemCell3
        
        cell.layer.masksToBounds = false;
        cell.layer.shadowOpacity = 0.75;
        cell.layer.shadowRadius = 5.0;
        cell.layer.shadowOffset = CGSize.zero;
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowPath = UIBezierPath.init(rect: cell.bounds).cgPath
        
        cell.contentView.backgroundColor = UIColor.white
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: itemCollectionView.bounds.size.height/1.7)
    }
    
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
