//
//  TabBarVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 13/10/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController,UITabBarControllerDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        let arrayOfImageNameForUnselectedState:NSArray = ["Knowledge & nugget.png","Buy & Sell.png","activity Partners.png","Buy & Sell.png","activity Partners.png"]
        let arrayOfImageNameForSelectedState:NSArray = ["Knowledge & nugget selected.png","Buy & Sell selected.png","activity Partners selected.png","Buy & Sell selected.png","activity Partners selected.png"]
        
        if let count = self.tabBar.items?.count
        {
            for i in 0...(count-1)
            {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState as! String)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState as! String)?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        let selectedColor   = AFWrapperClass.colorWithHexString("00BEFF")
        let unselectedColor = UIColor.darkGray
        
        let normalTitleFont = UIFont.systemFont(ofSize: 7, weight: UIFontWeightRegular)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: normalTitleFont,NSForegroundColorAttributeName: unselectedColor], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: normalTitleFont,NSForegroundColorAttributeName: selectedColor], for: .selected)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
//        AFWrapperClass.svprogressHudDismiss(view: self)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let animatedTransitioningObject = AFWrapperClass()
        return animatedTransitioningObject
    }


    
}
