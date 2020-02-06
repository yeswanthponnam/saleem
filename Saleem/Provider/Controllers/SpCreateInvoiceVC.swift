//
//  SpCreateInvoiceVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 24/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
class SpCreateInvoiceVC: UIViewController,UIGestureRecognizerDelegate {
    //var arryData = ["0"]
    
    var backCheckStr: String?
    
    @IBOutlet var sendInvoiceBtn: UIButton!
    var serviceName: String?
    var servicePrice: String?
    var serviceIdStr: String?
    var additional_amount : String! = ""
    var offer_price: String?
    
    var serviceNameArray = [String]()
    var servicePriceArray = [String]()
    var serviceIDrray = [String]()
    
    var currentTF : UITextField?
    var tagValue : Int?
    @IBOutlet var addServiceBtn: UIButton!
    @IBOutlet var sericePlusBtn: UIButton!
    
    @IBOutlet var issueListUnderLineView: UIView!
    var reqID : String?
    var issuesList : [[String: Any]]!
    var issue_nameArray = [String]()
    
    var rejectString : String! = ""
    var reasonIdString : String! = ""
    var issueIDArray = [String]()
    var issueNameArray = [String]()
    
    //storing issueId and send to server
    var idIssuesArray = [String]()
    
     var arryData = [String]()
    
    @IBOutlet var orderIdStaticLabel: UILabel!
    @IBOutlet var customerNameStaticLabel: UILabel!
    
    @IBOutlet var orderIdLabel: UILabel!
    @IBOutlet var dateStaticLAbel: UILabel!
    
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var invoiceNoStaticLabel: UILabel!
    
    var invoiceNumber : String?
    @IBOutlet var invoiceNoLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var detailsstaticLabel: UILabel!
    @IBOutlet var issueNameStaticLabel: UILabel!
    
    @IBOutlet var serviceView: UIView!
    @IBOutlet var detailsView: UIView!
    
    @IBOutlet var txt_additionPrice: UITextField!
    @IBOutlet var txt_estimatePrice: UITextField!
    @IBOutlet var txt_issueName: UITextField!
    //@IBOutlet var invoice_tableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var invoice_tableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView_Invoice: UITableView!
    
    @IBOutlet var subTotalStaticLabel: UILabel!
    @IBOutlet var subTotalLabel: UILabel!
    @IBOutlet var couponStaticLabel: UILabel!
    @IBOutlet var couponLabel: UILabel!
    @IBOutlet var totalStaticLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    
    @IBOutlet var estimatePriceStatic: UILabel!
    @IBOutlet var additionPriceStatic: UILabel!
    @IBOutlet weak var send_view: UIView!
    @IBOutlet weak var txt_Description: UITextField!
    @IBOutlet weak var customViewHight_Constaint: NSLayoutConstraint!
    
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var genderArray = ["VoiceProblem","DisplayProblem","BatteryProblem"]
    var cell : OrderTypeCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderIdStaticLabel.text = languageChangeString(a_str: "Order Id")
        self.customerNameStaticLabel.text = languageChangeString(a_str: "Customer Name")
        self.invoiceNoStaticLabel.text = languageChangeString(a_str: "Invoice No")
        self.dateStaticLAbel.text = languageChangeString(a_str: "Date")
        
        self.detailsstaticLabel.text = languageChangeString(a_str: "Details")
        self.issueNameStaticLabel.text = languageChangeString(a_str: "Issue Name")
        
        self.estimatePriceStatic.text = languageChangeString(a_str: "Estimated Price")
        self.additionPriceStatic.text = languageChangeString(a_str: "Addition Price")
        self.txt_additionPrice.placeholder = languageChangeString(a_str: "Input Number")
        
        
        self.addServiceBtn.setTitle(languageChangeString(a_str: "Add Service"), for: UIControl.State.normal)
        self.subTotalStaticLabel.text = languageChangeString(a_str: "Sub Total")
        self.couponStaticLabel.text = languageChangeString(a_str: "Admin Price")
        self.totalStaticLabel.text = languageChangeString(a_str: "Total Amount")
        
