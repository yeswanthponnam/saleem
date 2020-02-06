//
//  SpHomeVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 18/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
// #2979FF #F1F1F1

import UIKit
import Alamofire
import CoreLocation

class SpHomeVC: UIViewController,CLLocationManagerDelegate {

    var backgroundTask: UIBackgroundTaskIdentifier? // global variable
    @IBOutlet var nameLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    
    @IBOutlet var issueCountLabel: UILabel!
    @IBOutlet var issuesStatic: UILabel!
    
    @IBOutlet var reqCountLabel: UILabel!
    @IBOutlet var pendingCountLabel: UILabel!
    @IBOutlet var completedCountLabel: UILabel!
    @IBOutlet var rejectCountLabel: UILabel!
    
    @IBOutlet var reqStaticLabel: UILabel!
    @IBOutlet var pendingStaticLabel: UILabel!
    @IBOutlet var completedStaticLabel: UILabel!
    @IBOutlet var rejectStaticLabel: UILabel!
    
    
    @IBOutlet var starBtnOne: UIButton!
    @IBOutlet var starBtnTwo: UIButton!
    @IBOutlet var starBtnThree: UIButton!
    @IBOutlet var starButtonFour: UIButton!
    @IBOutlet var starButtonFive: UIButton!
    
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var view_Profile: UIView!
    
    @IBOutlet weak var view_Requests: UIView!
    
    @IBOutlet weak var view_Pending: UIView!
    
    @IBOutlet weak var view_Completed: UIView!
    
    @IBOutlet weak var view_Reject: UIView!
    
    @IBOutlet var backBtn: UIBarButtonItem!
    var checkValue :Int!
    var reqTypeStr : String?
    
     var timer = Timer()
    
    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating")!
    let halfStarImage:  UIImage = UIImage(named: "check")!
    let emptyStarImage: UIImage = UIImage(named: "unselected_star")!
    
