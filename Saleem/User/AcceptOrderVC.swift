//
//  AcceptOrderVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 01/02/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire

class AcceptOrderVC: UIViewController {

   
    @IBOutlet var yesBtn: UIButton!
    @IBOutlet var noBtn: UIButton!
    @IBOutlet var areyousureCancelOrderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noBtn.setTitle(languageChangeString(a_str: "NO"), for: UIControl.State.normal)
        self.yesBtn.setTitle(languageChangeString(a_str: "YES"), for: UIControl.State.normal)
        areyousureCancelOrderLabel.text = languageChangeString(a_str: "Are you sure you want to cancel this order?")
    }
    

    @IBAction func yesAction(_ sender: Any) {
  //pushView
       //com on apr8
       /*  let userType = UserDefaults.standard.object(forKey: "type") as? String
        if userType == "2"{
        
        NotificationCenter.default.post(name: Notification.Name("pushView"), object: nil)
        self.dismiss(animated: true) {
            print("dismmissed")
        }
        }
        else{
            NotificationCenter.default.post(name: Notification.Name("pushView4"), object: nil)
            self.dismiss(animated: true) {
                print("dismmissed")
        }
        }*/
        
        
        if Reachability.isConnectedToNetwork() {
            
            SPCancelOrderServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
    }
    
    
    @IBAction func noAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
    
    //User CancelOrder SERVICE CALL
    func SPCancelOrderServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         provider_id:
         request_id:
         */
       
        let signup = "\(Base_Url)cancel_request"
        
        //let deviceToken = "12345"
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let reqID = UserDefaults.standard.object(forKey: "reqID") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID,  "cancel_reason":"","provider_id" : spId,"lang" : language,"API-KEY":APIKEY]
        
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
                       
                        let userType = UserDefaults.standard.object(forKey: "type") as? String
                        if userType == "2"{
                            
                            NotificationCenter.default.post(name: Notification.Name("pushView"), object: nil)
                            self.dismiss(animated: true) {
                                print("dismmissed")
                            }
                        }
                        else{
                            NotificationCenter.default.post(name: Notification.Name("pushView4"), object: nil)
                            self.dismiss(animated: true) {
                                print("dismmissed")
                            }
                        }
                        
                        self.showToast(message: message)
                        
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