        self.sendInvoiceBtn.setTitle(languageChangeString(a_str: "SEND INVOICE"), for: UIControl.State.normal)
        txt_Description.text = languageChangeString(a_str: "Description")
        
        if MOLHLanguage.isRTLLanguage(){
            txt_Description.textAlignment = .right
        }else{
            txt_Description.textAlignment = .left
        }
        
        if Reachability.isConnectedToNetwork() {

            getSPInvoiceDetailsServiceCall()

        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        DispatchQueue.main.async {

            self.detailsView.layer.masksToBounds = true
            self.detailsView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
            
            self.serviceView.layer.masksToBounds = true
            self.serviceView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10.0)

        }
        // tableView_Invoice.isHidden = true
       // customViewHight_Constaint.constant = 190
        //commented
        self.invoice_tableHeightConstraint.constant = 0
        //self.tableView_Invoice.frame.size.height = 0
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                            style: .plain,target: self,
                                            action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = barButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = languageChangeString(a_str: "Create Invoice")
        self.txt_Description.setBottomLineBorder()
       // self.txt_issueName.setBottomLineBorder()
        self.txt_additionPrice.setBottomLineBorder()
        self.txt_estimatePrice.setBottomLineBorder()
        
        
        
       /* if (txt_additionPrice.text?.count)! > 0{
            self.addServiceBtn.isEnabled = true
            self.sericePlusBtn.isEnabled = true
        }
        else{
            self.addServiceBtn.isEnabled = false
            self.sericePlusBtn.isEnabled = false
        }*/
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.serviceData),
            name: NSNotification.Name(rawValue: "serviceData"),
            object: nil)
        
       // issuesListServiceCall()
        //createPickerView()
        
        // Do any additional setup after loading the view.
    }

    @objc func serviceData(){
        
        tableView_Invoice.isHidden = false
        //commented
       // self.invoice_tableHeightConstraint.constant = 100
        //customViewHight_Constaint.constant = 260
       // self.serviceNameArray.append("0")
        
        serviceName = UserDefaults.standard.object(forKey: "serviceName") as? String ?? ""
        servicePrice = UserDefaults.standard.object(forKey: "servicePrice") as? String ?? ""
        serviceIdStr = UserDefaults.standard.object(forKey: "serviceID") as? String ?? ""
        
        serviceNameArray.append(serviceName!)
        servicePriceArray.append(servicePrice!)
        serviceIDrray.append(serviceIdStr!)
        print("serviceidArrays\(serviceIDrray)")
        
        self.tableView_Invoice.reloadData()
        
        print("arryData\(arryData)")
        let numberOfSections = self.tableView_Invoice.numberOfSections
        let numberOfRows = self.tableView_Invoice.numberOfRows(inSection: numberOfSections-1)
        print("number of rows\(numberOfRows)")
        let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
        print("indexpath\(indexPath)")
       // self.tableView_Invoice.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)

        print("Price Array:::\(self.servicePriceArray)")
        let intArray = servicePriceArray.map { Int($0)!}
        //let sum = intArray.reduce(0, +) + Int(self.txt_additionPrice.text!)!
        if (self.txt_additionPrice.text?.count)! > 0 {
            let sum = intArray.reduce(0, +) + Int(self.txt_additionPrice.text!)! + Int(self.additional_amount!)!
            print("Total::\(sum)")
            self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
            self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
            self.couponLabel.text = String(format: "%d %@", sum,"SAR")
        }
        else{
            let sum = intArray.reduce(0, +) + Int(self.additional_amount!)!
            print("Total::\(sum)")
            self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
            self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
            self.couponLabel.text = String(format: "%d %@", sum,"SAR")
        }
        
        //let sum = intArray.reduce(0, +) + Int(self.txt_additionPrice.text!)! + Int(self.additional_amount!)!
//        print("Total::\(sum)")
//        self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
//        self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
//        self.couponLabel.text = String(format: "%d %@", sum,"SAR")
        
        
        
       /* if serviceNameArray.count > 1{
            //            if (cell.txt_Estimate_Price.text?.count)! > 0{
            //                addServiceBtn.isEnabled = true
            //                sericePlusBtn.isEnabled = true
            //            }
            //            else
            //            {
            //                addServiceBtn.isEnabled = false
            //                sericePlusBtn.isEnabled = false
            //            }
            let numberOfSections = self.tableView_Invoice.numberOfSections
            let numberOfRows = self.tableView_Invoice.numberOfRows(inSection: numberOfSections-1)
            print("number of rows\(numberOfRows)")
            let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
            print("indexpath\(indexPath)")
            self.tableView_Invoice.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
        else{
            
            print("please fill values")
        }*/
        
        
        
    }
    @objc fileprivate func backButtonTapped() {
        
        if self.backCheckStr == "toComplete"{
            self.navigationController?.popViewController(animated: true)
        }
        
        else{
            
        let alert = UIAlertController(title: languageChangeString(a_str: "Alert"), message: languageChangeString(a_str: "please generate invoice to complete the request"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: languageChangeString(a_str: "NO"), style: .default, handler: { action in
            switch action.style{
            case .default:
                self.dismiss(animated: true, completion: nil)
                
            case .cancel:
                self.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
                
            }}))
        
        alert.addAction(UIAlertAction(title: languageChangeString(a_str: "YES"), style: .default, handler: { action in
            switch action.style{
            case .default:
                //self.dismiss(animated: true, completion: nil)
                self.goToHomeScreen()
                
            case .cancel:
                self.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
                
            }}))
        
        self.present(alert, animated: true, completion: nil)
        }
        
        
       //just today self.navigationController?.popViewController(animated: true)
        
    }
 
    func goToHomeScreen(){
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
    
    @IBAction func btn_AddService_Action(_ sender: UIButton) {
        
       let addVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddServiceVC") as! AddServiceVC
       self.present(addVC, animated: true, completion: nil)
      /*  tableView_Invoice.isHidden = false
        //commented
        self.invoice_tableHeightConstraint.constant = 100
        //customViewHight_Constaint.constant = 260
        self.arryData.append("0")
        self.tableView_Invoice.reloadData()
       
        print("arryData\(arryData)")
        
       
        if arryData.count > 1{
//            if (cell.txt_Estimate_Price.text?.count)! > 0{
//                addServiceBtn.isEnabled = true
//                sericePlusBtn.isEnabled = true
//            }
//            else
//            {
//                addServiceBtn.isEnabled = false
//                sericePlusBtn.isEnabled = false
//            }
                let numberOfSections = self.tableView_Invoice.numberOfSections
                let numberOfRows = self.tableView_Invoice.numberOfRows(inSection: numberOfSections-1)
               print("number of rows\(numberOfRows)")
                let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                print("indexpath\(indexPath)")
                self.tableView_Invoice.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
            else{
            
                print("please fill values")
            }*/
       
        
        
      
        //self.customViewHight_Constaint.constant = CGFloat(self.arryData.count * 240);
    
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
        
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        
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
        cell.txt_Estimate_Price.text = self.rejectString
        reasonIdString = issueIDArray[(pickerView?.selectedRow(inComponent: 0))!]
        if rejectString.count > 0{
            cell.txt_Estimate_Price.text = self.rejectString ?? ""
        }else{
            cell.txt_Estimate_Price.text = issueNameArray[0]
        }
        print("reject string\(String(describing: self.rejectString))")
        idIssuesArray.append(self.reasonIdString)
        print("idIssuesArray\(idIssuesArray)")
        self.view.endEditing(true)
        cell.txt_Estimate_Price.resignFirstResponder()
        addServiceBtn.isEnabled = true
        sericePlusBtn.isEnabled = true
        
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
        cell.txt_Estimate_Price.resignFirstResponder()
    }
    
    @IBAction func btn_SendInvoice_Action(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {

            sendInvoiceServiceCall()

        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
//        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpPendingDetailsVC") as! SpPendingDetailsVC
//        self.navigationController?.pushViewController(gotoVC, animated: true)
 
       /* let alert = UIAlertController(title:"", message:"Your Order as completed  successfully and invoice sent to client", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in
            switch action.style{
                
            case .default:
                
                let mainViewController = self.sideMenuController!
                let SpHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "SpHomeVC") as! SpHomeVC
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(SpHomeVC, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
                
                               
            case .cancel:
                self.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
                
            }}))
//        alert.addAction(UIAlertAction(title:"NO", style: .default, handler: { action in
//            switch action.style{
//            case .default:
//                self.dismiss(animated: true, completion: nil)
//
//            case .cancel:
//                self.dismiss(animated: true, completion: nil)
//
//            case .destructive:
//                print("destructive")
//
//            }}))
        self.present(alert, animated: true, completion: nil)*/
        
        
    }
    
    //SPINVOICE DETAILS SERVICE CALL
    func getSPInvoiceDetailsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         provider_id:*/
        
        let getInvoiceDetails = "\(Base_Url)invoice_details"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        //for noti come let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""

        let parameters: Dictionary<String, Any> = [ "request_id" : self.reqID!,"lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(getInvoiceDetails, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    
                    if let userDetailsData = responseData["invoice"] as? Dictionary<String, AnyObject> {
                        
                        self.issuesList = userDetailsData["issues_list"] as? [[String: Any]]
                        
                        let userName = userDetailsData["name"] as? String?
                        //let invoice_number =
                        self.invoiceNumber = (userDetailsData["invoice_number"] as? String?)!
                        let order_id = userDetailsData["order_id"] as? String?
                        let date = userDetailsData["date"] as? String?
                        self.additional_amount = (userDetailsData["additional_amount"] as? String?)!
                        self.offer_price = (userDetailsData["offer_price"] as? String?)!
                        //self.additional_amount = "10"
                        for each in self.issuesList! {
                            
                            let issue_name = each["issue_name"]  as! String
                            self.txt_issueName.text = issue_name
                            //self.issue_idArray.append(issue_id)
                            self.issue_nameArray.append(issue_name)
                            //self.issue_statusArray.append(issue_status)
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.customerNameLabel.text = userName as? String
                            self.orderIdLabel.text = order_id as? String
                            self.dateLabel.text = date as? String
                            self.invoiceNoLabel.text = self.invoiceNumber
                            
//                            self.dateTimeLabel.text = date as? String
//                            self.problemTypeLabel.text = issues as? String
//                            self.issueDescTV.text = description as? String
//                            self.userImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: ""))
                            //self.timerLabel.text = request_timer as? String
                            
                            let sum = Int(self.additional_amount!)!
                            print("Total::\(sum)")
                            self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
                            self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
                            self.couponLabel.text = String(format: "%d %@", sum,"SAR")
                            self.txt_estimatePrice.text = self.offer_price
                            
                            if (self.issuesList?.count)! > 1{
                                self.issueListUnderLineView.isHidden = false
                                self.txt_issueName.isUserInteractionEnabled = true
                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapIssues))
                                //UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
                                self.txt_issueName.addGestureRecognizer(tap)
                            }
                            else{
                                self.issueListUnderLineView.isHidden = true
                                self.txt_issueName.isUserInteractionEnabled = false
                            }
                            
                        }
                        
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
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
    @objc func onTapIssues(sender:UITapGestureRecognizer) {
        
        print("tap working")
        UserDefaults.standard.setValue(self.issue_nameArray, forKey: "list")
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }
    //FOR SERVICE CALL FOR ISSUES
    
    func issuesListServiceCall ()
    {
        //category_id=2&benfit=&sort=&lang=en
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let vehicles = "\(Base_Url)issues_list?"
        
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
                    //print("services categorys are ***** \(servicesCat!)")
                    
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
                            //self.showToast(message: message!)
                        }
                    
                }
                else
                {
                    //self.showToastForAlert(message: message!)
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.showToast(message: message!)
                }
            }
        }
    }
    //SEND OFFER SERVICE CALL
    func sendInvoiceServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         invoice_number:
         invoice_description:
         issue_id[]:
         issue_price[]:
         provider_amount:*/
        
        let signup = "\(Base_Url)generate_invoice"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
  
        let parameters: Dictionary<String, Any> = [ "invoice_number" : self.invoiceNumber!, "invoice_description" :self.txt_Description.text!,"issue_id":serviceIDrray ,"issue_price":servicePriceArray,"provider_amount":txt_additionPrice.text!,"lang" : language,"API-KEY":APIKEY]
        
        //,"latitude":self.latitudeString!,"longitude":self.longitudeString!
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
                        
                        self.showToast(message: message)
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
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    //self.showToastForAlert(message: message)
                    self.showToast(message: message)
                }
            }
        }
    }
    
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
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SpCreateInvoiceVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SpCreateInvoiceVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        //pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
        
        
    }
    
}

