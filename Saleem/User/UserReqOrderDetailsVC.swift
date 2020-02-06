//
//  UserReqOrderDetailsVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 18/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import MOLH
class UserReqOrderDetailsVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet var issueNamesUnderLineView: UIView!
    //data holding values
    var brandString : String!
    var modelString : String!
    var issueString : String!
    var issueDescString : String!
    var addressString : String!
    
    var brandIdString : String!
    var modelIdString : String!
    
   
    @IBOutlet var nameStatic: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var mobileStatic: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    
    @IBOutlet var brandStatic: UILabel!
    @IBOutlet var brandLabel: UILabel!
    
    @IBOutlet var modelStatic: UILabel!
    @IBOutlet var modelLabel: UILabel!
    
    @IBOutlet var issueStatic: UILabel!
    @IBOutlet var issueName: UILabel!
    
    @IBOutlet var issueDescStatic: UILabel!
    @IBOutlet var issueDescTV: UITextView!
    
    @IBOutlet var sendRequestBtn: UIButton!
    var idArray = [String]()
    var idIssueNameArray = [String]()
    
    
    @IBOutlet var mapView: GMSMapView!
    var currentLocation:CLLocationCoordinate2D!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
      
        let barButtonItem = UIBarButtonItem(title: languageChangeString(a_str: "Edit"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        self.navigationItem.title = languageChangeString(a_str: "Order Details")
        self.nameStatic.text = languageChangeString(a_str: "Your Name")
        self.mobileStatic.text = languageChangeString(a_str: "Mobile Number")
        self.brandStatic.text = languageChangeString(a_str: "Mobile brand")
        self.modelStatic.text = languageChangeString(a_str: "Model")
        self.issueStatic.text = languageChangeString(a_str: "Problem Type")
        self.issueDescStatic.text = languageChangeString(a_str: "Issue description")
        self.sendRequestBtn.setTitle(languageChangeString(a_str: "SEND REQUEST"), for: UIControl.State.normal)
        
        if MOLHLanguage.isRTLLanguage(){
            self.issueDescTV.textAlignment = .right
        }
        else{
            self.issueDescTV.textAlignment = .left
        }

        //retrieving array values  and store into label
       /* let defaults = UserDefaults.standard
        let array = defaults.object(forKey: "IdsStringissueArr") as? [String] ?? [String]()
        
        var string = ""
        
        for value in array {
            string = string.appendingFormat("\(value), ")
        }*/
        
        //retrieving array values  and store into label
        var string = ""
        string = idIssueNameArray.joined(separator: ",")
        issueName.text = string

        if idIssueNameArray.count > 1{
            issueNamesUnderLineView.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapIssues))
            self.issueName.addGestureRecognizer(tap)
        }
        else{
            issueNamesUnderLineView.isHidden = true
        }
        
        self.nameLabel.text = UserDefaults.standard.object(forKey: "userName") as? String
        self.mobileLabel.text = UserDefaults.standard.object(forKey: "phone") as? String
        self.brandLabel.text = self.brandString
        self.modelLabel.text = self.modelString
        self.issueDescTV.text = self.issueDescString
    
        
        // Do any additional setup after loading the view.
    }
    @objc func onTapIssues(sender:UITapGestureRecognizer) {
        
        print("tap working")
        UserDefaults.standard.setValue(self.idIssueNameArray, forKey: "list")
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        self.issueDescTV.setContentOffset(CGPoint.zero, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
        // Create and Add MapView to our main view
        
    }
    
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func loadMaps(){
        self.mapView.delegate = self
        //self.googleMapView?.delegate = self
        
        let dLati = Double(self.latitudeString ?? "") ?? 0.0
        let dLong = Double(self.longitudeString ?? "") ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: dLati, longitude: dLong, zoom: 10)
        //self.googleMapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        self.mapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        self.marker = GMSMarker()
        self.marker.position = currentLocation
        self.mapView?.settings.setAllGesturesEnabled(false)
        // marker.tracksViewChanges = true
        
//        //self.myMapView.addSubview(self.googleMapView!)
//        self.marker?.icon = UIImage.init(named: "Locationmarker")
//        //self.marker?.map = self.mapView
        
        
//        self.marker?.map = self.googleMapView
//        self.mapView.addSubview(self.googleMapView!)
//        self.marker?.icon = UIImage.init(named: "Locationmarker")
        
    }
    
    @objc fileprivate func backButtonTapped() {
        //edit clicked
        UserDefaults.standard.set("filt", forKey: "savebS")
        let HomeViewController: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        HomeViewController.editString = "edit"
        HomeViewController.brandString = brandString
        HomeViewController.modelString = modelString
        HomeViewController.issueDescString = self.issueDescTV.text
        HomeViewController.latitudeString = self.latitudeString
        HomeViewController.longitudeString = self.longitudeString
        HomeViewController.addressStr = self.addressString
        HomeViewController.idArray = self.idArray
        HomeViewController.brandIdString = self.brandIdString
        HomeViewController.modelIdString = self.modelIdString
        HomeViewController.idIssueNameArray = self.idIssueNameArray
        self.navigationController?.pushViewController(HomeViewController, animated: true)
        
    }
   
    
    @IBAction func backACtion(_ sender: Any) {
//        UserDefaults.standard.setValue("", forKey: "IdsStringissueArr")
//        UserDefaults.standard.setValue("", forKey: "IdsStringArr")
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editAction(_ sender: Any) {
       
    }
    
    @IBAction func sendRequestAction(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            
            sendRequestServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
 
    }
    
    //MARK:DID UPDATE LOCATIONS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate location")
        let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
       // let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
        let latitud = Double(self.latitudeString ?? "") ?? 0.0
        let longitud = Double(self.longitudeString ?? "") ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
        let position = CLLocationCoordinate2D(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)
        print(position)
        
        DispatchQueue.main.async {
            
            self.mapView.camera = camera
            self.loadMaps()
        }
        self.mapView?.animate(to: camera)
        manager.stopUpdatingLocation()
    }
    
    //USER SEND REQUEST SERVICE CALL
    func sendRequestServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         user_id:
         brand_id:
         model_id:
         issue_id:
         description:
         address:
         latitude:
         longitude:*/
        
        let sendrequest = "\(Base_Url)send_request"
        
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        //retrieving array values  and store into label
        var string = ""
        string = idArray.joined(separator: ",")
    
        let parameters: Dictionary<String, Any> = [ "user_id" : userID!,  "brand_id" : brandIdString!,"model_id":modelIdString! ,"issue_id" : string,"description" : self.issueDescTV.text! , "address" : addressString! ,"latitude" : latitudeString!, "longitude" : longitudeString! ,  "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(sendrequest, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    var request_id : String!
                    var offer_price :String!
                    var request_timer :String!

                    let genderCheck = UserDefaults.standard.object(forKey: "gender") as? String ?? ""
                    if let userDetailsData = responseData["req_details"] as? Dictionary<String, AnyObject> {
                        
                        request_id = userDetailsData["request_id"] as! String?
                        offer_price = userDetailsData["additional_amount"] as! String?
                        
                        request_timer = userDetailsData["request_timer"] as! String?
                        
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                  
                            let reqVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestDetailsVC") as! RequestDetailsVC
                            reqVC.check = ""
                            reqVC.reqID = request_id
                            reqVC.price = offer_price
                            reqVC.getStr = ""
                            reqVC.checkGenderStr = genderCheck
                            //reqVC.getTimeStr = request_timer
                                //UserDefaults.standard.object(forKey: "request_id") as? String
                            self.navigationController?.pushViewController(reqVC, animated: false)
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



