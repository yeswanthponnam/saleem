//
//  AppDelegate.swift
//  Saleem
//
//  Created by Suman Guntuka on 18/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import MOLH
import SCLAlertView

import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,SSASideMenuDelegate {

    var window: UIWindow?
    var chatTypeStr : String?
    var checkStr : String?
    var backgroundTask: UIBackgroundTaskIdentifier?
    var vc : SpHomeVC?
    
    
    var timer1 = Timer()
    
    lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
        //_locationManager.delegate = self as! CLLocationManagerDelegate
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 5.0)
        IQKeyboardManager.shared.enable = true
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        MOLHLanguage.setDefaultLanguage("en")
        MOLH.shared.activate(true)
//        GMSServices.provideAPIKey("AIzaSyBUEqgY9_QYZQOuhuNijz0VseAnyjmfXzA")
//        GMSPlacesClient.provideAPIKey("AIzaSyBUEqgY9_QYZQOuhuNijz0VseAnyjmfXzA")
//       // AIzaSyABpo4ftk8Vzdnz3BVXKYeVAjNC720xD8A
        //current keys
        
        
        //paid key working
        //AIzaSyAzdbEknCYu7dd1_V6uFSXtPaBxoz0uxtg
        GMSServices.provideAPIKey("AIzaSyC458EIE1cXPdU-SHNi8fJ2dF1uQhnRTcY")
        GMSPlacesClient.provideAPIKey("AIzaSyAzdbEknCYu7dd1_V6uFSXtPaBxoz0uxtg")
        
        
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            print("no internet")
            //showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
        }
              
        // paid api keys
//        GMSServices.provideAPIKey("AIzaSyC458EIE1cXPdU-SHNi8fJ2dF1uQhnRTcY")
        //GMSPlacesClient.provideAPIKey("AIzaSyCsRrT4-kfrHtxoHGH7iKVqLCUZTRXzDjA")
        
        
        if #available(iOS 10.0, *){
            
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                
                DispatchQueue.main.async {
                    
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            })
            
        }else{
            
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
            
            print("User Notifications else")
            
        }
        
     self.loginCall()
        
        return true
    }
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("background method called")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationUpdateBackground"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "methodToRefresh"), object: nil)
        
        /*
         [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
         __block UIBackgroundTaskIdentifier task = 0;
         task=[application beginBackgroundTaskWithExpirationHandler:^{
         NSLog(@"Expiration handler called %f",[application backgroundTimeRemaining]);
         [application endBackgroundTask:task];
         task=UIBackgroundTaskInvalid;
         }];
         
         _timer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUI:)
         userInfo:nil repeats:YES];
         [[NSRunLoop currentRunLoop] addTimer:_timer1 forMode:NSRunLoopCommonModes];
    */
        application.beginReceivingRemoteControlEvents()
        backgroundTask = UIBackgroundTaskIdentifier(rawValue: 0)
        backgroundTask = application.beginBackgroundTask(expirationHandler: {
            print("expire handler called\(application.backgroundTimeRemaining)")
            application.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        })
        
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(RequestDetailsVC.updateTimer)), userInfo: nil, repeats: true)
        RunLoop.current .add(timer1, forMode: RunLoop.Mode.common)
        
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "runTimerInBackground"), object: nil)
//        if Reachability.isConnectedToNetwork()
//        {
//        print("background method called")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationUpdateBackground"), object: nil)
//        }
//        else{
//            print("no internet")
//        }
    }
    @objc func updateTimer() {
       // print("update timer called in background running",timer1)
        
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        timer1.invalidate()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK:PUSHNOTIFICATION DELEGATES
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("didRegister")
        application.registerForRemoteNotifications()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        let defaults = UserDefaults.standard
        defaults.set(deviceTokenString, forKey: "deviceToken")
        // Persist it in your backend in case it's new
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        let dic = data as NSDictionary
        print("Notification data Is: \(dic)")
        //NotificationCenter.default.post(name: NSNotification.Name("messageSent"), object: nil)
    }
    
    
    func loginCall(){
        
        let type = UserDefaults.standard.object(forKey: "type") as? String ?? ""
        
        if type == "2"{
             if UserDefaults.standard.bool(forKey: "log") == false{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            print("setup type"); navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "HomeViewController")], animated: false)
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let mainViewController = story.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            mainViewController.rootViewController = navigationController
            
            mainViewController.setup(type: 3)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "SelectUserTypeVC")
                let nav = UINavigationController.init(rootViewController: login)
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
      /*  else{
            
            if Reachability.isConnectedToNetwork(){
                if type == "3"{
                    if UserDefaults.standard.bool(forKey: "log") == false{
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                        print("setup type"); navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "SpHomeVC")], animated: false)
                        let story = UIStoryboard.init(name: "Main", bundle: nil)
                        let mainViewController = story.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        mainViewController.rootViewController = navigationController
                        mainViewController.setup(type: 3)
                        
                        let window = UIApplication.shared.delegate!.window!!
                        window.rootViewController = mainViewController
                        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                        
                        
                    }
                    else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let login = storyboard.instantiateViewController(withIdentifier: "SelectUserTypeVC")
                        let nav = UINavigationController.init(rootViewController: login)
                        self.window?.rootViewController = nav
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
            else{
                print("no connection from apphjjhgghg")
            }
            
        }*/
        else if type == "3"{
            
            
            if UserDefaults.standard.bool(forKey: "log") == false{
               // if Reachability.isConnectedToNetwork(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            print("setup type"); navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "SpHomeVC")], animated: false)
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let mainViewController = story.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            mainViewController.rootViewController = navigationController
            mainViewController.setup(type: 3)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
//            }
//            else{
//               // showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
//                print("no connection from apphjjhgghg")
//            }
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "SelectUserTypeVC")
                let nav = UINavigationController.init(rootViewController: login)
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
            
        }
        
