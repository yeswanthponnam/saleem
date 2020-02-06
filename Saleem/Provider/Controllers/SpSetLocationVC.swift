//
//  SpSetLocationVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 25/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import MOLH

class SpSetLocationVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    var locationManager = CLLocationManager()
    
    var checkMapString : String! = ""
    
    var checkMapString2 :String! = ""
    @IBOutlet var confirmLocationBtn: UIButton!
    @IBOutlet var setServiceLocationStaticLabel: UILabel!
    @IBOutlet var locationView: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var addressTV: UITextView!
    
    var checkStr : String?
    
    //for map
    var streetAddress : String! = ""
    var addressStr : String! = ""
    var latitudeString : String! = ""
    var longitudeString : String! = ""
    
    var currentLocation:CLLocationCoordinate2D!
    
    var latStr : String?
    var langStr :String?
    
//    lazy var locationManager: CLLocationManager = {
//
//        var _locationManager = CLLocationManager()
//        _locationManager.delegate = self
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        _locationManager.activityType = .automotiveNavigation
//        _locationManager.distanceFilter = 10.0
//        return _locationManager
//    }()
    
    
    
    @IBOutlet weak var txt_Location: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.mapView.isMyLocationEnabled = true
//        self.mapView.delegate = self
        
        self.setServiceLocationStaticLabel.text = languageChangeString(a_str: "Set your service location")
        self.confirmLocationBtn.setTitle(languageChangeString(a_str: "CONFIRM LOCATION"), for: UIControl.State.normal)
        
        if MOLHLanguage.isRTLLanguage(){
            self.addressTV.textAlignment = .right
        }else{
            self.addressTV.textAlignment = .left
        }
        
//  working      if Reachability.isConnectedToNetwork()
//        {
//            self.isAuthorizedtoGetUserLocation()
//        }else
//        {
//            //showToastForError (message:"Please make sure that you have connected to proper internet.")
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.showUpdatedValueOnMap(_:)), name: NSNotification.Name(rawValue:"showUpdatedValueOnMap"), object: nil)
        
       
        
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.pushViewController1),
//            name: NSNotification.Name(rawValue: "pushView6"),
//            object: nil)
        
        //self.txt_Location.setBottomLineBorder()
        
    }

