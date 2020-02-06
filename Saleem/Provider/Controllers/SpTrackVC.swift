//
//  SpTrackVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 21/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import MOLH

class SpTrackVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    var timerTracker:Timer! = nil
    var phoneNumber : String?
    
    @IBOutlet var sliderImageView: UIImageView!
    
    @IBOutlet var orderConfirmImageview: UIImageView!
    @IBOutlet var orderConfirmLabel: UILabel!
    @IBOutlet var ontheWayImageView: UIImageView!
    @IBOutlet var ontheWayLabel: UILabel!
    
    @IBOutlet var arrivedImageView: UIImageView!
    @IBOutlet var arrivedLabel: UILabel!
    
    @IBOutlet var startFixingImageView: UIImageView!
    @IBOutlet var startFixingLabel: UILabel!
    
    @IBOutlet var completedImageView: UIImageView!
    @IBOutlet var completedLabel: UILabel!
    
    
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var orderNoStatic: UILabel!
    @IBOutlet var orderNoLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    var reqIdStr : String?
    var userIdStr : String?
    
    var appDelegate = AppDelegate()
    
    var latitude : String!
    var longitude : String!
    var latitude1 : String!
    var longitude1 : String!
    
    var currentLocation:CLLocationCoordinate2D!
    @IBOutlet var mapView1: GMSMapView!
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

         appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "Cancel_234"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))
        
        self.orderConfirmLabel.text = languageChangeString(a_str: "order confirmed")
        self.ontheWayLabel.text = languageChangeString(a_str: "on the way")
        self.arrivedLabel.text = languageChangeString(a_str: "Arrived")
        self.startFixingLabel.text = languageChangeString(a_str: "Start fixing")
        self.completedLabel.text = languageChangeString(a_str: "Fixed")
        
         navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = languageChangeString(a_str: "Track")
        self.orderNoStatic.text = languageChangeString(a_str: "Order No")
        mapView1.delegate = self
        if Reachability.isConnectedToNetwork() {
            isAuthorizedtoGetUserLocation()
//            if appDelegate.loginUser == "customer" {
                
               SPTrackingServiceCall()
//
//            }
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        timerTracker = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(updateTrackStatus), userInfo: nil, repeats: true)
        //RunLoop.current.add(timerTracker, forMode: RunLoopMode.defaultRunLoopMode)
    }
    override func viewDidDisappear(_ animated: Bool) {
        timerTracker.invalidate()
    }
    @objc func updateTrackStatus () {
        print("timer run");
        if Reachability.isConnectedToNetwork() {
            
            SPTrackingServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        
    }
    @objc fileprivate func backButtonTapped() {
        
        
        if appDelegate.chatTypeStr == "appDelNewSpTrack"{
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
  
    @IBAction func chatAction(_ sender: Any) {
        let ChatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        ChatVC.reqIdStr = self.reqIdStr
        ChatVC.providerIdStr = self.userIdStr
        self.navigationController?.pushViewController(ChatVC, animated: false)
    }
    
    func pinGenerate ()
    {
        
        self.mapView1.clear()
        
        let dLati = Double(latitude1 ?? "") ?? 0.0
        let dLong = Double(longitude1 ?? "") ?? 0.0
        
        let dLati2 = Double(self.latitude ?? "") ?? 0.0
        let dLong2 = Double(self.longitude ?? "") ?? 0.0
        
        let locationMark :GMSMarker!
        let posit = CLLocationCoordinate2D(latitude: dLati2 , longitude: dLong2 )
        locationMark = GMSMarker(position: posit )
        locationMark.map = self.mapView1
        locationMark.appearAnimation =  .pop
        locationMark.icon = UIImage(named: "UserLocation")?.withRenderingMode(.alwaysTemplate)
        locationMark.opacity = 0.75
        locationMark.isFlat = true
        
        //
        let locationMarker1 :GMSMarker!
        
        let position1 = CLLocationCoordinate2D(latitude: dLati , longitude: dLong )
        locationMarker1 = GMSMarker(position: position1 )
        locationMarker1.map = self.mapView1
        locationMarker1.appearAnimation =  .pop
        locationMarker1.icon = UIImage(named: "SPLocation")?.withRenderingMode(.alwaysTemplate)
        locationMarker1.opacity = 0.75
        locationMarker1.isFlat = true
        
        
        //
        //        let dLati1 = Double(latitude ?? "") ?? 0.0
        //        let dLong1 = Double(longitude ?? "") ?? 0.0
        //
        //        let path = GMSMutablePath()
        //        path.add(CLLocationCoordinate2D(latitude: dLati1, longitude: dLong1))
        //        path.add(CLLocationCoordinate2D(latitude: dLati, longitude: dLong))
        //
        //
        //         // gmapView1.clear()
        //
        //        let polyline = GMSPolyline(path: path)
        //
        //        polyline.strokeColor = #colorLiteral(red: 0.9215686275, green: 0, blue: 0.1137254902, alpha: 1)
        //        polyline.strokeWidth = 6.0
        //        polyline.geodesic = true
        //        polyline.map = gmapView1
        
        let locationstart = CLLocation(latitude: dLati2, longitude: dLong2)
        let locationEnd = CLLocation(latitude: dLati, longitude: dLong)
        
        self.drawPath(startLocation: locationstart, endLocation: locationEnd)
        
        //         let loc : CLLocation = CLLocation(latitude: dLati, longitude: dLong)
        //         updateMapFrame(newLocation: loc, zoom: self.gmapView1.camera.zoom)
        
    }
    //Zoom map with cordinate
    func updateMapFrame(newLocation: CLLocation, zoom: Float) {
        let camera = GMSCameraPosition.camera(withTarget: newLocation.coordinate, zoom: 15)
        
        self.mapView1.animate(to: camera)
    }
    
   // destination coordinates in this method.
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
//        createMarker(titleMarker: "", iconMarker: (UIImage(named: "UserLocation")?.withRenderingMode(.alwaysTemplate))!, latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
//        createMarker(titleMarker: "", iconMarker: (UIImage(named: "SPLocation")?.withRenderingMode(.alwaysTemplate))!, latitude: endLocation.coordinate.latitude, longitude: endLocation.coordinate.longitude)
        
        let url1 = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAzdbEknCYu7dd1_V6uFSXtPaBxoz0uxtg"
        //let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving")!
        
        let url = URL(string: url1)!
        //let request = URLRequest(url: url)
//        let task1 = session.dataTask(with: url, completionHandler: {{ (data, response, error) in
//            <#code#>
//            }})
        
        DispatchQueue.main.async {
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    //                self.activityIndicator.stopAnimating()
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                }
                else {
                    do {
                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                            
                            guard let routes = json["routes"] as? NSArray else {
                                DispatchQueue.main.async {
                                    MobileFixServices.sharedInstance.loader(view: self.view)
                                }
                                return
                            }
                            
                            DispatchQueue.main.async {
                                if (routes.count > 0) {
                                    let overview_polyline = routes[0] as? NSDictionary
                                    let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                    
                                    let points = dictPolyline?.object(forKey: "points") as? String
                                    
                                    self.showPath(polyStr: points!)
                                    
                                    DispatchQueue.main.async {
                                        //                                self.activityIndicator.stopAnimating()
                                        MobileFixServices.sharedInstance.dissMissLoader()
                                        
                                        //                                let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                        //                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
                                        // self.mapView.moveCamera(update)
                                    }
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                //                                self.activityIndicator.stopAnimating()
                                MobileFixServices.sharedInstance.dissMissLoader()
                                
                                
                            }
                        }
                    }
                        
                    catch {
                        print("error in JSONSerialization")
                        DispatchQueue.main.async {
                            //                        self.activityIndicator.stopAnimating()
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                        }
                    }
                }
            })
            
            task.resume()
        }
    }
    func showPath(polyStr :String){
        DispatchQueue.main.async {
            let path = GMSPath(fromEncodedPath: polyStr)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.strokeColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
            polyline.map = self.mapView1 // Your map view
        }
    }
    
    
 /*   //MARK: - this is function for create direction path, from start location to desination location
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        createMarker(titleMarker: "", iconMarker: (UIImage(named: "LOc")?.withRenderingMode(.alwaysTemplate))!, latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
        createMarker(titleMarker: "", iconMarker: (UIImage(named: "Locationmarker")?.withRenderingMode(.alwaysTemplate))!, latitude: endLocation.coordinate.latitude, longitude: endLocation.coordinate.longitude)
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyCUFhnriBHpQPckrI5vvCPDyf3Z8U-2cBQ"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            print("json",json)
            let routes = json["routes"].arrayValue
            
           
            
            // print route using Polyline
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.gmapView1
                polyline.geodesic = true
            }
            
            
        }
        
    }*/
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = self.mapView1
    }
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate location")
        let geocoder = GMSGeocoder()
        
        let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
        
        let position = CLLocationCoordinate2D(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)
        
        latitude = String(format: "%.8f", currentLocation.latitude)
        longitude = String(format: "%.8f",currentLocation.longitude)
        
       // let latLang = "\(latitude), \(longitude)"
        UserDefaults.standard.set( latitude, forKey: "latitude")
        UserDefaults.standard.set( longitude, forKey: "longitude")
        
      //  print("current lat and long \(latLang)")
        
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
               // let result = response?.results()?.first
                
                //print("adress of that location is \(result!)")
                
                // let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                
                // self.addressOfuser = address?.strstr(needle: ",")
                //print(self.addressOfuser)
                
                //UserDefaults.standard.set(self.addressOfuser, forKey: "address")
                
                let dLati = Double(self.latitude ?? "") ?? 0.0
                let dLong = Double(self.longitude ?? "") ?? 0.0
                
                let locationMark :GMSMarker!
                let posit = CLLocationCoordinate2D(latitude: dLati , longitude: dLong )
                locationMark = GMSMarker(position: posit )
                locationMark.map = self.mapView1
                locationMark.appearAnimation =  .pop
                locationMark.icon = UIImage(named: "UserLocation")?.withRenderingMode(.alwaysTemplate)
                locationMark.opacity = 0.75
                locationMark.isFlat = true
                
            }
        }
        
        DispatchQueue.main.async {
           // self.gmapView?.camera = camera
            self.mapView1?.camera = camera
        }
       // self.gmapView?.animate(to: camera)
        self.mapView1?.animate(to: camera)
        manager.stopUpdatingLocation()
       /* if appDelegate.loginUser == "customer" {
        
        }else{
            
            pinGenerate ()
        }*/
        
        
        
    }
    
    @IBAction func callBtnAction(_ sender: Any) {
        let mobileNo = self.phoneNumber
        let phoneUrl = URL(string: "telprompt:\(mobileNo ?? "")")
        if let anUrl = phoneUrl {
            if UIApplication.shared.canOpenURL(anUrl) {
                UIApplication.shared.openURL(anUrl)
            }
        }
        
    }
    
    func SPTrackingServiceCall ()
    {
        //https://www.volive.in/mobilefix/services/tracking?API-KEY=9173645&lang=en&request_id=182
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        //appde.loginUser = "customer"
        
           let userDetails = "\(Base_Url)tracking?"
           let parameters = ["API-KEY": APIKEY , "request_id" :self.reqIdStr!, "lang" : language]
      
        print(parameters)
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        Alamofire.request(userDetails, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print("response of tracking",responseData,userDetails)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                if status == 1
                {
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let mainDetails = responseData["details"] as! NSDictionary
                    let provider_details = mainDetails["provider_details"] as! NSDictionary
                    let user_details = mainDetails["user_details"] as! NSDictionary
                    
                    self.longitude1 =  provider_details["longitude"] as? String
                    self.latitude1  = provider_details["latitude"] as? String
                    print("timer update latest lat and long",self.latitude1,self.longitude1)
                    
                    self.longitude =  mainDetails["longitude"] as? String
                    self.latitude = mainDetails["latitude"] as? String
                   
                    let username =  user_details["username"] as? String
                    let phone = user_details["phone"] as? String
                    self.phoneNumber = phone
                    let profile_pic = user_details["profile_pic"] as? String
                    let userImage = String(format: "%@%@", base_path,profile_pic!)
                    let email = user_details["email"] as? String
                    let order_id = mainDetails["order_id"] as? String
                    let tracking_status = mainDetails["tracking_status"] as? String
                    let request_status = mainDetails["request_status"] as? String
                    
                    DispatchQueue.main.async {
                        self.userImageView.sd_setImage(with: URL(string: userImage), completed: nil)
                        self.userNameLabel.text = username
                        self.phoneNumberLabel.text = phone
                        self.emailLabel.text = email
                        self.orderNoLabel.text = String(format: "%@%@", "#",(order_id as? String)!)
                        
                        ////`tracking_status` in tracking (1=on the way,2= arrived,3=work started)
                        if MOLHLanguage.isRTLLanguage(){
                        if tracking_status == "1"{
                            
                            self.orderConfirmLabel.text = languageChangeString(a_str: "order confirmed")
                            self.orderConfirmLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.orderConfirmImageview.image =  UIImage.init(named: "orderconfirmselected1")
                            self.sliderImageView.image = UIImage.init(named: "slider3ar")
                            
                            self.ontheWayLabel.text = languageChangeString(a_str: "on the way")
                            self.ontheWayLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.ontheWayImageView.image =  UIImage.init(named: "onthewaySelected2")
                        }
                        else if tracking_status == "2"{
                            self.sliderImageView.image = UIImage.init(named: "slider4ar")
                            self.arrivedImageView.image =  UIImage.init(named: "arrivedselected3")
                            self.arrivedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            
                            self.orderConfirmLabel.text = languageChangeString(a_str: "order confirmed")
                            self.orderConfirmLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.orderConfirmImageview.image =  UIImage.init(named: "orderconfirmselected1")
                            
                            self.ontheWayLabel.text = languageChangeString(a_str: "on the way")
                            self.ontheWayLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.ontheWayImageView.image =  UIImage.init(named: "onthewaySelected2")
                            
                        }
                        else if tracking_status == "3"{
                            self.sliderImageView.image = UIImage.init(named: "slider5ar")
                            self.startFixingImageView.image =  UIImage.init(named: "startfixingselected4")
                            self.startFixingLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.startFixingLabel.text = languageChangeString(a_str: "Start fixing")
                            
                            self.arrivedImageView.image =  UIImage.init(named: "arrivedselected3")
                            self.arrivedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.arrivedLabel.text = languageChangeString(a_str: "Arrived")
                            
                            self.orderConfirmLabel.text = languageChangeString(a_str: "order confirmed")
                            self.orderConfirmLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.orderConfirmImageview.image =  UIImage.init(named: "orderconfirmselected1")
                            
                            self.ontheWayLabel.text = languageChangeString(a_str: "on the way")
                            self.ontheWayLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.ontheWayImageView.image =  UIImage.init(named: "onthewaySelected2")
                            
                        }
                        else{
                            self.arrivedImageView.image =  UIImage.init(named: "arrivedunselected3")
                            self.arrivedLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                            
                            self.startFixingImageView.image =  UIImage.init(named: "startfixingunselected4")
                            self.startFixingLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                            
                            self.completedImageView.image =  UIImage.init(named: "completeunselected5")
                            self.completedLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                        }
                        
                        if request_status == "1"{
                            
                            self.startFixingImageView.image =  UIImage.init(named: "startfixingselected4")
                            self.startFixingLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            
                            self.arrivedImageView.image =  UIImage.init(named: "arrivedselected3")
                            self.arrivedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            
                            self.orderConfirmLabel.text = "order confirmed"
                            self.orderConfirmLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.orderConfirmImageview.image =  UIImage.init(named: "orderconfirmselected1")
                            
                            self.ontheWayLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            self.ontheWayImageView.image =  UIImage.init(named: "onthewaySelected2")
                            
                            self.sliderImageView.image = UIImage.init(named: "slider6ar")
                            self.completedImageView.image =  UIImage.init(named: "completeselected5")
                            self.completedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                            
                        }
                    }
                        else{
                            if tracking_status == "1"{
                                
                                self.orderConfirmLabel.text = "order confirmed"
                                self.orderConfirmLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.orderConfirmImageview.image =  UIImage.init(named: "orderconfirmselected1")
                                self.sliderImageView.image = UIImage.init(named: "slider3")
                                
                                self.ontheWayLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.ontheWayImageView.image =  UIImage.init(named: "onthewaySelected2")
                            }
                            else if tracking_status == "2"{
                                self.sliderImageView.image = UIImage.init(named: "slider4")
                                self.arrivedImageView.image =  UIImage.init(named: "arrivedselected3")
                                self.arrivedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                
                                self.orderConfirmLabel.text = "order confirmed"
                                self.orderConfirmLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.orderConfirmImageview.image =  UIImage.init(named: "orderconfirmselected1")
                                
                                self.ontheWayLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.ontheWayImageView.image =  UIImage.init(named: "onthewaySelected2")
                                
                            }
                            else if tracking_status == "3"{
                                self.sliderImageView.image = UIImage.init(named: "slider5")
                                self.startFixingImageView.image =  UIImage.init(named: "startfixingselected4")
                                self.startFixingLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                
                                self.arrivedImageView.image =  UIImage.init(named: "arrivedselected3")
                                self.arrivedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                
                                self.orderConfirmLabel.text = "order confirmed"
                                self.orderConfirmLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.orderConfirmImageview.image =  UIImage.init(named: "orderconfirmselected1")
                                
                                self.ontheWayLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.ontheWayImageView.image =  UIImage.init(named: "onthewaySelected2")
                                
                            }
                            else{
                                self.arrivedImageView.image =  UIImage.init(named: "arrivedunselected3")
                                self.arrivedLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                                
                                self.startFixingImageView.image =  UIImage.init(named: "startfixingunselected4")
                                self.startFixingLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                                
                                self.completedImageView.image =  UIImage.init(named: "completeunselected5")
                                self.completedLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                            }
                            
                            if request_status == "1"{
                                
                                self.startFixingImageView.image =  UIImage.init(named: "startfixingselected4")
                                self.startFixingLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                
                                self.arrivedImageView.image =  UIImage.init(named: "arrivedselected3")
                                self.arrivedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                
                                self.orderConfirmLabel.text = "order confirmed"
                                self.orderConfirmLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.orderConfirmImageview.image =  UIImage.init(named: "orderconfirmselected1")
                                
                                self.ontheWayLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.ontheWayImageView.image =  UIImage.init(named: "onthewaySelected2")
                                
                                self.sliderImageView.image = UIImage.init(named: "slider6")
                                self.completedImageView.image =  UIImage.init(named: "completeselected5")
                                self.completedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                
                            }
                        }
                    }
                    
                    self.pinGenerate ()
                 
                }
                else
                {
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToast(message: message)
                    }
                }
            }
        }
    }
    
}

//`tracking_status` in tracking (1=on the way,2= arrived,3=work started)
//(17.403080, 78.468556) user location 
