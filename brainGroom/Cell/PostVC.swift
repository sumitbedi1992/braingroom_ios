//
//  PostVC.swift
//  brainGroom
//
//  Created by iOS_dev02 on 11/10/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import Alamofire
import FCAlertView

class PostOptionsTVCell: UITableViewCell
{
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var selectedRadioView: UIViewX!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
}

class PostVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,FCAlertViewDelegate
{
    
    @IBOutlet weak var viewTo: UIView!
    @IBOutlet weak var viewFrom: UIView!
    @IBOutlet weak var const_save_top: NSLayoutConstraint!
    
    @IBOutlet weak var fromdateLable : UILabel!
    @IBOutlet weak var TodateLable : UILabel!
    
    @IBOutlet weak var privacyLabel: UILabel!
    var isOndateTap = Bool()
    var isRecdateTap = Bool()
    
    @IBOutlet weak var radioImgFrom: UIImageView!
    @IBOutlet weak var radioimgTo: UIImageView!
    
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var txtReqNote: ACFloatingTextfield!
    @IBOutlet weak var txtProposedTime: ACFloatingTextfield!
    @IBOutlet weak var txtProposedLocation: ACFloatingTextfield!
    
//    @IBOutlet weak var viewFrom: UIView!
//    @IBOutlet weak var viewTo: UIView!
    
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var optionLbl: UILabel!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var topicTF: ACFloatingTextfield!
    @IBOutlet weak var youtubeTF: ACFloatingTextfield!
    @IBOutlet weak var classPageUrlTF: ACFloatingTextfield!
    var isFromActivityAndPartner = Bool()
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var activityLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var segmentLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var localityLbl: UILabel!
    
    @IBOutlet weak var uploadVideoImageView: UIImageView!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var postIdStr = String()
    var groupIdStr = String()
    var categoryIdStr = String()
    var segmentIdStr = String()
    var privacyID = String()
    var cityIdStr = String()
    var localityIdStr = String()
    var countryIdStr = String()
    var stateIdStr = String()
    var activityIdStr = String()
    
    var uploadImageUrl = String()
    var uploadVideoUrl = String()

    var dataArray = NSArray()
    var selectedOption = Int()
    
    var mediaType = String()
    var mediaData = Data()
    
    var postLblStr = String()
    var postStr = String()
    
    let picker = UIImagePickerController()

    @IBAction func btnDateToTap(_ sender: Any) {
        print("dateto")
        self.isRecdateTap = true
        datePickerTapped()
    }
    
    @IBAction func btnPrivacyTap(_ sender: Any) {
        
        optionsView.isHidden = false
        optionLbl.text = "Privacy"
        dataArray = [["id": "1","post_type": "Group"],["id": "2","post_type": "All"]]
        TV.reloadData()
        selectedOption = 6
        
    }
    
    @IBAction func btnRecurringTap(_ sender: Any) {
        print("requring")
        self.viewTo.isHidden = false

        isRecdateTap = true
        isOndateTap = false

        self.fromdateLable.text = "Choose"
        self.TodateLable.text = "Choose"
        
        self.lblTo.text = "To"
        self.lblFrom.text = "From"
        
        if radioImgFrom.image == UIImage(named:"radio-off") {
            radioImgFrom.image = UIImage(named:"radio-on-button")
            radioimgTo.image = UIImage(named:"radio-off")
        } else {
            radioImgFrom.image = UIImage(named:"radio-off")
        }
    }
    
    @IBAction func btnFromTap(_ sender: Any) {
        print("from tap")
        isOndateTap = true
        isRecdateTap = false
        datePickerTapped()
    }
    
