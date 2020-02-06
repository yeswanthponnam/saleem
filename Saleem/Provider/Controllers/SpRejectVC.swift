//
//  SpRejectVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 21/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
class SpRejectVC: UIViewController {

    @IBOutlet weak var txt_RejectReson: UITextField!
    @IBOutlet weak var btn_Send: UIButton!
    @IBOutlet weak var btn_Close: UIButton!
    
    @IBOutlet var reasonForRejectStatic: UILabel!
    @IBOutlet var rejectOfferStaticLabel: UILabel!
    
    var reasonIdString : String! = ""
    var reasonIDArray = [String]()
    var reasonNameArray = [String]()
    
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var rejectString : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rejectOfferStaticLabel.text = languageChangeString(a_str: "REJECT OFFER")
        reasonForRejectStatic.text = languageChangeString(a_str: "Reason For Rejection")
        self.txt_RejectReson.placeholder = languageChangeString(a_str: "This service is unavailable")
        self.btn_Send.setTitle(languageChangeString(a_str: "SEND"), for: UIControl.State.normal)
        
        if MOLHLanguage.isRTLLanguage(){
            self.txt_RejectReson.textAlignment = .right
        }else{
            self.txt_RejectReson.textAlignment = .left
        }
        createPickerView()
        if Reachability.isConnectedToNetwork() {
            rejectReasonsListServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        self.txt_RejectReson.setBottomLineBorder()

    }

    func createPickerView(){
        pickerView = UIPickerView()
        pickerView?.frame = CGRect(x: 0, y:0, width: view.frame.size.width, height: 162)
        pickerView?.delegate = self
        pickerView?.dataSource = self
        let lightTextureColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        pickerView?.backgroundColor = lightTextureColor
        pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        pickerToolBar?.barStyle = .blackOpaque
        pickerToolBar?.autoresizingMask = .flexibleWidth
        pickerToolBar?.barTintColor = #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1)
        
        pickerToolBar?.frame = CGRect(x: 0,y: (pickerView?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
        pickerToolBar?.barStyle = UIBarStyle.default
        pickerToolBar?.isTranslucent = true
        pickerToolBar?.tintColor = #colorLiteral(red: 0.09803921569, green: 0.231372549, blue: 0.3764705882, alpha: 1)
        pickerToolBar?.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.231372549, blue: 0.3764705882, alpha: 1)
        pickerToolBar?.sizeToFit()
        
        
        let doneButton1 = UIBarButtonItem(title: languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        self.txt_RejectReson.inputView = self.pickerView
        self.txt_RejectReson.inputAccessoryView = self.pickerToolBar
        
        self.pickerView?.reloadInputViews()
        self.pickerView?.reloadAllComponents()
        
    }
    
    
    @objc func donePickerView(){
     
     /*   self.txt_RejectReson.text = reasonNameArray[0]
        
        if rejectString.count > 0 {
            self.txt_RejectReson.text = self.rejectString ?? ""
        }else{
            self.txt_RejectReson.text = reasonNameArray[0]
        }
        self.view.endEditing(true)
        txt_RejectReson.resignFirstResponder()*/
        
        
        self.rejectString = reasonNameArray[(pickerView?.selectedRow(inComponent: 0))!]
        self.txt_RejectReson.text = self.rejectString
        reasonIdString = reasonIDArray[(pickerView?.selectedRow(inComponent: 0))!]
        if rejectString.count > 0{
            self.txt_RejectReson.text = self.rejectString ?? ""
        }else{
            self.txt_RejectReson.text = reasonNameArray[0]
        }
     
        self.view.endEditing(true)
        txt_RejectReson.resignFirstResponder()
        
    }
    
    @objc func cancelPickerView(){
        
        if (txt_RejectReson.text?.count)! > 0 {
            self.view.endEditing(true)
            txt_RejectReson.resignFirstResponder()
        }else{
            self.view.endEditing(true)
            txt_RejectReson.text = ""
            txt_RejectReson.resignFirstResponder()
        }
        txt_RejectReson.resignFirstResponder()
    }
    
    @IBAction func btn_Send_Action(_ sender: UIButton) {
        
       /* NotificationCenter.default.post(name: Notification.Name("pushView3"), object: nil)
        self.dismiss(animated: true) {
            print("dismmissed")
        }*/

        if Reachability.isConnectedToNetwork() {
            
            rejectOfferServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    
    @IBAction func btn_Close_Action(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
  
    //FOR SERVICE CALL FOR MODEL
    
    func rejectReasonsListServiceCall ()
    {
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let vehicles = "\(Base_Url)reject_reasons_list?"
        let parameters: Dictionary<String, Any> = ["API-KEY" : APIKEY ,"lang" : language ]
        print(vehicles)
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(vehicles, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.reasonIDArray = [String]()
                self.reasonNameArray = [String]()
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let servicesCat = responseData["reasons_list"] as? [[String:Any]]
                    for servicesCat in servicesCat! {
                        let reason_id = servicesCat["reason_id"]  as! String
                        let reason_name = servicesCat["reason_name"]  as! String
                        
                        self.reasonIDArray.append(reason_id)
                        self.reasonNameArray.append(reason_name)
                    }
                    
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.pickerView?.reloadAllComponents()
                        self.pickerView?.reloadInputViews()
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
    
    //REJECT OFFER SERVICE CALL
    func rejectOfferServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         provider_id:
         request_id:
         reason_id::*/
        
        let signup = "\(Base_Url)reject_service_request"
        
        //let deviceToken = "12345"
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let reqID = UserDefaults.standard.object(forKey: "reqID") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID,  "provider_id" : spId,"reason_id":reasonIdString! ,"lang" : language,"API-KEY":APIKEY]
        
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


extension SpRejectVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return reasonNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return reasonNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        self.txt_RejectReson.text = reasonNameArray[row]
        self.rejectString = reasonNameArray[row]
        reasonIdString = reasonIDArray[row]
    }
}
