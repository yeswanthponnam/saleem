//
//  SignUpVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 18/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
import CoreTelephony
class SignUpVC: UIViewController {

    var phoneNumberStart : String?
    var phoneNumber1Start : String?
    var newLength :NSInteger?
    @IBOutlet var welcomeStaticLabel: UILabel!
    @IBOutlet var signupToCreateStaticLabel: UILabel!
    
    @IBOutlet var countryCodeTF: UITextField!
    
    @IBOutlet var fullNameStatic: UILabel!
    @IBOutlet var genderStatic: UILabel!
    @IBOutlet var emailStatic: UILabel!
    @IBOutlet var phoneNumberStatic: UILabel!
    @IBOutlet var createPwdStatic: UILabel!
    @IBOutlet var confirmPwdStatic: UILabel!
    
    @IBOutlet var checkBtn: UIButton!
    var checkTerms : Bool!
    var checkTermStr : String! = ""
    
    @IBOutlet var fullNameTF: UITextField!
    @IBOutlet var genderTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var createPwdTF: UITextField!
    @IBOutlet var confirmPwdTF: UITextField!
    
    @IBOutlet var createPwdBtn: UIButton!
    @IBOutlet var confirmPwdBtn: UIButton!
    
    @IBOutlet var agreeBtn: UIButton!
    @IBOutlet var termsCondBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var alreadyHaveAccountBtn: UIButton!
    @IBOutlet var signInNowBtn: UIButton!
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var genderArray = [languageChangeString(a_str: "Male"),languageChangeString(a_str: "Female")]
    var genderIdArray = ["0","1"]
    var genderIdString : String! = ""
    var genderString : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberStart = "0"
        phoneNumber1Start = "5"
        createPwdTF.isSecureTextEntry = true
        confirmPwdTF.isSecureTextEntry = true
        checkTerms = false
        createPickerView()
      
        DispatchQueue.main.async {
            if MOLHLanguage.isRTLLanguage(){
                self.countryCodeTF.roundCorners(corners: [.topRight,.bottomRight], radius: 10.0)
                self.phoneNumberTF.roundCorners(corners: [.topLeft,.bottomLeft], radius: 10.0)
            }else{
                self.countryCodeTF.roundCorners(corners: [.topLeft,.bottomLeft], radius: 10.0)
                self.phoneNumberTF.roundCorners(corners: [.topRight,.bottomRight], radius: 10.0)
            }
            
        }
        
        let network_Info = CTTelephonyNetworkInfo()
        let carrier: CTCarrier? = network_Info.subscriberCellularProvider
        print("country code is: \(carrier?.mobileCountryCode ?? "")")
        //will return the actual country code
        print("ISO country code is: \(carrier?.isoCountryCode ?? "")")
        
        if carrier?.isoCountryCode == "in" {
            self.countryCodeTF.text = "+91" //
        }else{
            self.countryCodeTF.text = "+966"
        }
        
        welcomeStaticLabel.text = languageChangeString(a_str: "Welcome to")
        signupToCreateStaticLabel.text = languageChangeString(a_str: "Sign up to Create account")
        fullNameStatic.text = languageChangeString(a_str: "Full name")
        genderStatic.text = languageChangeString(a_str: "Gender")
        emailStatic.text = languageChangeString(a_str: "E-mail Address")
        phoneNumberStatic.text = languageChangeString(a_str: "Phone number")
        createPwdStatic.text = languageChangeString(a_str: "Create password")
        confirmPwdStatic.text = languageChangeString(a_str: "Confirm password")
        self.agreeBtn.setTitle(languageChangeString(a_str: "I agree to the"), for: UIControl.State.normal)
        self.termsCondBtn.setTitle(languageChangeString(a_str: "Terms and Conditions"), for: UIControl.State.normal)
        self.signUpBtn.setTitle(languageChangeString(a_str: "SIGN UP"), for: UIControl.State.normal)
        self.alreadyHaveAccountBtn.setTitle(languageChangeString(a_str: "Already have an account?"), for: UIControl.State.normal)
        self.signInNowBtn.setTitle(languageChangeString(a_str: "Sign in Now!"), for: UIControl.State.normal)
        
        self.fullNameTF.placeholder = languageChangeString(a_str: "Full name")
        self.genderTF.placeholder = languageChangeString(a_str: "Gender")
        self.emailTF.placeholder = languageChangeString(a_str: "user@yopmail.com")

