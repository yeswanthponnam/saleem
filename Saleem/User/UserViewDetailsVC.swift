//
//  UserViewDetailsVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 25/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import MOLH

class UserViewDetailsVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    var issuesList : [[String: Any]]!
    var issue_nameArray = [String]()
    
    var reqID : String?
    var providerIdStr : String?
    var offer_acceptedStr : String?
    
    @IBOutlet var amountBackView: UIView!
    @IBOutlet var fixedAmountStaticLabel: UILabel!
    @IBOutlet var fixedAmountLabel: UILabel!
    var totalAmountAfterDiscount: String?
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var nameStatic: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var brandStatic: UILabel!
    @IBOutlet var brandLabel: UILabel!
    
    @IBOutlet var mobileStatic: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    
    @IBOutlet var modelStatic: UILabel!
    @IBOutlet var modelLabel: UILabel!
    
    @IBOutlet var issueStatic: UILabel!
    @IBOutlet var issueLabel: UILabel!
    
    @IBOutlet var descStatic: UILabel!
    @IBOutlet var descTV: UITextView!
    
    @IBOutlet var issueUnderLineView: UIView!
    //var currentLocation:CLLocationCoordinate2D!
    
    var googleMapView : GMSMapView?
    
    var latitudeString : String! = ""
    var longitudeString : String! = ""
    var marker:GMSMarker!
    
    lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    
    var checkValue :Int!
    @IBOutlet var cancelOrderBtn: UIButton!
    @IBOutlet var trackOrderBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.mapView.delegate = self
        
        self.navigationItem.title = languageChangeString(a_str: "Order Details")
        self.nameStatic.text = languageChangeString(a_str: "Your Name")
        self.mobileStatic.text = languageChangeString(a_str: "Mobile Number")
        self.brandStatic.text = languageChangeString(a_str: "Mobile brand")
        self.modelStatic.text = languageChangeString(a_str: "Model")
        self.issueStatic.text = languageChangeString(a_str: "Problem Type")
        self.descStatic.text = languageChangeString(a_str: "Issue description")
        self.trackOrderBtn.setTitle(languageChangeString(a_str:"TRACK ORDER"), for: UIControl.State.normal)
        self.cancelOrderBtn.setTitle(languageChangeString(a_str:"CANCEL ORDER"), for: UIControl.State.normal)
        if MOLHLanguage.isRTLLanguage(){
            self.descTV.textAlignment = .right
        }
        else{
            self.descTV.textAlignment = .left
        }
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        //navigationController?.navigationBar.barTintColor = UIColor.init(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        self.cancelOrderBtn.layer.borderColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        self.cancelOrderBtn.layer.borderWidth = 1.0
        self.cancelOrderBtn.setTitleColor(#colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1), for: UIControl.State.normal)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pushViewController),
            name: NSNotification.Name(rawValue: "pushView"),
        object: nil)
        
        if Reachability.isConnectedToNetwork() {
            
            getRequestDetailsServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func pushViewController()
    {
//        let UserRequestsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
//        self.navigationController?.pushViewController(UserRequestsVC, animated: false)
        
        
//        let mainViewController = sideMenuController!
//        let UserRequestsVC = self.storyboard?.instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
//        let navigationController = mainViewController.rootViewController as! NavigationController
//        navigationController.pushViewController(UserRequestsVC, animated: true)
//        mainViewController.hideLeftView(animated: true, completionHandler: nil)
        let HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //        OrderTypeListVC.checkIntValue = self.checkValue
        //        OrderTypeListVC.checkStr = ""
        self.navigationController?.pushViewController(HomeViewController, animated: false)

    }
    @objc func onClcikBack()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func cancelOrderAction(_ sender: Any) {
//        let RequestDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestDetailsVC") as! RequestDetailsVC
//        RequestDetailsVC.check = "cancel"
//        self.navigationController?.pushViewController(RequestDetailsVC, animated: false)
        
//        let UserRequestsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
//      
//        self.navigationController?.pushViewController(UserRequestsVC, animated: false)
        //reqID
                UserDefaults.standard.setValue(self.reqID, forKey: "reqID")
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : AcceptOrderVC = storyboard.instantiateViewController(withIdentifier: "AcceptOrderVC") as! AcceptOrderVC
                self.present(vc, animated: true, completion: nil)
        
        
       
//        let alert = UIAlertController(title: "Alert", message: "Are you want to LogOut?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
//            switch action.style{
//            case .default:
//                self.dismiss(animated: true, completion: nil)
//
////                let storyboard = UIStoryboard(name:"Main", bundle: nil)
////                let window : UIWindow = ((UIApplication.shared.delegate?.window)!)!
////                window.rootViewController = storyboard.instantiateInitialViewController()
//            case .cancel:
//                self.dismiss(animated: true, completion: nil)
//
//            case .destructive:
//                print("destructive")
//
//            }}))
//
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
//            switch action.style{
//            case .default:
//                //self.dismiss(animated: true, completion: nil)
//
//                let mainViewController = self.sideMenuController!
//                let UserRequestsVC = self.storyboard?.instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
//                //                OrderTypeListVC.checkIntValue = self.checkValue
//                //                OrderTypeListVC.checkStr = ""
//               // UserRequestsVC.check = "side"
//                let navigationController = mainViewController.rootViewController as! NavigationController
//                navigationController.pushViewController(UserRequestsVC, animated: true)
//                mainViewController.hideLeftView(animated: true, completionHandler: nil)
//
//
//
//
//            case .cancel:
//                self.dismiss(animated: true, completion: nil)
//
//            case .destructive:
//                print("destructive")
//
//            }}))
//
//        self.present(alert, animated: true, completion: nil)
//
//
        
    }
    
    @IBAction func trackOrderAction(_ sender: Any) {
        let TrackOrderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
        TrackOrderVC.providerIdStr = self.providerIdStr
        TrackOrderVC.requestIDStr = self.reqID
        TrackOrderVC.sepCheckStr = "UserViewDetails"
        self.navigationController?.pushViewController(TrackOrderVC, animated: false)
    }
    
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
  
    
    //USER REQUESTDETAILS SERVICE CALL
    func getRequestDetailsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:*/
        
        let getProfile = "\(Base_Url)service_request_details"
      
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID!, "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(getProfile, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                self.issue_nameArray = [String]()
                
                if status == 1
                {
                    
                    if let userDetailsData = responseData["request_details"] as? Dictionary<String, AnyObject> {
                        
                        self.issuesList = userDetailsData["issues_list"] as? [[String: Any]]
                        
                        let userName = userDetailsData["name"] as? String?
                        let brand_name = userDetailsData["brand_name"] as? String?
                        let phone = userDetailsData["phone"] as? String?
                        let model_name = userDetailsData["model_name"] as? String?
                        let description = userDetailsData["description"] as? String?
                        let issues = userDetailsData["issues"] as? String?
                        let request_status = userDetailsData["request_status"] as? String?
                        let invoice_status = userDetailsData["invoice_status"] as? String?
                        let payment_status = userDetailsData["payment_status"] as? String?
                        let total_after_discount = userDetailsData["total_after_discount"] as? String?
                        
                        self.latitudeString = userDetailsData["latitude"] as? String
                        self.longitudeString = userDetailsData["longitude"] as? String
                        
                        for each in self.issuesList! {
                            let issue_name = each["issue_name"]  as! String
                            self.issue_nameArray.append(issue_name)
                        }
                        
                        DispatchQueue.main.async {
                            self.nameLabel.text = userName as? String
                            self.mobileLabel.text = phone as? String
                            self.brandLabel.text = brand_name as? String
                            self.modelLabel.text = model_name as? String
                            self.issueLabel.text = issues as? String
                            self.descTV.text = description as? String
                            self.totalAmountAfterDiscount = total_after_discount as? String
                            //self.fixedAmountLabel.text = total_after_discount as? String
                            self.fixedAmountLabel.text = String(format: "%@ %@", self.totalAmountAfterDiscount!,"SAR")
                            
                            if (self.issuesList?.count)! > 1{
                                self.issueUnderLineView.isHidden = false
                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapIssues))
                                //UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
                                self.issueLabel.addGestureRecognizer(tap)
                            }
                            else{
                                self.issueUnderLineView.isHidden = true
                            }
                            
                            //(0=pending,1=completed,2=in progress,3=cancelled)(optional)
                            if request_status == "0"{
                                self.cancelOrderBtn.isHidden = false
                                self.trackOrderBtn.isHidden = true
                                self.amountBackView.isHidden = true
                                self.fixedAmountLabel.isHidden = true
                                self.fixedAmountStaticLabel.isHidden = true
                            }
                            else if request_status == "1" && payment_status == "1" && invoice_status == "1"{
                                self.cancelOrderBtn.isHidden = true
                                self.trackOrderBtn.isHidden = true
                                self.amountBackView.isHidden = false
                                self.fixedAmountLabel.isHidden = false
                                self.fixedAmountStaticLabel.isHidden = false
                                self.fixedAmountStaticLabel.text = languageChangeString(a_str: "Fixed Amount")
                            }
                            else if request_status == "2"{
                                self.cancelOrderBtn.isHidden = true
                                self.trackOrderBtn.isHidden = false
                                self.amountBackView.isHidden = true
                                self.fixedAmountLabel.isHidden = true
                                self.fixedAmountStaticLabel.isHidden = true
                            }
                            else if request_status == "3"{
                                self.cancelOrderBtn.isHidden = true
                                self.trackOrderBtn.isHidden = true
                                self.amountBackView.isHidden = true
                                self.fixedAmountLabel.isHidden = true
                                self.fixedAmountStaticLabel.isHidden = true
                            }
                            else{
                                self.amountBackView.isHidden = true
                                self.fixedAmountLabel.isHidden = true
                                self.fixedAmountStaticLabel.isHidden = true
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
    
    @objc func onTapIssues(sender:UITapGestureRecognizer) {
        
        print("tap working")
        UserDefaults.standard.setValue(self.issue_nameArray, forKey: "list")
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }
    
}

