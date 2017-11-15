//
//  BookingVC.swift
//  brainGroom
//
//  Created by Satya Mahesh on 21/09/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import FCAlertView

class LevelTVCell : UITableViewCell
{
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}

class LocationTVCell : UITableViewCell
{
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var selectedRadioView: UIViewX!
    
}

class BookingVC: UIViewController, UITableViewDelegate, UITableViewDataSource,RazorpayPaymentCompletionProtocol, FCAlertViewDelegate
{
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var TVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationTVHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var payBtn: UIButtonX!
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var promoCodeBtn: UIButton!
    @IBOutlet weak var couponCodeBtn: UIButton!
    
    @IBOutlet weak var loginView: UIViewX!
    @IBOutlet weak var locationView: UIViewX!
    @IBOutlet weak var locationTV: UITableView!
    
    @IBOutlet weak var promoCodeTF: UITextField!
    @IBOutlet weak var couponCodeTF: UITextField!
    
    
    var price = String()
    var isPopUpOpen = Bool()
    var isOnline = Bool()
    var isGuest = Bool()
    var isPromo = Bool()
    var isCoupon = Bool()
    
    var dataDict = NSDictionary()
    var locationArray = NSArray()
    var levelArray = NSArray()
    
    var quantityTotal = Int()
    
    var total = Int()
    var grandTotal = Int()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var ticket = String()
    var isTicketSelect : Bool = false
    
    @IBOutlet weak var couponTFWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var promoTFWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    
    private var razorpay : Razorpay!
    
    var transactionId = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(self.dataDict)
        
        if price == "" || price.characters.count == 0 {
            self.payBtn .setTitle("Book For Free", for: .normal)
        }
        self.loginView.isHidden = true
        
        if isOnline != true
        {
            if let location = dataDict["location"]
            {
                locationArray = location as! NSArray
            }
            
        }
        levelArray = dataDict["vendorClasseLevelDetail"] as! NSArray
        
        print(getTicketValue())
        self.topImage.sd_setImage(with: URL(string: (self.dataDict.value(forKey: "photo") as! String)), placeholderImage: UIImage.init(named: "chocolate1Dca410A2"))
        self.descLbl.text = self.dataDict.value(forKey: "class_topic") as? String
        self.TVHeightConstraint.constant = CGFloat(levelArray.count) * 60.0
        self.locationTVHeightConstraint.constant = CGFloat(locationArray.count) * 150
        
        
        razorpay = Razorpay.initWithKey("rzp_test_RzeA80NW4jeMpe", andDelegate: self)
//        razorpay = Razorpay.initWithKey("rzp_live_SN4tYAqDnzHHem", andDelegate: self)
//        if price != nil && price != ""
//        {
//            total = Int(price)!
//        }
//        else{
            total = 0
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(true)
        UserDefaults.standard.set(false, forKey: "fromBooking")
    }
