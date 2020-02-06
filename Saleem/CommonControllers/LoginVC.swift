//
//  LoginVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 18/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
import MessageUI
class LoginVC: UIViewController {

    var userType : String?
    var checkTypeStr : String?
    
    var deviceTokenStr: String?
    @IBOutlet var welcomeStaticLabel: UILabel!
    @IBOutlet var signInStaticLabel: UILabel!
    
    @IBOutlet var userNameOrEmailStaticLabel: UILabel!
    @IBOutlet var passwordStaticLabel: UILabel!
    
    @IBOutlet var userNameOrEmailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var signUpNowBtn: UIButton!
    @IBOutlet var alredyHaveAccountBtn: UIButton!
    @IBOutlet var forgotPwdBtn: UIButton!
    
    
    @IBOutlet var showHideBtn: UIButton!
    
    var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTF.isSecureTextEntry = true
        
        self.signInBtn.setTitle(languageChangeString(a_str: "SIGN IN"), for: UIControl.State.normal)
        self.forgotPwdBtn.setTitle(languageChangeString(a_str: "Forgot Your Password?"), for: UIControl.State.normal)
        self.alredyHaveAccountBtn.setTitle(languageChangeString(a_str: "Don't have an account?"), for: UIControl.State.normal)
        self.signUpNowBtn.setTitle(languageChangeString(a_str: "create account"), for: UIControl.State.normal)
        self.welcomeStaticLabel.text = languageChangeString(a_str: "Welcome")
        self.signInStaticLabel.text = languageChangeString(a_str: "Sign in to continue")
        self.userNameOrEmailStaticLabel.text = languageChangeString(a_str: "User name or E-mail")
        self.passwordStaticLabel.text = languageChangeString(a_str: "Password")
        self.userNameOrEmailTF.placeholder = languageChangeString(a_str: "User name or E-mail")
        self.passwordTF.placeholder = languageChangeString(a_str: "Password")
        
