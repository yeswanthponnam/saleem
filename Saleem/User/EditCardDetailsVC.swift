//
//  EditCardDetailsVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 16/02/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
class EditCardDetailsVC: UIViewController {

    @IBOutlet var payNowBtn: UIButton!
    var checkStr : String?
    var serviceName : String?
    var params = [String:Any]()
    
    var cardTypeStr : String?
    var nameOnCardStr : String?
    var cardNumberStr : String?
    var cardExpiryDateStr : String?
    var cardCVVStr : String?
       
    @IBOutlet var enterCardDetailStaticLabel: UILabel!
    @IBOutlet var cardTypeStaticLabel: UILabel!
    @IBOutlet var cardNameStaticLabel: UILabel!
    @IBOutlet var cardNumberStaticLabel: UILabel!
    @IBOutlet var cardExpiryStaticLabel: UILabel!
    @IBOutlet var cvvStaticLabel: UILabel!
    @IBOutlet var secureSaveCardBtn: UIButton!
    
    @IBOutlet var cardTypeTF: UITextField!
    @IBOutlet var nameOnCardTF: UITextField!
    @IBOutlet var cardNumberTF: UITextField!
    @IBOutlet var cardExpiryTF: UITextField!
    @IBOutlet var cvvTF: UITextField!
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var cardTypeString : String! = ""
    var cardTypeIDString : String! = ""
    var card_type_idArray = [String]()
    var card_type_nameArray = [String]()

    var cardIdStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if MOLHLanguage.isRTLLanguage(){
            self.cardTypeTF.textAlignment = .right
            self.nameOnCardTF.textAlignment = .right
            self.cardNumberTF.textAlignment = .right
            self.cardExpiryTF.textAlignment = .right
            self.cvvTF.textAlignment = .right
        }
        else{
            self.cardTypeTF.textAlignment = .left
            self.nameOnCardTF.textAlignment = .left
            self.cardNumberTF.textAlignment = .left
            self.cardExpiryTF.textAlignment = .left
            self.cvvTF.textAlignment = .left
        }
        
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(backBtnAction), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        
        enterCardDetailStaticLabel.text = languageChangeString(a_str: "ENTER YOUR CARD DETAILS")
        cardTypeStaticLabel.text = languageChangeString(a_str:"Card Type")
        cardNameStaticLabel.text = languageChangeString(a_str:"Name on Card")
        cardNumberStaticLabel.text = languageChangeString(a_str:"Card Number")
        cardExpiryStaticLabel.text = languageChangeString(a_str:"Card Expiry")
        cvvStaticLabel.text = languageChangeString(a_str:"CVV")
        secureSaveCardBtn.setTitle(languageChangeString(a_str: "Securely Save my Card For Future Use"), for: UIControl.State.normal)
        if checkStr == "addCard"{
            self.navigationItem.title = languageChangeString(a_str:"Add card")
            self.payNowBtn.setTitle(languageChangeString(a_str: "Add card"), for: UIControl.State.normal)
        }
        else{
            self.navigationItem.title = languageChangeString(a_str: "Edit Card")
            self.payNowBtn.setTitle(languageChangeString(a_str: "Edit Card"), for: UIControl.State.normal)
        }
        