//        else{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let login = storyboard.instantiateViewController(withIdentifier: "SelectUserTypeVC")
//            let nav = UINavigationController.init(rootViewController: login)
//            self.window?.rootViewController = nav
//            self.window?.makeKeyAndVisible()
//        }
    }
  
//    func showToastForAlert(message : String) {
//
//        let message = message
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//
//        vc.present(alert, animated: true)
//        // duration in seconds
//        let duration: Double = 3
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
//            alert.dismiss(animated: true)
//
//        }
//    }
    
    
}


@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate{
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
        let userInfo = notification.request.content.userInfo as! Dictionary <String,Any>
        
        print("Notification data is:\(userInfo)")
        
       // let aps = userInfo["aps"] as? Dictionary<String,Any>
        //let infoDict = aps!["info"] as? Dictionary<String,Any>
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeList"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageSent"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProviderList"), object: nil)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToUserHome"), object: nil)
        completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue)|UInt8(UNNotificationPresentationOptions.sound.rawValue))))
        
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
        let userInfo = response.notification.request.content.userInfo
        
        print("Notification data is:\(userInfo)")
                let aps = userInfo["aps"] as? Dictionary<String,Any>
                let infoDict = aps!["info"] as? Dictionary<String,Any>
        
                let notification_type = infoDict!["notification_type"] as! String
                let request_id = infoDict!["request_id"] as! String
                let sender_id = infoDict!["sender_id"] as! String
                let receiver_id = infoDict!["receiver_id"] as! String
        
        if notification_type == "new_message"{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let chatvc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            chatvc.reqIdStr = request_id
            chatvc.providerIdStr = sender_id
            chatTypeStr = "appDelchat"
            let nav = UINavigationController.init(rootViewController: chatvc)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
           
           //let navController = UINavigationController.init(rootViewController: viewController)
//            let nav = UINavigationController.init(nibName: "DeviceProblemPopUpVC1", bundle: nil)
//            nav.present(viewController, animated: true, completion: nil)
           //
            
            
        }
            
        else if notification_type == "offer_accepted"{
            /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let SpTrackVC = storyboard.instantiateViewController(withIdentifier: "SpTrackVC") as! SpTrackVC
            SpTrackVC.reqIdStr = request_id
            SpTrackVC.userIdStr = sender_id
            //receiver_id
            chatTypeStr = "appDelNewSpTrack"
            let nav = UINavigationController.init(rootViewController: SpTrackVC)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible() before track*/
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gotoVC = storyboard.instantiateViewController(withIdentifier: "SpPendingDetailsVC") as! SpPendingDetailsVC
            gotoVC.reqID = request_id
            gotoVC.userIdStr = sender_id
            //gotoVC.providerIdStr = receiver_id
            chatTypeStr = "appDelNewPending"
            let nav = UINavigationController.init(rootViewController: gotoVC)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            
            
        }
        else if notification_type == "new_request"{
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gotoVC = storyboard.instantiateViewController(withIdentifier: "SpRequestsDetailsVC") as! SpRequestsDetailsVC
            gotoVC.reqID = request_id
            gotoVC.providerIdStr = receiver_id
            chatTypeStr = "appDelNewReq"
            let nav = UINavigationController.init(rootViewController: gotoVC)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            
        }
//        else if notification_type == "cancel_request"{
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let gotoVC = storyboard.instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
//            let userID = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
//           // gotoVC.userId = userID
////            gotoVC.providerIdStr = receiver_id
////            chatTypeStr = "appDelNewReq"
//            let nav = UINavigationController.init(rootViewController: gotoVC)
//            self.window?.rootViewController = nav
//            self.window?.makeKeyAndVisible()
//
//        }
        else if notification_type == "invoice_generated"{
            
            UserDefaults.standard.setValue(request_id, forKey: "invoiceReqId")
            UserDefaults.standard.setValue("InvoiceFromAppDel", forKey: "delegate")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"DeviceProblemPopUpVC") as! DeviceProblemPopUpVC
            self.window?.rootViewController?.present(viewController, animated: true, completion: nil)
        }
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeList"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageSent"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProviderList"), object: nil)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToUserHome"), object: nil)
        completionHandler()
    }
}




/*
 Notification data is:["aps": {
 alert = "Your offer is accepted";
 badge = 1;
 info =     {
 "created_at" = "2019-06-10 09:08:52";
 "description_ar" = "New problem ";
 "description_en" = "New problem ";
 latitude = "17.43746795";
 longitude = "78.45321937";
 "notification_title_ar" = "\U062a\U0645 \U0642\U0628\U0648\U0644 \U0639\U0631\U0636\U0643";
 "notification_title_en" = "Your offer is accepted";
 "notification_type" = "offer_accepted";
 "receiver_id" = 78;
 "request_id" = 355;
 "seen_status" = 1;
 "sender_id" = 40;
 };
 sound = default;
 }]
 
 */

/*
 Email :      Saleeemapp@gmail.com
 password:    saleem@1234
 */





