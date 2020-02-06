//
//  SpPendingDetailsVC.swift
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
class SpPendingDetailsVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    var userIdStr : String?
    
    var trackStatus: String?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var orderNoStatic: UILabel!
    @IBOutlet var orderNoLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var customerNameStatic: UILabel!
    @IBOutlet var mobileBrandStatic: UILabel!
    @IBOutlet var visitDateTimeStatic: UILabel!
    @IBOutlet var problemTypeStatic: UILabel!
    
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var mobileBrandLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var problemTypeLabel: UILabel!
    
    @IBOutlet var issueDescStatic: UILabel!
    @IBOutlet var issueDescTV: UITextView!
    
    @IBOutlet var issueViewUnderLine: UIView!
    
    var checkValue :Int!
    var reqID : String?
    
    var issuesList : [[String: Any]]!
    var issue_nameArray = [String]()
    
    @IBOutlet weak var btn_Track: UIButton!
    @IBOutlet weak var btn_CancelOrder: UIButton!
    @IBOutlet weak var btn_StartWork: UIButton!
    @IBOutlet weak var btn_Complete: UIButton!
    
    @IBOutlet var trackLocationStaticLabel: UILabel!
    @IBOutlet var viewIssuesBtn: UIButton!
    @IBOutlet var issueView: UIView!
    
    var indexValue : Int!
    
    @IBOutlet var mapView: GMSMapView!
    var googleMapView : GMSMapView?
    var currentLocation:CLLocationCoordinate2D!
    
    var latitudeString : String! = ""
    var longitudeString : String! = ""
    var marker:GMSMarker!
     var appDelegate = AppDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
         self.mapView.delegate = self
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationItem.title = languageChangeString(a_str: "Details")
        self.orderNoStatic.text = languageChangeString(a_str: "Order No")
        customerNameStatic.text = languageChangeString(a_str: "Customer Name")
        mobileBrandStatic.text = languageChangeString(a_str: "Mobile brand")
        visitDateTimeStatic.text = languageChangeString(a_str: "Visit date & time")
        problemTypeStatic.text = languageChangeString(a_str: "Problem Type")
        issueDescStatic.text = languageChangeString(a_str: "Issue description")
        trackLocationStaticLabel.text = languageChangeString(a_str: "Track customer Location")
        btn_Track.setTitle(languageChangeString(a_str: "TRACK"), for: UIControl.State.normal)
        btn_StartWork.setTitle(languageChangeString(a_str: "START WORK"), for: UIControl.State.normal)
        btn_Complete.setTitle(languageChangeString(a_str: "COMPLETE"), for: UIControl.State.normal)
        btn_CancelOrder.setTitle(languageChangeString(a_str: "CANCEL ORDER"), for: UIControl.State.normal)
       // btn_CancelOrder.isHidden = true
        
        if MOLHLanguage.isRTLLanguage(){
            self.issueDescTV.textAlignment = .right
        }
        else{
            self.issueDescTV.textAlignment = .left
        }
        
       /* com apr4 if indexValue == 0{
            self.viewIssuesBtn.isHidden = false
            self.issueView.isHidden = false
        }
        else{
            self.viewIssuesBtn.isHidden = true
            self.issueView.isHidden = true
        }*/
        
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        userImageView.clipsToBounds = true
        
        if Reachability.isConnectedToNetwork() {
            
            getSPPendingDetailsServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pushViewController1),
            name: NSNotification.Name(rawValue: "pushView4"),
            object: nil)
        
        // Do any additional setup after loading the view.
    }

    @objc func pushViewController1()
    {
        //        let UserRequestsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
        //        self.navigationController?.pushViewController(UserRequestsVC, animated: false)
//        self.checkValue = 4
//        let OrderTypeListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
//        OrderTypeListVC.checkIntValue = self.checkValue
//        OrderTypeListVC.checkStr = ""
//        self.navigationController?.pushViewController(OrderTypeListVC, animated: false)
        
        let SpHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpHomeVC") as! SpHomeVC
        //        OrderTypeListVC.checkIntValue = self.checkValue
        //        OrderTypeListVC.checkStr = ""
        self.navigationController?.pushViewController(SpHomeVC, animated: false)
 
        
    }
    
    @objc fileprivate func backButtonTapped() {
//        self.navigationController?.popViewController(animated: true)
        if appDelegate.chatTypeStr == "appDelNewPending"{
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
    
    // #MARK:- Complete Action
    
    @IBAction func viewIssuesAction(_ sender: Any) {
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }
    
    @IBAction func btn_Complete_Action(_ sender: UIButton) {
        //self.btn_Complete.isEnabled = false
//        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpCreateInvoiceVC") as! SpCreateInvoiceVC
//        gotoVC.reqID = self.reqID
//        self.navigationController?.pushViewController(gotoVC, animated: true)
        if Reachability.isConnectedToNetwork() {
            completeReqServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
       /* if self.btn_Complete.isEnabled == true{
        
        if Reachability.isConnectedToNetwork() {
            
            completeReqServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        }
        else{
            print("start work")
        }*/
    }
    
    // #MARK:- StartWork Action
    @IBAction func btn_StartWork_Action(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {
            
            starWorkServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
       
    }
    
    // #MARK:- CancelOrder Action
    @IBAction func btn_CancelOrder_Action(_ sender: UIButton) {
        
        UserDefaults.standard.setValue(reqID, forKey: "reqID")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : SPCancelOrderVC = storyboard.instantiateViewController(withIdentifier: "SPCancelOrderVC") as! SPCancelOrderVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btn_Track_Action(_ sender: UIButton) {
        
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpTrackVC") as! SpTrackVC
        gotoVC.reqIdStr = self.reqID
        gotoVC.userIdStr = self.userIdStr
        self.navigationController?.pushViewController(gotoVC, animated: true)
//        var navi = UINavigationController()
//        navi = UINavigationController.init(rootViewController: gotoVC)
//
//        self.present(navi, animated: true, completion: nil)
        
//        let TrackOrderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
//        TrackOrderVC.checkstr = "sp"
//        self.navigationController?.pushViewController(TrackOrderVC, animated: false)
        
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
    
    
    
    
    //SP PENDINGDETAILS SERVICE CALL
    func getSPPendingDetailsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         provider_id:*/
        
        let getProfile = "\(Base_Url)provider_service_request_details"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID!,"provider_id":spId, "lang" : language,"API-KEY":APIKEY]
        
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
                        
                        self.latitudeString = userDetailsData["latitude"] as? String
                        self.longitudeString = userDetailsData["longitude"] as? String
                        
                        let tracking_status = userDetailsData["tracking_status"] as? String?
                        self.trackStatus = tracking_status!
                        
                        //110 172 166
                        
                        if self.trackStatus == "3" || self.trackStatus == "4"{
                            self.btn_Complete.isEnabled = true
                            self.btn_StartWork.isEnabled = false
                           
                            self.btn_StartWork.layer.shadowColor = UIColor.lightGray.cgColor
                            self.btn_StartWork.layer.shadowOffset = CGSize(width: 5, height: 5)
                            self.btn_StartWork.layer.shadowRadius = 5
                            self.btn_StartWork.layer.shadowOpacity = 1.0
                            self.btn_StartWork.backgroundColor = UIColor.init(red: 221/255.0, green: 229/255.0, blue: 233/255.0, alpha: 1)
                           // self.btn_StartWork.setTitleColor(UIColor.init(white: 2.0, alpha: 0.1), for: UIControl.State.normal)
                            //self.btn_StartWork.setTitleShadowColor(UIColor.lightText, for: UIControl.State.normal)
                            //self.btn_StartWork.backgroundColor = UIColor.init(red: 110/255.0, green: 172/255.0, blue: 166/255.0, alpha: 1)
//                            self.btn_StartWork.setTitleShadowColor(UIColor.init(red: 110/255.0, green: 172/255.0, blue: 166/255.0, alpha: 1), for: UIControl.State.normal)
//                            self.btn_StartWork.titleShadowColor(for: UIControl.State.normal)
                        }
                        else{
                             self.btn_Complete.isEnabled = false
                             self.btn_StartWork.isEnabled = true
                            self.btn_Complete.layer.shadowColor = UIColor.lightGray.cgColor
                            self.btn_Complete.layer.shadowOffset = CGSize(width: 5, height: 5)
                            self.btn_Complete.layer.shadowRadius = 5
                            self.btn_Complete.layer.shadowOpacity = 1.0
                            self.btn_Complete.backgroundColor = UIColor.init(red: 221/255.0, green: 229/255.0, blue: 233/255.0, alpha: 1)
                                //UIColor.lightGray
                            //self.btn_Complete.setTitleColor(UIColor.init(white: 2.0, alpha: 0.1), for: UIControl.State.normal)
                           // self.btn_Complete.setTitleColor(UIColor.init(red: 221/255.0, green: 229/255.0, blue: 233/255.0, alpha: 1), for: UIControl.State.normal)
                            //self.btn_Complete.setTitleShadowColor(UIColor.lightText, for: UIControl.State.normal)
                        }
                        
                        for each in self.issuesList! {
                            
                            //let issue_id = each["issue_id"]  as! String
                            let issue_name = each["issue_name"]  as! String
                            //let issue_status = each["issue_status"]  as! String
                            
                            //self.issue_idArray.append(issue_id)
                            self.issue_nameArray.append(issue_name)
                            //self.issue_statusArray.append(issue_status)
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.customerNameLabel.text = userName as? String
                            self.orderNoLabel.text = order_id as? String
                            self.addressLabel.text = address as? String
                            self.mobileBrandLabel.text = brand_name as? String
                            self.dateLabel.text = date as? String
                            self.problemTypeLabel.text = issues as? String
                            self.issueDescTV.text = description as? String
                            self.userImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: ""))
                          
                            if (self.issuesList?.count)! > 1{
                                self.issueViewUnderLine.isHidden = false
                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapIssues))
                                //UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
                                self.problemTypeLabel.addGestureRecognizer(tap)
                            }
                            else{
                                self.issueViewUnderLine.isHidden = true
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
                    self.showToast(message: message)
                }
            }
        }
    }
    
    //STARTWORK SERVICE CALL
    func starWorkServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:*/
        
        let signup = "\(Base_Url)start_work"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID!, "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    DispatchQueue.main.async {
                        
                        //self.btn_Complete.isEnabled = true
