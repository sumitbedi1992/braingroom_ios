//
//  FacebookHelper.swift
//  Relish
//
//  Created by Hardik on 28/08/17.
//  Copyright © 2017 Gaurav Parmar. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit


class FacebookHelper: NSObject {
    
    static let shared = FacebookHelper()
    let loginManager = LoginManager()
    
    func logoutFBUser() {
        loginManager .logOut()
    }
    
    func getuserInfo(successblock: @escaping ([String:AnyObject])->Void) {
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,name,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(String(describing: error))")
            } else {
                
                let data:[String:AnyObject] = result as! [String : AnyObject]
                successblock(data)
            }
        })
    }
    
    func loginWithFacebook(fromViewController:UIViewController,successblock: @escaping ([String:AnyObject])->Void ,failblock:@escaping (_ error: Error)->()){
    
        loginManager.logIn([.publicProfile,.email], viewController: fromViewController) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
                failblock(error)
                break
                
            case .cancelled:
                print("User cancelled login.")
                break
                
            case .success:
                self.getuserInfo(successblock: { (data) in
//                data["username"]
                    successblock(data)
                })
                break
                
            }
        }
        
    }
}
