//
//  PostDetailsVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 14/10/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit

class PostDetailsVC: UIViewController,UIWebViewDelegate
{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInstitute: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var webview: UIWebView!
    var htmlstr = String()
    var data = [String:Any]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.lblName.text = data["vendor_name"] as? String
        self.lblCategory.text = data["segment_name"] as? String
        
        if let data1 = data["detail"] as? String {
            self.webview .loadHTMLString(data1, baseURL: nil)
        }
        self.lblInstitute.text = data["institute_name"] as? String
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.imgview.sd_setImage(with: URL.init(string: data["vendor_image"] as! String), placeholderImage: UIImage(named: "imm"))
        self.webview.delegate = self
        
        let timeStamp = data["date"] as? String
        self.lblDate.text = timeStampToDate(time: timeStamp!)
     
        self.lblTitle.text = "Post Detail"
    }
    
    func timeStampToDate(time: String) -> String
    {
        let date = NSDate(timeIntervalSince1970: Double(time)!)
        
        let dayTimePeriodFormatter =
            
            DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
    }
}