extension  SpCreateInvoiceVC :UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.arryData.count
//        let height: CGFloat = CGFloat(serviceNameArray.count * 90)
//        if view.frame.size.height / 2 + 180 >= height {
//            invoice_tableHeightConstraint.constant = CGFloat(serviceNameArray.count * 90)
//            print("view height \(view.frame.size.height - 260)\(height) ")
//        } else {
//            print("less view height \(view.frame.size.height)")
//            invoice_tableHeightConstraint.constant = view.frame.size.height / 2 + 180
//        }
//        return self.serviceNameArray.count
        
        let height: CGFloat = CGFloat(serviceNameArray.count * 90)
        if view.frame.size.height / 2 + 80 >= height {
            invoice_tableHeightConstraint.constant = CGFloat(serviceNameArray.count * 90)
            print("view height \(view.frame.size.height - 160)\(height) ")
        } else {
            print("less view height \(view.frame.size.height)")
            invoice_tableHeightConstraint.constant = view.frame.size.height / 2 + 80
        }
        return self.serviceNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = tableView_Invoice.dequeueReusableCell(withIdentifier: "cell") as? OrderTypeCell
        //cell.txt_IssueName.setBottomLineBorder()
        cell.txt_Estimate_Price.setBottomLineBorder()
        cell.txt_Addition_Price.setBottomLineBorder()
