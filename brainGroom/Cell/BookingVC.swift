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
            locationArray = dataDict["location"] as! NSArray
        }
        levelArray = dataDict["vendorClasseLevelDetail"] as! NSArray
        
        self.topImage.sd_setImage(with: URL(string: (self.dataDict.value(forKey: "photo") as! String)), placeholderImage: UIImage.init(named: "chocolate1Dca410A2"))
        self.descLbl.text = self.dataDict.value(forKey: "class_topic") as? String
        self.TVHeightConstraint.constant = CGFloat(levelArray.count) * 60.0
        self.locationTVHeightConstraint.constant = CGFloat(locationArray.count) * 150
        
        
        razorpay = Razorpay.initWithKey("rzp_test_RzeA80NW4jeMpe", andDelegate: self)
//        razorpay = Razorpay.initWithKey("rzp_live_SN4tYAqDnzHHem", andDelegate: self)
        if price != nil && price != ""
        {
            total = Int(price)!
        }
        else{
            total = 0
        }
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
        }
        else {
            let index : IndexPath = IndexPath(row: sender.tag, section: 0)
            let cell : LevelTVCell = self.TV.cellForRow(at: index) as! LevelTVCell
            var c:NSInteger = NSInteger(cell.quantityLbl.text!)!
            c += 1
            quantityTotal = c
            cell.quantityLbl.text = String(format:"%lu",c)
            totalPrice(quantity: c, price: NSInteger(((levelArray.object(at: sender.tag) as! NSDictionary).object(forKey:"price") as? String)!)!)
            cell.priceLbl.text = String(format:"Rs.%lu",total)
            payBtn.setTitle(String(format:"Pay %@",cell.priceLbl.text!), for: .normal)
            if c == 0
            {
                cell.priceLbl.text = ""
                payBtn.setTitle(String(format:"Select Item To Proceed"), for: .normal)
            }
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
                totalPrice(quantity: c, price: NSInteger(((levelArray.object(at: sender.tag) as! NSDictionary).object(forKey:"price") as? String)!)!)
                cell.priceLbl.text = String(format:"Rs.%lu",total)
                payBtn.setTitle(String(format:"Pay %@",cell.priceLbl.text!), for: .normal)
                
                if c==0
                {
                    cell.priceLbl.text = ""
                    payBtn.setTitle(String(format:"Select Item To Proceed"), for: .normal)
                }
            }
        }
        
    }
    
    func totalPrice(quantity: NSInteger, price: NSInteger)
    {
        total = price * quantity
        totalAmountLbl.text = String(format:"Total amount: Rs.%lu",total)
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
        else
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
        let amount = Int(total)
        let options = [
            "amount" : String(format:"%f",CGFloat(amount!*100)),
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
//MARK: ----------------------- API Hitting -----------------------------
    
    func promoCodeApiHitting(guest: Int, codeText: String)
    {
        let baseURL  = String(format:"%@verifyPromoCode",Constants.mainURL)
        let innerParams  = [
            "class_id":dataDict.object(forKey: "id") as! String,
            "promo_code": codeText,
            "is_guest":guest,
            "total_ticket":"{tickets:[\((levelArray.object(at: 0) as! NSDictionary).object(forKey: "level_id") as! String):\(quantityTotal)]}",
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
                    
                    self.grandTotal = self.total - Int((((dic.object(forKey: "braingroom") as! NSArray).object(at:0) as! NSDictionary).object(forKey: "promo_amount") as? String)!)!
                    print("Grand total --> \(self.grandTotal)")
                    
                    self.payBtn.setTitle(String(format:"Total amount: Rs.%lu",self.grandTotal), for: .normal)
                    
                    self.alertSuccessView(text: "Code applied successfully.")
                    
                    self.popUpView.isHidden = true
                    self.loginView.isHidden = true
                    
                    if self.isCoupon == true
                    {
                        self.couponCodeBtn.setTitle("Applied", for: .normal)
                    }
                    else
                    {
                        self.promoCodeBtn.setTitle("Applied", for: .normal)
                    }
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
        let baseURL  = String(format:"%@getBookNowPageDetails",Constants.mainURL)
        let innerParams  = [
            "amount":self.grandTotal,
            "class_id": dataDict.object(forKey: "id") as! String,
            "is_guest":guest,
            "levels":"[{\((levelArray.object(at: 0) as! NSDictionary).object(forKey: "level_id") as! String):\(quantityTotal)}]",
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
                    self.paymentSuccessApiHitting(paymentTxtId: "", transactionId: self.transactionId, guest: guest)
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
        let baseURL  = String(format:"%@getBookNowPageDetails",Constants.mainURL)
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
            "tickets":"{tickets:[\((levelArray.object(at: 0) as! NSDictionary).object(forKey: "level_id") as! String):\(quantityTotal)]}",
            "user_email":"",
            "user_mobile":UserDefaults.standard.object(forKey: "userMobile") as? String ?? "" ,
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
