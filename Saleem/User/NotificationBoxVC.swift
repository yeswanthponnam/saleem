//
//  NotificationBoxVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 25/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import MOLH

class NotificationBoxVC: UIViewController {

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var checkBtn: UIButton!
    
    var checkTerms : Bool!
    var checkTermStr : String! = "1"
    
    @IBOutlet var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTerms = false
        let priceStr = UserDefaults.standard.object(forKey: "price") as? String
        let genderStr = UserDefaults.standard.object(forKey: "genderStr") as? String ?? ""
        //self.priceLabel.text = String(format: "%@ %@", priceStr!,"SAR will be added to the total price of the fixing cost for service fee")
        self.priceLabel.text = String(format: "%@ %@ %@", priceStr!,"SAR",languageChangeString(a_str: "will be added to the total price of the fixing cost for service fee")!)
        self.okBtn.setTitle(languageChangeString(a_str: "OK"), for: UIControl.State.normal)
       // self.checkBtn.setTitle(languageChangeString(a_str: "Send order to female only"), for: UIControl.State.normal)
        if MOLHLanguage.isRTLLanguage(){
            self.checkBtn.titleEdgeInsets.right = 16
            
        }else{
            self.checkBtn.titleEdgeInsets.left = 10
            
        }
        
        if genderStr == "0"{
            self.checkBtn.isHidden = true
            checkTermStr = "1"
        }
        else if genderStr == "1"{
            self.checkBtn.isHidden = false
            self.checkBtn.setTitle(languageChangeString(a_str: "Send order to female only"), for: UIControl.State.normal)
        }
        
}
 
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
       
        let alert = UIAlertController(title: languageChangeString(a_str:"Alert"), message: languageChangeString(a_str:"Are you sure you want to cancel this order?"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: languageChangeString(a_str:"NO"), style: .default, handler: { action in
            switch action.style{
            case .default:
                //self.dismiss(animated: true, completion: nil)
                print("error")
            case .cancel:
                self.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
                
            }}))
        
        alert.addAction(UIAlertAction(title: languageChangeString(a_str:"YES"), style: .default, handler: { action in
            switch action.style{
            case .default:
                    if Reachability.isConnectedToNetwork() {
                    
                    self.userCancelOrderServiceCall()
                }else
                {
                    self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                    // showToastForAlert (message:"Please ensure you have proper internet connection.")
                }
                
            case .cancel:
                self.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
                
            }}))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func checkBtnAction(_ sender: Any) {
        if checkTerms == false{
            self.checkBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
            checkTerms = true
            checkTermStr = "2"
        }
        else{
            self.checkBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
            checkTerms = false
            checkTermStr = "1"
        }
    }
    
    @IBAction func agreeAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            confirmServiceReqServiceCall()
        }else
        {
            self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    
    //USER CancelOrder SERVICE CALL
    func userCancelOrderServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         provider_id:
         request_id:
        */
        
        let cancelRequest = "\(Base_Url)cancel_request"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        let newReqId =  UserDefaults.standard.object(forKey: "newReqId") as? String
        let parameters: Dictionary<String, Any> = [ "request_id" : newReqId!,  "provider_id" : spId,"cancel_reason":"","lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(cancelRequest, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
               
                if status == 1
                {
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
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
                        
                       // self.showToast(message: message)
                        
                    }
                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    //self.showToast(message: message)
                }
            }
        }
    }
    
    
    //Confirm Service req for timer running
    func confirmServiceReqServiceCall ()
    {
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let newReqId =  UserDefaults.standard.object(forKey: "newReqId") as? String
        
        let serviceName = "\(Base_Url)confirm_service_request_user?"
        // sp_type values(1=all providers, 2= only female providers)
        
        let parameters: Dictionary<String, Any> = ["request_id":newReqId!,"sp_type":checkTermStr!,"API-KEY" : APIKEY ,"lang" : language ]
        //self.reqID!
        print(serviceName)
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(serviceName, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
               
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let requestDetailsDict = responseData["req_details"] as? [String:Any]
            
                    //self.getTimeStr
                        //let timeStr = requestDetailsDict?["request_timer"] as? String
                    
                    DispatchQueue.main.async {
                       
                        UserDefaults.standard.setValue("stopTime", forKey: "yes")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProviderList"), object: nil)
                        self.dismiss(animated: true) {
                                    print("dismmissed")
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                    }
                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.showToast(message: message!)
                }
            }
        }
    }
    
    
}
