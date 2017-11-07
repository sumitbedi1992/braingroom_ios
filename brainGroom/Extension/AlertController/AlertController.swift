//
//  AlertController.swift
//  CabSnapper
//
//  Created by Gaurav Parmar on 16/05/17.
//  Copyright © 2017 Gaurav Parmar. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showalert (_ title : String, message :String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showalert (_ title : String, message :String, action : [UIAlertAction]) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        for act in action {
                alert.addAction(act)
        }
         self.present(alert, animated: true, completion: nil)
    }

}
