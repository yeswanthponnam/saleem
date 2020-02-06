//
//  ConfirmOfferVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 24/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire

class ConfirmOfferVC: UIViewController {
    
    
    @IBOutlet var providerImageView: UIImageView!
    @IBOutlet var providerNameLabel: UILabel!
    
    @IBOutlet var distanceStaticLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var priceStatic: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var acceptOfferBtn: UIButton!
    
    @IBOutlet var starButtonOne: UIButton!
    @IBOutlet var starButtonTwo: UIButton!
    @IBOutlet var starButtonThree: UIButton!
    @IBOutlet var starButtonFour: UIButton!
    @IBOutlet var starButtonFive: UIButton!
    
    
    var reqId: String! = ""
    var providerId : String! = ""
    var offerPrice: String! = ""
    var providerName : String! = ""
    var distance: String! = ""
    var image : String! = ""
    var providerRating: String! = ""
   
    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating")!
    let halfStarImage:  UIImage = UIImage(named: "check")!
    let emptyStarImage: UIImage = UIImage(named: "unselected_star")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        distanceStaticLabel.text = languageChangeString(a_str: "Distance")
        priceStatic.text = languageChangeString(a_str: "Price")
        self.acceptOfferBtn.setTitle(languageChangeString(a_str: "ACCEPT OFFER"), for: UIControl.State.normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getProviderDataValues(_:)), name: NSNotification.Name(rawValue: "getProviderDataValues"), object: nil)
    }
    
    @objc func getProviderDataValues(_ notification: NSNotification){
        
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            reqId = dict["key"] as? String
            providerId = dict["key1"] as? String
            offerPrice = dict["key2"] as? String
            providerName = dict["key3"] as? String
            distance = dict["key4"] as? String
            image = dict["key5"] as? String
            providerRating = dict["key6"] as? String
            print("reqId",reqId)
            print("providerId",providerId)
            print("offerPrice",offerPrice)
            print("providerName",providerName)
            print("distance",distance)
            print("image",image)
            print("providerRating",providerRating)
        }
        
        self.providerNameLabel.text = providerName
        self.distanceLabel.text = String(format: "%@ %@", distance,"Km")
        self.priceLabel.text = String(format: "%@ %@", offerPrice,"SAR")
        self.providerImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: ""))
     
        let moreRate1 = Double(providerRating)
        
        if let ourRating = moreRate1 {
            starButtonOne.setImage(self.getStarImage(starNumber: 1, forRating: ourRating), for: UIControl.State.normal)
            starButtonTwo.setImage(self.getStarImage(starNumber: 2, forRating: ourRating), for: UIControl.State.normal)
            starButtonThree.setImage(self.getStarImage(starNumber: 3, forRating: ourRating), for: UIControl.State.normal)
            starButtonFour.setImage(self.getStarImage(starNumber: 4, forRating: ourRating), for: UIControl.State.normal)
            starButtonFive.setImage(self.getStarImage(starNumber: 5, forRating: ourRating), for: UIControl.State.normal)
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

    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        print("tap")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptOfferAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            acceptOfferServiceCall()
        }else{
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
        }
    }
    
    //ACCEPT OFFER SERVICE CALL
    func acceptOfferServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         provider_id:
         offer_price:*/
        
        let signup = "\(Base_Url)accept_offer"
        
        //let deviceToken = "12345"
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqId!,  "provider_id" : providerId!,"offer_price":offerPrice! ,"lang" : language,"API-KEY":APIKEY]
        
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
                        
                      /* for chat comment geting value  NotificationCenter.default.post(name: Notification.Name("pushView1"), object: nil)
                        self.dismiss(animated: true) {
                            print("dismmissed")
                        }*/
                        
                        let DataDict:[String: String] = ["key": self.reqId,"key1":self.providerId]
                            
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushView1"), object: nil, userInfo: DataDict)
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
