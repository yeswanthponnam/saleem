//
//  RequestDetailsVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 19/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class RequestDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var backgroundTask: UIBackgroundTaskIdentifier? // global variable
    var getTimeStr : String?
    var getStr : String?
    
    var checkGenderStr : String?
    
    @IBOutlet var issueUnderLineView: UIView!
    
    var issuesList : [[String: Any]]!
    var issueNameArray = [String]()
    
    //for chat providerid getting
    var providerId : String?
    
    var reqID : String?
    var price : String?
    //dynamic arrays
    var request_idArray = [String]()
    var providerNameArray = [String]()
    var offer_idArray = [String]()
    var offer_priceArray = [String]()
    var provider_idArray = [String]()
    var addressArray = [String]()
    var imageArray = [String]()
    var distanceArray = [String]()
    var providerRatingArray = [String]()
    
    var serviceName : String?
    var separateServiceCheckStr : String?
    var arrayCount = Int()
    
    @IBOutlet var providerListTV: UITableView!
    
    @IBOutlet var orderNoStatic: UILabel!
    @IBOutlet var dateTimeStatic: UILabel!
    
    @IBOutlet var orderNo: UILabel!
    @IBOutlet var issueName: UILabel!
    @IBOutlet var date: UILabel!
    
    @IBOutlet var nameStatic: UILabel!
    @IBOutlet var mobileStatic: UILabel!
    @IBOutlet var mobileBrandStatic: UILabel!
    @IBOutlet var mobileModelStatic: UILabel!
    @IBOutlet var problemTypeSatic: UILabel!
    
    @IBOutlet var issueDescStatic: UILabel!
    @IBOutlet var issueDescTV: UITextView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mobileNoLabel: UILabel!
    @IBOutlet var mobileBrandLabel: UILabel!
    @IBOutlet var mobileModel: UILabel!
    @IBOutlet var issueNameLabel: UILabel!
    
    @IBOutlet var serviceProvidersStaticLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var mainViewHeightConstarint: NSLayoutConstraint!
    
    
    @IBOutlet var firstBackViewHeightConstraint: NSLayoutConstraint!
 
    @IBOutlet var firstBackView: UIView!
    
    @IBOutlet var timerView: UIView!
    @IBOutlet var orderView: UIView!
    
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var detailsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var expandBtn: UIButton!
    @IBOutlet var detailsView: UIView!
    
    @IBOutlet var MoreBtn: UIButton!
    
    @IBOutlet var expandBtnHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var mainViewHeightConstraint: NSLayoutConstraint!
    var check : String?
    
    var seconds = Int()
    
   // var seconds = 3600
    var timer = Timer()
    
    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating")!
    let halfStarImage:  UIImage = UIImage(named: "check")!
    let emptyStarImage: UIImage = UIImage(named: "unselected_star")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.navigationItem.title = languageChangeString(a_str: "Request Details")
       self.orderNoStatic.text = languageChangeString(a_str: "Order No")
       self.dateTimeStatic.text = languageChangeString(a_str: "Date & Time")
       self.serviceProvidersStaticLabel.text = languageChangeString(a_str: "Service Providers")
        
        self.nameStatic.text = languageChangeString(a_str: "Your Name")
        self.mobileStatic.text = languageChangeString(a_str: "Mobile Number")
        self.mobileBrandStatic.text = languageChangeString(a_str: "Mobile brand")
        self.mobileModelStatic.text = languageChangeString(a_str: "Model")
        self.problemTypeSatic.text = languageChangeString(a_str: "Problem Type")
        self.issueDescStatic.text = languageChangeString(a_str: "Issue description")
        if check == "cancel"{
            
        }
        else{
            
        let genderStr = self.checkGenderStr
        let offerPrice = self.price
        let newReqId = self.reqID
        UserDefaults.standard.setValue(offerPrice, forKey: "price")
        UserDefaults.standard.setValue(newReqId, forKey: "newReqId")
        UserDefaults.standard.setValue(genderStr, forKey: "genderStr")
            
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationBoxVC") as!
        NotificationBoxVC
        self.present(mvc, animated: true, completion: nil)
           
        }
       
        if Reachability.isConnectedToNetwork() {
            
            self.providerListServiceCall()
            
        }else
        {
            self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        /* coome for chat getting value NotificationCenter.default.addObserver(self,
            selector: #selector(self.pushViewController),
            name: NSNotification.Name(rawValue: "pushView1"),
            object: nil)*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProviderList), name: NSNotification.Name(rawValue:"refreshProviderList"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushViewController(_:)), name: NSNotification.Name(rawValue: "pushView1"), object: nil)
       
        //NotificationCenter.default.addObserver(self, selector:#selector(runTimerInForeground), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        //NotificationCenter.default.addObserver(self, selector:#selector(runTimerInBackground), name: UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
      //comment april 20
      //  NotificationCenter.default.addObserver(self, selector: #selector(self.callTimer), name: NSNotification.Name(rawValue: "callTimer"), object: nil)
       
    }
    @objc func refreshProviderList()
    {
        separateServiceCheckStr = ""
        if Reachability.isConnectedToNetwork() {
            self.providerListServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection")
        }
    }
    
//    @objc func runTimerInForeground()
//    {
//
//        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "backgroundTask") {
//            // Cleanup code should be written here so that you won't see the loader
//
//            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
//            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
//        }
//        if Reachability.isConnectedToNetwork() {
//
//            runTimer()
//        }else
//        {
//            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
//            // showToastForAlert (message:"Please ensure you have proper internet connection.")
//        }
//
//    }
 
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.detailsView.isHidden = true
            self.detailsViewHeightConstraint.constant = 0
            self.mainViewHeightConstarint.constant = 180
       
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:- BASED ON RATING VALUES FILL THE IMAGES WITH DIFFERENT STARS
    func getStarImage(starNumber: Double, forRating rating: Double) -> UIImage {
        if rating >= starNumber {
            return fullStarImage
        } else if rating + 0.5 == starNumber {
            return halfStarImage
        } else {
            return emptyStarImage
        }
    }
    
    @objc func pushViewController(_ notification: NSNotification)
    {
        //        let UserRequestsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
        //        self.navigationController?.pushViewController(UserRequestsVC, animated: false)
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            reqID = dict["key"] as? String
            providerId = dict["key1"] as? String
        }
        
        let TrackOrderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
        TrackOrderVC.requestIDStr = reqID
        TrackOrderVC.providerIdStr = providerId
        TrackOrderVC.sepCheckStr = "confOffer"
        self.navigationController?.pushViewController(TrackOrderVC, animated: false)
    }
    
    func runTimer() {
        
//        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI:)
//            userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(RequestDetailsVC.updateTimer)), userInfo: nil, repeats: true)
        RunLoop.current .add(timer, forMode: RunLoop.Mode.common)
        
    }
   
    func stopTimer()
    {
        if timer != nil {
            timer.invalidate()
            timer = Timer()
        }
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timeLabel.text = timeString(time: TimeInterval(seconds)) //This will update the label.
        
        if seconds == 00 {
            DispatchQueue.main.async {
                self.stopTimer()
            }
            
            print("stop timer called")
           
            if self.arrayCount == 0{
                let alert = UIAlertController(title: languageChangeString(a_str: "Alert"), message:languageChangeString(a_str: "No Available service providers. Do you want to resend  request?") , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: languageChangeString(a_str: "NO"), style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("going to home")
                        self.userCancelOrderServiceCall()
                        //self.dismiss(animated: true, completion: nil)
                        
                    case .cancel:
                        self.dismiss(animated: true, completion: nil)
                        
                    case .destructive:
                        print("destructive")
                        
                    }}))
                
                alert.addAction(UIAlertAction(title: languageChangeString(a_str: "YES"), style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        //self.dismiss(animated: true, completion: nil)
                        
                        self.separateServiceCheckStr = "renewReq"
                        self.providerListServiceCall()
                    case .cancel:
                        self.dismiss(animated: true, completion: nil)
                        
                    case .destructive:
                        print("destructive")
                        
                    }}))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    func timeString(time:TimeInterval) -> String {
       //  let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let new = String(format:"00:%02i:%02i", minutes, seconds)
        return String(format:"00:%02i:%02i", minutes, seconds)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
                let alert = UIAlertController(title: languageChangeString(a_str: "Alert"), message: languageChangeString(a_str: "Are you sure you want to cancel this order?"), preferredStyle: .alert)
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
                        self.userCancelOrderServiceCall()
        
                    case .cancel:
                        self.dismiss(animated: true, completion: nil)
        
                    case .destructive:
                        print("destructive")
        
                    }}))
        
                self.present(alert, animated: true, completion: nil)
   
    }
    
    //USER CancelOrder SERVICE CALL
    func userCancelOrderServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         provider_id:
         request_id:
         */
        
        timer.invalidate()
        timer = Timer()
        
        let signup = "\(Base_Url)cancel_request"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID!,  "provider_id" : spId,"cancel_reason":"","lang" : language,"API-KEY":APIKEY]
        
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
                        
                        
                      /*  let userType = UserDefaults.standard.object(forKey: "type") as? String
                        if userType == "2"{
                            
                            NotificationCenter.default.post(name: Notification.Name("pushView"), object: nil)
                            self.dismiss(animated: true) {
                                print("dismmissed")
                            }
                        }
                        else{
                            NotificationCenter.default.post(name: Notification.Name("pushView4"), object: nil)
                            self.dismiss(animated: true) {
                                print("dismmissed")
                            }
                        }*/
                        
                       // self.showToast(message: message)
                        
                    }
                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                   // self.showToast(message: message)
                }
            }
        }
    }
    
    
    @IBAction func expandAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.expandBtnHeightConstraint.constant = 0
            self.expandBtn.isHidden = true
            self.detailsView.isHidden = false
            self.MoreBtn.isHidden = false
            self.detailsViewHeightConstraint.constant = 310
            self.mainViewHeightConstarint.constant = 180 + 310
        }
    }
 
    
    @IBAction func moreBtnAction(_ sender: Any) {
        //self.expandBtnHeightConstraint.constant = 22
        DispatchQueue.main.async {
            self.expandBtnHeightConstraint.constant = 20
            self.mainViewHeightConstarint.constant = 500 - 310
            self.MoreBtn.isHidden = false
        //self.MoreBtn.setImage(UIImage.init(named: "show less"), for: UIControl.State.normal)
            self.detailsViewHeightConstraint.constant = 0
        
            self.detailsView.isHidden = true
        
            self.expandBtn.isHidden = false
       // self.firstBackViewHeightConstraint.constant = 190
        }
    }
    
    //Tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offer_idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = providerListTV.dequeueReusableCell(withIdentifier: "UserReqDetailsCell", for: indexPath) as! UserReqDetailsCell
        
        cell.userName.text = providerNameArray[indexPath.row]
        cell.priceLabel.text = String(format: "%@ %@",offer_priceArray[indexPath.row],"SAR")
        
        cell.location.text = addressArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: imageArray[indexPath.row]), placeholderImage: UIImage.init(named: ""))
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.height/2
        cell.userImageView.clipsToBounds = true

        let rateValue1 = providerRatingArray[indexPath.row]
        
        let moreRate1 = Double(rateValue1)
        
        if let ourRating = moreRate1 {
            cell.starButtonOne.setImage(self.getStarImage(starNumber: 1, forRating: ourRating), for: UIControl.State.normal)
            cell.starButtontwo.setImage(self.getStarImage(starNumber: 2, forRating: ourRating), for: UIControl.State.normal)
            cell.starButtonThree.setImage(self.getStarImage(starNumber: 3, forRating: ourRating), for: UIControl.State.normal)
            cell.starButtonFour.setImage(self.getStarImage(starNumber: 4, forRating: ourRating), for: UIControl.State.normal)
            cell.starButtonFive.setImage(self.getStarImage(starNumber: 5, forRating: ourRating), for: UIControl.State.normal)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
        //93
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let reqId = request_idArray[indexPath.row]
        let providerId = provider_idArray[indexPath.row]
        let offerPrice = offer_priceArray[indexPath.row]
        
        let providerName = providerNameArray[indexPath.row]
        let distance = distanceArray[indexPath.row]
        let image = imageArray[indexPath.row]
        let providerRating = providerRatingArray[indexPath.row]
        
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOfferVC") as! ConfirmOfferVC
        self.present(gotoVC, animated: true, completion: nil)
        
        let imageDataDict:[String: String] = ["key": reqId,"key1":providerId,"key2":offerPrice,"key3": providerName,"key4":distance,"key5":image,"key6":providerRating]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getProviderDataValues"), object: nil, userInfo: imageDataDict)
    
    }
    

    //MARK: FOR SERVICE CALL FOR PROVIDER LIST
    
    func providerListServiceCall ()
    {
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        if self.separateServiceCheckStr == "renewReq"{
            serviceName = "\(Base_Url)renew_request?"
        }
        else{
            serviceName = "\(Base_Url)service_request_details_offer?"
        }
        
        let parameters: Dictionary<String, Any> = ["request_id":self.reqID!,"API-KEY" : APIKEY ,"lang" : language ]
        print(serviceName!)
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(serviceName!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.request_idArray = [String]()
                self.offer_idArray = [String]()
                self.offer_priceArray = [String]()
                self.providerNameArray = [String]()
                self.provider_idArray = [String]()
                self.imageArray = [String]()
                self.addressArray = [String]()
                self.distanceArray = [String]()
                self.providerRatingArray = [String]()
                self.issueNameArray = [String]()
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let requestDetailsDict = responseData["request_details"] as? [String:Any]
                    let providerList = requestDetailsDict!["offers_list"] as? [[String:AnyObject]]
                    self.arrayCount = providerList!.count
                    self.issuesList = requestDetailsDict!["issues_list"] as? [[String: Any]]
                    
                    for each in self.issuesList! {
                        let issue_name = each["issue_name"]  as! String
                        self.issueNameArray.append(issue_name)
                    }
                  
                    let orderId = requestDetailsDict?["order_id"]
                    let date = requestDetailsDict?["date"]
                    let name = requestDetailsDict?["name"]
                    let phone = requestDetailsDict?["phone"]
                    let brand_name = requestDetailsDict?["brand_name"]
                    let model_name = requestDetailsDict?["model_name"]
                    let issues = requestDetailsDict?["issues"]
                    let descriptionstr = requestDetailsDict?["description"]
                    let timeStr = requestDetailsDict?["request_timer"] as? String
                   
                    
                    DispatchQueue.main.async {
                         self.getTimeStr = timeStr
                       // self.getTimeStr = requestDetailsDict?["request_timer"] as? String
                        self.orderNo.text = String(format: "%@%@", "#",(orderId as? String)!)
                        self.nameLabel.text = name as? String
                        self.mobileNoLabel.text = phone as? String
                        self.mobileBrandLabel.text = brand_name as? String
                        self.mobileModel.text = model_name as? String
                        self.date.text = date as? String
                        self.orderNo.text = orderId as? String
                        self.issueDescTV.text = descriptionstr as? String
                        self.issueNameLabel.text = issues as? String
                        self.issueName.text = model_name as? String
                        
                        if (self.issuesList?.count)! > 1{
                            self.issueUnderLineView.isHidden = false
                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapIssues))
                            self.issueNameLabel.addGestureRecognizer(tap)
                        }
                        else{
                            self.issueUnderLineView.isHidden = true
                        }
//                      now comment  self.seconds = (self.getTimeStr?.secondFromString)!
//                        self.runTimer()
                        
                        if self.separateServiceCheckStr == "renewReq"{
                            self.seconds = (self.getTimeStr?.secondFromString)!
                             DispatchQueue.main.async {
                                self.runTimer()
                            }
                            print("timer calling")
                        }
                            
                        else if UserDefaults.standard.string(forKey: "yes") == "stopTime" {
                            self.seconds = (self.getTimeStr?.secondFromString)!
                            print("timer string\(self.seconds)")
                            DispatchQueue.main.async {
                                self.runTimer()
                               
                            }
                            
                            print("through noti")
                            UserDefaults.standard.removeObject(forKey: "yes")
                        }
//                        else if self.getStr == ""{
//                            print("not calling")
//                        }
                    }
                    for each in providerList! {
                        
                        let request_id = each["request_id"]  as! String
                        let offer_id = each["offer_id"]  as! String
                        let offer_price = each["offer_price"]  as! String
                        let provider_name = each["provider_name"]  as! String
                        let provider_id = each["provider_id"]  as! String
                        let address = each["address"]  as! String
                        let distance = each["distance"]  as! String
                        let provider_rating = each["provider_rating"]  as! String
                        
                        let providerImage = each["profile_pic"]  as! String
                        let image = String(format: "%@%@",base_path,providerImage)
                        
                        self.request_idArray.append(request_id)
                        self.offer_idArray.append(offer_id)
                        self.offer_priceArray.append(offer_price)
                        self.providerNameArray.append(provider_name)
                        self.provider_idArray.append(provider_id)
                        self.addressArray.append(address)
                        self.imageArray.append(image)
                        self.distanceArray.append(distance)
                        self.providerRatingArray.append(provider_rating)
                    }
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.providerListTV.reloadData()
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
    
    @objc func onTapIssues(sender:UITapGestureRecognizer) {
        
        print("tap working")
        UserDefaults.standard.setValue(self.issueNameArray, forKey: "list")
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }
}

extension String{
    
    var integer: Int {
        return Int(self) ?? 0
    }
    
    var secondFromString : Int{
        var components: Array = self.components(separatedBy: ":")
        //let hours = components[0].integer
        let minutes = components[0].integer
        let seconds = components[1].integer
        //return Int((hours * 60 * 60) + (minutes * 60) + seconds)
        return Int((minutes * 60) + seconds)
    }
}



