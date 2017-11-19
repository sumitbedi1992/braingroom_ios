//
//  AppDelegate.swift
//  brainGroom
//
//  Created by Mahesh on 11/08/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn
import IQKeyboardManagerSwift
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var deviceToken = NSString()
    
    var signUpFullName = NSString()
    var signUpEmail = NSString()
    var signUpMobileNumber = NSString()
    var signUpPassword = NSString()
    var signUpReferralCode = NSString()
    var signUpUGCollege = NSString()
    var signUpUGCollegeID = NSString()
    var signUpPassout = NSString()
    var signUpDOB = NSString()
    var signUpGender = NSString()
    var signUpCountry = NSString()
    var signUpCountryID = NSString()
    var signUpState = NSString()
    var signUpStateID = NSString()
    var signUpCity = NSString()
    var signUpCityID = NSString()
    var SignUpLocation = NSString()
    var SignUpLocationID = NSString()
    var SignUpInterests = NSString()
    var SignUpInterestsID = NSString()
    var tempUser = NSString()
    var PRICE_SYMBOLE = "&#8377;"
    var PRICE_CODE = "INR"
    
    var userId = NSString()
    var userUUID = NSString()
    var userData = NSMutableDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        GMSPlacesClient.provideAPIKey(Constants.GMS_PLACE_KEY)
        GMSServices.provideAPIKey(Constants.GMS_SERVICE_KEY)
        GIDSignIn.sharedInstance().delegate = self
        
        setFromBooking(false)
        BITHockeyManager.shared().configure(withIdentifier: Constants.HOCKEY_ID)
        // Do some additional configuration if needed here
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()

        GIDSignIn.sharedInstance().clientID = Constants.GOOGLE_CLIENT_ID
        
         signUpFullName = ""
         signUpEmail = ""
         signUpMobileNumber = ""
         signUpPassword = ""
         signUpReferralCode = ""
         signUpUGCollege = ""
         signUpPassout = ""
        signUpDOB = ""
        signUpGender = ""
        signUpCountry = ""
        signUpState = ""
        signUpCity = ""
        SignUpLocation = ""
        
        let str = UserDefaults.standard.string(forKey: "user_id")
        if (str == nil || (str?.characters.count)! <= 0)
        {
            userId = ""
        }
        else
        {
            userData = getLoginUserData()
            userId = str! as NSString
        }

        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate=self
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
        } else {
            // Fallback on earlier versions
        }
        
        application.registerForRemoteNotifications()
        registerForPushNotifications(application: application)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
        else{ //If user is not on iOS 10 use the old methods we've been using
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.absoluteString.contains(Constants.GOOGLE_REVERSED_CLIENT_ID)
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }else{
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func mainStoryboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func profileStoryboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Profile", bundle: nil)
    }
    
    func setSocialLogin(isSocial : Bool)
    {
        UserDefaults.standard.set(isSocial, forKey: PREFERENCE.IS_SOCIAL_LOGIN)
        UserDefaults.standard.synchronize()
    }
    
    func isSocialLogin() -> Bool
    {
        return UserDefaults.standard.bool(forKey: PREFERENCE.IS_SOCIAL_LOGIN)
    }
    
    func setLoginUserData()
    {
        UserDefaults.standard.set(self.userData, forKey: PREFERENCE.USER_DATA)
        UserDefaults.standard.synchronize()
    }
    
    func getLoginUserData() -> NSMutableDictionary
    {
        if let value = UserDefaults.standard.value(forKey: PREFERENCE.USER_DATA)
        {
            return value as! NSMutableDictionary
        }
        else
        {
            return NSMutableDictionary()
        }
    }
    
    func setLoginUserCountry(value : String)
    {
        UserDefaults.standard.set(value, forKey: PREFERENCE.USER_COUNTRY)
        UserDefaults.standard.synchronize()
    }
    
    func getLoginUserCountry() -> String
    {
        if let value = UserDefaults.standard.value(forKey: PREFERENCE.USER_COUNTRY)
        {
            return value as! String
        }
        else
        {
            return ""
        }
    }
    
    func setLoginUserState(value : String)
    {
        UserDefaults.standard.set(value, forKey: PREFERENCE.USER_STATE)
        UserDefaults.standard.synchronize()
    }
    
    func getLoginUserState() -> String
    {
        if let value = UserDefaults.standard.value(forKey: PREFERENCE.USER_STATE)
        {
            return value as! String
        }
        else
        {
            return ""
        }
    }
    
    func setLoginUserCity(value : String)
    {
        UserDefaults.standard.set(value, forKey: PREFERENCE.USER_CITY)
        UserDefaults.standard.synchronize()
    }
    
    func getLoginUserCity() -> String
    {
        if let value = UserDefaults.standard.value(forKey: PREFERENCE.USER_CITY)
        {
            return value as! String
        }
        else
        {
            return ""
        }
    }
    
    func getLoginUserCategory() -> String
    {
        if let value = UserDefaults.standard.value(forKey: PREFERENCE.USER_CATEGORY)
        {
            return value as! String
        }
        else
        {
            return ""
        }
    }
    
    func setLoginUserCategory(value : String)
    {
        UserDefaults.standard.set(value, forKey: PREFERENCE.USER_CATEGORY)
        UserDefaults.standard.synchronize()
    }
    
    func getLoginUserCollage() -> String
    {
        if let value = UserDefaults.standard.value(forKey: PREFERENCE.USER_COLLAGE)
        {
            return value as! String
        }
        else
        {
            return ""
        }
    }
    
    func setLoginUserCollage(value : String)
    {
        UserDefaults.standard.set(value, forKey: PREFERENCE.USER_COLLAGE)
        UserDefaults.standard.synchronize()
    }
    
    func getUserProfile()
    {
        if UserDefaults.standard.value(forKey: "user_id") == nil || UserDefaults.standard.value(forKey: "user_id") as! String == ""
        {
            return
        }
        //let baseURL: String  = String(format:"%@getProfile",Constants.mainURL)
        let baseURL: String  = API.GET_PROFILE
        
        let innerParams : [String: String] = [
            "id":UserDefaults.standard.value(forKey: "user_id") as! String
        ]
        let params : [String: AnyObject] = [
            "braingroom": innerParams as AnyObject
        ]
        print(params)
        
        AFWrapperClass.requestPOSTURL(baseURL, params: params as [String : AnyObject]?, success: { (responseDict) in
            
            print("DDD: \(responseDict)")
            let dic:NSDictionary = responseDict as NSDictionary
            if (dic.object(forKey: "braingroom") as! NSArray).count > 0
            {
                let dictData = (dic.object(forKey: "braingroom") as! NSArray).object(at: 0) as! NSDictionary
                print(dictData)
                self.userData = NSMutableDictionary(dictionary: dictData)
                for key in self.userData.allKeys
                {
                    if (self.userData[key] is NSNull)
                    { // NSNull is a singleton, so this check is sufficient
                        self.userData.setValue("", forKey: key as! String)
                    }
                }

                self.setLoginUserData()
                UserDefaults.standard.set(self.userData, forKey: "userData")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.UPDATE_LOGIN_USER_PROFILE), object: nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func displayServerError()
    {
        AFWrapperClass.showToast(title: "Please try again later.", view: self.window!)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    //MARK: Get Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken1: Data) {
        let deviceTokenString = deviceToken1.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "DeviceToken")
        UserDefaults.standard.synchronize()
        deviceToken = deviceTokenString as NSString
        print("APNs device token: \(deviceTokenString)")
    }
    // Called when APNs failed to register the device for push notifications
    @nonobjc func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    //MARK: Push Notification Methods
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response.notification.request.content.userInfo)
        _ = response.notification.request.content.userInfo as NSDictionary

    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
        // print(notification.request.content.userInfo)
        //        let dic = notification.request.content.userInfo as NSDictionary
        //        if let aps = dic["aps"] as? [String: Any] {
        //        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func timeStampToDate(time: String) -> String
    {
        let date = NSDate(timeIntervalSince1970: Double(time)!)
        
        let dayTimePeriodFormatter =
            
            DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MMM/yyyy"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
}

