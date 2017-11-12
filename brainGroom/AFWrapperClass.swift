//
//  AFWrapper.swift
//  PizzaInSwift
//
//  Created by Kanwar Sierah on 19/09/16.
//  Copyright © 2016 carsake. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore
import SVProgressHUD
class AFWrapperClass: NSObject,UIViewControllerAnimatedTransitioning,CAAnimationDelegate
{
    var view = UIView()
    class func requestGETURL(_ strURL: String, params : [String : AnyObject]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void) {
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlwithPercentEscapes!, method: .get, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                //to get status code
                if response.result.isSuccess {
                    let resJson = response.result.value as! NSDictionary
                    success(resJson)
                }
                if response.result.isFailure {
                    let error : NSError = response.result.error! as NSError
                    failure(error)
                }
        }
    }
    
    class func requestPOSTURLVersionChange2(_ strURL : String, params : [String : AnyObject]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Accept":"application/json"])
            
            .responseJSON { response in
                print(response)
                //to get status code
                if response.result.isSuccess {
                    let resJson = response.result.value as! NSDictionary
                    success(resJson)
                }
                if response.result.isFailure {
                    let error : NSError = response.result.error! as NSError
                    failure(error)
                }
        }
        
    }
    
    class func requestPOSTURLVersionChange(_ strURL : String, params : [String : AnyObject]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Accept":"application/json","X-App-Type":"BGUSR01","X-App-Version":"1.2"])
            
            .responseJSON { response in
                print(response)
                //to get status code
                if response.result.isSuccess {
                    let resJson = response.result.value as! NSDictionary
                    success(resJson)
                }
                if response.result.isFailure {
                    let error : NSError = response.result.error! as NSError
                    failure(error)
                }
        }
        
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Accept":"application/json","X-App-Type":"BGUSR01"])
            
            .responseJSON { response in
                print(response)
                //to get status code
                if response.result.isSuccess {
                    let resJson = response.result.value as! NSDictionary
                    success(resJson)
                }
                if response.result.isFailure {
                    let error : NSError = response.result.error! as NSError
                    failure(error)
                }
        }
        
    }
    
    class func requestPOSTURLWithUrlsession(_ strURL : String, params : NSDictionary, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlwithPercentEscapes!)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("BGUSR01", forHTTPHeaderField: "X-App-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []);
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                //                print("error=\(error?.localizedDescription)")
                OperationQueue.main.addOperation()
                    {
                        failure(error! as NSError)
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //                print("response = \(response)")
                OperationQueue.main.addOperation()
                    {
                        failure(error! as NSError)
                }
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    OperationQueue.main.addOperation()
                        {
                            success(json as NSDictionary)
                    }
                }
            } catch let error {
                OperationQueue.main.addOperation()
                    {
                        failure(error as NSError)
                }
            }
        }
        task.resume()
    }
    class func requestPUTURL(_ strURL : String, params : [String : AnyObject]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlwithPercentEscapes!, method: .put, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                //to get status code
                if response.result.isSuccess {
                    let resJson = response.result.value as! NSDictionary
                    success(resJson)
                }
                if response.result.isFailure {
                    let error : NSError = response.result.error! as NSError
                    failure(error)
                }
        }
    }
    class func requestPostWithMultiFormData(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
        }, to: strURL, encodingCompletion: {result in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON
                    {
                        response in
                        //                        print(response.request )  // original URL request
                        //                        print(response.response) // URL response
                        //                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value
                        {
                            print("JSON: \(JSON)")
                        }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    class func alert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    class func activityView(_ IOS : String, ANDROID : String, frame : CGRect ,view:UIViewController)
    {
        let alert = UIAlertController(title: "Braingroom", message: "SHARE", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "IOS", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction) in
            let myWebsite = URL(string:IOS)
            let text = "I am Using 'Shopping Zone' For booking Home Appliances,Food items,Books and many more products. This application is awesome. Try it and enjoy continue shopping."
            let objectsToShare: [AnyObject] = [ text as AnyObject , myWebsite! as AnyObject]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: frame.origin.x+frame.size.width/2, y: frame.origin.y+frame.size.height/2, width: 0, height: 0);
            activityViewController.excludedActivityTypes = [ UIActivityType.postToWeibo,UIActivityType.print,UIActivityType.copyToPasteboard,UIActivityType.assignToContact,UIActivityType.saveToCameraRoll,UIActivityType.addToReadingList,UIActivityType.postToFlickr,UIActivityType.postToVimeo,                                                       UIActivityType.postToTencentWeibo,UIActivityType.airDrop ]
            
            view.present(activityViewController, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "ANDROID", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction) in
            
            let myWebsite = URL(string:ANDROID)
            let text = "I am Using 'Naples Pizza' Application this is awesome."
            let objectsToShare: [AnyObject] = [ text as AnyObject , myWebsite! as AnyObject]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: frame.origin.x+frame.size.width/2, y: frame.origin.y+frame.size.height/2, width: 0, height: 0);
            activityViewController.excludedActivityTypes = [ UIActivityType.postToWeibo,UIActivityType.print,UIActivityType.copyToPasteboard,UIActivityType.assignToContact,UIActivityType.saveToCameraRoll,UIActivityType.addToReadingList,UIActivityType.postToFlickr,UIActivityType.postToVimeo,                                                       UIActivityType.postToTencentWeibo,UIActivityType.airDrop ]
            
            view.present(activityViewController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction) in
        }))
        view.present(alert, animated: true, completion: nil)
        
    }
    
    class func colorWithHexString (_ hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    class func isValidEmail(_ testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func forwardView(view:UIView) -> Void {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            view.layoutSubviews()
        }) { (succeed) -> Void in
            
        }
    }
    class func reverseView(view:UIView) -> Void {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            view.transform = CGAffineTransform(rotationAngle: CGFloat(-180 * Double.pi))
            view.layoutSubviews()
        }) { (succeed) -> Void in
            
        }
    }
    class func autoLayoutUpdate(constrain:NSLayoutConstraint,constrainValue:CGFloat,view:UIView) -> Void
    {
        UIView.animate(withDuration: 0.5, animations: {
            constrain.constant = constrainValue
            view.layoutIfNeeded()
        })
    }
    
    class func dampingEffect(view:UIView) -> Void
    {
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .allowUserInteraction,
                       animations: { [weak view] in
                        view?.transform = .identity
            },
                       completion: nil)
    }
    
    class func shadowEffect(view:UIView) -> Void
    {
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowOpacity = 0.45
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shadowRadius = 1.0
    }
    class func presentViewControllerEffect(view:UIView) -> Void
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    class func popViewControllerEffect(view:UIView) -> Void
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        // Get the "from" and "to" views
        let fromView : UIView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView : UIView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        transitionContext.containerView.addSubview(fromView)
        transitionContext.containerView.addSubview(toView)
        
        //The "to" view with start "off screen" and slide left pushing the "from" view "off screen"
        toView.frame = CGRect(x:toView.frame.width, y:0, width:toView.frame.width, height:toView.frame.height)
        let fromNewFrame = CGRect(x:-1 * fromView.frame.width, y:0, width:fromView.frame.width, height:fromView.frame.height)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            toView.frame = CGRect(x:0, y:0, width:fromView.frame.width, height:fromView.frame.height)
            fromView.frame = fromNewFrame
        }) { (Bool) -> Void in
            // update internal view - must always be called
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.35
    }
    class func fadeIn(view:UIView) ->Void
    {
        view.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            view.alpha = 1.0
            view.isHidden = false
        }, completion: nil)
    }
    class func fadeOut(view:UIView) ->Void
    {
        view.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            view.alpha = 0
        }, completion: { finished in
            view.isHidden = true
        })
    }
    
    class func animateCell(cell: UITableViewCell)
    {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = 200
        cell.layer.cornerRadius = 0
        animation.toValue = 0
        animation.duration = 1
        cell.layer.add(animation, forKey: animation.keyPath)
    }
    
    class  func animateCellAtIndexPath(indexPath: NSIndexPath, tableViewView:UITableView)
    {
        guard  let cell = tableViewView.cellForRow(at: indexPath as IndexPath) else { return }
        animateCell(cell: cell)
    }
    
    class func runSpinAnimationOnView(view:UIView , duration:Float, rotations:Double, repeatt:Float ) ->()
    {
        let rotationAnimation=CABasicAnimation();
        rotationAnimation.keyPath="transform.rotation.z"
        let toValue = .pi * 2.0 * rotations ;
        let someInterval = CFTimeInterval(duration)
        
        rotationAnimation.toValue=toValue;
        rotationAnimation.duration=someInterval;
        rotationAnimation.isCumulative=true;
        rotationAnimation.repeatCount=repeatt;
        view.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    class func shadowEffectNormal(view:UIView) -> Void
    {
        view.layer.cornerRadius = 7
        // shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.7)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 1.2
    }
    class func svprogressHudShow(title:String,view:UIViewController) -> Void
    {
        SVProgressHUD.show(withStatus: title);
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        view.view.isUserInteractionEnabled = false;
    }
    class func svprogressHudDismiss(view:UIViewController) -> Void
    {
        SVProgressHUD.dismiss();
        view.view.isUserInteractionEnabled = true;
    }
    
    class func showToast(title:String,view:UIView) -> Void
    {
        view.makeToast(title)
    }
    
    class func displaySubViewtoParentView(_ parentview: UIView! , subview: UIView!)
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        parentview.addSubview(subview);
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        parentview.addConstraint(NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: parentview, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0))
        parentview.layoutIfNeeded()
        
    }
    
    class func viewSlideInFromRightToLeft(view:UIView) -> Void
    {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.layer.add(transition, forKey: kCATransition)
    }
    class func viewSlideInFromLeftToRight(view:UIView) -> Void
    {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: kCATransition)
    }
    class func viewSlideInFromTopToBottom(view:UIView) -> Void
    {
        let transition:CATransition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        view.layer.add(transition, forKey: kCATransition)
    }
    class func viewSlideInFromBottomToTop(view:UIView) -> Void
    {
        let transition:CATransition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        view.layer.add(transition, forKey: kCATransition)
    }
    
    
    
}
