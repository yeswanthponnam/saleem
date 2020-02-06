//
//  OrderTypeListVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 18/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import Alamofire

class OrderTypeListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var request_idArray = [String]()
    var orderNoArray = [String]()
    var dateArray = [String]()
    var imageArray = [String]()
    var addressArray = [String]()
    var descriptionArray = [String]()
    var rejectReasonArray = [String]()
    //for chat through sp userid taking
    var user_idArray = [String]()
    
    var modelNameArray = [String]()
    var issueNameArray = [String]()
    
    var checkIntValue:Int!
    var checkStr : String?
    
    var reqTypeStr : String?
    
    @IBOutlet var backBtn: UIBarButtonItem!
    
    @IBOutlet var ordersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //navigationController?.navigationBar.barTintColor = UIColor.init(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(showLeftView(sender:)), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        //navigationController?.navigationBar.barTintColor = UIColor.init(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        if checkIntValue == 1{
            
            self.navigationItem.title = languageChangeString(a_str: "Requests")
            
        }else if checkIntValue == 2
        {
             self.navigationItem.title = languageChangeString(a_str:"Pending")
        }
        else if checkIntValue == 3
        {
            
             self.navigationItem.title = languageChangeString(a_str:"Completed")
        }
        else if checkIntValue == 4
        {
            
             self.navigationItem.title = languageChangeString(a_str:"Reject")
        }
        
        if Reachability.isConnectedToNetwork() {
            
            requestListServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }

        // Do any additional setup after loading the view.
    }

    @objc func showLeftView(sender: AnyObject?) {
        if self.checkStr == "req"{
            self.navigationController?.popViewController(animated: true)
        }
        else if checkStr == "newReqBack"{
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
        else{
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
    }
    
//    @objc fileprivate func backButtonTapped() {
//        
//        self.navigationController?.popViewController(animated: true)
//        
//    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // #MARK:- BACK BAR Button  Action
    
    @IBAction func Back(_ sender: Any) {
        
//        let buttonPosition = sender.convert(CGPoint.zero, to: self.ordersTableView)
//        let indexPath = self.ordersTableView.indexPathForRow(at:buttonPosition)
//        let cellIndexPath = self.ordersTableView.cellForRow(at: indexPath!) as! OrderTypeCell
//        //print(cell.itemLabel.text)//print or get item
//       //let datasetCell = mycollectionview.cellForItem(at: indexPath) as? AddToCartCollectionViewCell
//        let rowIndex = indexPath?.row
//        let value = addressArray[rowIndex!]
        self.navigationController?.popViewController(animated: true)
    }
    
    // #MARK:- TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request_idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "cell") as! OrderTypeCell
        
        cell.btn_ViewDetail.layer.cornerRadius = 6.0
        cell.btn_ViewDetail.layer.masksToBounds = true
        
        cell.orderNoStatic.text = languageChangeString(a_str: "Order No")
        cell.dateStatic.text = languageChangeString(a_str: "Date & Time")
//  commented on apr3      if indexPath.row == 0{
//            cell.viewNoOfIssuesBtn.isHidden = false
//            cell.issueView.isHidden = false
//        }
//        else{
//            cell.viewNoOfIssuesBtn.isHidden = true
//            cell.issueView.isHidden = true
//        }
        
        //UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        cell.img_customer.layer.cornerRadius = cell.img_customer.frame.size.height/2
        cell.img_customer.clipsToBounds = true
        
        cell.btn_ViewDetail.addTarget(self, action: #selector(self.ViewDetailData(_:)) ,for: .touchUpInside)
        
         cell.viewNoOfIssuesBtn.addTarget(self, action: #selector(self.viewIssuesBtn(_:)) ,for: .touchUpInside)
        
        if checkIntValue == 1 {
            
            cell.rejectlLbel.isHidden = true
            cell.img_status.isHidden = true
            cell.btn_ViewDetail.tag = 1
            cell.rejectLabelHeightConstraint.constant = 0
            cell.unavailableHeightConstarint.constant = 0
            cell.rejectLabel.isHidden = true
            
            cell.img_customer.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage.init(named: ""))
            cell.orderNoLabel.text = orderNoArray[indexPath.row]
            cell.dateTimeLabel.text = dateArray[indexPath.row]
            cell.addressLabel.text = addressArray[indexPath.row]
            cell.issueNameLabel.text = String(format: "%@,%@", modelNameArray[indexPath.row],issueNameArray[indexPath.row])
        }
        else if checkIntValue == 2
        {
            cell.btn_ViewDetail.tag = 2
            
            cell.img_status.isHidden = false
            cell.rejectlLbel.isHidden = true
            cell.img_status.image = UIImage(named: "Pending")
            cell.rejectLabelHeightConstraint.constant = 0
            cell.unavailableHeightConstarint.constant = 0
            cell.rejectLabel.isHidden = true
            
            cell.img_customer.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage.init(named: ""))
            cell.orderNoLabel.text = orderNoArray[indexPath.row]
            cell.dateTimeLabel.text = dateArray[indexPath.row]
            cell.addressLabel.text = addressArray[indexPath.row]
            
            cell.issueNameLabel.text = String(format: "%@,%@", modelNameArray[indexPath.row],issueNameArray[indexPath.row])
            
        }
        else if checkIntValue == 3
        {
            cell.btn_ViewDetail.tag = 3
            cell.rejectlLbel.isHidden = true
            cell.img_status.isHidden = false
            cell.rejectLabel.isHidden = true
            cell.rejectLabelHeightConstraint.constant = 0
            cell.unavailableHeightConstarint.constant = 0
            cell.img_status.image = UIImage(named: "Completed")
            
            cell.img_customer.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage.init(named: ""))
            cell.orderNoLabel.text = orderNoArray[indexPath.row]
            cell.dateTimeLabel.text = dateArray[indexPath.row]
            cell.addressLabel.text = addressArray[indexPath.row]
            cell.issueNameLabel.text = String(format: "%@,%@", modelNameArray[indexPath.row],issueNameArray[indexPath.row])
            
        }
        else if checkIntValue == 4
        {
            cell.rejectLabelHeightConstraint.constant = 16
            cell.unavailableHeightConstarint.constant = 16
            cell.btn_ViewDetail.tag = 4
            cell.img_status.isHidden = false
            cell.rejectlLbel.isHidden = false
            cell.rejectLabel.isHidden = false
            cell.img_status.image = UIImage(named: "reject")
            
            cell.img_customer.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage.init(named: ""))
            cell.orderNoLabel.text = orderNoArray[indexPath.row]
            cell.dateTimeLabel.text = dateArray[indexPath.row]
            cell.addressLabel.text = addressArray[indexPath.row]
            cell.issueNameLabel.text = String(format: "%@,%@", modelNameArray[indexPath.row],issueNameArray[indexPath.row])
            cell.rejectLabel.text = rejectReasonArray[indexPath.row]
            cell.rejectlLbel.text = languageChangeString(a_str: "Reject Reason:")
            
        }
      
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell : OrderTypeCell!
//        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? OrderTypeCell
//        if indexPath.row % 2 == 0{
//            cell.viewNoOfIssuesBtn.isHidden = true
//        }
//        else{
//            cell.viewNoOfIssuesBtn.isHidden = false
//        }
//
//    }
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if checkIntValue == 4 {
            if indexPath.row == 0{
             //return 208
                return 217
            }
            else{
                return 195
            }
        }
       
        else{
            return 180
//            if indexPath.row == 0{
////            return 185
//                return 200
//            }
//            else{
//                return 160
//            }
        }
        
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected inde %@",indexPath.row)
        
         if checkIntValue == 1 {
            
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpRequestsDetailsVC") as! SpRequestsDetailsVC
            gotoVC.indexValue = indexPath.row
            gotoVC.reqID = request_idArray[indexPath.row]
            self.navigationController?.pushViewController(gotoVC, animated: true)
        }
         else if checkIntValue == 2{
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpPendingDetailsVC") as! SpPendingDetailsVC
            gotoVC.indexValue = indexPath.row
            gotoVC.reqID = request_idArray[indexPath.row]
            gotoVC.userIdStr = user_idArray[indexPath.row]
            self.navigationController?.pushViewController(gotoVC, animated: true)
        }
         else if checkIntValue == 3{
            self.checkIntValue = 3
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPCompletedDetailsVC") as! SPCompletedDetailsVC
            gotoVC.checkInt = self.checkIntValue
            gotoVC.indexValue = indexPath.row
            gotoVC.reqID = request_idArray[indexPath.row]
            self.navigationController?.pushViewController(gotoVC, animated: true)
        }
         else if checkIntValue == 4{
            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPCompletedDetailsVC") as! SPCompletedDetailsVC
             gotoVC.indexValue = indexPath.row
            gotoVC.reqID = request_idArray[indexPath.row]
            self.navigationController?.pushViewController(gotoVC, animated: true)
            
        }
    }
    
    @objc func viewIssuesBtn(_ sender:UIButton){
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }
    
    @objc func ViewDetailData(_ sender:UIButton){
        
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
        
        
        
//        if sender.tag == 1 {
//
//            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpRequestsDetailsVC") as! SpRequestsDetailsVC
//
//            self.navigationController?.pushViewController(gotoVC, animated: true)
//
//
//        }else if sender.tag == 2{
//
//            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpPendingDetailsVC") as! SpPendingDetailsVC
//
//            self.navigationController?.pushViewController(gotoVC, animated: true)
//
//        }
//        else if sender.tag == 3{
//            self.checkIntValue = 5
//            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPCompletedDetailsVC") as! SPCompletedDetailsVC
//           gotoVC.checkInt = self.checkIntValue
//
//            self.navigationController?.pushViewController(gotoVC, animated: true)
//
//        }
//        else if sender.tag == 4{
//
//            let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPCompletedDetailsVC") as! SPCompletedDetailsVC
//
//            self.navigationController?.pushViewController(gotoVC, animated: true)
//
//        }
//
    }

    
    //FOR SERVICE CALL FOR REQUEST LIST
    
    func requestListServiceCall ()
    {
        /*
         API-KEY=9173645&
         lang=en&
         provider_id=39
         request_type: (1=total,2=pending,3=completed,4=rejected)
         
         */
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let vehicles = "\(Base_Url)provider_requests_list?"
        let spId = UserDefaults.standard.object(forKey: "spId") as? String
        let parameters: Dictionary<String, Any> = ["provider_id":spId!,"request_type":reqTypeStr!,"API-KEY" : APIKEY ,"lang" : language ]
        //self.reqID!
        print(vehicles)
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(vehicles, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.request_idArray = [String]()
                self.orderNoArray = [String]()
                self.dateArray = [String]()
                self.imageArray = [String]()
                self.addressArray = [String]()
                self.descriptionArray = [String]()
                self.rejectReasonArray = [String]()
                self.modelNameArray = [String]()
                self.issueNameArray = [String]()
                self.user_idArray = [String]()
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let requestDetailsList = responseData["requests_list"] as? [[String:Any]]
                   
                    //print("services categorys are ***** \(servicesCat!)")
               
                    for each in requestDetailsList! {
                        
                        let request_id = each["request_id"]  as! String
                        let order_id = each["order_id"]  as! String
                        let date = each["date"]  as! String
                       
                        let address = each["address"]  as! String
                        let description = each["description"]  as! String
                        let reject_reason = each["reject_reason"] as! String
                        
                        let model_name = each["model_name"]  as! String
                        let issues = each["issues"]  as! String
                        
                        let profile_pic = each["profile_pic"]  as! String
                        let image = String(format: "%@%@",base_path,profile_pic)
                        
                        let user_id = each["user_id"] as! String
                        
                        self.request_idArray.append(request_id)
                        self.orderNoArray.append(order_id)
                        self.dateArray.append(date)
                        self.addressArray.append(address)
                        self.descriptionArray.append(description)
                        self.rejectReasonArray.append(reject_reason)
                        self.imageArray.append(image)
                        self.modelNameArray.append(model_name)
                        self.issueNameArray.append(issues)
                        self.user_idArray.append(user_id)
                    }
                   
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.ordersTableView.reloadData()
                    }
                    
                }
                else{
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.ordersTableView.reloadData()
                    self.showToast(message: message!)
                }
            }
        }
    }
    
    
}