    var latitudeString : String?
    var longitudeString : String?
    
//    lazy var locationManager: CLLocationManager = {
//
//        var _locationManager = CLLocationManager()
//        _locationManager.delegate = self
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        _locationManager.activityType = .automotiveNavigation
//        _locationManager.distanceFilter = 10.0
//        return _locationManager
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reqStaticLabel.text = languageChangeString(a_str: "Requests")
        self.pendingStaticLabel.text = languageChangeString(a_str: "Pending")
        self.completedStaticLabel.text = languageChangeString(a_str: "Completed")
        self.rejectStaticLabel.text = languageChangeString(a_str: "Reject")
        self.issuesStatic.text = languageChangeString(a_str: "Issues Solved:")
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
         //navigationController?.navigationBar.barTintColor = UIColor (red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        backBtn.target = self
        backBtn.action = #selector(showLeftView(sender:))
        
        
        self.view_Requests.RoundFrameBackground(self.view_Requests, borderWidth: 0, cornerRadius: 10, borderColor: .white, backgroundColor: #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1))
        self.view_Pending.RoundFrameBackground(self.view_Pending, borderWidth: 0, cornerRadius: 10, borderColor: .white, backgroundColor: #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1))
        self.view_Completed.RoundFrameBackground(self.view_Completed, borderWidth: 0, cornerRadius: 10, borderColor: .white, backgroundColor: #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1))
        self.view_Reject.RoundFrameBackground(self.view_Reject, borderWidth: 0, cornerRadius: 10, borderColor: .white, backgroundColor: #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1))
        self.view_Profile.RoundFrameBackground(self.view_Profile, borderWidth: 1.0, cornerRadius: 12, borderColor: #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        self.img_Profile.setRounded()
        
        img_Profile.layer.cornerRadius = img_Profile.frame.size.height/2
        img_Profile.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.view_Requests.isUserInteractionEnabled = true
        self.view_Reject.isUserInteractionEnabled = true
        self.view_Pending.isUserInteractionEnabled = true
        self.view_Completed.isUserInteractionEnabled = true
        
        self.view_Requests.tag = 1
        self.view_Pending.tag = 2
        self.view_Completed.tag = 3
        self.view_Reject.tag = 4
        
        
        self.view_Requests.addGestureRecognizer(tap)
        self.view_Completed.addGestureRecognizer(tap1)
        self.view_Pending.addGestureRecognizer(tap2)
        self.view_Reject.addGestureRecognizer(tap3)
        

        NotificationCenter.default.addObserver(self, selector: #selector(refreshHomeList), name: NSNotification.Name(rawValue:"refreshHomeList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdateBackground), name: NSNotification.Name(rawValue:"locationUpdateBackground"), object: nil)
//        self.view.addSubview(self.view_Requests)
//        self.view.addSubview(self.view_Completed)
//        self.view.addSubview(self.view_Pending)
//        self.view.addSubview(self.view_Reject)

        // Do any additional setup after loading the view.
    }
    @objc func methodToRefresh(){
       // self.homeServiceCall()
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
    @objc func refreshHomeList()
    {
        self.homeServiceCall()
    }
    @objc func locationUpdateBackground()
    {
        
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "backgroundTask") {
        UIApplication.shared.endBackgroundTask(self.backgroundTask!)
        self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
        if Reachability.isConnectedToNetwork() {
            
            timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(SpHomeVC.sayHello), userInfo: nil, repeats: true)
            
        }else
        {
           // showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
             showToastForAlert (message:languageChangeString(a_str:"Please ensure you have proper internet connection")!)
       }
        
    }
    //MARK:- BASED ON RATING VALUES FILL THE IMAGES WITH DIFFERENT STARS
    func getStarImage(starNumber: Double, forRating rating: Double) -> UIImage {
        if rating >= starNumber {
            return fullStarImage
        } else if rating + 0.5 == starNumber {
            return halfStarImage
        } else {
            return emptyStarImage
        }
    }
    
    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork()
        {
            homeServiceCall()
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            //showToast(message: languageChangeString(a_str:"Please ensure you have proper internet connection") ?? "")
        }
        NotificationCenter.default.addObserver(self, selector:#selector(SpHomeVC.methodToRefresh), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
}
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    func isAuthorizedtoGetUserLocation() {
        //locationManager delegates
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                let alertController = UIAlertController(title: languageChangeString(a_str: "Location Services Disabled!") , message: languageChangeString(a_str: "Please enable Location Based Services for better results! You must enable location services to update location in background"), preferredStyle: .alert)
                
              
                let settingsAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Settings")!, comment: ""), style: .default) { (UIAlertAction) in
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    //UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                }
                
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                
            }
        } else {
            print("Location services are not enabled")
        }
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//
//        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
//            locationManager.requestWhenInUseAuthorization()
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        backBtn.target = self
        backBtn.action = #selector(presentLeftMenuViewController)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    
        let reqVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        reqVC.checkStr = "home"
        self.navigationController?.pushViewController(reqVC, animated: false)
    }
    

    @objc func handleTap(_ sender: UITapGestureRecognizer){
        
       // request_type: (1=total,2=pending,3=completed,4=rejected)
        if sender.view?.tag == 1 {
            
            self.checkValue = 1
            reqTypeStr = "1"
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
            gotoVC.checkIntValue = self.checkValue
            gotoVC.reqTypeStr = self.reqTypeStr
            gotoVC.checkStr = "req"
            self.navigationController?.pushViewController(gotoVC, animated: true)
            
            
        }else if sender.view?.tag == 2{
            
            self.checkValue = 2
            reqTypeStr = "2"
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
            
            gotoVC.checkIntValue = self.checkValue
            gotoVC.reqTypeStr = self.reqTypeStr
            gotoVC.checkStr = "req"
            self.navigationController?.pushViewController(gotoVC, animated: true)
            
        }
        else if sender.view?.tag == 3{
            
            self.checkValue = 3
            reqTypeStr = "3"
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
            
            gotoVC.checkIntValue = self.checkValue
            gotoVC.reqTypeStr = self.reqTypeStr
            gotoVC.checkStr = "req"
            self.navigationController?.pushViewController(gotoVC, animated: true)
            
        }
        else if sender.view?.tag == 4{
            
            self.checkValue = 4
            reqTypeStr = "4"
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
            
            gotoVC.checkIntValue = self.checkValue
            gotoVC.reqTypeStr = self.reqTypeStr
            gotoVC.checkStr = "req"
            self.navigationController?.pushViewController(gotoVC, animated: true)
            
        }
     
    }
  
    
    //delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let latitud = Double(userLocation.coordinate.latitude)
        let longitud = Double(userLocation.coordinate.longitude)
        
        self.latitudeString = String(format: "%.8f",userLocation.coordinate.latitude)
        self.longitudeString = String(format: "%.8f",userLocation.coordinate.longitude)
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            let placemark = placemarks! as [CLPlacemark]
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
//                
//                //self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
//            }
//        }
        
    
        let type = UserDefaults.standard.object(forKey: "type") as? String ?? ""
        
        if type == "3"{
            if UserDefaults.standard.string(forKey: "spId") != ""{
           //com today
                if Reachability.isConnectedToNetwork() {
                    
                    timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(SpHomeVC.sayHello), userInfo: nil, repeats: true)
                    
                }else
                {
                    showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                    // showToastForAlert (message:"Please ensure you have proper internet connection.")
                }
               
                
            }
            else{
                timer.invalidate()
                print("provider not login")
                
            }
        }
        else{
            timer.invalidate()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    @objc func sayHello()
    {
       /* https://www.volive.in/mobilefix/services/update_provider_location
        
        API-KEY:9173645
        lang:en
        latitude:17.426861
        longitude:78.452526
        provider_id:6*/
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        let details = "\(Base_Url)update_provider_location?"
        //let details = "\(Base_Url)update_provider_location?API-KEY=\(APIKEY)&latitude=\(self.latitudeString!)&longitude=\(self.longitudeString!)&provider_id=\(spId)&lang=\(language)"
        if latitudeString == nil && longitudeString == nil {
            latitudeString = ""
            longitudeString = ""
        }
        let parameters: Dictionary<String, Any> = ["API-KEY": APIKEY ,"latitude" :self.latitudeString! , "longitude" :self.longitudeString!,"provider_id" : spId,"lang":language ]
        print(details)
        print(parameters)
        
        let queue = DispatchQueue(label: "in.volive.www", qos: .background, attributes: .concurrent)
        
      /*  Alamofire.request(details, method: .post, parameters: parameters,encoding: URLEncoding.default, headers: nil)
            .responseJSON(queue: queue) { response in
                // check for errors
               
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("Inside error guard")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get products as JSON from API")
                    print("Error: \(response.result.error)")
                    return
                }
                 print(json)
                // get and print the title
                guard let products = json["products"] as? [[String: Any]]
                    
                    
                    else {
                    print("Could not get products from JSON")
                    return
                }
                print(products)
        }*/
        
        Alamofire.request(details, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON(queue: queue) { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                
                print(responseData)
                
                let status = responseData["status"] as! Int
               // let message = responseData["message"] as! String
                if status == 1
                {
                    DispatchQueue.main.async {
                        
                        print("Timer is calling.......")
                        
                    }
                }else
                {
                    print("Timer is Not calling...")
                }
                
                
            }
        }
    }
    
    //HOME SERVICE CALL
    func homeServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY=9173645
         lang=en&
         provider_id=6
         */
        
        let getProfile = "\(Base_Url)provider_requests_home"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String
        
        let parameters: Dictionary<String, Any> = [ "provider_id" : spId!, "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(getProfile, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    
                    if let userDetailsData = responseData["user_details"] as? Dictionary<String, AnyObject> {
                        
                        let userName = userDetailsData["name"] as? String?
                        let userImg = userDetailsData["profile_pic"] as? String?
                        let providerImage = String(format: "%@%@",base_path,userImg!!)
                        
                        let completed = responseData["completed"] as? String?
                        let pending = responseData["pending"] as? String?
                        let rejected = responseData["rejected"] as? String?
                        let provider_rating = responseData["provider_rating"] as? String?
                        
                        let total = responseData["total"] as? String?
                        
                       
                        DispatchQueue.main.async {
                            self.nameLabel.text = userName as? String
                            self.issueCountLabel.text = completed as? String
                            self.reqCountLabel.text = total as? String
                            self.pendingCountLabel.text = pending as? String
                            self.completedCountLabel.text = completed as? String
                            self.rejectCountLabel.text = rejected as? String
                            
                           self.img_Profile.sd_setImage(with: URL(string: providerImage), placeholderImage: UIImage.init(named: ""))
                         
                            
                            let str : String = provider_rating!!
                            let secStr : NSString = str as NSString
                            let flt : Double = Double(secStr.doubleValue)
                            
                            //cell.ratingView.value = flt
                            let moreRate1 = flt as? Double
                            
                            if let ourRating = moreRate1 {
                                self.starBtnOne.setImage(self.getStarImage(starNumber: 1, forRating: ourRating), for: UIControl.State.normal)
                                self.starBtnTwo.setImage(self.getStarImage(starNumber: 2, forRating: ourRating), for: UIControl.State.normal)
                                self.starBtnThree.setImage(self.getStarImage(starNumber: 3, forRating: ourRating), for: UIControl.State.normal)
                                self.starButtonFour.setImage(self.getStarImage(starNumber: 4, forRating: ourRating), for: UIControl.State.normal)
                                self.starButtonFive.setImage(self.getStarImage(starNumber: 5, forRating: ourRating), for: UIControl.State.normal)
                            }
                            
                            
                        }
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                       
                    }
                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    //self.showToastForAlert(message: message)
                    self.showToast(message: message)
                }
            }
        }
    }
    
}


extension UIView{
    
    public func RoundFrameBackground(_ aView: UIView!, borderWidth: CGFloat!, cornerRadius: CGFloat!, borderColor: UIColor, backgroundColor: UIColor) {
        aView.layer.borderWidth = borderWidth ; aView.layer.borderColor = borderColor.cgColor
        aView.backgroundColor = backgroundColor ; aView.clipsToBounds = true
        aView.layer.cornerRadius = cornerRadius
    }
    
    
    
}
