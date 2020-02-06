//
//  SpRequestsDetailsVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 19/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import MOLH
class SpRequestsDetailsVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    //for notification new req receive values
    var providerIdStr : String?
   
    
    //var issue_idArray = [String]()
    var issue_nameArray = [String]()
   // var issue_statusArray = [String]()
    var issuesList : [[String: Any]]!
    //var request_id : String!
    
    var getTimeStr : String?
    var seconds = Int()
    var timer = Timer()
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    
    @IBOutlet var issueUnderlineView: UIView!
    @IBOutlet var orderNoStatic: UILabel!
    @IBOutlet var orderNoLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var customerNameStatic: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var mobileBrandStatic: UILabel!
    @IBOutlet var mobileBrandLabel: UILabel!
    
    @IBOutlet var dateTimeStatic: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    
    @IBOutlet var timerView: UIView!
    @IBOutlet var orderView: UIView!
    
    @IBOutlet var problemTypeStatic: UILabel!
    @IBOutlet var problemTypeLabel: UILabel!
    
    @IBOutlet var issueDescStatic: UILabel!
    @IBOutlet var issueDescTV: UITextView!
    
    @IBOutlet var rejectOfferBtn: UIButton!
    @IBOutlet var sendOfferBtn: UIButton!
    
    var checkValue :Int!
    var reqTypeStr : String?
    
    var indexValue : Int!
    
    var reqID : String?
    
    @IBOutlet var viewIssuesBtn: UIButton!
    @IBOutlet var issueView: UIView!
    
    var googleMapView : GMSMapView?
    @IBOutlet var mapView: GMSMapView!
    
    var currentLocation:CLLocationCoordinate2D!
    
    var latitudeString : String! = ""
    var longitudeString : String! = ""
    var marker:GMSMarker!
    
    var appDelegate = AppDelegate()
    
    lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        DispatchQueue.main.async {
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = UIBezierPath(roundedRect: self.timerView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
//            //self.invoiceView.layer.mask = maskLayer
//            self.timerView.layer.mask = maskLayer
//            self.timerView.layer.masksToBounds = true
//            self.timerView.clipsToBounds = true
//        }
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        orderNoStatic.text = languageChangeString(a_str: "Order No")
        customerNameStatic.text = languageChangeString(a_str: "Customer Name")
        mobileBrandStatic.text = languageChangeString(a_str: "Mobile brand")
        dateTimeStatic.text = languageChangeString(a_str: "Visit date & time")
        problemTypeStatic.text = languageChangeString(a_str: "Problem Type")
        issueDescStatic.text = languageChangeString(a_str: "Issue description")
        rejectOfferBtn.setTitle(languageChangeString(a_str: "REJECT"), for: UIControl.State.normal)
        sendOfferBtn.setTitle(languageChangeString(a_str: "SEND OFFER"), for: UIControl.State.normal)
        //self.title = languageChangeString(a_str: "Request Details")
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if MOLHLanguage.isRTLLanguage(){
            self.issueDescTV.textAlignment = .right
        }
        else{
            self.issueDescTV.textAlignment = .left
        }
        DispatchQueue.main.async {
            self.timerView.layer.masksToBounds = true
            self.timerView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)

            self.orderView.layer.masksToBounds = true
            self.orderView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10.0)
        }
        
       self.mapView.delegate = self
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = barButtonItem
//        let btnLeftMenu: UIButton = UIButton()
//        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
//        btnLeftMenu.addTarget(self, action: #selector(backButtonTapped), for: UIControl.Event.touchUpInside)
//        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
//        let barButton = UIBarButtonItem(customView: btnLeftMenu)
//        self.navigationItem.leftBarButtonItem = barButton
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = languageChangeString(a_str:"Request Details")
        
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        userImageView.clipsToBounds = true
        
        if Reachability.isConnectedToNetwork() {
            
            getSPRequestDetailsServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
// comented apr 3       if indexValue == 0{
//            self.viewIssuesBtn.isHidden = false
//            self.issueView.isHidden = false
//        }
//        else{
//            self.viewIssuesBtn.isHidden = true
//            self.issueView.isHidden = true
//        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pushViewController),
            name: NSNotification.Name(rawValue: "pushView3"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pushViewController1),
            name: NSNotification.Name(rawValue: "pushView4"),
            object: nil)
        
        // Do any additional setup after loading the view.
    }

    @objc func pushViewController()
    {
        //        let UserRequestsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
        //        self.navigationController?.pushViewController(UserRequestsVC, animated: false)
//        self.checkValue = 4
//        let OrderTypeListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
//        OrderTypeListVC.checkIntValue = self.checkValue
//        OrderTypeListVC.checkStr = ""
//        self.navigationController?.pushViewController(OrderTypeListVC, animated: false)
        
         if appDelegate.chatTypeStr == "appDelNewReq"{
            self.checkValue = 1
            reqTypeStr = "1"
            let OrderTypeListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
            OrderTypeListVC.checkIntValue = self.checkValue
            OrderTypeListVC.reqTypeStr = self.reqTypeStr
            OrderTypeListVC.checkStr = "newReqBack"
            self.navigationController?.pushViewController(OrderTypeListVC, animated: false)
        }
        else{
        self.checkValue = 1
        reqTypeStr = "1"
        let OrderTypeListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
        OrderTypeListVC.checkIntValue = self.checkValue
        OrderTypeListVC.reqTypeStr = self.reqTypeStr
        OrderTypeListVC.checkStr = ""
        
        self.navigationController?.pushViewController(OrderTypeListVC, animated: false)
        }
        
    }
 
    @objc func pushViewController1()
    {
        let alert = UIAlertController(title:"", message:"Your Offer was sent successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.dismiss(animated: true, completion: nil)
                
            case .cancel:
                self.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
                
            }}))
        self.present(alert, animated: true, completion: nil)
     