    @IBAction func btnOnDateTap(_ sender: Any) {
        print("ontap")
        self.viewTo.isHidden = true
        self.fromdateLable.text = "Choose"
        self.lblFrom.text = "On"
        
        if radioimgTo.image == UIImage(named:"radio-off") {
            radioimgTo.image = UIImage(named:"radio-on-button")
            radioImgFrom.image = UIImage(named:"radio-off")
        } else {
            radioimgTo.image = UIImage(named:"radio-off")
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        picker.delegate = self
        
        self.descriptionTextView.placeholderText = "Description"
        descriptionTextView.layer.cornerRadius = 5.0
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        radioimgTo.image = UIImage(named:"radio-on-button")
        
        self.viewTo.isHidden = true
        
        viewFrom.layer.cornerRadius = 5.0
        viewFrom.layer.borderColor = UIColor.darkGray.cgColor
        viewFrom.layer.borderWidth = 1.0
        
        
        viewTo.layer.cornerRadius = 5.0
        viewTo.layer.borderColor = UIColor.darkGray.cgColor
        viewTo.layer.borderWidth = 1.0
        
        
        self.view .bringSubview(toFront: optionsView)
        if isFromActivityAndPartner {
            self.viewDate.isHidden = false
        } else {
            self.viewDate.isHidden = true
        }
        if appDelegate.SignUpLocation != ""
        {
            localityLbl.text = appDelegate.SignUpLocation as String
        }
        if appDelegate.signUpCity != ""
        {
            cityLbl.text = appDelegate.signUpCity as String
        }
        if appDelegate.signUpCountry != ""
        {
            countryLbl.text = appDelegate.signUpCountry as String
        }
        if appDelegate.signUpState != ""
        {
            stateLbl.text = appDelegate.signUpState as String
        }
    }
    
    
//MARK: ------------------------ TV Delegates & DataSource ---------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostOptionsTVCell") as! PostOptionsTVCell
        
        if selectedOption == 1
        {
            cell.titleLbl.text! = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as? String)!
            if postIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String
            {
                cell.selectedRadioView.isHidden = false
            } else {
                cell.selectedRadioView.isHidden = true
            }
        }else if selectedOption == 2
        {
            cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "group_name") as? String
            if groupIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "segment_id") as? String {
                cell.selectedRadioView.isHidden = false
            } else {
                cell.selectedRadioView.isHidden = true
            }
        }
        else if selectedOption == 3
        {
            cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "activity_name") as? String
            if activityIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                cell.selectedRadioView.isHidden = false
            } else {
                cell.selectedRadioView.isHidden = true
            }
        }else if selectedOption == 4
        {
            cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
            if categoryIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                cell.selectedRadioView.isHidden = false
            } else {
                cell.selectedRadioView.isHidden = true
            }
        }else if selectedOption == 5
        {
            cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
            if segmentIdStr == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                cell.selectedRadioView.isHidden = false
            } else {
                cell.selectedRadioView.isHidden = true
            }
        }
        else if selectedOption == 6
        {
            cell.titleLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as? String
            if privacyID == (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String {
                cell.selectedRadioView.isHidden = false
            } else {
                cell.selectedRadioView.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectedOption == 1
        {
            postIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            postLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as? String
            postLblStr = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as! String
        }else if selectedOption == 2
        {
            groupIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "segment_id") as? String)!
            groupLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "group_name") as? String
        }
        else if selectedOption == 3
        {
            activityIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            activityLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "activity_name") as? String
        }
        else if selectedOption == 4
        {
            categoryIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            categoryLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
        }
        else if selectedOption == 5
        {
            segmentIdStr = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            segmentLbl.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "category_name") as? String
        }
        else if selectedOption == 6
        {
            privacyID = ((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!
            privacyLabel.text = (dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "post_type") as? String
        }
        
        self.TV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }

//MARK: -------------------------- Button Actions ------------------------------
    
    @IBAction func postTypeBtnAction(_ sender: Any)
    {
        optionsView.isHidden = false
        optionLbl.text = "Post"
        dataArray = [["id": "1","post_type": "Knowledge nuggets"],["id": "2","post_type": "Buy & sell"],["id": "3","post_type": "Find learning partners"],["id": "4","post_type": "Discuss and Decide"]]
        TV.reloadData()
        selectedOption = 1

    }
    @IBAction func groupTypeBtnAction(_ sender: Any)
    {
        
        optionLbl.text = "Group"
        if categoryIdStr == "" {
            AFWrapperClass.alert("Alert!", message: "Select category to get group list.", view: self)
        } else {
            optionsView.isHidden = false
            groupApiHitting(id: categoryIdStr)
        }
        
        dataArray = []
        TV.reloadData()
        selectedOption = 2

    }
    @IBAction func activityBTnAction(_ sender: Any)
    {
        optionsView.isHidden = false
        optionLbl.text = "Activity"
        activitiesApiHitting()
        dataArray = []
        TV.reloadData()
        selectedOption = 3

    }
    @IBAction func categoryBtnAction(_ sender: Any)
    {
        optionsView.isHidden = false
        optionLbl.text = "Category"
        optionsApiHitting(type: "getCategory")
        selectedOption = 4

    }
    @IBAction func segmentBtnAction(_ sender: Any)
    {
        optionsView.isHidden = false
        optionLbl.text = "Category"
        segmentApiHitting(id: categoryIdStr)
        selectedOption = 5
    }
    @IBAction func countryBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
        vc.keyForApi = "country"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func stateBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
        vc.keyForApi = "state"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func cityBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
        vc.keyForApi = "city"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func localityBtnAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItemsViewController") as! SearchItemsViewController
        vc.keyForApi = "location"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func imageUploadingBtnAction(_ sender: Any)
    {
        mediaActionSheet()
    }
    @IBAction func videoUploadingBtnAction(_ sender: Any)
    {
        openVideos()
    }
    
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        
        var dateComponents1 = DateComponents()
        dateComponents1.month = 36
        let after = Calendar.current.date(byAdding: dateComponents1, to: currentDate)
        
        
        
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        datePicker.show("DatePickerDialog",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: threeMonthAgo,
                        maximumDate: after,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                let str = formatter .string(from: date!)
                                
                                if self.isOndateTap {
                                    self.fromdateLable.text = str
                                }
                                if self.isRecdateTap {
                                    self.TodateLable.text = str
                                }
                                
                            }
        }
    }
    
