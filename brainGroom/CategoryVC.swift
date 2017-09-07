//
//  CategoryVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 20/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
class categoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
}
class CategoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var categoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categoryTableView.delegate = self;
        self.categoryTableView.dataSource = self;
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath as IndexPath) as! categoryCell
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
   
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
