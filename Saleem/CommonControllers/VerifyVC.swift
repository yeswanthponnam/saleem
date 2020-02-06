//
//  VerifyVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 18/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire

class VerifyVC: UIViewController,SSASideMenuDelegate,UITextFieldDelegate {

    var sideMenu: SSASideMenu?
    var window: UIWindow?
    var userTypeString : String?
   
    
    @IBOutlet var verifyStaticLabel: UILabel!
    @IBOutlet var verifyMobileStaticLabel: UILabel!
    @IBOutlet var enterOtpStaticLabel: UILabel!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var didnotReceiveCodeStaticBtn: UIButton!
    @IBOutlet var resendBtn: UIButton!
    
    @IBOutlet var otpOneTF: UITextField!
    @IBOutlet var otpTwoTF: UITextField!
    @IBOutlet var otpThreeTF: UITextField!
    @IBOutlet var otpFourTF: UITextField!
    
    var parameters = [String: String]()
    var resendParamDict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        verifyStaticLabel.text = languageChangeString(a_str: "Verification")
        verifyMobileStaticLabel.text = languageChangeString(a_str: "Verify your mobile")
        enterOtpStaticLabel.text = languageChangeString(a_str: "Enter your OTP CODE here")
        self.didnotReceiveCodeStaticBtn.setTitle(languageChangeString(a_str: "Don't receive code?"), for: UIControl.State.normal)
        self.resendBtn.setTitle(languageChangeString(a_str: "Resend code"), for: UIControl.State.normal)
        self.signInBtn.setTitle(languageChangeString(a_str: "SIGN IN"), for: UIControl.State.normal)
        
