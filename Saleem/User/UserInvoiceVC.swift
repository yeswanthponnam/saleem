//
//  UserInvoiceVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 24/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire

class UserInvoiceVC: UIViewController {

    var reqIdStr : String?
    
    var offer_price: String?
    var additional_amount : String?
    var total_amount: String?
    
    var discount_amount: String? = ""
    
    var final_amount: String?
    
    var coupon_code: String?
    
    var addn_issues_amount: String?
    var provider_amount: String?
    
    var invoiceNumber : String?
    var issuesList : [[String: Any]]!
    var issue_nameArray = [String]()
    
    @IBOutlet var issueListUnderLineView: UIView!
    @IBOutlet var orderIdStaticLabel: UILabel!
    @IBOutlet var customerNameStaticLabel: UILabel!
    
    @IBOutlet var orderIdLabel: UILabel!
    @IBOutlet var customerNameLabel: UILabel!
    
    @IBOutlet var invoiceNoStaticLabel: UILabel!
    @IBOutlet var dateStaticLabel: UILabel!
    
    @IBOutlet var invoiceNoLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var detailsStaticLabel: UILabel!
    @IBOutlet var issueNameLabel: UILabel!
    
    @IBOutlet var estimatePriceStatic: UILabel!
    @IBOutlet var additionPriceStatic: UILabel!
    
    @IBOutlet var adminPriceStatic: UILabel!
    @IBOutlet var adminPriceLabel: UILabel!
    
    @IBOutlet var providerAmountStatic: UILabel!
    @IBOutlet var providerAmountLabel: UILabel!
    
    @IBOutlet var couponPercentageLabel: UILabel!
    @IBOutlet var discountAmountLabel: UILabel!
    @IBOutlet var subtotalStatic: UILabel!
    
    @IBOutlet var estimatePriceLabel: UILabel!
    @IBOutlet var additionPriceLabel: UILabel!
    @IBOutlet var subTotalLabel: UILabel!
    
    @IBOutlet var discountCodeStatic: UILabel!
    
    @IBOutlet var couponStaticLabel: UILabel!
    
    @IBOutlet var totalAmountStaticLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    @IBOutlet var applyBtn: UIButton!
    
    @IBOutlet var orderidView: UIView!
    @IBOutlet var invoiceView: UIView!
    
    @IBOutlet var couponView: UIView!
    @IBOutlet var amountView: UIView!
    
    @IBOutlet var couponCodeTF: UITextField!
    @IBOutlet var confirmPayBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = languageChangeString(a_str: "Invoice Details")
        self.orderIdStaticLabel.text = languageChangeString(a_str: "Order Id")
        self.customerNameStaticLabel.text = languageChangeString(a_str: "Customer Name")
        self.invoiceNoStaticLabel.text = languageChangeString(a_str: "Invoice No")
        self.dateStaticLabel.text = languageChangeString(a_str: "Date")
        self.detailsStaticLabel.text = languageChangeString(a_str: "Details")
        self.estimatePriceStatic.text = languageChangeString(a_str: "Estimated Price")
        self.adminPriceStatic.text = languageChangeString(a_str: "Admin Price")
        self.providerAmountStatic.text = languageChangeString(a_str: "Provider Amount")
        self.additionPriceStatic.text = languageChangeString(a_str: "Addition Price")
        self.subtotalStatic.text = languageChangeString(a_str: "Sub Total")
        self.discountCodeStatic.text = languageChangeString(a_str: "Discount coupon codes")
        self.couponCodeTF.placeholder = languageChangeString(a_str: "Enter your coupon code")
        self.couponStaticLabel.text = languageChangeString(a_str: "Coupon")
        self.totalAmountStaticLabel.text = languageChangeString(a_str: "Total Amount")
        self.confirmPayBtn.setTitle(languageChangeString(a_str: "CONFIRM & PAY"), for: UIControl.State.normal)
        self.applyBtn.setTitle(languageChangeString(a_str: "APPLY"), for: UIControl.State.normal)
        
        if Reachability.isConnectedToNetwork() {

            getUserInvoiceDetailsServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        DispatchQueue.main.async {
            self.orderidView.layer.masksToBounds = true
            self.orderidView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
            
            self.invoiceView.layer.masksToBounds = true
            self.invoiceView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10.0)
            
            self.amountView.layer.masksToBounds = true
            self.amountView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10.0)
            
