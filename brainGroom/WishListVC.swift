//
//  WishListVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 20/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
class WishListCell: UITableViewCell
{
 
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petTrainLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var sessionLbl: UILabel!
}
class WishListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var wishListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishListTableView.delegate = self;
        self.wishListTableView.dataSource = self;
        // Do any additional setup after loading the view.
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


//MARK: ----------------- TV Delegates & Datasource ---------------------
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return 5
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
{
    let cell = tableView.dequeueReusableCell(withIdentifier: "WishListCell", for: indexPath as IndexPath) as! WishListCell
    

    
    return cell
}


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
{
    return 120
}
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
