//
//  CateloguesViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 05/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class itemCell1 : UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descripitionLbl: UILabel!
}


class CateloguesViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var itemsArray = NSMutableArray()
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
                
        itemsArray = ["Fun & Recreation","Informative & Motivational","Health & Fitness","Kids & Teens","Educational & Skill-development","Home Maintenance"];
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.reloadData()
        
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        self.present(vc, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath as IndexPath) as! itemCell1
        
        cell.descripitionLbl.text = itemsArray[indexPath.row] as? String
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            return CGSize(width: itemCollectionView.bounds.size.width/2-5, height: itemCollectionView.bounds.size.height/3-5);
    }

}