            self.couponView.layer.masksToBounds = true
            self.couponView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
        }
       
       
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        couponCodeTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        couponCodeTF.layer.borderWidth = 1.0
        
        self.discountAmountLabel.text = String(format: "0 %@","SAR")
        self.couponPercentageLabel.text = ""
    }
    

    @IBAction func backAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "delegate") == "InvoiceFromAppDel"{
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
            UserDefaults.standard.removeObject(forKey: "delegate")
        }
        else{
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func confirmPayAction(_ sender: Any) {
        let PaymentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        PaymentVC.reqIdStr = self.reqIdStr
        PaymentVC.total_amount = self.total_amount
        PaymentVC.coupon_code = self.couponCodeTF.text!
        PaymentVC.discount_amount = self.discount_amount
            //?? ""
        self.navigationController?.pushViewController(PaymentVC, animated: false)
    }
    
    @IBAction func applyCouponCodeBtnAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            
            applyCouponCodeServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    //USER INVOICE DETAILS SERVICE CALL
    func getUserInvoiceDetailsServiceCall()
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
        if UserDefaults.standard.string(forKey: "invoiceReqId") != nil{
            self.reqIdStr = UserDefaults.standard.string(forKey: "invoiceReqId")
        }
        
        let parameters: Dictionary<String, Any> = [ "request_id" : self.reqIdStr!,"lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(getInvoiceDetails, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    if UserDefaults.standard.string(forKey: "invoiceReqId") != nil{
                        UserDefaults.standard.removeObject(forKey: "invoiceReqId")
                    }
                    if let userDetailsData = responseData["invoice"] as? Dictionary<String, AnyObject> {
                        
                        self.issuesList = userDetailsData["issues_list"] as? [[String: Any]]
                        
                        let userName = userDetailsData["name"] as? String?
                        self.invoiceNumber = (userDetailsData["invoice_number"] as? String?)!
                        let order_id = userDetailsData["order_id"] as? String?
                        let date = userDetailsData["date"] as? String?
                        
                        self.additional_amount = (userDetailsData["additional_amount"] as? String?)!
                        self.offer_price = (userDetailsData["offer_price"] as? String?)!
                        self.total_amount = (userDetailsData["total_amount"] as? String?)!
                        
                        self.addn_issues_amount = (userDetailsData["addn_issues_amount"] as? String?)!
                        self.provider_amount = (userDetailsData["provider_amount"] as? String?)!
                        
                        for each in self.issuesList! {
                            
                            let issue_name = each["issue_name"]  as! String
                            self.issueNameLabel.text = issue_name
                            self.issue_nameArray.append(issue_name)
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.customerNameLabel.text = userName as? String
                            self.orderIdLabel.text = order_id as? String
                            self.dateLabel.text = date as? String
                            self.invoiceNoLabel.text = self.invoiceNumber
                            
                            self.estimatePriceLabel.text = String(format: "%@ %@", self.offer_price!,"SAR")
                            self.adminPriceLabel.text = String(format: "%@ %@", self.additional_amount!,"SAR")
                            self.providerAmountLabel.text = String(format: "%@ %@", self.provider_amount!,"SAR")
                            self.additionPriceLabel.text = String(format: "%@ %@", self.addn_issues_amount!,"SAR")
                            self.totalAmountLabel.text = String(format: "%@ %@", self.total_amount!,"SAR")
                            self.subTotalLabel.text = String(format: "%@ %@", self.total_amount!,"SAR")
//                            self.discountAmountLabel.text = String(format: "%d %@", self.discount_amount!,"SAR")
                            
                            
                            //                            self.dateTimeLabel.text = date as? String
                            //                            self.problemTypeLabel.text = issues as? String
                            //                            self.issueDescTV.text = description as? String
                            //                            self.userImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: ""))
                            //self.timerLabel.text = request_timer as? String
                            
                            if (self.issuesList?.count)! > 1{
                                self.issueListUnderLineView.isHidden = false
                                self.issueNameLabel.isUserInteractionEnabled = true
                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapIssues))
                                self.issueNameLabel.addGestureRecognizer(tap)
                            }
                            else{
                                self.issueListUnderLineView.isHidden = true
                                //self.issueNameLabel.isUserInteractionEnabled = false
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
    //APPLY COUPON SERVICE CALL
    func applyCouponCodeServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         coupon_code:*/
        
        let signup = "\(Base_Url)apply_coupon"
        
        //let deviceToken = "12345"
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : self.reqIdStr!,  "coupon_code" : couponCodeTF.text!,"lang" : language,"API-KEY":APIKEY]
        //,"latitude":self.latitudeString!,"longitude":self.longitudeString!
        print(parameters)
        
        Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
             
                if status == 1
                {
                    if let details = responseData["details"] as? Dictionary<String, AnyObject> {
                        
                       self.final_amount = details["final_amount"] as? String
                       self.coupon_code = details["coupon_applied"] as? String
                       self.discount_amount = details["discount_amount"] as? String
                        
                        DispatchQueue.main.async {
                            self.discountAmountLabel.text = String(format: "%@ %@", self.discount_amount!,"SAR")
                            self.totalAmountLabel.text = String(format: "%@ %@", self.final_amount!,"SAR")
                            self.couponPercentageLabel.text = String(format: "%@ %@",  self.coupon_code!,"SAR")
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
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

extension UIView
{
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = maskLayer
    }
}