//MARK: ------------------------- TV Delegate & DataSource -------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == locationTV
        {
            return locationArray.count
        }
        else
        {
            return levelArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == TV
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelTVCell") as! LevelTVCell
        cell.selectionStyle = .none
        cell.detailsBtn.isHidden = true
        
        cell.titleLbl.text = (levelArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"level_name") as? String
        
        cell.detailsBtn.tag = indexPath.row
        cell.plusBtn.tag = indexPath.row
        cell.minusBtn.tag = indexPath.row
        
        cell.detailsBtn.addTarget(self, action: #selector(self.detailsBtnAction(_:)), for: .touchUpInside)
        cell.plusBtn.addTarget(self, action: #selector(self.plusBtnAction(_:)), for: .touchUpInside)
        cell.minusBtn.addTarget(self, action: #selector(self.minusBtnAction(_:)), for: .touchUpInside)
        
        return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTVCell") as! LocationTVCell
            cell.selectionStyle = .none
            cell.selectedRadioView.isHidden = true
            
            cell.locationLbl.text = (locationArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"location_area") as? String
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == locationTV
        {
            let cell = tableView.cellForRow(at: indexPath) as! LocationTVCell
            cell.selectedRadioView.isHidden = false
            locationLbl.text = cell.locationLbl.text!
            closePopUp()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == locationTV
        {
            return 100.0
        }
        else
        {
            return 60.0
        }
    }
//MARK: -------------------------- Cell Buttons Action --------------------------
    
    func detailsBtnAction(_ sender:UIButton)
    {
        
    }
    func plusBtnAction(_ sender:UIButton)
    {
        if price == "" || price.characters.count == 0 {
            let index : IndexPath = IndexPath(row: sender.tag, section: 0)
            let cell : LevelTVCell = self.TV.cellForRow(at: index) as! LevelTVCell
            var c:NSInteger = NSInteger(cell.quantityLbl.text!)!
            c += 1
            quantityTotal = c
            cell.quantityLbl.text = String(format:"%lu",c)
            payBtn.setTitle(String(format:"Book For Free"), for: .normal)
            isTicketSelect = true
        }
        else {
            let index : IndexPath = IndexPath(row: sender.tag, section: 0)
            let cell : LevelTVCell = self.TV.cellForRow(at: index) as! LevelTVCell
            var c:NSInteger = NSInteger(cell.quantityLbl.text!)!
            c += 1
            quantityTotal = c
            cell.quantityLbl.text = String(format:"%lu",c)
            let priceValue = c * NSInteger(((levelArray.object(at: sender.tag) as! NSDictionary).object(forKey:"price") as? Int)!)
            totalPrice(price: priceValue)
            cell.priceLbl.text = String(format:"Rs.%lu",priceValue)
            isTicketSelect = true
//            payBtn.setTitle(String(format:"Pay %@",cell.priceLbl.text!), for: .normal)
//            if c == 0
//            {
//                cell.priceLbl.text = ""
//                payBtn.setTitle(String(format:"Select Item To Proceed"), for: .normal)
//            }
        }
        
    }
    func minusBtnAction(_ sender:UIButton)
    {
        
        if price == "" || price.characters.count == 0 {
            let index : IndexPath = IndexPath(row: sender.tag, section: 0)
            let cell : LevelTVCell = self.TV.cellForRow(at: index) as! LevelTVCell
            var c:NSInteger = NSInteger(cell.quantityLbl.text!)!
            if c != 0
            {
                c -= 1
                cell.quantityLbl.text = String(format:"%lu",c)
                quantityTotal = c
                isTicketSelect = true
            }
            else
            {
                isTicketSelect = false
            }
            payBtn.setTitle(String(format:"Book For Free"), for: .normal)
            
        } else {
            let index : IndexPath = IndexPath(row: sender.tag, section: 0)
            let cell : LevelTVCell = self.TV.cellForRow(at: index) as! LevelTVCell
            var c:NSInteger = NSInteger(cell.quantityLbl.text!)!
            if c != 0
            {
                c -= 1
                cell.quantityLbl.text = String(format:"%lu",c)
                quantityTotal = c
                let priceValue = c * NSInteger(((levelArray.object(at: sender.tag) as! NSDictionary).object(forKey:"price") as? Int)!)
                totalPrice(price: priceValue)
                cell.priceLbl.text = String(format:"Rs.%lu",priceValue)
                isTicketSelect = true
//                payBtn.setTitle(String(format:"Pay %@",cell.priceLbl.text!), for: .normal)
//
//                if c==0
//                {
//                    cell.priceLbl.text = ""
//                    payBtn.setTitle(String(format:"Select Item To Proceed"), for: .normal)
//                }
            }
            else
            {
                isTicketSelect = false
            }
        }
        
    }
    
    func totalPrice(price: NSInteger)
    {
        total = 0
        for i in 0..<levelArray.count
        {
            let index : IndexPath = IndexPath(row: i, section: 0)
            let cell : LevelTVCell = self.TV.cellForRow(at: index) as! LevelTVCell
            total = total + NSInteger(cell.quantityLbl.text!)! * NSInteger(((levelArray.object(at: i) as! NSDictionary).object(forKey:"price") as? Int)!)
        }
        
        totalAmountLbl.text = String(format:"Total amount: Rs.%lu",total)
        
        payBtn.setTitle(String(format:"Rs.%lu",total), for: .normal)
        if total == 0
        {
            payBtn.setTitle(String(format:"Select Item To Proceed"), for: .normal)
        }
    }
    
//MARK: ------------------------- Buttons Action -------------------------
    @IBAction func chooseLocationBtnAction(_ sender: Any)
    {
        if isOnline != true
        {
        popUpView.isHidden = false
        loginView.isHidden = true
        locationView.isHidden = false
        isPopUpOpen = true
        }
        else
        {
            self.alertView(text:"This option is disabled for online classes.")
        }
    }
    @IBAction func couponCodeBtnAction(_ sender: Any)
    {
        if couponTFWidthConstraint.constant == 0
        {
            AFWrapperClass.autoLayoutUpdate(constrain: couponTFWidthConstraint, constrainValue: self.view.frame.size.width * 0.7, view: self.view)
            AFWrapperClass.autoLayoutUpdate(constrain: promoTFWidthConstraint, constrainValue: 0, view: self.view)
            couponCodeBtn.setTitle("Apply", for: .normal)
            promoCodeBtn.setTitle("Apply a promo code", for: .normal)
            self.isCoupon = true
            self.isPromo = false
        }
        else{}
        
        if self.couponCodeBtn.titleLabel?.text == "Apply"
        {
            if userId() == ""
            {
                displayLoginView()
                self.isPromo = false
            }
            else
            {
                promoCodeApiHitting(guest: 0, codeText: couponCodeTF.text!)
            }
        }
        else{}
    }
    
    @IBAction func promoCodeBtnAction(_ sender: Any)
    {
        if promoTFWidthConstraint.constant == 0
        {
            AFWrapperClass.autoLayoutUpdate(constrain: promoTFWidthConstraint, constrainValue: self.view.frame.size.width * 0.7, view: self.view)
            AFWrapperClass.autoLayoutUpdate(constrain: couponTFWidthConstraint, constrainValue: 0, view: self.view)
            promoCodeBtn.setTitle("Apply", for: .normal)
            couponCodeBtn.setTitle("Apply a coupan code", for: .normal)
            self.isPromo = true
            self.isCoupon = false
        }
        else{}
        
        if self.promoCodeBtn.titleLabel?.text == "Apply"
        {
            if userId() == ""
            {
                displayLoginView()
                self.isCoupon = false
            }
            else
            {
                promoCodeApiHitting(guest: 0, codeText: promoCodeTF.text!)
            }
        }
        else{}
    }
    
    @IBAction func popViewCloseBtn(_ sender: Any)
    {
        closePopUp()
    }
    
    @IBAction func payBtnAction(_ sender: Any)
    {
        if isOnline != true
        {
            if locationLbl.text != "Select location"
            {
                totalCheck()
            }
            else
            {
                AFWrapperClass.showToast(title: "Please, select location.", view: self.view)
            }
        }
        else
        {
            totalCheck()
        }
    }
    
    func totalCheck()
    {
        if isTicketSelect == false
        {
            AFWrapperClass.showToast(title: "Please, select number of tickets.", view: self.view)
            return
        }
        if total != 0
        {
            if userId() == ""
            {
                popUpView.isHidden = false
                loginView.isHidden = false
                locationView.isHidden = true
                isPopUpOpen = true
            }
            else
            {
                if isPromo == false && isCoupon == false
                {
                    self.grandTotal = total
                }
                paymentApiHitting(guest:0)
            }
        }
        else if (self.price == "" || self.price == "0")
        {
//            alertView(text: "Please, select number of seats.")
            if userId() == ""
            {
                popUpView.isHidden = false
                loginView.isHidden = false
                locationView.isHidden = true
                isPopUpOpen = true
            }
            else
            {
                if isPromo == false && isCoupon == false
                {
                    self.grandTotal = total
                }
                paymentApiHitting(guest:0)
            }
        }
        else
        {
            AFWrapperClass.showToast(title: "Please, select number of tickets.", view: self.view)
            //alertView(text: "Please, select number of tickets.")
        }
    }
    
    func closePopUp()
    {
        if isPopUpOpen == true
        {
            popUpView.isHidden = true
            isPopUpOpen = false
        }
    }
    
    func displayLoginView()
    {
        if userId() == ""
        {
            popUpView.isHidden = false
            loginView.isHidden = false
            locationView.isHidden = true
            isPopUpOpen = true
        }
        else
        {
            
        }
    }
    
    @IBAction func loginBtnAction(_ sender: Any)
    {
        self.goToLogin()
    }
    
    func goToLogin()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"LoginVC") as! LoginVC
        UserDefaults.standard.set(true, forKey: "fromBooking")
        UserDefaults.standard.synchronize()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func continueAsGuestBtnAction(_ sender: Any)
    {
        if nameTF.text!.characters.count != 0 && mobileTF.text!.characters.count != 0 && emailTF.text!.characters.count != 0
        {
            self.isGuest = true
            if isPromo == true
            {
                promoCodeApiHitting(guest: 1, codeText: promoCodeTF.text!)
            }
            else if isCoupon == true
            {
                promoCodeApiHitting(guest: 1, codeText: couponCodeTF.text!)
            }
            else
            {
                paymentApiHitting(guest:1)
            }
        }
        else
        {
            AFWrapperClass.showToast(title: "Please, fill all fields.", view: self.view)
        }
    }
    
    func showPaymentForm(total:String, email: String, phone: String)
    {
//        NSDictionary *options = @{
//            @"amount": @"1000", // mandatory, in paise
//            // all optional other than amount.
//            @"image": @"https://url-to-image.png",
//            @"name": @"business or product name",
//            @"description": @"purchase description",
//            @"prefill" : @{
//                @"email": @"pranav@razorpay.com",
//                @"contact": @"8879524924"
//            },
//            @"theme": @{
//                @"color": @"#F37254"
//            }
//        };
//        [razorpay open:options];
        
        var class_provided_by : String = ""
        if let name : String = self.dataDict.value(forKey: "class_provided_by") as? String
        {
            class_provided_by = "By : " + name
        }
        
        let amount = Int(total)
        let options = [
            "amount" : String(format:"%f",CGFloat(amount!*100)), // mandatory, in paise
            //            // all optional other than amount.
            "image" : "https://www.braingroom.com/homepage/img/logo.jpg",
            "name" : self.dataDict.value(forKey: "class_topic") as? String ?? "",
            "description" : class_provided_by,
            "prefill" : ["email" : email,"contact" : phone]
        ] as [String : Any]
        razorpay.open(options)
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        if isPopUpOpen == true
        {
            popUpView.isHidden = true
            isPopUpOpen = false
        }
        else
        {
            _ = self.navigationController!.popViewController(animated:true)
        }
    }
    
    func getTicketValue() -> String
    {
        var tempArr : [AnyObject] = [AnyObject] ()
        for i in 0..<levelArray.count
        {
            let dict : [String : AnyObject] = levelArray[i] as! [String : AnyObject]
            var tempDict : [String : AnyObject] = [String : AnyObject] ()
            tempDict["level_id"] = dict["level_id"]
            tempDict["tickets"] = quantityTotal as AnyObject
            tempArr.append(tempDict as AnyObject)
        }
        var ticketDict : [String : AnyObject] = [String : AnyObject]()
        ticketDict["tickets"] = tempArr as AnyObject
        
//        var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
//        if error == nil {
//            return NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
//        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ticketDict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    
//MARK: ----------------------- API Hitting -----------------------------
    
    func promoCodeApiHitting(guest: Int, codeText: String)
    {
        ticket = getTicketValue()
        let baseURL  = API.VERIFY_PROMOCODE
        let innerParams  = [
            "class_id":dataDict.object(forKey: "id") as! String,
            "promo_code": codeText,
            "is_guest":guest,
            "total_ticket":ticket,
            "total_amount":total,
            "user_id":userId()
            ] as [String : Any]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            print("Promo code response ---> \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if dic.object(forKey: "res_code") as! String == "1"
            {
                if (dic.object(forKey: "res_msg") as! String) != "Invalid Promo!"
                {
                    let dict : NSDictionary = (dic.object(forKey: "braingroom") as! NSArray).object(at:0) as! NSDictionary
                    self.grandTotal = self.total
                    if let discount : String = dict.value(forKey: "promo_amount") as? String
                    {
                        let newDiscount : Float = Float(discount)!
                        self.grandTotal = self.grandTotal - Int(newDiscount) 
                    }
                    
                    print("Grand total --> \(self.grandTotal)")
                    AFWrapperClass.autoLayoutUpdate(constrain: self.promoTFWidthConstraint, constrainValue: 0, view: self.view)
                    AFWrapperClass.autoLayoutUpdate(constrain: self.couponTFWidthConstraint, constrainValue: 0, view: self.view)
                    if self.isCoupon == true
                    {
                        self.couponCodeBtn.setTitle(String(format: "Coupon Code Discount Rs. : %d", self.grandTotal), for: .normal)
                    }
                    else if self.isPromo == true
                    {
                        self.promoCodeBtn.setTitle(String(format: "Promo Code Discount Rs. : %d", self.grandTotal), for: .normal)
                    }
                    self.payBtn.setTitle(String(format:"Total amount: Rs.%lu",self.grandTotal), for: .normal)
                    
                    self.alertSuccessView(text: "Code applied successfully.")
                    
                    self.popUpView.isHidden = true
                    self.loginView.isHidden = true
                    
//                    if self.isCoupon == true
//                    {
//                        self.couponCodeBtn.setTitle("Applied", for: .normal)
//                    }
//                    else
//                    {
//                        self.promoCodeBtn.setTitle("Applied", for: .normal)
//                    }
                }
                else
                {
                    self.alertView(text: dic.object(forKey: "res_msg") as! String)
                }
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alertView(text: error.localizedDescription)
        }
    }

    func paymentApiHitting(guest: Int)
    {
        
        let baseURL  = API.GET_BOOKNOW_PAGE_DETAIL
        let innerParams  = [
            "amount":self.grandTotal,
            "class_id": dataDict.object(forKey: "id") as! String,
            "is_guest":guest,
            "levels":ticket,
            "locality_id":(locationArray.object(at: 0) as! NSDictionary).object(forKey: "locality_id") as! String,
            "txnid":"",
            "user_id":userId()
        ] as [String : Any]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "braingroom") as! NSArray).count != 0
            {
                if self.grandTotal != 0 {
                    print("Payment Success")
                    if self.isGuest == true
                    {
                        self.showPaymentForm(total: String(format:"%lu",self.grandTotal), email: self.emailTF.text!, phone: self.mobileTF.text!)
                    }
                    else
                    {
                        self.transactionId = (((dic.object(forKey: "braingroom") as! NSArray).object(at:0) as! NSDictionary).object(forKey:"txnid") as? String)!
                        self.showPaymentForm(total: String(format:"%lu",self.grandTotal), email: (((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "email") as? String)!, phone: (((dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "phone") as? String)!)
                    }
                }else
                {
                    self.transactionId = (((dic.object(forKey: "braingroom") as! NSArray).object(at:0) as! NSDictionary).object(forKey:"txnid") as? String)!
                    //self.paymentSuccessApiHitting(paymentTxtId: "", transactionId: self.transactionId, guest: guest)
                    self.freeBookingPaymentSuccessApiHitting(paymentTxtId: "", transactionId: self.transactionId, guest: guest)
                }
                
            }
            else
            {
                self.alertView(text: "Something went wrong. Please, try again later.")
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alertView(text: error.localizedDescription)
        }
    }
    
    func paymentSuccessApiHitting(paymentTxtId: String, transactionId: String, guest: Int)
    {
        ticket = getTicketValue()
        let baseURL  = API.GET_BOOKNOW_PAGE_DETAIL
        let innerParams  = [
            "amount":self.grandTotal,
            "bg_txnid":transactionId,
            "book_type":1,
            "class_id":dataDict.object(forKey: "id") as! String,
            "coupon_value":"",
            "is_guest":guest,
            "locality_id":(locationArray.object(at: 0) as! NSDictionary).object(forKey: "locality_id") as! String,
            "promo_value":"",
            "promo_id":"",
            "tickets":ticket,
            "user_email":appDelegate.userData.value(forKey: "email") as? String ?? "",
            "user_mobile":appDelegate.userData.value(forKey: "contact_no") as? String ?? "" ,
            "txnid":paymentTxtId,
            "user_id":userId()
            ] as [String : Any]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "braingroom") as! NSArray).count != 0
            {
                AFWrapperClass.showToast(title: "Payment Successfully Done. Thank you.", view: self.view)
//                self.alertSuccessView(text: "Payment Successfully Done. Thank you.")
                self.isGuest = false
                
                self.isCoupon = false
                self.isPromo = false
                self.backBtnAction(self)
            }
            else
            {
                self.alertView(text: "Something went wrong. Please, try again later.")
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alertView(text: error.localizedDescription)
        }
    }
    
    func freeBookingPaymentSuccessApiHitting(paymentTxtId: String, transactionId: String, guest: Int)
    {
        ticket = getTicketValue()
        
        let baseURL  = API.RAZOR_PAY_SUCCESS
        let innerParams  = [
            "amount":self.grandTotal,  // Total paid amount
            "bg_txnid":transactionId, // Braingroom  transactionId
            "book_type":1, //
            "class_id":dataDict.object(forKey: "id") as! String, // class id
            "coupon_value":"0.0", // applied coupon amount
            "is_guest":guest,  // guest booking 1 normal booking 0
            "locality_id":(locationArray.object(at: 0) as! NSDictionary).object(forKey: "locality_id") as! String, // location id
            "promo_value":"1.0", // promo amount
            "promo_id":"testzero", // promo code
            "txnid":"", // razor pay transaction id
            "tickets":ticket, // booked class levels and number of tickets
            "user_email":appDelegate.userData.value(forKey: "email") as? String ?? "", // user email id
            "user_id":userId(), // user id
            "user_mobile":appDelegate.userData.value(forKey: "contact_no") as? String ?? "" //user mobile number
            ] as [String : Any]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURL(baseURL, params: params, success: { (responseDict) in
            print("DDD: \(responseDict)")
            AFWrapperClass.svprogressHudDismiss(view: self)
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "braingroom") as! NSArray).count != 0
            {
                //AFWrapperClass.showToast(title: "Payment Successfully Done. Thank you.", view: self.view)
                //                self.alertSuccessView(text: "Payment Successfully Done. Thank you.")
                self.isGuest = false
                
                self.isCoupon = false
                self.isPromo = false
                
                let alert = FCAlertView()
                alert.blurBackground = false
                alert.cornerRadius = 15
                alert.bounceAnimations = true
                alert.dismissOnOutsideTouch = false
                alert.delegate = self
                alert.makeAlertTypeSuccess()
                alert.showAlert(in: self.appDelegate.window, withTitle: "Braingroom", withSubtitle: "Successfully booked" , withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
                alert.hideDoneButton = true;
                alert.addButton("OK", withActionBlock: {
                    self.backBtnAction(self)
                })
            }
            else
            {
                self.alertView(text: "Something went wrong. Please, try again later.")
            }
        }) { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            self.alertView(text: error.localizedDescription)
        }
    }

    
//MARK: ------------------------ Razor pay delegates --------------------------
    func onPaymentSuccess(_ payment_id: String)
    {
        if isGuest == true
        {
            paymentSuccessApiHitting(paymentTxtId: payment_id, transactionId: transactionId, guest: 1)
        }
        else
        {
            paymentSuccessApiHitting(paymentTxtId: payment_id, transactionId: transactionId, guest: 0)
        }
    }
    
    func onPaymentError(_ code: Int32, description str: String)
    {
        alertView(text: str)
    }
//MARK: --------------------- Alert ----------------------------
    
    func alertView(text: String)
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
    
    func alertSuccessView(text: String)
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