//    @objc func pushViewController1()
//    {
//        //        let UserRequestsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
//        //        self.navigationController?.pushViewController(UserRequestsVC, animated: false)
//        //        self.checkValue = 4
//        //        let OrderTypeListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
//        //        OrderTypeListVC.checkIntValue = self.checkValue
//        //        OrderTypeListVC.checkStr = ""
//        //        self.navigationController?.pushViewController(OrderTypeListVC, animated: false)
//        
//        let SpHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpHomeVC") as! SpHomeVC
//        //        OrderTypeListVC.checkIntValue = self.checkValue
//        //        OrderTypeListVC.checkStr = ""
//        self.navigationController?.pushViewController(SpHomeVC, animated: false)
//    }
    @objc func showUpdatedValueOnMap(_ notification: NSNotification){
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["lat"] as? String
            longitudeString = dict["lang"] as? String
            addressStr = dict["address"] as? String
            checkMapString2 = dict["map1"] as? String
            print("latitudeString",latitudeString)
            print("longitudeString",longitudeString)
            print("addressStr",addressStr)
            print("checkMapString2",checkMapString)
        }
        
        self.addressTV.text = addressStr
    }
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//  working     self.mapView.delegate = self
//        if Reachability.isConnectedToNetwork()
//        {
//            self.isAuthorizedtoGetUserLocation()
//        }else
//        {
//            //showToastForError (message:"Please make sure that you have connected to proper internet.")
//        }
//
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundRefreshHome), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //locationManager delegates
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                let alertController = UIAlertController(title: languageChangeString(a_str: "Location Services Disabled!") , message: languageChangeString(a_str: "Please enable Location Based Services for better results! We promise to keep your location private"), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Cancel")!, comment: ""), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Settings")!, comment: ""), style: .default) { (UIAlertAction) in
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    //UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                //google maps
                mapView?.isMyLocationEnabled = true
                
            }
        } else {
            print("Location services are not enabled")
        }
        self.navigationController?.navigationBar.isHidden = true
      
        
    }
    
    @objc func willEnterForegroundRefreshHome() {
        
        //Register for
        registerForLocationUpdates()
    }
    func registerForLocationUpdates(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                //  self.showToastForAlert(message: "Access Denied")
                
                let alertController = UIAlertController(title: languageChangeString(a_str: "Location Services Disabled!") , message: languageChangeString(a_str: "Please enable Location Based Services for better results! We promise to keep your location private"), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Cancel")!, comment: ""), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Settings")!, comment: ""), style: .default) { (UIAlertAction) in
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    //UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = true
                
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }

    @IBAction func btn_Back_Action(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_ConfirmLocation(_ sender: UIButton) {
        
       ////  commented on march 20  NotificationCenter.default.post(name: Notification.Name("pushView5"), object: nil)
        checkMapString = "confirm"
        let imageDataDict:[String: String] = ["key": latitudeString,"key1":longitudeString,"key2":self.addressTV.text!,"map":checkMapString]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getLocation"), object: nil, userInfo: imageDataDict)
        
        self.dismiss(animated: true) {
            print("dismmissed")
        }
        //17.419561, 78.450008
//        let userType = UserDefaults.standard.object(forKey: "type") as? String
//        if userType == "1"{
//
//        NotificationCenter.default.post(name: Notification.Name("pushView5"), object: nil)
//        self.dismiss(animated: true) {
//            print("dismmissed")
//        }
//        }
//        else{
//
//        }
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showCurrentLocationAction(_ sender: Any) {
        //latitudeString = ""
        checkMapString2 = ""
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
//        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    //for map
    
    func wrapperFunctionToShowPosition(mapView:GMSMapView){
        
       /* var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = mapView.camera.target.latitude
            //Double("\(self.latitudeString)")!
        //21.228124
        let lon: Double = mapView.camera.target.longitude
            //Double("\(self.longitudeString)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                else{
               let pm = placemarks! as [CLPlacemark]
                //! as [CLPlacemark]
                
                    if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    self.addressStr = addressString
                    self.addressTV.text = self.addressStr
                    print(addressString)
                }
                }
        })*/
        
        
        let geocoder = GMSGeocoder()
        
 // now rnni just now
//        let latitud = mapView.camera.target.latitude
//        let longitud = mapView.camera.target.longitude
//
//        self.latitudeString = String(format: "%.8f", mapView.camera.target.latitude)
//        self.longitudeString = String(format: "%.8f", mapView.camera.target.longitude)
//        let position = CLLocationCoordinate2DMake( latitud, longitud)
        
 //before com
//        self.latStr = String(format: "%.8f", mapView.camera.target.latitude)
//        self.langStr = String(format: "%.8f", mapView.camera.target.longitude)
//        let latitud = Double(self.latStr ?? "") ?? 0.0
//        let longitud = Double(self.langStr ?? "") ?? 0.0
//                let position = CLLocationCoordinate2DMake( latitud, longitud)
        
        self.latitudeString = String(format: "%.8f", mapView.camera.target.latitude)
        self.longitudeString = String(format: "%.8f", mapView.camera.target.longitude)
        print("wrap lat\(self.latitudeString)")
        print("wrap lang\(self.longitudeString)")
        let latitud = Double(self.latitudeString ?? "") ?? 0.0
        let longitud = Double(self.longitudeString ?? "") ?? 0.0
        let position = CLLocationCoordinate2DMake( latitud, longitud)
        
      /*  var pos1 = CLLocationCoordinate2D()
        if self.checkMapString2 == "map1"{
            if self.latitudeString != ""{
                self.latitudeString = String(format: "%.8f", mapView.camera.target.latitude)
                self.longitudeString = String(format: "%.8f", mapView.camera.target.longitude)
                print("wrap lat\(self.latitudeString)")
                print("wrap lang\(self.longitudeString)")
                let latitud = Double(self.latitudeString ?? "") ?? 0.0
                let longitud = Double(self.longitudeString ?? "") ?? 0.0
               pos1 = CLLocationCoordinate2DMake( latitud, longitud)
            }
        }*/
        
        
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                // print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                guard let result = response?.results()?.first else {
                    return
                }
                print("adress of that location is \(result)")
                self.addressStr = result.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                // self.landMarkStr = result?.subLocality
                // self.cityStr = result?.locality
                
                print("Address Str Is :\(self.addressStr ?? "")")
                //print("LandMark Str Str Is :\(self.landMarkStr ?? "")")
                
                    //self.addressStr
                DispatchQueue.main.async {
                    self.addressTV.text = self.addressStr
                    //self.locationBtn.setTitle(self.landMarkStr, for: UIControlState.normal)
                    //self.txt_locationName.text = self.landMarkStr
                    //                    if self.languageString == "ar"{
                    //                        self.txt_streetAddress.textAlignment = NSTextAlignment.right
                    //                        self.addressTextView.text = self.addressStr
                    //                    }else{
                    //                        self.txt_streetAddress.textAlignment = NSTextAlignment.left
                    //                        self.addressTextView.text = self.addressStr
                    //                    }
                   // self.addressTV.text = self.addressStr
                    //self.txt_city.text = self.cityStr
                    //                    if self.txt_streetAddress.text.count > 0{
                    //                        self.addressPlaceHolderLabel.isHidden = true
                    //                    }
                }
            }
        }
        
    }
    
     //MARK:mapview delegate methods
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("didchange")
        //called everytime
        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
       // wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    //MARK:DID UPDATE LOCATIONS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate location")
        let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
     /*   let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        //let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
        let latitud = Double(self.latitudeString ?? "") ?? 0.0
        let longitud = Double(self.longitudeString ?? "") ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
        let position = CLLocationCoordinate2D(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)
        print(position)
        
        // self.setupLocationMarker(coordinate: position)
        
        DispatchQueue.main.async {
            
            self.mapView.camera = camera
        }
        self.mapView?.animate(to: camera)
        manager.stopUpdatingLocation()
    }*/
    