//                        self.btn_StartWork.isEnabled = false
//                        self.btn_StartWork.isUserInteractionEnabled = false
                        //if self.trackStatus == "3" || self.trackStatus == "4"{
                            self.btn_Complete.isEnabled = true
                            self.btn_StartWork.isEnabled = false
                            self.btn_StartWork.backgroundColor = UIColor.init(red: 221/255.0, green: 229/255.0, blue: 233/255.0, alpha: 1)
                                //UIColor.init(red: 110/255.0, green: 172/255.0, blue: 166/255.0, alpha: 1)
                        self.btn_Complete.backgroundColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
                        
                        
                        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpTrackVC") as! SpTrackVC
                        gotoVC.reqIdStr = self.reqID
                        gotoVC.userIdStr = self.userIdStr
                        self.navigationController?.pushViewController(gotoVC, animated: true)
                        
                      //  }
                        //else{
                        
                      //  }dd
                        //https://www.ioscreator.com/tutorials/blur-effect-ios-tutorial
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                       // self.showToast(message: message)
                        
                    }
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    
                    self.btn_Complete.isEnabled = false
                    self.btn_StartWork.isEnabled = true
                    self.btn_Complete.backgroundColor = UIColor.init(red: 221/255.0, green: 229/255.0, blue: 233/255.0, alpha: 1)
                        //UIColor.init(red: 110/255.0, green: 172/255.0, blue: 166/255.0, alpha: 1)
                    //self.showToastForAlert(message: message)
//                    self.btn_StartWork.isEnabled = false
//                    self.btn_StartWork.isUserInteractionEnabled = false

                   // self.showToast(message: message)
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
    
    //COMPLETE REQUEST SERVICE CALL
    func completeReqServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:*/
        
        let signup = "\(Base_Url)complete_service_request"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID!, "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpCreateInvoiceVC") as! SpCreateInvoiceVC
                        gotoVC.reqID = self.reqID
                        gotoVC.backCheckStr = ""
                        self.navigationController?.pushViewController(gotoVC, animated: true)
                        self.showToast(message: message)
                    }
                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.showToast(message: message)
                }
            }
        }
    }
    
}



extension UIButton{
    func shadowForView(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
            //UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50).cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 30
        self.layer.shadowOffset = CGSize(width: 0 , height:2)
    }
}
