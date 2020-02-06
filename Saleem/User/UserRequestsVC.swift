//
//  UserRequestsVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 21/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire

class UserRequestsVC: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    var check : String?
    var userId : String?
    //filter values
    
//    var fromDateStr : String! = ""
//    var toDateStr : String! = ""
//    var statusStr : String! = ""
//    var priceStr : String! = ""
//    var checkFiltStr : String! = ""
    
    var fromDateStr : String?
    var toDateStr : String?
    var statusStr : String?
    var priceStr : String?
    var checkFiltStr : String?
    
    var params = [String: String]()
    
    var request_idArray = [String]()
    var dateArray = [String]()
    var orderNoArray = [String]()
    var offerAcceptedArray = [String]()
    var reqStatusArray = [String]()
    var offer_priceArray = [String]()
    var provider_idArray = [String]()
    var payment_statusArray = [String]()
    var invoice_statusArray = [String]()
    
    @IBOutlet var requestTableView: UITableView!
    @IBOutlet var backBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        backBtn.target = self
        backBtn.action = #selector(showLeftView(sender:))
        
        self.navigationItem.title = languageChangeString(a_str:"My Request")
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(showLeftView(sender:)), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        //navigationController?.navigationBar.barTintColor = UIColor.init(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.getUserFilterData(_:)), name: NSNotification.Name(rawValue: "getUserFilterData"), object: nil)
        
    
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pushViewController6),
            name: NSNotification.Name(rawValue: "pushView6"),
            object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func pushViewController6()
    {
        let UserInvoiceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInvoiceVC") as! UserInvoiceVC
        self.navigationController?.pushViewController(UserInvoiceVC, animated: false)
    }
    
    @objc func getUserFilterData(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            fromDateStr = dict["key"] as? String
            toDateStr = dict["key1"] as? String
            priceStr = dict["key2"] as? String
            statusStr = dict["key3"] as? String
            checkFiltStr = dict["key4"] as? String
            
            
            print("fromDateStr",fromDateStr as Any)
            print("toDateStr",toDateStr as Any)
            print("priceStr",priceStr as Any)
            print("statusStr",statusStr as Any)
            print("checkFiltStr",checkFiltStr as Any)
            
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
            
            userReqListServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
        }
        

