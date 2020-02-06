//
//  TrackOrderVC.swift
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

class TrackOrderVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    var sepCheckStr : String?
    
    @IBOutlet var starButtonOne: UIButton!
    @IBOutlet var starButtonTwo: UIButton!
    @IBOutlet var starButtonThree: UIButton!
    @IBOutlet var starButtonFour: UIButton!
    @IBOutlet var starButtonFive: UIButton!
    
    //var locationManager = CLLocationManager()
    //var locationsDriver = CLLocationCoordinate2D()
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
    
    @IBOutlet var spImageView: UIImageView!
    @IBOutlet var spNameLabel: UILabel!
    @IBOutlet var distanceStaticLabel: UILabel!
    @IBOutlet var timeStaticLabel: UILabel!
    
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var mapView1: GMSMapView!
    var latitude : String!
    var longitude : String!
    var latitude1 : String!
    var longitude1 : String!
    
    var currentLocation:CLLocationCoordinate2D!
    
    
    var requestIDStr : String?
    var providerIdStr : String?
    
    @IBOutlet var orderDetailsBtn: UIButton!
    
    lazy var locationManager: CLLocationManager = {

        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        print("location Manager")
          print("location Manager is working")
        return _locationManager

    }()
    
    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating")!
    let halfStarImage:  UIImage = UIImage(named: "check")!
    let emptyStarImage: UIImage = UIImage(named: "unselected_star")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = languageChangeString(a_str: "Track")
        self.distanceStaticLabel.text = languageChangeString(a_str: "Distance")
        self.timeStaticLabel.text = languageChangeString(a_str: "TIME")
        self.orderDetailsBtn.setTitle(languageChangeString(a_str: "Order Details"), for: UIControl.State.normal)

        self.orderConfirmLabel.text = languageChangeString(a_str: "order confirmed")
        self.ontheWayLabel.text = languageChangeString(a_str: "on the way")
        self.arrivedLabel.text = languageChangeString(a_str: "Arrived")
        self.startFixingLabel.text = languageChangeString(a_str: "Start fixing")
        self.completedLabel.text = languageChangeString(a_str: "Fixed")
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        orderDetailsBtn.layer.borderColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        orderDetailsBtn.layer.borderWidth = 1.0
        NotificationCenter.default.addObserver(self, selector: #selector(goToUserHome), name: NSNotification.Name(rawValue:"goToUserHome"), object: nil)
        mapView1.delegate = self
        if Reachability.isConnectedToNetwork() {
            isAuthorizedtoGetUserLocation()
            if sepCheckStr == "toHome"{
                userTrackingPendingServiceCall()
            }else{
                userTrackingServiceCall()
            }
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            
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
    @objc func goToUserHome()
    {
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
    override func viewWillAppear(_ animated: Bool) {
        
        timerTracker = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(updateTrackStatus), userInfo: nil, repeats: true)
        //RunLoop.current.add(timerTracker, forMode: RunLoopMode.defaultRunLoopMode)
    }
    override func viewDidDisappear(_ animated: Bool) {
        timerTracker.invalidate()
    }
    @objc func updateTrackStatus () {
        print("timer run");
        if sepCheckStr == "toHome"{
            userTrackingPendingServiceCall()
        }else{
        userTrackingServiceCall()
        }
    }

    
    @IBAction func orderDetailsAction(_ sender: Any) {
        let UserViewDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewDetailsVC") as! UserViewDetailsVC
        UserViewDetailsVC.reqID = self.requestIDStr
        UserViewDetailsVC.providerIdStr = self.providerIdStr
        self.navigationController?.pushViewController(UserViewDetailsVC, animated: false)
    }
    
    @IBAction func chatAction(_ sender: Any) {
        let ChatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        ChatVC.reqIdStr = self.requestIDStr
        ChatVC.providerIdStr = self.providerIdStr
        self.navigationController?.pushViewController(ChatVC, animated: false)
    }
    
    
    @IBAction func callBtnAction(_ sender: Any) {
        
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc : DeviceProblemPopUpVC = storyboard.instantiateViewController(withIdentifier: "DeviceProblemPopUpVC") as! DeviceProblemPopUpVC
//        
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        //navigationController.definesPresentationContext = true;
//        self.present(navigationController, animated: true, completion: nil)
        
        
        let mobileNo = self.phoneNumber
        let phoneUrl = URL(string: "telprompt:\(mobileNo ?? "")")
        if let anUrl = phoneUrl {
            if UIApplication.shared.canOpenURL(anUrl) {
                UIApplication.shared.openURL(anUrl)
            }
        }
        
    }
    
    
    @IBAction func currentLocationBtnAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
    }
    @IBAction func closeAction(_ sender: Any) {
       //comment self.navigationController?.popViewController(animated: true)
        //confOffer home
        //UserViewDetails navigate
        if sepCheckStr == "confOffer"{
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
        else if sepCheckStr == "UserViewDetails"{
            self.navigationController?.popViewController(animated: true)
        }
        else if sepCheckStr == "toHome"{
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
        locationMark.icon = UIImage(named: "SPLocation")?.withRenderingMode(.alwaysTemplate)
        locationMark.opacity = 0.75
        locationMark.isFlat = true
        
        //
        let locationMarker1 :GMSMarker!
        
        let position1 = CLLocationCoordinate2D(latitude: dLati , longitude: dLong )
        locationMarker1 = GMSMarker(position: position1 )
        locationMarker1.map = self.mapView1
        locationMarker1.appearAnimation =  .pop
        locationMarker1.icon = UIImage(named: "UserLocation")?.withRenderingMode(.alwaysTemplate)
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
        
        let locationstart = CLLocationCoordinate2D(latitude: dLati2, longitude: dLong2)
        let locationEnd = CLLocationCoordinate2D(latitude: dLati, longitude: dLong)
        
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
    func drawPath(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        
        
        let url1 = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAzdbEknCYu7dd1_V6uFSXtPaBxoz0uxtg"
        //AIzaSyAzdbEknCYu7dd1_V6uFSXtPaBxoz0uxtg
        //let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving")!
        
        let url = URL(string: url1)!
                
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
    
    // MARK: function for create a marker pin on map
   /* func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = self.mapView1
    }*/
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate location")
        
       
        
       /* let location = locations.last
        
        print("  did update core location is \(String(describing: location))")
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:16)
        locationsDriver = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        
        mapView1.animate(to: camera)
        
        //self.mapView.delegate = self
        //    //Finally stop updating location otherwise it will come again and again in this delegate
        locationManager.stopUpdatingLocation()
        
       /* let dummylatitude = 17.4764744
        let dummylongitude = 78.4557333
        
        let sdummylatitude = 17.486502419528474
        let sdummylongitude = 78.38483534753323*/
        
        
        let marker = GMSMarker()
        
        
        let markerImage = #imageLiteral(resourceName: "SPLocation").withRenderingMode(.alwaysOriginal)
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        
        //marker.position = CLLocationCoordinate2D(latitude: Double(dummylatitude), longitude: Double(dummylongitude))
        marker.position = CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
            //CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        marker.iconView = markerView
        
        let marker2 = GMSMarker()
        
        let markerImage2 = #imageLiteral(resourceName: "UserLocation").withRenderingMode(.alwaysOriginal)
        
        //creating a marker view
        let markerView2 = UIImageView(image: markerImage2)
        
       // marker2.position = CLLocationCoordinate2D(latitude: Double(sdummylatitude), longitude: Double(sdummylongitude))
        marker2.position = CLLocationCoordinate2D(latitude: Double(self.latitude1)!, longitude: Double(self.longitude1)!)
        marker2.iconView = markerView2
        
        
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(0.2)
//        marker2.position = (manager.location?.coordinate)!
//        CATransaction.commit()
        
        let from_loc = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let to_loc = CLLocationCoordinate2DMake(Double(self.latitude)!, Double(self.longitude)!)
        
        self.drawPath(startLocation: from_loc, endLocation: to_loc)
        //self.getPolylineRoute(from: from_loc, to: to_loc)
        DispatchQueue.main.async {
            
            marker.map = self.self.mapView1
            marker2.map = self.self.mapView1
        }*/
        
        
        
        let geocoder = GMSGeocoder()
        
        let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
        
        let position = CLLocationCoordinate2D(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)
        
        latitude = String(format: "%.8f", currentLocation.latitude)
        longitude = String(format: "%.8f",currentLocation.longitude)
        
      //  let latLang = "\(latitude), \(longitude)"
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
                
               /* today let dLati = Double(self.latitude ?? "") ?? 0.0
                let dLong = Double(self.longitude ?? "") ?? 0.0
                
                let locationMark :GMSMarker!
                let posit = CLLocationCoordinate2D(latitude: dLati , longitude: dLong )
                locationMark = GMSMarker(position: posit )
                locationMark.map = self.mapView1
                locationMark.appearAnimation =  .pop
                locationMark.icon = UIImage(named: "SPLocation")?.withRenderingMode(.alwaysTemplate)
                locationMark.opacity = 0.75
                locationMark.isFlat = true*/
                
            }
        }
        
        DispatchQueue.main.async {
            // self.gmapView?.camera = camera
            self.mapView1?.camera = camera
        }
        // self.gmapView?.animate(to: camera)
        self.mapView1?.animate(to: camera)
        manager.stopUpdatingLocation()
    
    }
    
    
    func userTrackingServiceCall ()
    {
        //https://www.volive.in/mobilefix/services/tracking?API-KEY=9173645&lang=en&request_id=182
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        //appde.loginUser = "customer"
        
        let userDetails = "\(Base_Url)tracking?"
        let parameters = ["API-KEY": APIKEY , "request_id" :self.requestIDStr!, "lang" : language]
        
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
                                       
                    let provider_rating = mainDetails["provider_rating"] as? String
                    
                    self.longitude1 = mainDetails["longitude"] as? String
                    self.latitude1  = mainDetails["latitude"] as? String
                    print("timer update latest lat and long",self.latitude1,self.longitude1)
                    
                    self.longitude = provider_details["longitude"] as? String
                    self.latitude = provider_details["latitude"] as? String
                    
                    self.phoneNumber = provider_details["phone"] as? String
                    let username =  provider_details["username"] as? String
                    let distance = mainDetails["distance"] as? String
                    
                    let profile_pic = provider_details["profile_pic"] as? String
                    let userImage = String(format: "%@%@", base_path,profile_pic!)
                    
                    let time = mainDetails["time"] as? String
                    let tracking_status = mainDetails["tracking_status"] as? String
                    let request_status = mainDetails["request_status"] as? String
                    
                    DispatchQueue.main.async {

                        if let moreRate1 = provider_rating{
                            let ourRating = Double(moreRate1)
                    
                            self.starButtonOne.setImage(self.getStarImage(starNumber: 1, forRating: ourRating!), for: UIControl.State.normal)
                            self.starButtonTwo.setImage(self.getStarImage(starNumber: 2, forRating: ourRating!), for: UIControl.State.normal)
                            self.starButtonThree.setImage(self.getStarImage(starNumber: 3, forRating: ourRating!), for: UIControl.State.normal)
                            self.starButtonFour.setImage(self.getStarImage(starNumber: 4, forRating: ourRating!), for: UIControl.State.normal)
                            self.starButtonFive.setImage(self.getStarImage(starNumber: 5, forRating: ourRating!), for: UIControl.State.normal)
                        }
                      
                        self.spImageView.sd_setImage(with: URL(string: userImage), completed: nil)
                        self.spNameLabel.text = username
                        self.distanceLabel.text = String(format: "%@ %@", distance!,"Km")
                        self.timeLabel.text = time
                        
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
                                self.arrivedLabel.text = languageChangeString(a_str: "Arrived")
                                
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
                            
                            if request_status == "1"{
                                
                                self.startFixingImageView.image =  UIImage.init(named: "startfixingselected4")
                                self.startFixingLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                self.startFixingLabel.text = languageChangeString(a_str: "Start fixing")
                                
                                self.arrivedImageView.image =  UIImage.init(named: "arrivedselected3")
                                self.arrivedLabel.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                                
                                self.orderConfirmLabel.text = languageChangeString(a_str: "order confirmed")
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
                        
//                        self.locationManager.delegate = self
//                        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                        self.locationManager.startUpdatingLocation()
//                        //google maps
//                        self.mapView1?.isMyLocationEnabled = true
                    }
                   
                    //com
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
    
    func userTrackingPendingServiceCall ()
    {
        //https://www.volive.in/mobilefix/services/user_track_pending?API-KEY=9173645&lang=en&user_id=40
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        //appde.loginUser = "customer"
        
        let userDetails = "\(Base_Url)user_track_pending?"
        let parameters = ["API-KEY": APIKEY , "user_id" :userID!, "lang" : language]
        
        print(parameters)
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        Alamofire.request(userDetails, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print("response of tracking",responseData,userDetails)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                if status == 1
                {
                    
                    // DispatchQueue.main.async {
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let mainDetails = responseData["details"] as! NSDictionary
                    let provider_details = mainDetails["provider_details"] as! NSDictionary
                   
                    self.requestIDStr = mainDetails["request_id"] as? String
                    self.providerIdStr = mainDetails["provider_id"] as? String
                    
                    self.longitude1 = mainDetails["longitude"] as? String
                    self.latitude1  = mainDetails["latitude"] as? String
                    print("timer update latest lat and long",self.latitude1,self.longitude1)
                    
                    self.longitude = provider_details["longitude"] as? String
                    self.latitude = provider_details["latitude"] as? String
                    
                    self.phoneNumber = provider_details["phone"] as? String
                    let username =  provider_details["username"] as? String
                    let distance = mainDetails["distance"] as? String
                    
                    let profile_pic = provider_details["profile_pic"] as? String
                    let userImage = String(format: "%@%@", base_path,profile_pic!)
                    
                    let time = mainDetails["time"] as? String
                    let tracking_status = mainDetails["tracking_status"] as? String
                    let request_status = mainDetails["request_status"] as? String
                    
                    DispatchQueue.main.async {
                        self.spImageView.sd_setImage(with: URL(string: userImage), completed: nil)
                        self.spNameLabel.text = username
                        self.distanceLabel.text = String(format: "%@ %@", distance!,"Km")
                        self.timeLabel.text = time
                        
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
                            self.arrivedLabel.text = languageChangeString(a_str: "Arrived")
                            
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
//                        self.locationManager.delegate = self
//                        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                        self.locationManager.startUpdatingLocation()
//                        //google maps
//                        self.mapView1?.isMyLocationEnabled = true
                    }
                    
                    //com
                    self.pinGenerate ()
                    
                }
                else
                {
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        let alert = UIAlertController(title:"Alert", message:message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title:"Done", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                self.timerTracker.invalidate()
                                self.navigationController?.popViewController(animated: true)
                                
                            case .cancel:
                                self.dismiss(animated: true, completion: nil)
                                
                            case .destructive:
                                print("destructive")
                                
                            }}))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                }
            }
        }
    }
    
    
}



