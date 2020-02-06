//
//  SpPaymentsVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 21/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire

class SpPaymentsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var fromDateStr : String?
    var toDateStr : String?
    var priceStr : String?
    var checkFiltStr : String?
    
    @IBOutlet weak var payment_view: UIView!
    
    @IBOutlet var paymentTableView: UITableView!
    @IBOutlet var receivedAmountStatic: UILabel!
    @IBOutlet var adminAccountStatic: UILabel!
    @IBOutlet var remainingBalanceStatic: UILabel!
    
    @IBOutlet var receivedAmountLabel: UILabel!
    @IBOutlet var adminAmountLabel: UILabel!
    @IBOutlet var remainingBalanceLabel: UILabel!
    @IBOutlet var totalSummaryStaticLabel: UILabel!
    
    var paymodeArray = [String]()
    var dateArray = [String]()
    var orderNoArray = [String]()
    var orderAmountArray = [String]()
    var adminAmountArray = [String]()
    var providerPaymentArray = [String]()
    var imageArray = [String]()
    var params = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = languageChangeString(a_str: "Payments")
        totalSummaryStaticLabel.text = languageChangeString(a_str: "Total summary for the month")
        remainingBalanceStatic.text = languageChangeString(a_str: "Remaining balance")
        adminAccountStatic.text = languageChangeString(a_str: "Admin amount")
        receivedAmountStatic.text = languageChangeString(a_str: "Received amount")
        
        self.payment_view.dropShadow(color: .lightGray, offSet: CGSize(width: 1, height: 1))
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSPFilterData(_:)), name: NSNotification.Name(rawValue: "getSPFilterData"), object: nil)
  
        
    }

    
    @objc func getSPFilterData(_ notification: NSNotification){
        
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            fromDateStr = dict["key"] as? String
            toDateStr = dict["key1"] as? String
            priceStr = dict["key2"] as? String
            checkFiltStr = dict["key3"] as? String
            //as Any as? String
            
            print("fromDateStr",fromDateStr as Any)
            print("toDateStr",toDateStr)
            print("priceStr",priceStr)
           
            print("checkFiltStr",checkFiltStr)
            
        }
        
        //        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        //        let UserRequestsVC = storyBoard.instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
        //        //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewDetailsVC") as! UserViewDetailsVC
        //        UserRequestsVC.checkFiltStr = checkFiltStr
        //        UserRequestsVC.fromDateStr = fromDateStr
        //        UserRequestsVC.toDateStr = toDateStr
        //        UserRequestsVC.priceStr = priceStr
        //        UserRequestsVC.statusStr = statusStr
        //        self.navigationController?.pushViewController(UserRequestsVC, animated: true)
        if Reachability.isConnectedToNetwork() {
            
            paymentHistoryServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        
        //        let checkStr = UserDefaults.standard.object(forKey: "filter") as? String ?? ""
        //         if checkStr == "filter"{
        //            userReqListServiceCall()
        //        }
        //         else{
        //
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() {
            
            paymentHistoryServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    
    // #MARK:- BACK BAR Button  Action
    
     @IBAction func btn_Back_Action(_ sender: Any) {
        
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
                
    }
    
     // #MARK:- BACK BAR Button  Action
    
    @IBAction func btn_Filter_Action(_ sender: UIBarButtonItem) {
        
        
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpFilterVC") as! SpFilterVC
        
            self.present(gotoVC, animated: true, completion: nil)
        
    }
    

    
    // #MARK:- TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderNoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = paymentTableView.dequeueReusableCell(withIdentifier: "cell") as! OrderTypeCell
    
        cell.orderNoStatic.text = languageChangeString(a_str: "Order No")
        cell.dateStatic.text = languageChangeString(a_str: "Date & Time")
        cell.orderAmountStatic.text = languageChangeString(a_str: "Order amount")
        cell.adminAmountStatic.text = languageChangeString(a_str: "Admin amount")
        cell.providerPaymentStatic.text = languageChangeString(a_str: "Provider payment")
        cell.paymentModeStatic.text = languageChangeString(a_str: "Payment mode")
        
        cell.orderNoLabel.text = orderNoArray[indexPath.row]
        cell.dateTimeLabel.text = dateArray[indexPath.row]
        cell.paymentModeLabel.text = paymodeArray[indexPath.row]
        cell.orderAmountLabel.text = String(format: "%@ %@", orderAmountArray[indexPath.row],"SAR")
        cell.adminAmountLabel.text = String(format: "%@ %@", adminAmountArray[indexPath.row],"SAR")
        cell.providerPaymentLabel.text = String(format: "%@ %@", providerPaymentArray[indexPath.row],"SAR")
        cell.providerImageview.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage.init(named: ""))
        cell.providerImageview.layer.cornerRadius = cell.providerImageview.frame.size.height/2
        cell.providerImageview.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 210
    }
    
    //SERVICE CALL FOR PAYMENT HISTORY
    
    func paymentHistoryServiceCall ()
    {
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         user_id:49
         from_date:2019-03-02(optional)
         to_date:2019-03-03(optional)
         total_amount:(optional)*/
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let checkStr = checkFiltStr
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let vehicles = "\(Base_Url)payments_history?"
        
        print(vehicles)
        
        if checkStr == "spfilter"{
            params = ["user_id":spId,"total_amount":priceStr!,"from_date":fromDateStr!,"to_date":toDateStr!,"API-KEY" : APIKEY ,"lang" : language ]
        }

        else{
            params = ["user_id":spId,"API-KEY" : APIKEY ,"lang" : language ]
        }
        
        
        print(params)
        
        Alamofire.request(vehicles, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.paymodeArray = [String]()
                self.dateArray = [String]()
                self.orderNoArray = [String]()
                self.orderAmountArray = [String]()
                self.adminAmountArray = [String]()
                self.providerPaymentArray = [String]()
                self.imageArray = [String]()
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                
                    let total_amount = responseData["total_amount"]
                    let admin_amount = responseData["admin_amount"]
                    let remaining_balance = responseData["remaining_balance"]
                    
                    DispatchQueue.main.async {
                        self.receivedAmountLabel.text = String(format: "%@ %@", total_amount as! CVarArg,"SAR")
                        self.adminAmountLabel.text = String(format: "%@ %@", admin_amount as! CVarArg,"SAR")
                        self.remainingBalanceLabel.text = String(format: "%@ %@", remaining_balance as! CVarArg,"SAR")
                    }
                    
                    let paymentHistoryList = responseData["payment_history"] as? [[String:Any]]
                    //print("services categorys are ***** \(servicesCat!)")
                    
                    for each in paymentHistoryList! {
                        
                        let payment_method = each["payment_method"]  as! String
                        let order_id = each["order_id"]  as! String
                        let date = each["date"]  as! String
                        let total_amount = each["total_amount"]  as! String
                        let discount_amount = each["discount_amount"]  as! String
                        let additional_amount = each["additional_amount"]  as! String
                       
                        let providerImage = each["profile_pic"]  as! String
                        let image = String(format: "%@%@",base_path,providerImage)
                        
                        self.paymodeArray.append(payment_method)
                        self.orderNoArray.append(order_id)
                        self.dateArray.append(date)
                        self.orderAmountArray.append(total_amount)
                        self.adminAmountArray.append(discount_amount)
                        self.providerPaymentArray.append(additional_amount)
                        self.imageArray.append(image)
                    }
                    
                    
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.paymentTableView.reloadData()
                        self.payment_view.isHidden = false
                        //self.payment_view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        //self.showToast(message: message!)
                    }
                    
                }
                else
                {
                    //self.showToastForAlert(message: message!)
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.paymentTableView.reloadData()
                    //self.payment_view.backgroundColor = UIColor.clear
                   
                    self.payment_view.isHidden = true
                    
                    self.receivedAmountLabel.text = ""
                    self.adminAmountLabel.text = ""
                    self.remainingBalanceLabel.text = ""
                    
                    self.showToast(message: message!)
                }
            }
        }
    }
    
}


//right
//LGSideMenuSegue