//        self.checkValue = 1
//        let OrderTypeListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
//        OrderTypeListVC.checkIntValue = self.checkValue
//        OrderTypeListVC.checkStr = ""
//        self.navigationController?.pushViewController(OrderTypeListVC, animated: false)


    }
    @objc fileprivate func backButtonTapped() {
        if appDelegate.chatTypeStr == "appDelNewReq"{
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
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
  
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(SpRequestsDetailsVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func stopTimer()
    {
        if timer != nil {
            timer.invalidate()
            timer = Timer()
        }
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds)) //This will update the label.
        if seconds == 00 {
            stopTimer()
            print("stop timer called")
            
        }
    }
    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"00:%02i:%02i", minutes, seconds)
    }
    
    
    @IBAction func locationDirectionAction(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(latitudeString!),\(longitudeString!)&directionsmode=driving")! as URL)
        } else {
            NSLog("Can't use comgooglemaps://");
        }
        
    }
    
    @IBAction func btn_SendOffer_Action(_ sender: UIButton) {
        
        UserDefaults.standard.setValue(reqID, forKey: "reqID")
        
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpSendOfferVC") as! SpSendOfferVC
        
        self.present(gotoVC, animated: true, completion: nil)
       
    }
       
    @IBAction func viewIssuesAction(_ sender: Any) {
        
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }
    
    @IBAction func btn_Reject_Action(_ sender: UIButton) {
        
        UserDefaults.standard.setValue(reqID, forKey: "reqID")
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpRejectVC") as! SpRejectVC
        
        self.present(gotoVC, animated: true, completion: nil)
        
        
    }
    //loading mapview
    func loadMaps(){
        self.mapView.delegate = self
        self.googleMapView?.delegate = self
        let dLati = Double(self.latitudeString ?? "") ?? 0.0
        let dLong = Double(self.longitudeString ?? "") ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: dLati, longitude: dLong, zoom: 12)
        self.googleMapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        self.marker = GMSMarker()
        self.marker!.position = CLLocationCoordinate2DMake(dLati, dLong)
        // marker.tracksViewChanges = true
        self.marker?.map = self.googleMapView
        self.mapView.addSubview(self.googleMapView!)
        self.googleMapView?.settings.setAllGesturesEnabled(false)
        self.marker?.icon = UIImage.init(named: "location")
    }
    
    //SP REQUESTDETAILS SERVICE CALL
    func getSPRequestDetailsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         provider_id:*/
        
        let getProfile = "\(Base_Url)provider_service_request_details"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
       //for noti come let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        providerIdStr = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID!,"provider_id":providerIdStr!, "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(getProfile, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                //self.issue_idArray = [String]()
                self.issue_nameArray = [String]()
                //self.issue_statusArray = [String]()
                
                if status == 1
                {
                    
                    if let userDetailsData = responseData["request_details"] as? Dictionary<String, AnyObject> {
                        
                        self.issuesList = userDetailsData["issues_list"] as? [[String: Any]]
                        
                        let userName = userDetailsData["name"] as? String?
                        let brand_name = userDetailsData["brand_name"] as? String?
                        let order_id = userDetailsData["order_id"] as? String?
                        let address = userDetailsData["address"] as? String?
                      
                        let date = userDetailsData["date"] as? String?
                        let description = userDetailsData["description"] as? String?
                        let issues = userDetailsData["issues"] as? String?
                        let request_status = userDetailsData["request_status"] as? String?
                        let Image = userDetailsData["profile_pic"]  as! String
                        let image = String(format: "%@%@",base_path,Image)
                        self.getTimeStr = userDetailsData["request_timer"] as? String
                        
                        self.latitudeString = userDetailsData["latitude"] as? String
                        self.longitudeString = userDetailsData["longitude"] as? String
 
                        for each in self.issuesList! {
                            
                            //let issue_id = each["issue_id"]  as! String
                            let issue_name = each["issue_name"]  as! String
                            //let issue_status = each["issue_status"]  as! String
                            
                            //self.issue_idArray.append(issue_id)
                            self.issue_nameArray.append(issue_name)
                            //self.issue_statusArray.append(issue_status)
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.nameLabel.text = userName as? String
                            self.orderNoLabel.text = order_id as? String
                            self.addressLabel.text = address as? String
                            self.mobileBrandLabel.text = brand_name as? String
                            self.dateTimeLabel.text = date as? String
                            self.problemTypeLabel.text = issues as? String
                            self.issueDescTV.text = description as? String
                            self.userImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: ""))
                            //self.timerLabel.text = request_timer as? String
                           
                            if (self.issuesList?.count)! > 1{
                                self.issueUnderlineView.isHidden = false
                                 let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapIssues))
                                    //UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
                                self.problemTypeLabel.addGestureRecognizer(tap)
                            }
                            else{
                                self.issueUnderlineView.isHidden = true
                            }
                            
                            self.seconds = (self.getTimeStr?.secondFromString)!
                            if self.seconds == 0{
                            print("rsec",self.seconds)
                            //self.timerLabel.text = self.getTimeStr
                            self.timerLabel.text = self.timeString(time: TimeInterval(self.seconds)) //This will update the label.
                            }
                            else{
                            self.runTimer()
                            }
                        }
                  
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.loadMaps()
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
    
    @objc func onTapIssues(sender:UITapGestureRecognizer) {
        
        print("tap working")
        UserDefaults.standard.setValue(self.issue_nameArray, forKey: "list")
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }

}


//extension String{
//
//    var integer1: Int {
//        return Int(self) ?? 0
//    }
//
//    var secondFromString1 : Int{
//        var components: Array = self.components(separatedBy: ":")
//        //let hours = components[0].integer1
//        let minutes = components[0].integer1
//        let seconds = components[1].integer1
//       // return Int((hours * 60 * 60) + (minutes * 60) + seconds)
//        return Int((minutes * 60) + seconds)
//    }
//}
