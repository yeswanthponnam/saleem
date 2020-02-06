//
//  SPCancelOrderVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 06/08/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
class SPCancelOrderVC: UIViewController,UITextViewDelegate {

    @IBOutlet var reasonLabel: UILabel!
    @IBOutlet var areYouSureCancelOrderStaticLabel: UILabel!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var reasonTV: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        reasonLabel.text = languageChangeString(a_str: "Write a Reason")
        self.submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        areYouSureCancelOrderStaticLabel.text = languageChangeString(a_str: "Please Enter The Reason For Cancellation")
//        reasonTV.layer.borderColor = UIColor (red: 252.0/255.0, green: 64.0/255.0, blue: 65.0/255.0, alpha: 1.0).cgColor
//        reasonTV.layer.borderWidth = 1.0
    }
    

    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            SPCancelOrderServiceCall()
        }else
        {            showToastForAlert(message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    //MARK:TEXTVIEW DELAGATES
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.reasonLabel.isHidden = true
    }
    //SP CancelOrder SERVICE CALL
    func SPCancelOrderServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         cancel_reason
         */
        
        let cancelOrder = "\(Base_Url)cancel_request"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let reqID = UserDefaults.standard.object(forKey: "reqID") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID, "cancel_reason":self.reasonTV.text!, "lang" : language,"API-KEY":APIKEY]
        //"provider_id" : spId,
        print(parameters)
        
        Alamofire.request(cancelOrder, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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