        self.otpOneTF.placeholder = languageChangeString(a_str: "1")
        self.otpTwoTF.placeholder = languageChangeString(a_str: "2")
        self.otpThreeTF.placeholder = languageChangeString(a_str: "3")
        self.otpFourTF.placeholder = languageChangeString(a_str: "4")
    }
    

    override func  viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- TEXTFILED DELGATES
    func textFieldShouldReturnSingle(_ textField: UITextField , newString : String)
    {
       /* let nextTag: Int = textField.tag + 1

        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        textField.text = newString
        if let nextR = nextResponder
        {
            // Found next responder, so set it.
            nextR.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }*/
  
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
      /*  let newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)

        let newLength = newString.characters.count

        if newLength == 1{
            textFieldShouldReturnSingle(textField , newString : newString)
            return false
        }
        else if newLength >= 1{
            return false
        }
        return true*/
        let newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        let newLength = newString.characters.count
        if textField.text!.count < 1 && string.count > 0 {
            let tag = textField.tag + 1;
            let nextResponder = textField.superview?.viewWithTag(tag)
            
            if   (nextResponder != nil){
                textField.resignFirstResponder()
                
            }
            textField.text = string;
            if (nextResponder != nil){
                nextResponder?.becomeFirstResponder()
                
            }
            return false;
            
            
        }else if (textField.text?.count)! >= 1 && string.count == 0 {
            let prevTag = textField.tag - 1
            let prevResponser = textField.superview?.viewWithTag(prevTag)
            if (prevResponser != nil){
                textField.resignFirstResponder()
            }
            textField.text = string
            if (prevResponser != nil){
                prevResponser?.becomeFirstResponder()
                
            }
            return false
        }
       else if newLength >= 1{
            return false
        }
        return true;
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            
            verifyOTPServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        
      /*  if userType == "1"{
      
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "HomeViewController")], animated: false)
           
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let mainViewController = story.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            mainViewController.rootViewController = navigationController
            
            mainViewController.setup(type: 3)
            
            let window = UIApplication.shared.delegate!.window!!
            window.rootViewController = mainViewController
            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            
        }
            
            
        
        else{
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
          
        }*/
        
    }
    
    
    
    @IBAction func resendOtpAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            
            resendOTPServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    
    // Service call for otp
    
    func verifyOTPServiceCall()
    {
        
        /*  API-KEY:9173645
         lang:en
         user_id:
         otp:*/
        
        let verifyOtp = "\(Base_Url)verify_otp"
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        let spId = UserDefaults.standard.object(forKey: "spId") as? String
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        userTypeString = userType
        let str = String(format: "%@%@%@%@", self.otpOneTF.text!,self.otpTwoTF.text!,self.otpThreeTF.text!,self.otpFourTF.text!)
        
        if userType == "2"{
            parameters = ["user_id" : userID!,"otp": str,"lang" : language,"API-KEY":APIKEY]
        }
        else {
            parameters = ["user_id" : spId!,"otp": str,"lang" : language,"API-KEY":APIKEY]
        }
   
       // let parameters: Dictionary<String, Any> = ["user_id" : userID!,"otp": str,"lang" : language,"API-KEY":APIKEY]
        
        print(verifyOtp)
        print(parameters)
        
        Alamofire.request(verifyOtp, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String?
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if let userDetailsData = responseData["user_details"] as? Dictionary<String, AnyObject> {
                        // UserDefaults.standard.set(self.passwordTF.text!, forKey: "password")
                        let userName = userDetailsData["username"] as? String?
                        let userEmail = userDetailsData["email"] as? String?
                        let userImg = userDetailsData["profile_pic"] as? String?
                        let userId = userDetailsData["user_id"] as? String?
                        
                        let userImage = String(format: "%@%@",base_path,userImg!!)
                        
                        UserDefaults.standard.set(userName as Any, forKey: "userName")
                        UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                        UserDefaults.standard.set(userId as Any, forKey: "userId")
                        UserDefaults.standard.set(userImage as Any, forKey: "userImage")
                        
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        if userType == "2"{
                            UserDefaults.standard.set(false, forKey: "log")
                            
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
                            
                        else{
                            UserDefaults.standard.set(false, forKey: "log")
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
                    
                    }
                    
                }
                else if status == 2{
                     MobileFixServices.sharedInstance.dissMissLoader()

                    let alert = UIAlertController(title: languageChangeString(a_str: "Alert"), message: message!, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: languageChangeString(a_str: "OK"), style: .default, handler: { action in
                        print("Ok button tapped");
                        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        login.userType = self.userTypeString
                        login.checkTypeStr = "fromOTP"
                        self.navigationController?.pushViewController(login, animated: true)
                    })
                    alert.addAction(okButton)
                    self.present(alert, animated: true)
                    
                    
//                    let alertController = UIAlertController(title: "Alert title", message: "Message to display", preferredStyle: .alert)
//
//                    let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action:UIAlertAction!) in
//
//                        // Code in this block will trigger when OK button tapped.
//                        print("Ok button tapped");
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pop"), object: nil)
//                    }
//
//                    alertController.addAction(OKAction)
//
//                    self.present(alertController, animated: true, completion:nil)
                   // self.dismiss(animated: true, completion: nil)
                    
//                    let alert = UIAlertController(title: "Alert", message: message!,preferredStyle: UIAlertController.Style.alert)
//
//
//                    alert.addAction(UIAlertAction(title: "OK",
//                                                  style: UIAlertAction.Style.default,
//                                                  handler: {(_: UIAlertAction!) in
//                                                    //Sign out action
//
//                                                   self.dismiss(animated: true, completion: nil)
//
//                    }))
//                    self.present(alert, animated: true, completion: nil)
              
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    //self.showToast(message: message!!)
                    //self.showToastForAlert(message: message!!)
                    self.showToast(message: message!!)
                }
            }
        }
        
    }

    // Service call for RESEND OTP
    
    func resendOTPServiceCall()
    {
        
        /*API-KEY:9173645
         lang:en
         user_id:*/
        
        let signin = "\(Base_Url)resend_otp"
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        let spId = UserDefaults.standard.object(forKey: "spId") as? String
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        
        if userType == "2"{
            resendParamDict = ["user_id" : userID!,"lang" : language,"API-KEY":APIKEY]
        }
        
        else{
            resendParamDict = ["user_id" : spId!,"lang" : language,"API-KEY":APIKEY]
        }
      
       // let parameters: Dictionary<String, Any> = ["user_id" : userID!,"lang" : language,"API-KEY":APIKEY]
        
        print(signin)
        print(resendParamDict)
        
        Alamofire.request(signin, method: .post, parameters: resendParamDict, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String?
                // let number = responseData["smartmed_mobile"] as? String
                
                // UserDefaults.standard.set(number, forKey: "smartNo")
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if let userDetailsData = responseData["user_details"] as? Dictionary<String, AnyObject> {
                        // UserDefaults.standard.set(self.passwordTF.text!, forKey: "password")
                        let userName = userDetailsData["username"] as? String?
                        let userEmail = userDetailsData["email"] as? String?
                        let userImg = userDetailsData["profile_pic"] as? String?
                        let userId = userDetailsData["user_id"] as? String?
                        
                        let userImage = String(format: "%@%@",base_path,userImg!!)
                        
                        UserDefaults.standard.set(userName as Any, forKey: "userName")
                        UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                        UserDefaults.standard.set(userId as Any, forKey: "userId")
                        UserDefaults.standard.set(userImage as Any, forKey: "userImage")
                        
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToast(message: message!!)
                    }
                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    //self.showToast(message: message!!)
                    //self.showToastForAlert(message: message!!)
                    self.showToast(message: message!!)
                }
            }
        }
        
    }
    
}