//        let checkStr = UserDefaults.standard.object(forKey: "filter") as? String ?? ""
//         if checkStr == "filter"{
//            userReqListServiceCall()
//        }
//         else{
//
//        }
    }
    
    @objc func showLeftView(sender: AnyObject?) {
//        if check == ""{
//        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
//        }
//        else{
//            
//        }
         sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() {
            
            userReqListServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        
        backBtn.target = self
        backBtn.action = #selector(showLeftView(sender:))
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func filtetAction(_ sender: Any) {
        
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as!
        FilterVC
        self.present(mvc, animated: true, completion: nil)
    }
    
    
    @IBAction func viewDetailsAction(_ sender: Any) {
    }
    
    @IBAction func trackOrderAction(_ sender: Any) {
//        for now comment and directly sent to ivoice
//        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceProblemPopUpVC") as! DeviceProblemPopUpVC
//        self.present(gotoVC, animated: true, completion: nil)
       
        
    }
    
    //Tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request_idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = requestTableView.dequeueReusableCell(withIdentifier: "UserRequestCell", for: indexPath) as! UserRequestCell
        
        cell.orderNoStatic.text = languageChangeString(a_str: "Order No")
        cell.dateTimeStatic.text = languageChangeString(a_str: "Date & Time")
        cell.statusStatic.text = languageChangeString(a_str: "Status")
        cell.viewDetailsBtn.setTitle(languageChangeString(a_str: "VIEW DETAILS"), for: UIControl.State.normal)
        cell.trackOrderBtn.setTitle(languageChangeString(a_str: "VIEW INVOICE"), for: UIControl.State.normal)
        
        cell.orderNoLabel.text = orderNoArray[indexPath.row]
        cell.dateLabel.text = dateArray[indexPath.row]

        let reqStatus = reqStatusArray[indexPath.row]
        let payment_status = payment_statusArray[indexPath.row]
        let invoice_status = invoice_statusArray[indexPath.row]
        
        if reqStatus == "0"{
            cell.statusLabel.text = languageChangeString(a_str: "Pending")
            cell.trackOrderBtn.isHidden = true
            cell.trackOrderBtn.isEnabled = true
        }
//        else if reqStatus == "1"{
//            if payment_status == "1"{
//            cell.statusLabel.text = "completed"
//            cell.trackOrderBtn.isHidden = true
//            //cell.trackOrderBtn.isHidden = false
//            //cell.trackOrderBtn.setTitle("VIEW INVOICE", for: UIControl.State.normal)
//            }
//            else if payment_status == "0"{
//                cell.statusLabel.text = "completed"
//                cell.trackOrderBtn.isHidden = false
//                cell.trackOrderBtn.setTitle("VIEW INVOICE", for: UIControl.State.normal)
//            }
//
//        }
        
//        else if reqStatus == "1" && payment_status == "0"{
//            cell.statusLabel.text = "completed"
//            cell.trackOrderBtn.isHidden = false
//            cell.trackOrderBtn.setTitle("VIEW INVOICE", for: UIControl.State.normal)
//        }
//            if payment_status == "1"
//            {
//                cell.trackOrderBtn.isHidden = false
//                cell.trackOrderBtn.setTitle("PaymentDone", for: UIControl.State.normal)
//            }
//            else{
//                cell.trackOrderBtn.isHidden = false
//                cell.trackOrderBtn.setTitle("view invoice", for: UIControl.State.normal)
//            }
            
      //  }
        else if reqStatus == "2"{
            cell.statusLabel.text = languageChangeString(a_str: "in progress")
            cell.trackOrderBtn.isHidden = true
            cell.trackOrderBtn.isEnabled = true
        }
        else if reqStatus == "3"{
            cell.statusLabel.text = languageChangeString(a_str: "cancelled")
            cell.trackOrderBtn.isHidden = true
            cell.trackOrderBtn.isEnabled = true
        }
        
        if reqStatus == "1" && invoice_status == "0"{
            cell.statusLabel.text = languageChangeString(a_str: "completed")
            //cell.trackOrderBtn.isHidden = true
            cell.trackOrderBtn.isHidden = false
            cell.trackOrderBtn.setTitle(languageChangeString(a_str: "WAITING FOR INVOICE"), for: UIControl.State.normal)
            cell.trackOrderBtn.isEnabled = false
        }
         if reqStatus == "1" && payment_status == "0" && invoice_status == "1"{
            cell.statusLabel.text = languageChangeString(a_str: "completed")
            cell.trackOrderBtn.isHidden = false
            cell.trackOrderBtn.setTitle(languageChangeString(a_str: "VIEW INVOICE"), for: UIControl.State.normal)
            cell.trackOrderBtn.isEnabled = true
        }
            
        else if reqStatus == "1" && payment_status == "1" && invoice_status == "1"{
            cell.statusLabel.text = languageChangeString(a_str: "completed")
            cell.trackOrderBtn.isHidden = true
            cell.trackOrderBtn.isEnabled = true
            //cell.trackOrderBtn.isHidden = false
            //cell.trackOrderBtn.setTitle("VIEW INVOICE", for: UIControl.State.normal)
        }
        cell.trackOrderBtn.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1)
        cell.trackOrderBtn.layer.borderWidth = 1.0
        
        cell.viewDetailsBtn.tag = indexPath.row
        cell.viewDetailsBtn.addTarget(self, action: #selector(detailsAction(sender:)), for: UIControl.Event.touchUpInside)
        cell.trackOrderBtn.tag = indexPath.row
        cell.trackOrderBtn.addTarget(self, action: #selector(invoiceBtnAction(sender:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
       
    }
    @objc func invoiceBtnAction(sender:UIButton){
        let reqId = sender.tag
    
        let UserInvoiceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInvoiceVC") as! UserInvoiceVC
        UserInvoiceVC.reqIdStr = request_idArray[reqId]
        self.navigationController?.pushViewController(UserInvoiceVC, animated: false)
        
    }
    @objc func detailsAction(sender:UIButton)
    {
        let buttonRow = sender.tag
      //  let offerAccept = sender.tag
        //let offerPrice = sender.tag
        let providerID = sender.tag
        //(1=accepted,0=not accepted)
       // let offerAcceptedStr = offerAcceptedArray[offerAccept]
            //String(format: "%d", offerAccept)
        
       /* if offerAcceptedStr == "0"{
            
            let reqVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestDetailsVC") as! RequestDetailsVC
            reqVC.check = "cancel"
            reqVC.reqID = request_idArray[buttonRow]
            reqVC.price = offer_priceArray[offerPrice]
            //UserDefaults.standard.object(forKey: "request_id") as? String
            self.navigationController?.pushViewController(reqVC, animated: false)
        }
        else{
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let UserViewDetailsVC = storyBoard.instantiateViewController(withIdentifier: "UserViewDetailsVC") as! UserViewDetailsVC
            UserViewDetailsVC.reqID = request_idArray[buttonRow]
            self.navigationController?.pushViewController(UserViewDetailsVC, animated: true)
          
        }*/
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let UserViewDetailsVC = storyBoard.instantiateViewController(withIdentifier: "UserViewDetailsVC") as! UserViewDetailsVC
        UserViewDetailsVC.reqID = request_idArray[buttonRow]
        UserViewDetailsVC.providerIdStr = provider_idArray[providerID]
        self.navigationController?.pushViewController(UserViewDetailsVC, animated: true)
        
    }
    

    //FOR SERVICE CALL FOR USER REQUESTS
    
    func userReqListServiceCall ()
    {
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         user_id:
         total_amount:(optional)
         from_date:(YYYY-MM-DD)(optional)
         to_date:(YYYY-MM-DD)(optional)
         request_status:(0=pending,1=completed,2=in progress,3=cancelled)(optional)*/
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let checkStr = checkFiltStr
        let userID = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
        
        let vehicles = "\(Base_Url)user_requests?"
      
        //self.reqID!
        print(vehicles)
        
        if checkStr == "filter"{
            params = ["user_id":userID,"total_amount":priceStr!,"from_date":fromDateStr!,"to_date":toDateStr!,"request_status":
                statusStr!,"API-KEY" : APIKEY ,"lang" : language ]
        }
            
        else{
            params = ["user_id":userID,"API-KEY" : APIKEY ,"lang" : language ]
        }
        
        
        print(params)
        
        Alamofire.request(vehicles, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.request_idArray = [String]()
                self.dateArray = [String]()
                self.orderNoArray = [String]()
                self.offerAcceptedArray = [String]()
                self.reqStatusArray = [String]()
                self.offer_priceArray = [String]()
                self.provider_idArray = [String]()
                self.payment_statusArray = [String]()
                self.invoice_statusArray = [String]()
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let requestList = responseData["requests"] as? [[String:Any]]
                    //print("services categorys are ***** \(servicesCat!)")
                   
                    for each in requestList! {
                        
                        let provider_id = each["provider_id"]  as! String
                        let request_id = each["request_id"]  as! String
                        let order_id = each["order_id"]  as! String
                        let date = each["date"]  as! String
                        let offer_accepted = each["offer_accepted"]  as! String
                        let request_status = each["request_status"]  as! String
                        let offer_price = each["offer_price"]  as! String
                        let payment_status = each["payment_status"]  as! String
                        let invoice_status = each["invoice_status"]  as! String
                        
                        self.request_idArray.append(request_id)
                        self.orderNoArray.append(order_id)
                        self.dateArray.append(date)
                        self.offerAcceptedArray.append(offer_accepted)
                        self.reqStatusArray.append(request_status)
                        self.offer_priceArray.append(offer_price)
                        self.provider_idArray.append(provider_id)
                        self.payment_statusArray.append(payment_status)
                        self.invoice_statusArray.append(invoice_status)
                    }
                    
                    
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.requestTableView.reloadData()
                    }
                    
                }
                else
                {
                    //self.showToastForAlert(message: message!)
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.requestTableView.reloadData()
                    self.showToast(message: message!)
                }
            }
        }
    }
    
}