//        if indexPath.row == 0{
//            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }else{
//            cell.contentView.backgroundColor = #colorLiteral(red: 0.6700000167, green: 0.6700000167, blue: 0.6700000167, alpha: 0.2)
//        }
        cell.issueNameStatic.text = languageChangeString(a_str: "Issue Name")
        cell.additionPriceStatic.text = languageChangeString(a_str: "Addition Price")
        
        cell.txt_Estimate_Price.text = serviceNameArray[indexPath.row]
            //as? String ?? ""
        cell.txt_Addition_Price.text = servicePriceArray[indexPath.row]
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteClicked(sender:)), for: UIControl.Event.touchUpInside)
      /*  cell.txt_Estimate_Price.tag = indexPath.row
        cell.txt_Addition_Price.tag = indexPath.row
        tagValue = cell.txt_Estimate_Price.tag
        print("tagvalue\(tagValue)")
        if indexPath.row == 0{
                cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            cell.contentView.backgroundColor = #colorLiteral(red: 0.6700000167, green: 0.6700000167, blue: 0.6700000167, alpha: 0.2)
        }
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteClicked(sender:)), for: UIControl.Event.touchUpInside)
        
//        if (cell.txt_Estimate_Price.text?.count)! > 0{
//            addServiceBtn.isEnabled = true
//            sericePlusBtn.isEnabled = true
//        }
//        else
//        {
//            addServiceBtn.isEnabled = false
//            sericePlusBtn.isEnabled = false
//        }
        let tap = UITapGestureRecognizer(target: self,action: #selector(handleTaponTextField(_:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        cell.txt_Estimate_Price.isUserInteractionEnabled = true
        cell.txt_Estimate_Price.addGestureRecognizer(tap)
//        cell.txt_Estimate_Price.inputView = self.pickerView
//        cell.txt_Estimate_Price.inputAccessoryView = self.pickerToolBar*/
        
        
        
        return cell
    }
    
    @objc func deleteClicked(sender:UIButton){
        
      //  let buttonRow = sender.tag
        
        self.serviceIDrray.remove(at: sender.tag)
        self.serviceNameArray.remove(at: sender.tag)
        self.servicePriceArray.remove(at: sender.tag)
        self.tableView_Invoice.reloadData()
        print("serviceIdarray\(serviceIDrray)")
        print("serviceNameArray\(serviceNameArray)")
        print("servicePriceArray\(servicePriceArray)")
        
        print("Price Array:::\(self.servicePriceArray)")
        
//        let intArray = servicePriceArray.map { Int($0)!}
//        let sum = intArray.reduce(0, +) + Int(self.txt_additionPrice.text!)! + Int(self.additional_amount!)!
//        print("Total::\(sum)")
        
        if (self.txt_additionPrice.text?.count)! > 0 {
            let intArray = servicePriceArray.map { Int($0)!}
            let sum = intArray.reduce(0, +) + Int(self.txt_additionPrice.text!)! + Int(self.additional_amount!)!
            print("Total::\(sum)")
            self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
            self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
            self.couponLabel.text = String(format: "%d %@", sum,"SAR")
        }
        else{
            let intArray = servicePriceArray.map { Int($0)!}
            let sum = intArray.reduce(0, +)  + Int(self.additional_amount!)!
            print("Total::\(sum)")
            self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
            self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
            self.couponLabel.text = String(format: "%d %@", sum,"SAR")
        }
//        self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
//        self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
//        self.couponLabel.text = String(format: "%d %@", sum,"SAR")
    }
    @objc func handleTaponTextField(_ sender: UITapGestureRecognizer)
    {
        //comcreatePickerView()
       // issuesListServiceCall()
        print("Tap is handled here!")
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return (self.tableView_Invoice.frame.size.height)/CGFloat(serviceNameArray.count)
        return 90
//
    }
}