        self.cardTypeTF.text = self.cardTypeStr
        self.nameOnCardTF.text = self.nameOnCardStr
        self.cardNumberTF.text = self.cardNumberStr
        self.cardExpiryTF.text = self.cardExpiryDateStr
        self.cvvTF.text = self.cardCVVStr
        
    }
    
    @objc func backBtnAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payAction(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            
            addCardsServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
     
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == self.cardTypeTF)
        {
            if Reachability.isConnectedToNetwork() {
                
                self.cardTypesServiceCall()
            }else
            {
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                // showToastForAlert (message:"Please ensure you have proper internet connection.")
            }
            self.pickUp(self.cardTypeTF)
        }
    }
 
    //   MARK: - Custom PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        //  toolBar.backgroundColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: languageChangeString(a_str: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        //pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
      }
   
    @objc func donePickerView(){
            self.cardTypeString = card_type_nameArray[(pickerView?.selectedRow(inComponent: 0))!]
            self.cardTypeTF.text = self.cardTypeString
            cardTypeIDString = card_type_idArray[(pickerView?.selectedRow(inComponent: 0))!]
            if cardTypeString.count > 0{
                self.cardTypeTF.text = self.cardTypeString ?? ""
            }else{
                self.cardTypeTF.text = card_type_nameArray[0]
            }
            self.view.endEditing(true)
            cardTypeTF.resignFirstResponder()
    }
    
    @objc func cancelPickerView(){
        
            if (cardTypeTF.text?.count)! > 0 {
                self.view.endEditing(true)
                cardTypeTF.resignFirstResponder()
            }else{
                self.view.endEditing(true)
                cardTypeTF.text = ""
                cardTypeTF.resignFirstResponder()
            }
            cardTypeTF.resignFirstResponder()
            
            print("model cancel")
        }
  
     //MARK: FOR SERVICE CALL FOR CARD TYPES
    
    func cardTypesServiceCall ()
    {
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let cardTypes = "\(Base_Url)get_card_types?"
        let parameters: Dictionary<String, Any> = ["API-KEY" : APIKEY ,"lang" : language ]
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(cardTypes, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                self.card_type_idArray = [String]()
                self.card_type_nameArray = [String]()
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                   
                    let cardList = responseData["card_types"] as? [[String:Any]]
                        for each in cardList! {
                            let card_type_id = each["card_type_id"]  as! String
                            let card_type_name = each["card_type_name"]  as! String
                        
                            self.card_type_idArray.append(card_type_id)
                            self.card_type_nameArray.append(card_type_name)
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
    
    
    //MARK: ADD CARDS SERVICE CALL
    func addCardsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         user_id:
         card_type:
         card_number:
         name_on_card:
         expiry_date:(MM/YY)
         cvv:*/
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        if checkStr == "addCard"{
             serviceName = "\(Base_Url)add_cards"
           params = [ "user_id" : userID!,  "card_type" : cardTypeIDString!,"card_number":cardNumberTF.text! ,"name_on_card" : nameOnCardTF.text!,"expiry_date" : cardExpiryTF.text! , "cvv" : cvvTF.text! , "lang" : language,"API-KEY":APIKEY]
        }
        
        else{
            serviceName = "\(Base_Url)edit_cards"
            params = [ "card_id":self.cardIdStr!, "card_type" : cardTypeIDString!,"card_number":cardNumberTF.text! ,"name_on_card" : nameOnCardTF.text!,"expiry_date" : cardExpiryTF.text! , "cvv" : cvvTF.text! , "lang" : language,"API-KEY":APIKEY]
        }
    
       // let parameters: Dictionary<String, Any> = [ "user_id" : userID!,  "card_type" : cardTypeTF.text!,"card_number":cardNumberTF.text! ,"name_on_card" : nameOnCardTF.text!,"expiry_date" : cardExpiryTF.text! , "cvv" : cvvTF.text! , "lang" : language,"API-KEY":APIKEY]
        
        print(params)
        
        Alamofire.request(serviceName!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        let UserProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
                        self.navigationController?.pushViewController(UserProfileVC, animated: false)
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

extension EditCardDetailsVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        // Row count: rows equals array length.
        return card_type_idArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        // Return a string from the array for this row.
        return card_type_nameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            cardTypeTF.text =  card_type_nameArray[row]
            self.cardTypeString = card_type_nameArray[row]
            cardTypeIDString = card_type_idArray[row]
          }
 }

extension EditCardDetailsVC : UITextFieldDelegate {
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
//                   replacementString string: String) -> Bool //swift 3
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.cardNumberTF{
//        let maxLength = 16
//        let currentString: NSString = textField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
            
//            var strText: String? = textField.text
//            if strText == nil {
//                strText = ""
//            }
//
//            strText = strText?.replacingOccurrences(of: " ", with: "")
//            if strText!.characters.count > 1 && strText!.characters.count % 4 == 0 && string != "" {
//                print(strText?.characters.count)
//                //&& strText!.characters.count % 2 == 0
//                textField.text = "\(textField.text!) \(string)"
//                return false
//            }
//            else{
//                return true
//
//            }
            
            
            if range.location == 19 {
                return false
            }
            
            if range.length == 1 {
                if (range.location == 5 || range.location == 10 || range.location == 15) {
                    let text = textField.text ?? ""
                    textField.text = text.substring(to: text.index(before: text.endIndex))
                }
                return true
            }
            
            if (range.location == 4 || range.location == 9 || range.location == 14) {
                textField.text = String(format: "%@ ", textField.text ?? "")
            }
            
        }
        else if textField == self.cvvTF{
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField == cardExpiryTF {
            if range.location == 5 {
                return false
            }
            
            if range.length == 1 {
                if (range.location == 3) {
                    let text = textField.text ?? ""
                    textField.text = text.substring(to: text.index(before: text.endIndex))
                    //let newStr = str[..<index]
                   // textField.text = [Int](String(text[index...]))
                        //text.substring(to: text.index(before: text.endIndex))
                }
                return true
            }
            
            if (range.location == 2) {
                textField.text = String(format: "%@/", textField.text ?? "")
            }
            
           /* var strText: String? = textField.text
            if strText == nil {
                strText = ""
            }
            strText = strText?.replacingOccurrences(of: "/", with: "")
            if strText!.characters.count == 2 && string != "" {
                print(strText?.characters.count)
                //&& strText!.characters.count % 2 == 0
                textField.text = "\(textField.text!)/\(string)"
                return false
            }
            else{
                
                let maxLength = 5
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }*/
    
        }
        return true
    }

}


