//
//  CommentsVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 14/10/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView
class CommentsTVCell: UITableViewCell
{
    
    @IBOutlet weak var userImage: UIImageViewX!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
}

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate
{

    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var commentTF: UITextField!
    
    var postId = String()
    var dataArray = NSArray()
    let alert = FCAlertView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TV.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI))
        
        setAlertViewData(alert)
        alert.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        commentsApiHitting()
    }

    func commentsApiHitting()
    {
        let baseURL: String  = String(format:"%@getComments",Constants.mainURL)
        let innerParams : [String: Any] = [
            "user_id": userId(),
            "post_id": postId
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLVersionChange(baseURL, params: params, success: { (responseDict) in
            
            print("All Comments Response:---> \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                let array = dic["braingroom"] as! NSArray
                self.dataArray = array.reversed() as NSArray
                self.TV.reloadData()
            }
            else
            {
//            self.alert(text: dic.object(forKey: "res_msg") as! String)
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
//            self.alert(text: error.localizedDescription)
        }
    }
    
    func newCommentApiHitting()
    {
        let baseURL: String  = String(format:"%@commentReply",Constants.mainURL)
        let innerParams : [String: Any] = [
            "user_id": userId(),
            "post_id": postId,
            "comment_id": "",
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
                self.commentTF.text = ""
                self.commentsApiHitting()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTVCell") as! CommentsTVCell
        
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        
        cell.userNameLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_name") as? String
        cell.commentLbl.text = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "comment") as? String
        let timeStamp = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "date") as? String
        cell.dateLbl.text = timeStampToDate(time: timeStamp!)
        
        cell.userImage.sd_setImage(with: URL(string: (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "user_image") as! String),placeholderImage: nil)
        
        cell.replyBtn.tag = indexPath.row
        cell.replyBtn.addTarget(self, action: #selector(self.replyBtnAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func timeStampToDate(time: String)->String
    {
        let date = NSDate(timeIntervalSince1970: Double(time)!)
        
        let dayTimePeriodFormatter =
            
            DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    func replyBtnAction(_ sender: UIButton)
    {
       let rvc = self.storyboard?.instantiateViewController(withIdentifier: "ReplyCommentsVC") as! ReplyCommentsVC
        
        if !((self.dataArray.object(at: sender.tag) as! NSDictionary).object(forKey: "replies") is NSNull)
        {
            rvc.dataArray = (self.dataArray.object(at: sender.tag) as! NSDictionary).object(forKey: "replies") as! NSArray
        }
        else
        {
            rvc.dataArray = []
        }
        
        rvc.commentID = ((self.dataArray.object(at: sender.tag) as! NSDictionary).object(forKey: "id") as? String)!
        rvc.postID = postId
        
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    @IBAction func sendBtnAction(_ sender: Any)
    {
        if commentTF.text!.characters.count != 0
        {
            self.newCommentApiHitting()
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        _=self.navigationController?.popViewController(animated:true)
    }
    
    func alert(text: String)
    {
        self.alert.makeAlertTypeWarning()
        self.alert.showAlert(withTitle: "Braingroom", withSubtitle: text , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
        self.alert.hideDoneButton = true;
        self.alert.addButton("OK", withActionBlock: {
        })
    }
    
}
