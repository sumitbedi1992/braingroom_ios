//
//  ReplyCommentsVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 14/10/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class ReplyTVCell: UITableViewCell
{
    @IBOutlet weak var userImage: UIImageViewX!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
}

class ReplyCommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate
{

    
    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var commentTF: UITextField!
    
    var dataArray = NSArray()
    var commentID = String()
    var postID = String()
    
    var responseArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        TV.reloadData()
    }
    
    func newCommentApiHitting()
    {
        let baseURL: String  = String(format:"%@commentReply",Constants.mainURL)
        let innerParams : [String: Any] = [
            "user_id": userId(),
            "post_id": postID,
            "comment_id": commentID,
            "text": commentTF.text!
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
            
            print("New Comment Response:---> \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                _=self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.alert(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alert(text: error.localizedDescription)
        }
    }

//MARK: ------------------------- TV Delegates & Datasource ---------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTVCell") as! ReplyTVCell
        
        cell.userNameLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_name") as? String
        cell.commentLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "reply") as? String
        cell.userImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image") as! String),placeholderImage: nil)
        
        return cell
    }
    
    

    @IBAction func sendBtnAction(_ sender: Any)
    {
        if commentTF.text?.characters.count != 0
        {
            newCommentApiHitting()
        }
    }
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    func alert(text: String)
    {
        let alert = FCAlertView()
        alert.blurBackground = false
        alert.cornerRadius = 15
        alert.bounceAnimations = true
        alert.dismissOnOutsideTouch = false
        alert.delegate = self
        alert.makeAlertTypeWarning()
        alert.showAlert(withTitle: "Braingroom", withSubtitle: text , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
        alert.hideDoneButton = true;
        alert.addButton("OK", withActionBlock: {
        })
    }
}
