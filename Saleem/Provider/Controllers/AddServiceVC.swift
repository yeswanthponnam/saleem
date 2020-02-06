//
//  AddServiceVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 20/05/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
class AddServiceVC: UIViewController {

    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var rejectString : String! = ""
    var reasonIdString : String! = ""
    var issueIDArray = [String]()
    var issueNameArray = [String]()
    
    @IBOutlet var issueNameTF: UITextField!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        issueNameTF.placeholder = languageChangeString(a_str: "Add issue name")
        priceTF.placeholder = languageChangeString(a_str: "Add Price")
        self.issueNameTF.setBottomLineBorder()
        self.priceTF.setBottomLineBorder()
        
        createPickerView()
        if Reachability.isConnectedToNetwork() {
            issuesListServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        // Do any additional setup after loading the view.
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
        self.issueNameTF.inputView = self.pickerView
        self.issueNameTF.inputAccessoryView = self.pickerToolBar
        //        cell = OrderTypeCell(style: .default, reuseIdentifier: "OrderTypeCell")
        //
        //        var position = textField.convert(CGPoint.zero, to: packageTV)
        //        var indexPath: IndexPath? = packageTV.indexPathForRow(at: position)
        //        cell = packageTV.cellForRow(at: indexPath) as? PackCell
        
        
        //        cell.txt_Estimate_Price.inputView = self.pickerView
        //        cell.txt_Estimate_Price.inputAccessoryView = self.pickerToolBar
        
        self.pickerView?.reloadInputViews()
        self.pickerView?.reloadAllComponents()
        
    }
    @objc func donePickerView(){
        
        self.rejectString = issueNameArray[(pickerView?.selectedRow(inComponent: 0))!]
        self.issueNameTF.text = self.rejectString
        reasonIdString = issueIDArray[(pickerView?.selectedRow(inComponent: 0))!]
        if rejectString.count > 0{
            self.issueNameTF.text = self.rejectString ?? ""
        }else{
            self.issueNameTF.text = issueNameArray[0]
        }
        print("reject string\(String(describing: self.rejectString))")
//        idIssuesArray.append(self.reasonIdString)
//        print("idIssuesArray\(idIssuesArray)")
        self.view.endEditing(true)
        self.issueNameTF.resignFirstResponder()
        
    }
    
    @objc func cancelPickerView(){
        //        if (txt_reminder.text?.count)! > 0 {
        //            self.view.endEditing(true)
        //            txt_reminder.resignFirstResponder()
        //        }else{
        //            self.view.endEditing(true)
        //            txt_reminder.text = ""
        //            txt_reminder.resignFirstResponder()
        //        }
        self.issueNameTF.resignFirstResponder()
    }
    
    @IBAction func closeAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitAction(_ sender: Any) {
        
        if !((self.priceTF.text?.count)! > 0){
            showToast(message: languageChangeString(a_str: "Please Add Price")!)
        }
        else if !((self.issueNameTF.text?.count)! > 0){
            showToast(message: languageChangeString(a_str: "Please Add IssueName")!)
        }
        else{
            dismiss(animated: true, completion: nil)
            UserDefaults.standard.setValue(self.priceTF.text!, forKey: "servicePrice")
            UserDefaults.standard.setValue(rejectString, forKey: "serviceName")
            UserDefaults.standard.setValue(reasonIdString, forKey: "serviceID")
            NotificationCenter.default.post(name: Notification.Name("serviceData"), object: nil)
        }
    }
    
    //FOR SERVICE CALL FOR ISSUES
    
    func issuesListServiceCall ()
    {
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let vehicles = "\(Base_Url)issues_list?"
        let userID = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
        let parameters: Dictionary<String, Any> = ["API-KEY" : APIKEY ,"lang" : language ]
        print(vehicles)
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(vehicles, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.issueIDArray = [String]()
                self.issueNameArray = [String]()
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let servicesCat = responseData["issues_list"] as? [[String:Any]]
                    
                    for servicesCat in servicesCat! {
                        
                        let issue_id = servicesCat["issue_id"]  as! String
                        let issue_name = servicesCat["issue_name"]  as! String
                        
                        self.issueIDArray.append(issue_id)
                        self.issueNameArray.append(issue_name)
                  
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
}


extension AddServiceVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return issueNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return issueNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.issueNameTF.text = issueNameArray[row]
        self.rejectString = issueNameArray[row]
        reasonIdString = issueIDArray[row]
    }
}