        //self.emailTF.placeholder = languageChangeString(a_str: "E-mail Address")
       // self.phoneNumberTF.placeholder = languageChangeString(a_str: "Starts With 966")
        self.phoneNumberTF.placeholder = languageChangeString(a_str: "0518420022")
        self.createPwdTF.placeholder = languageChangeString(a_str: "Create password")
        self.confirmPwdTF.placeholder = languageChangeString(a_str: "Confirm password")
        if MOLHLanguage.isRTLLanguage(){
            self.fullNameTF.textAlignment = .right
            self.genderTF.textAlignment = .right
            self.emailTF.textAlignment = .right
            self.phoneNumberTF.textAlignment = .right
            self.createPwdTF.textAlignment = .right
            self.confirmPwdTF.textAlignment = .right
        }
        else{
            self.fullNameTF.textAlignment = .left
            self.genderTF.textAlignment = .left
            self.emailTF.textAlignment = .left
            self.phoneNumberTF.textAlignment = .left
            self.createPwdTF.textAlignment = .left
            self.confirmPwdTF.textAlignment = .left
        }
        // Do any additional setup after loading the view.
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
    
    
    @IBAction func termsAction(_ sender: Any) {
        let TermsConditionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsConditionsVC") as! TermsConditionsVC
        TermsConditionsVC.checkStr = "terms"
        self.navigationController?.pushViewController(TermsConditionsVC, animated: false)
        
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
        pickerToolBar?.barTintColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        
        pickerToolBar?.frame = CGRect(x: 0,y: (pickerView?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
        pickerToolBar?.barStyle = UIBarStyle.default
        pickerToolBar?.isTranslucent = true
        pickerToolBar?.tintColor = #colorLiteral(red: 0.09803921569, green: 0.231372549, blue: 0.3764705882, alpha: 1)
        pickerToolBar?.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.231372549, blue: 0.3764705882, alpha: 1)
        pickerToolBar?.sizeToFit()
        
        
        let doneButton1 = UIBarButtonItem(title: languageChangeString(a_str: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        self.genderTF.inputView = self.pickerView
        self.genderTF.inputAccessoryView = self.pickerToolBar
        
        self.pickerView?.reloadInputViews()
        self.pickerView?.reloadAllComponents()
        
    }
    
    @objc func donePickerView(){
        
       // self.genderTF.text = genderArray[0]
//        if timeString.count > 0 {
//            self.txt_reminder.text = self.timeString ?? ""
//        }else{
//            self.txt_reminder.text = timeArray[0]
//        }
//        self.view.endEditing(true)
       
        
        self.genderTF.text = genderArray[0]
        genderIdString = genderIdArray[(pickerView?.selectedRow(inComponent: 0))!]
        if genderString.count > 0 {
            self.genderTF.text = self.genderString ?? ""
        }else{
            self.genderTF.text = genderArray[0]
        }
        self.view.endEditing(true)
         genderTF.resignFirstResponder()
    }
    
    @objc func cancelPickerView(){
        
        if (genderTF.text?.count)! > 0 {
            self.view.endEditing(true)
            genderTF.resignFirstResponder()
        }else{
            self.view.endEditing(true)
            genderTF.text = ""
            genderTF.resignFirstResponder()
        }
        genderTF.resignFirstResponder()
    }
    
    @IBAction func genderAction(_ sender: Any) {
        createPickerView()
    }
    @IBAction func signUpAction(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            
            signUpServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
      
    }
    
    @IBAction func signInNowAction(_ sender: Any) {
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(login, animated: false)
    }
   
    @IBAction func checkBtnAction(_ sender: Any) {
        
        if checkTerms == false{
            self.checkBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
            checkTerms = true
            checkTermStr = "1"
        }
        else{
            self.checkBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
            checkTerms = false
            checkTermStr = "0"
        }
        
    }
    
    @IBAction func createPwdShowHideAction(_ sender: Any) {
        
        if createPwdBtn.tag == 1 {
            createPwdTF.isSecureTextEntry = false
            createPwdBtn.setImage(UIImage.init(named: "View_2"), for: UIControl.State.normal)
            createPwdBtn.tag = 2
        }
        else{
            createPwdTF.isSecureTextEntry = true
            createPwdBtn.setImage(UIImage.init(named: "View_1"), for: UIControl.State.normal)
            createPwdBtn.tag = 1
        }
        
    }
    
    @IBAction func confirmPwdShowHideAction(_ sender: Any) {
        if confirmPwdBtn.tag == 1 {
            confirmPwdTF.isSecureTextEntry = false
            confirmPwdBtn.setImage(UIImage.init(named: "View_2"), for: UIControl.State.normal)
            confirmPwdBtn.tag = 2
        }
        else{
            confirmPwdTF.isSecureTextEntry = true
            confirmPwdBtn.setImage(UIImage.init(named: "View_1"), for: UIControl.State.normal)
            confirmPwdBtn.tag = 1
        }
    }
    
    //USER SIGNUP SERVICE CALL
    func signUpServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
      /*
        API-KEY:9173645
        lang:en
        name:
        gender:(male/female)
        email:
        phone:
        password:
        confirm_password:
        agree_tc:1=checked,0=not checked
        device_name: (android/ios)
        device_token:*/
        
        let signup = "\(Base_Url)user_registration"
        let deviceToken = UserDefaults.standard.object(forKey: "deviceToken") as! String
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        //self.genderTF.text!
        let countrywithPhoneNumberStr = String(format: "%@%@", self.countryCodeTF.text!,self.phoneNumberTF.text!)
        
        let parameters: Dictionary<String, Any> = [ "name" : self.fullNameTF.text!,  "gender" :genderIdString! ,"email":self.emailTF.text! ,"phone" : countrywithPhoneNumberStr,"password" : self.createPwdTF.text! , "confirm_password" : self.confirmPwdTF.text! ,"agree_tc" : checkTermStr!, "device_name" : "ios" , "device_token" : deviceToken , "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
    
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    
                    if let userDetailsData = responseData["user_details"] as? Dictionary<String, AnyObject> {
                        
                        let userName = userDetailsData["username"] as? String?
                        let userEmail = userDetailsData["email"] as? String?
                        let userImg = userDetailsData["profile_pic"] as? String?
                        let phone = userDetailsData["phone"] as? String?
                        
                       // UserDefaults.standard.set(self.confirmPwdTF.text!, forKey: "password")
                        // let userImg = userDetailsData["image"] as? String?
                        //let userId = userDetailsData["user_id"] as? Int?
                     
                        // let userImage = String(format: "%@%@",base_path,userImg!!)
                        
                        let x : String = userDetailsData["user_id"] as! String
                        
                       // commentedlet x : Int = userDetailsData["user_id"] as! Int
                        // commented let xNSNumber = x as NSNumber
                        //let xString : String = xNSNumber.stringValue
                        
                        //user_image
                        let userImage = String(format: "%@%@",base_path,userImg!!)
                        
                        UserDefaults.standard.set(userName as Any, forKey: "userName")
                        UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                        UserDefaults.standard.set(x as Any, forKey: "userId")
                        UserDefaults.standard.set(userImage as Any, forKey: "userImage")
                        UserDefaults.standard.set(phone as Any, forKey: "phone")
                        //  UserDefaults.standard.set(userImage as Any, forKey: "userImage")
                        
                        
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        let verifyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyVC") as! VerifyVC
                        self.navigationController?.pushViewController(verifyVC, animated: false)
                   
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

   
extension SignUpVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView,
                        numberOfRowsInComponent component: Int) -> Int {
            
            // Row count: rows equals array length.
            return genderArray.count
        }
        
        func pickerView(_ pickerView: UIPickerView,
                        titleForRow row: Int,
                        forComponent component: Int) -> String? {
            
            // Return a string from the array for this row.
            return genderArray[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.genderTF.text = genderArray[row]
            self.genderString = genderArray[row]
            genderIdString = genderIdArray[row]
     
}
}


extension SignUpVC : UITextFieldDelegate {
    
    //    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
    //                   replacementString string: String) -> Bool //swift 3
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
//        if textField == self.phoneNumberTF{
//            let maxLength = 10
//            let currentString: NSString = textField.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
//        }
//        return true
       
        let phoneNumberlength = 10
        let totalString = "\(phoneNumberTF.text)\(string)"
        var prefix : String! = ""
        if textField == self.phoneNumberTF{
            if textField == self.phoneNumberTF && range.location == 0{
                if (!string.hasPrefix(phoneNumberStart!)){
                    return false
                }
                
            }
            else if textField == self.phoneNumberTF && range.location == 1{
                if (!string.hasPrefix(phoneNumber1Start!)){
                    return false
                }
//                else{return true}
            }
            else{
                newLength = (textField.text?.count)! + string.count - range.length
                return newLength! <= phoneNumberlength
            }
            if totalString.count == 1{
                
            }
//            if totalString.count >= 1{
//                prefix = (totalString as? NSString)?.substring(to: 1)
//                print("first letter \(prefix)")
//                if (prefix == "5") {
//
//                    //phoneNumber_TF.text = totalString.replacingOccurrences(of: totalString, with: "+9665")
//                }
//
//            else{
//                newLength = (textField.text?.count)! + string.count - range.length
//
//                return newLength! <= phoneNumberlength
//                    //return true
//            }
//            }
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let expression = "^([0-9]+)?(\\.([0-9]{1,2})?)?$"
            var regex: NSRegularExpression? = nil
            do {
                regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
            } catch {
            }
            let numberOfMatches: NSInteger = (regex?.numberOfMatches(in: newString, options: [], range: NSMakeRange(0, newString.count)))!
            if(range.length + range.location > (textField.text?.count)!)
            {
                return false
            }
            if numberOfMatches == 0{
                return false
            }
            newLength = (textField.text?.count)! + string.count - range.length
            return newLength! <= phoneNumberlength
            
        }

        return true
    }
    
}