//MARK: ------------------------ API Hitting ------------------------------
    func optionsApiHitting(type: String)
    {
        let baseURL: String  = String(format:"%@%@",Constants.mainURL,type)
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: nil, success: { (responseDict) in
            
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.optionsView.isHidden = false
                self.dataArray = dic["braingroom"] as! NSArray
                self.TV.reloadData()
            }
            else
            {}
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
        }
    }
    
    func segmentApiHitting(id: String)
    {
        let baseURL: String  = String(format:"%@getSegment",Constants.mainURL)
        
        let innerParams : [String: String] = [
            "category_id": "\(id)"
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.dataArray = dic["braingroom"] as! NSArray
                self.TV.reloadData()
            }
        }) { (error) in
        }
    }
    
    func groupApiHitting(id: String)
    {
        if categoryIdStr != ""
        {
        let baseURL: String  = String(format:"%@getConnectData",Constants.mainURL)
        
        let innerParams : [String: String] = [
            "category_id": "\(id)"
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.dataArray = dic["braingroom"] as! NSArray
                self.TV.reloadData()
            }
        }) { (error) in
        }
        }
        else
        {
            AFWrapperClass.alert("Alert!", message: "Select category to get group list.", view: self)
        }
    }
    
    func activitiesApiHitting()
    {
        let baseURL: String  = String(format:"%@getGroupActivities",Constants.mainURL)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: nil, success: { (responseDict) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "res_code")) as! String == "1"
            {
                self.dataArray = dic["braingroom"] as! NSArray
                self.TV.reloadData()
            }
        }) { (error) in
        }
    }
    
    
    
    func uploadImageMedia(postType:String, data:Data)
    {
        AFWrapperClass.svprogressHudShow(title: "Uploading image... please,wait untill it is done...", view: self)
        let parameters = [
            "post_type": postType,
            ] as [String : String]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
        
        multipartFormData.append(data, withName: "image", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")

        for (key, value) in parameters {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        }, to:"https://dev.braingroom.com/apis/uploadPostImage")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    let progressStatus = Float(progress.fractionCompleted)
                    print(progressStatus)
                    DispatchQueue.main
                    do
                    {
                    }
                })
                upload.responseJSON { response in
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let dic = response.result.value as? NSDictionary
                    if dic?.object(forKey: "res_code") as? String == "1"
                    {
                        self.uploadImageUrl = ((dic?.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "url") as! String
                        print("Image URL--->\(self.uploadImageUrl)")
                    }
                    else
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert("Alert!", message: "Image not uploaded. Please, try again.", view: self)
                    }
                }
            case .failure(let _):
                AFWrapperClass.svprogressHudDismiss(view: self)
                break
            }
        }
    }
    
    func uploadVideoMedia(postType:String, data:Data)
    {
        AFWrapperClass.svprogressHudShow(title: "Uploading video... please,wait untill it is done...", view: self)
        let parameters = [
            "post_type": postType,
            ] as [String : String]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
        multipartFormData.append(data, withName: "video", fileName: "video.mp4", mimeType: "video/quicktime")
            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:"https://dev.braingroom.com/apis/uploadPostVideo")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    let progressStatus = Float(progress.fractionCompleted)
                    print(progressStatus)
                    DispatchQueue.main
                    do
                    {
                    }
                })
                upload.responseJSON { response in
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    let dic = response.result.value as? NSDictionary
                    if dic?.object(forKey: "res_code") as? String == "1"
                    {
                        self.uploadVideoImageView.sd_setImage(with: URL(string: ((dic?.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "success_url") as! String),placeholderImage: nil)
                        
                        self.uploadVideoUrl = ((dic?.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "url") as! String
                    }
                    else
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        AFWrapperClass.alert("Alert!", message: "Video not uploaded. Please, try again.", view: self)
                    }
                }
            case .failure(let _):
                AFWrapperClass.svprogressHudDismiss(view: self)
                break
            }
        }
    }


    