//extension UIView
//{
//    func roundCorners(corners:UIRectCorner, radius: CGFloat)
//    {
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
//        self.layer.mask = maskLayer
//    }
//}
extension SpCreateInvoiceVC:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //cell = tableView_Invoice.dequeueReusableCell(withIdentifier: "cell") as? OrderTypeCell
        
//        let buttonPosition:CGPoint = textField.convert(CGPoint.zero, to:self.tableView_Invoice)
//        let indexPath = self.tableView_Invoice.indexPathForRow(at: buttonPosition)
//        cell = self.tableView_Invoice.cellForRow(at: indexPath!) as! OrderTypeCell
        
        //self.issuesListServiceCall()
        //self.pickUp(cell.txt_Estimate_Price)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       /* if (txt_additionPrice.text?.count)! > 0{
            self.addServiceBtn.isEnabled = true
            self.sericePlusBtn.isEnabled = true
        }
        else{
            self.addServiceBtn.isEnabled = false
            self.sericePlusBtn.isEnabled = false
        }*/
        
        //let sum = intArray.reduce(0, +) + Int(self.txt_additionPrice.text!)!
        if (txt_additionPrice.text?.count)! > 0{
            let sum = Int(self.txt_additionPrice.text!)! + Int(self.additional_amount!)!
            print("Total::\(sum)")
            self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
            self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
            self.couponLabel.text = String(format: "%d %@", sum,"SAR")
        }
        else{
            let sum = Int(self.additional_amount!)!
            print("Total::\(sum)")
            self.subTotalLabel.text = String(format: "%d %@", sum,"SAR")
            self.totalAmountLabel.text = String(format: "%d %@", sum,"SAR")
            self.couponLabel.text = String(format: "%d %@", sum,"SAR")
        }
    }
}
extension SpCreateInvoiceVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        // Row count: rows equals array length.
        return issueNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        return issueNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cell.txt_Estimate_Price.text = issueNameArray[row]
        self.rejectString = issueNameArray[row]
        reasonIdString = issueIDArray[row]
    }
}