//    DispatchQueue.main.async {
//        if self.checkMapString == "map1"{
//            //self.latitudeString == ""{
//            print("if check map1 str")
//    print("latitudeString is empty")
//    let userLocation:CLLocation = locations[0] as CLLocation
//    self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
//            let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:self.currentLocation.longitude, zoom: 15)
//            let position = CLLocationCoordinate2D(latitude:  self.currentLocation.latitude, longitude: self.currentLocation.longitude)
//    print(position)
//    DispatchQueue.main.async {
//
//    self.mapView.camera = camera
//    }
//   // self.mapView?.animate(to: camera)
//   // manager.stopUpdatingLocation()
//    }
//    else{
//      print("check map str")
//    print("latitudeString is not empty")
//    let latitud = Double(self.latitudeString ?? "") ?? 0.0
//    let longitud = Double(self.longitudeString ?? "") ?? 0.0
//    let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
//    let position = CLLocationCoordinate2D(latitude:  latitud, longitude: longitud)
//    print(position)
//    DispatchQueue.main.async {
//
//    self.mapView.camera = camera
//    }
//   // self.mapView?.animate(to: camera)
//        //manager.stopUpdatingLocation()
//    }
//        manager.stopUpdatingLocation()
//}
//    }
        
        
        DispatchQueue.main.async {
            if self.checkMapString2 == "map1"{
                if self.latitudeString == ""{
                print("if check map1 str")
                print("latitudeString is empty")
                let userLocation:CLLocation = locations[0] as CLLocation
                self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
                let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:self.currentLocation.longitude, zoom: 15)
                let position = CLLocationCoordinate2D(latitude:  self.currentLocation.latitude, longitude: self.currentLocation.longitude)
                print(position)
                DispatchQueue.main.async {
                    
                    self.mapView.camera = camera
                    
                    self.mapView.delegate = self
                    self.mapView.isMyLocationEnabled = true
                    self.mapView.settings.myLocationButton = true
                    self.locationManager.stopUpdatingLocation()
                }
                // self.mapView?.animate(to: camera)
                // manager.stopUpdatingLocation()
            }
            
            else{
                print("check map str")
                print("latitudeString is not empty")
                let latitud = Double(self.latitudeString ?? "") ?? 0.0
                let longitud = Double(self.longitudeString ?? "") ?? 0.0
                let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
                let position = CLLocationCoordinate2D(latitude:  latitud, longitude: longitud)
                print(position)
                DispatchQueue.main.async {
                    
                    self.mapView.camera = camera
                    self.mapView.delegate = self
                    self.mapView.isMyLocationEnabled = true
                    self.mapView.settings.myLocationButton = true
                    self.locationManager.stopUpdatingLocation()
                }
                // self.mapView?.animate(to: camera)
                //manager.stopUpdatingLocation()
            }
            //working manager.stopUpdatingLocation()
        }
            
            else{
                let userLocation:CLLocation = locations[0] as CLLocation
                self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
                let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:self.currentLocation.longitude, zoom: 15)
                let position = CLLocationCoordinate2D(latitude:  self.currentLocation.latitude, longitude: self.currentLocation.longitude)
                print(position)
                DispatchQueue.main.async {
                    
                    self.mapView.camera = camera
                    self.mapView.delegate = self
                    self.mapView.isMyLocationEnabled = true
                    self.mapView.settings.myLocationButton = true
                    self.locationManager.stopUpdatingLocation()
                }
               // manager.stopUpdatingLocation()
            }
    }
        self.locationManager.stopUpdatingLocation()
    }
    
}