//MARK: ------------------------------- Image picker Delegates -------------------------------
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if mediaType == "image"
        {
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            uploadImageView.image = chosenImage
            mediaData = UIImageJPEGRepresentation(self.uploadImageView.image!, 0.4)!
            uploadImageMedia(postType:"tips_tricks", data:mediaData)
        }
        else
        {
            if let fileURL =  info[UIImagePickerControllerMediaURL] as? URL
            {
                do {
                    let videoData = try Data(contentsOf: fileURL)
                    uploadVideoMedia(postType:"tips_tricks", data:videoData)
                    
                } catch {
                    print(error)
                }
            }
        }

        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func mediaActionSheet()
    {
        let alertController = UIAlertController(title: "Select image to upload from:", message: "", preferredStyle: .actionSheet)
        
        let photoButton = UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) -> Void in
            self.openPhotos()
            self.mediaType = "image"
        })
        
        let  cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.openCamera()
            self.mediaType = "image"
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
        })
    
        alertController.addAction(photoButton)
        alertController.addAction(cameraButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
    }
    
    func openPhotos()
    {
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    func openVideos()
    {
        self.mediaType = "video"
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    func postData()
    {
            if postLblStr == "Knowledge nuggets"
            {
                postStr = "tips_tricks"
            }
            else if postLblStr == "Buy & sell"
            {
                postStr = "group_post"
            }
            else if postLblStr == "Find learning partners"
            {
                postStr = "activity_request"
            }
            else
            {
                postStr = "user_post"
            }
            
            let baseURL: String  = String(format:"%@addPost",Constants.mainURL)
            let dic = UserDefaults.standard.object(forKey: "userData") as? NSDictionary
        
        var innerParams : [String: String] = [
                "uuid" : (dic?.object(forKey: "uuid") as? String)!,
                "post_type" : postStr,
                "post_title" : topicTF.text!,
                "post_summary" : descriptionTextView.text!,
                "group_id" : groupIdStr,
                "country_id" : appDelegate.signUpCountryID as String,
                "state_id" : appDelegate.signUpStateID as String,
                "city_id" : appDelegate.signUpCityID as String,
                "locality_id" : appDelegate.SignUpLocationID as String,
                "post_thumb_upload" : uploadImageUrl,
                "video" : uploadVideoUrl,
                "class_link" : classPageUrlTF.text!
            ]
        
            if isFromActivityAndPartner {
                innerParams["proposed_location"] = txtProposedLocation.text ?? ""
                
                if self.viewTo.isHidden {
                    innerParams["proposed_date_type"] = "On Date"
                } else {
                    innerParams["proposed_date_type"] = "Recurring Date"
                }
                
                innerParams["privacy_type"] = privacyLabel.text ?? ""
                innerParams["request_note"] = self.txtReqNote.text ?? ""
                innerParams["proposed_date_from"] = self.fromdateLable.text ?? ""
                innerParams["proposed_date_to"] = self.TodateLable.text ?? ""
            }
        
            let params : [String: AnyObject] = [
                "braingroom": innerParams as AnyObject
            ]
            print(params)
            AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
            AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
                AFWrapperClass.svprogressHudDismiss(view: self)
                let dic:NSDictionary = responseDict as NSDictionary
                if (dic.object(forKey: "res_code")) as! String == "1"
                {
                    self.txtReqNote.text = ""
                    self.txtProposedLocation.text = ""
                    self.txtProposedTime.text = ""
                
                   self.alert(text: "Posted Successfully.")
                }
            }) { (error) in
        }
    }

//MARK: ------------------------------- Done and Back Btn Action --------------------------------
    @IBAction func saveBtnAction(_ sender: Any)
    {
        self.postData()
    }
    @IBAction func optionsDoneBtn(_ sender: Any)
    {
        optionsView.isHidden = true
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
        alert.makeAlertTypeSuccess()
        alert.showAlert(withTitle: "Braingroom", withSubtitle: text , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
        alert.hideDoneButton = true;
        alert.addButton("OK", withActionBlock: {
        })
    }
    
}
