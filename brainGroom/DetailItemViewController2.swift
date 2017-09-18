//
//  DetailItemViewController.swift
//  brainGroom
//
//  Created by Krishna Kanth on 18/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import MXSegmentedPager

class DetailItemViewController2: UIViewController {

    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.parallaxHeader.view = headerView
        mainScrollView.parallaxHeader.height = 150
        mainScrollView.parallaxHeader.mode = .fill
        mainScrollView.parallaxHeader.minimumHeight = 0
        mainScrollView.bounces = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
