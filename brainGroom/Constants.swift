//
//  Constants.swift
//  brainGroom
//
//  Created by Satya Mahesh on 12/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let mainURL = "https://dev.braingroom.com/apis/"
    static let mainURLProd = "https://www.braingroom.com/apis/"
    static let GOOGLE_REVERSED_CLIENT_ID = "com.googleusercontent.apps.1036645765552-h3t4c43bc36el12f7ia996e80vgud37t"
    static let GOOGLE_CLIENT_ID = "1036645765552-h3t4c43bc36el12f7ia996e80vgud37t.apps.googleusercontent.com"
    static let HOCKEY_ID = "287fa86dfde34d3ea8a29f2a078c0402"
    static let GMS_PLACE_KEY = "AIzaSyALR0632alLB7CfRKlG6GEqz8HlVGhZTGA"
    static let GMS_SERVICE_KEY = "AIzaSyALR0632alLB7CfRKlG6GEqz8HlVGhZTGA"
}

func fromBooking() -> Bool
{
    if UserDefaults.standard.object(forKey: "fromBooking") != nil
    {
        let kFromBooking = UserDefaults.standard.object(forKey: "fromBooking") as! Bool
        return kFromBooking
    }
    else
    {
        return false
    }
}

func userId() -> String
{
    if UserDefaults.standard.object(forKey: "user_id") != nil
    {
        let kUserID = UserDefaults.standard.object(forKey: "user_id") as! String
        return kUserID
    }
    else
    {
        return ""
    }
}


@IBDesignable class GradientView: UIView
{
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass
    {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews()
    {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}

extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

struct API {
    
    static let mainURL = "https://dev.braingroom.com/apis/"
    static let mainURLProd = "https://www.braingroom.com/apis/"
    
    
    static var GET_PROFILE =  mainURL + "getProfile"
    static var VERIFY_PROMOCODE =  mainURL + "verifyPromoCode"
    
    static var GET_BOOKNOW_PAGE_DETAIL =  mainURL + "getBookNowPageDetails"
    static var RAZOR_PAY_SUCCESS =  mainURL + "razorPaySuccess"
    
    static var GET_COMMENT =  mainURL + "getComments"
    static var COMMENT_REPLY =  mainURL + "commentReply"
    
    
    
}


struct NOTIFICATION
{
    static var UPDATE_LOGIN_USER_PROFILE = "UPDATE_LOGIN_USER_PROFILE"
    static var UPDATE_FILTER_CLASS = "UPDATE_FILTER_CLASS"
    static var UPDATE_WISHLIST_CLASS = "UPDATE_WISHLIST_CLASS"
}

struct PREFERENCE
{
    static var IS_SOCIAL_LOGIN = "isSocialLogin"
    static var USER_DATA = "user_data"
    static var USER_COUNTRY = "user_country"
    static var USER_STATE = "user_state"
    static var USER_CITY = "user_city"
    static var USER_CATEGORY = "user_category"
    static var USER_COLLAGE = "user_collage"
}
