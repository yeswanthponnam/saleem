//
//  SpSendOfferVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 19/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class SpSendOfferVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet var sendOfferStaticLabel: UILabel!
    @IBOutlet var insertOfferPriceStaticLabel: UILabel!
    
    @IBOutlet weak var txt_SendOffer: UITextField!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_Close: UIButton!
    
    var latitudeString : String?
    var longitudeString : String?
    
    lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendOfferStaticLabel.text = languageChangeString(a_str: "SEND OFFER")
        insertOfferPriceStaticLabel.text = languageChangeString(a_str: "Insert the offer price")
        self.txt_SendOffer.placeholder = languageChangeString(a_str: "Price")
        self.btn_Submit.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        self.txt_SendOffer.setBottomLineBorder()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
    }
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    @IBAction func btn_Submit_Action(_ sender: UIButton) {
        
//     com apr 4th   NotificationCenter.default.post(name: Notification.Name("pushView4"), object: nil)
//        self.dismiss(animated: true) {
//            print("dismmissed")
//        }
        if Reachability.isConnectedToNetwork() {
            
            sendOfferServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
    }
    
    //delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
       
        let latitud = Double(userLocation.coordinate.latitude)
        let longitud = Double(userLocation.coordinate.longitude)
        
        self.latitudeString = String(format: "%.8f",userLocation.coordinate.latitude)
        self.longitudeString = String(format: "%.8f",userLocation.coordinate.longitude)
      
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                //self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    @IBAction func btn_Close_Action(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //SEND OFFER SERVICE CALL
    func sendOfferServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         provider_id:
         offer_price:
         latitude:
         longitude:*/
        
        let signup = "\(Base_Url)send_offer"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let reqID = UserDefaults.standard.object(forKey: "reqID") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID,  "provider_id" : spId,"offer_price":txt_SendOffer.text! ,"lang" : language,"API-KEY":APIKEY]
        //,"latitude":self.latitudeString!,"longitude":self.longitudeString!
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
                        
                        NotificationCenter.default.post(name: Notification.Name("pushView3"), object: nil)
                        self.dismiss(animated: true) {
                            print("dismmissed")
                        }
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
