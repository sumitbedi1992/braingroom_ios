//
//  HomePageViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 12/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func findClassesBtn(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CateloguesViewController") as! CateloguesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func commingSoonBtnAction(_ sender: Any)
    {
        AFWrapperClass.alert("Bridegroom", message: "Comming Soon...", view: self)
        
    }
    
    @IBAction func socialLearning(_ sender: Any)
    {
//        AFWrapperClass.alert("Bridegroom", message: "Comming Soon...", view: self)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BGNavController") as! BGNavController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func exploreBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