        if MOLHLanguage.isRTLLanguage(){
            self.userNameOrEmailTF.textAlignment = .right
            self.passwordTF.textAlignment = .right
        }
        else{
            self.userNameOrEmailTF.textAlignment = .left
            self.passwordTF.textAlignment = .left
        }
        /* var word = "aabb"

        let numberOfChars = word.characters.count // 4
        let numberOfDistinctChars = Set(word.characters).count // 2
        let occurrenciesOfA = word.characters.filter { $0 == "A" }.count // 0
        let occurrenciesOfa = word.characters.filter { $0 == "a" }.count // 2
        let occurrenciesOfACaseInsensitive = word.characters.filter { $0 == "A" || $0 == "a" }.count // 2

        print(occurrenciesOfA)
        print(occurrenciesOfa)
        print(occurrenciesOfACaseInsensitive)*/


    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        if self.checkTypeStr == "fromOTP"{
            let SelectUserTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectUserTypeVC") as! SelectUserTypeVC
            self.navigationController?.pushViewController(SelectUserTypeVC, animated: true)
//            DispatchQueue.main.async {
//                let mainViewController = self.sideMenuController!
//
//                let navigationController = mainViewController.rootViewController as! NavigationController
//                let viewController: UIViewController!
//
//                if navigationController.viewControllers.first is SelectUserTypeVC {
//                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectUserTypeVC")
//                }
//                else {
//                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectUserTypeVC")
//                }
//
//                navigationController.setViewControllers([viewController], animated: false)
//
//                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
//
//                MobileFixServices.sharedInstance.dissMissLoader()
//
//            }

        }
        else{
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
   
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }

    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        
        let providedEmailAddress = userNameOrEmailTF.text
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
//        if isEmailAddressValid
//        {
                   //(self.userNameOrEmailTF.text?.isValidEmail())!{
            //validateEmail(enteredEmail: self.userNameOrEmailTF.text!){
            if Reachability.isConnectedToNetwork() {
                
                signInServiceCall()
                
            }else
            {
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                //self.showToast(message: languageChangeString(a_str: "Please ensure you have proper internet connection") ?? "")
            }
      //  }
        
//        else{
//            showToast(message: languageChangeString(a_str: "Please enter valid email")!)
//        }
  
     
    }
    
    
    @IBAction func forgotPwdAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message:languageChangeString(a_str: "Enter Email To Reset Your Password"), preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { textField in
            // textField.placeholder = [[SharedClass sharedInstance]languageSelectedString:@"Old Password"];
            textField.placeholder = languageChangeString(a_str: "Enter your Email")
            textField.textColor = UIColor.black
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .roundedRect
            
        })
        alertController.view.tintColor = UIColor(red: 64 / 255.0, green: 198 / 255.0, blue: 182 / 255.0, alpha: 1)
       // alertController.view.tintColor = UIColor(red: 41 / 255.0, green: 121 / 255.0, blue: 255 / 255.0, alpha: 1)
        alertController.addAction(UIAlertAction(title: languageChangeString(a_str: "SUBMIT"), style: .default, handler: { action in
            
            var textfields = alertController.textFields
            
            self.emailField = textfields?[0]
            
            print("\(self.emailField!.text)")
            if Reachability.isConnectedToNetwork() {
               self.forgotPwdServiceCall()
            }else{
                self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            }
         
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func submit(){
        
//        let alertController = UIAlertController(title: "", message:"Password Reset link has been sent successfully. ", preferredStyle: .alert)
//        alertController.present(alertController, animated: true, completion: nil)
//
        
        let alert = UIAlertController(title:"", message:"Password Reset link has been sent successfully.Please Check Your Email", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.dismiss(animated: true, completion: nil)
          
            case .cancel:
                self.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
        
    
    @IBAction func signUpNowBtnAction(_ sender: Any) {
        
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        
        if userType == "2"{
         
            let SignUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            self.navigationController?.pushViewController(SignUpVC, animated: false)
            
        }
        else{
            let SpSignupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpSignupVC") as! SpSignupVC
            self.navigationController?.pushViewController(SpSignupVC, animated: true)
        }
    }
    
    
    @IBAction func showHideBtnAction(_ sender: Any) {
        
        if showHideBtn.tag == 1 {
            passwordTF.isSecureTextEntry = false
            showHideBtn.setImage(UIImage.init(named: "View_2"), for: UIControl.State.normal)
            showHideBtn.tag = 2
        }
        else{
            passwordTF.isSecureTextEntry = true
            //showHideBtn.setTitle("Show", for: UIControl.State.normal)
            showHideBtn.setImage(UIImage.init(named: "View_1"), for: UIControl.State.normal)
            showHideBtn.tag = 1
        }
        
    }
    
    
    // Service call for login
    
    func signInServiceCall()
    {
        
       /* API-KEY:9173645
        lang:en

        email: (username/email)
        password:
        device_name: (android/ios)
        device_token:
         user_type:(2=user,3=individual/company)
         */
        
        let signin = "\(Base_Url)login"
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        deviceTokenStr = UserDefaults.standard.object(forKey:"deviceToken") as? String 
        self.userType = UserDefaults.standard.object(forKey: "type") as? String ?? ""
        
        let parameters: Dictionary<String, Any>
        if ((deviceTokenStr?.count) != nil)  {
            parameters = ["email" : self.userNameOrEmailTF.text!,  "password":self.passwordTF.text!,"device_token" : deviceTokenStr! , "device_name" : "ios" , "lang" : language,"user_type":self.userType!,"API-KEY":APIKEY]
        }
        else
        {
            parameters = ["email" : self.userNameOrEmailTF.text!,  "password":self.passwordTF.text!,"device_token" : "123456" , "device_name" : "ios" , "lang" : language,"user_type":self.userType!,"API-KEY":APIKEY]
        }
        
            
        //let parameters: Dictionary<String, Any> = ["email" : self.userNameOrEmailTF.text!,  "password":self.passwordTF.text!,"device_token" : deviceTokenStr! , "device_name" : "ios" , "lang" : language,"user_type":userType,"API-KEY":APIKEY]
        
        print(signin)
        print(parameters)
        
        Alamofire.request(signin, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String?
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if let userDetailsData = responseData["user_details"] as? Dictionary<String, AnyObject> {
                        UserDefaults.standard.set(self.passwordTF.text!, forKey: "password")
                        let userName = userDetailsData["username"] as? String?
                        let userEmail = userDetailsData["email"] as? String?
                        let userImg = userDetailsData["profile_pic"] as? String?
                        let userId = userDetailsData["user_id"] as? String?
                        let otp_status = userDetailsData["otp_status"] as? String?
                        let auth_level = userDetailsData["auth_level"] as? String?
                        let phone = userDetailsData["phone"] as? String?
                        let gender = userDetailsData["gender"] as? String?
                        
                        let userImage = String(format: "%@%@",base_path,userImg!!)
                        
                        UserDefaults.standard.set(userName as Any, forKey: "userName")
                        UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                        UserDefaults.standard.set(userId as Any, forKey: "userId")
                        UserDefaults.standard.set(userImage as Any, forKey: "userImage")
                        UserDefaults.standard.set(otp_status as Any, forKey: "otpstatus")
                        UserDefaults.standard.set(auth_level as Any, forKey: "authlevel")
                        UserDefaults.standard.set(phone as Any, forKey: "phone")
                        UserDefaults.standard.set(gender as Any, forKey: "gender")
//
//                        let spid = userDetailsData["user_id"] as? String?
//
//                        UserDefaults.standard.set(spid as Any, forKey: "spId")
//
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        let userType = UserDefaults.standard.object(forKey: "type") as? String
                        let otpStatusStr = UserDefaults.standard.object(forKey: "otpstatus") as? String
                        if userType == "2"{
                            
                            if otpStatusStr == "0"{
                                
                                let verifyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyVC") as! VerifyVC
                                self.navigationController?.pushViewController(verifyVC, animated: false)
                            }
                            else{
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
                        }
                        
                        else{
                          if let userDetailsData = responseData["user_details"] as? Dictionary<String, AnyObject> {
                            
                            let spid = userDetailsData["user_id"] as? String?
                            
                            UserDefaults.standard.set(spid as Any, forKey: "spId")
                            
                            }
                            if otpStatusStr == "0"{
                                
                                let verifyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyVC") as! VerifyVC
                                self.navigationController?.pushViewController(verifyVC, animated: false)
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
    
    //USER FORGOT PASSWORD SERVICE CALL
    func forgotPwdServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         email:
         user_type:(2=user,3=individual/company)
         
         */
        
        let changePwd = "\(Base_Url)forgot_password"
      
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let userType = UserDefaults.standard.object(forKey: "type") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = ["email" : self.emailField.text! ,"user_type" : userType, "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(changePwd, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
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










/*
 //    old        let storyboard = UIStoryboard(name: "Main", bundle: nil)
 //            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
 //            print("setup type"); navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "UserHomeVC")], animated: false)
 //            let story = UIStoryboard.init(name: "Main", bundle: nil)
 //            let mainViewController = story.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
 //            mainViewController.rootViewController = navigationController
 //
 //            mainViewController.setup(type: 3)
 //
 //            let window = UIApplication.shared.delegate!.window!!
 //            window.rootViewController = mainViewController
 //            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
 
 */

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
