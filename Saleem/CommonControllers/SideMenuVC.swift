//
//  SideMenuVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 23/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import MOLH

class SideMenuVC: UIViewController,SSASideMenuDelegate {

    var unreadNoticount : String?
    
    var params = [String:String]()
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    
    var arrTitle = [String]()
    var checkValue :Int!
    
    @IBOutlet var signOutBtn: UIButton!
    @IBOutlet var menuTableView: UITableView!
    var cell : MenuCell!
    
    var userCheckArray = [String]()
    var spCheckArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.separatorColor = UIColor.clear      
        
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        
        if userType == "2"{
            
            arrTitle = [languageChangeString(a_str:"HOME"), languageChangeString(a_str:"MY REQUESTS"), languageChangeString(a_str:"MY PROFILE"),languageChangeString(a_str:"NOTIFICATIONS"),languageChangeString(a_str:"TERMS AND CONDITIONS"),languageChangeString(a_str:"CHANGE LANGUAGE")] as! [String]
            userCheckArray = ["1","0","0","0","0","0"]
        }
        else{
            arrTitle = [languageChangeString(a_str:"HOME"),languageChangeString(a_str:"PAYMENTS"),languageChangeString(a_str:"MY PROFILE"),languageChangeString(a_str:"NOTIFICATIONS"),languageChangeString(a_str:"TERMS AND CONDITIONS"),languageChangeString(a_str:"CHANGE LANGUAGE")] as! [String]
            spCheckArray = ["1","0","0","0","0","0"]
            //spCheckArray = ["1","0","0","0","0","0","0","0","0"]
            //"REQUESTS","REJECT","PENDING","COMPLETED",
        }
        signOutBtn.setTitle(languageChangeString(a_str: "SIGN OUT"), for: UIControl.State.normal)
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        userImageView.clipsToBounds = true
        
        
//        if userType == "2" {
//            self.userNameLabel.text = "sample"
//            self.userEmailLabel.text = "sample@gmail.com"
//            //self.profileImage.sd_setImage(with: URL (string: as? String ?? ""), placeholderImage:
//            //UIImage(named: ""))
//            self.userImageView.image = UIImage.init(named: "")
//        }
//        else{
            self.userNameLabel.text = (UserDefaults.standard.object(forKey: "userName") as? String) ?? ""
            self.userEmailLabel.text = (UserDefaults.standard.object(forKey: "userEmail") as? String) ?? ""
            DispatchQueue.main.async {
                self.userImageView.sd_setImage(with: URL (string: UserDefaults.standard.object(forKey: "userImage") as? String ?? ""), placeholderImage:
                    UIImage(named: ""))
            }
        //}
        NotificationCenter.default.addObserver(self, selector: #selector(profileData), name: NSNotification.Name(rawValue:"profileData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNotificationCount(_:)), name: NSNotification.Name(rawValue: "updateNotificationCount"), object: nil)
        
        //arrTitle = ["HOME", "REQUESTS","REJECT","PENDING","COMPLETED","PAYMENTS","MY PROFILE","NOTIFICATIONS","TERMS AND CONDITIONS"]
        
        // Do any additional setup after loading the view.
    }
    @objc func updateNotificationCount(_ notification: NSNotification){
        
        unreadNotificationCountServiceCall()
//        print(notification.userInfo ?? "")
//        if let dict = notification.userInfo as NSDictionary? {
//            self.unreadNoticount = dict["key"] as? String
//            print("unreadCount \(self.unreadNoticount)")
//            
//        }
//        self.menuTableView.reloadData()
    }
    @objc func profileData()
    {
        let profile = UserDefaults.standard.object(forKey: "userImage")
        let uname  = (UserDefaults.standard.object(forKey: "userName") as! String)
        let uemail  = (UserDefaults.standard.object(forKey: "userEmail") as! String)
        
        self.userImageView.sd_setImage(with: URL(string: profile as! String), placeholderImage: UIImage(named:"noImage"))
        self.userNameLabel.text = uname
        self.userEmailLabel.text = uemail
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2
        self.userImageView.clipsToBounds = true
        
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
             
        if Reachability.isConnectedToNetwork()
        {
            unreadNotificationCountServiceCall()
            
        }else
        {
            //showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            //showToast(message: languageChangeString(a_str:"Please ensure you have proper internet connection") ?? "")
        }
        
        self.userNameLabel.text = (UserDefaults.standard.object(forKey: "userName") as? String) ?? ""
        self.userEmailLabel.text = (UserDefaults.standard.object(forKey: "userEmail") as? String) ?? ""
        DispatchQueue.main.async {
            self.userImageView.sd_setImage(with: URL (string: UserDefaults.standard.object(forKey: "userImage") as? String ?? ""), placeholderImage:
                UIImage(named: ""))
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
  
    @IBAction func signoutAction(_ sender: Any) {
//        let gotoVC: SelectUserTypeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectUserTypeVC") as! SelectUserTypeVC
//
//        sideMenuViewController?.contentViewController =
//            UINavigationController(rootViewController: gotoVC)
//        sideMenuViewController?.hideMenuViewController()
        
    
        if Reachability.isConnectedToNetwork(){
            logoutServiceCall()
        }
        else{
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        UserDefaults.standard.removeObject(forKey: "otp_status")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "spId")
        UserDefaults.standard.removeObject(forKey: "type")
    }
 
    
    
    //FOR SERVICE CALL FOR LOGOUT
    
    func logoutServiceCall ()
    {
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         user_id:
         */
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let userID = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        let vehicles = "\(Base_Url)logout?"
        
        //self.reqID!
        print(vehicles)
        
        if userType == "2"{
            params = ["user_id":userID,"API-KEY" : APIKEY ,"lang" : language ]
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
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    DispatchQueue.main.async {
                    let mainViewController = self.sideMenuController!
                    
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    let viewController: UIViewController!
                    
                    if navigationController.viewControllers.first is SelectUserTypeVC {
                        viewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectUserTypeVC")
                    }
                    else {
                        viewController = self.storyboard!.instantiateViewController(withIdentifier: "SelectUserTypeVC")
                    }
                    
                    navigationController.setViewControllers([viewController], animated: false)
             
                    mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                    
                        MobileFixServices.sharedInstance.dissMissLoader()
                      
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
    
    //FOR SERVICE CALL FOR UNREAD NOTIFICATION COUNT
    
    func unreadNotificationCountServiceCall ()
    {
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         user_id:
         */
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let userID = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        let vehicles = "\(Base_Url)unread_notifications?"
        
        //self.reqID!
        print(vehicles)
        
        if userType == "2"{
            params = ["user_id":userID,"API-KEY" : APIKEY ,"lang" : language ]
        }
            
        else{
            params = ["user_id":spId,"API-KEY" : APIKEY ,"lang" : language ]
        }
        
        
        print(params)
        
        Alamofire.request(vehicles, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
               
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let notifications = responseData["count"] as? String
                    self.unreadNoticount = notifications
                   
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.menuTableView.reloadData()
                    }
                    
                }
                else
                {
                    //self.showToastForAlert(message: message!)
                    MobileFixServices.sharedInstance.dissMissLoader()
                }
            }
        }
    }
    
    func changeLanguage() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        let englishAction: UIAlertAction = UIAlertAction(title: "English", style: .default) { action -> Void in
            //MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "en" : "en")
            MOLH.reset(transition: .transitionCrossDissolve)
            UserDefaults.standard.set(ENGLISH_LANGUAGE, forKey: "currentLanguage")
            
            
        if userType == "2"{
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
        else {
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
        let arabicAction: UIAlertAction = UIAlertAction(title: "العربية", style: .default) { action -> Void in
           // MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "ar" ? "ar" : "ar")
            MOLH.reset(transition: .transitionCrossDissolve)
            UserDefaults.standard.set(ARABIC_LANGUAGE, forKey: "currentLanguage")
            if userType == "2"{
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
            else {
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
        let cancelAction: UIAlertAction = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(englishAction)
        actionSheetController.addAction(arabicAction)
        actionSheetController.addAction(cancelAction)
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
}

extension UIView {
    func onesideRoundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


extension SideMenuVC: UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var  cell : MenuCell
        
        cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell
        cell.menuName.text = arrTitle[indexPath.row]
        DispatchQueue.main.async {
        self.cell.countLabel.text = self.unreadNoticount
        }
            cell.countLabel.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.countLabel.layer.borderWidth = 1.0
              
//        cell.menuName.layer.masksToBounds = true
//        cell.menuName.layer.cornerRadius = 15
//        cell.menuName.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        cell.menuName.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        if userType == "2"{
            if indexPath.row == 3{
                //com
                cell.countLabel.isHidden = false
               // DispatchQueue.main.async {
                    self.cell.countLabel.text = self.unreadNoticount
                    self.cell.countLabel.layer.cornerRadius = 15
                    self.cell.countLabel.layer.masksToBounds = true
               // }
                
            }
            else{
                 cell.countLabel.isHidden = true
            }
            if userCheckArray[indexPath.row] == "0"
            {
                cell.menuName.textColor = UIColor.white
                cell.menuName.text = arrTitle[indexPath.row]
                
                cell.backView.backgroundColor = UIColor.clear
            }
            else
            {
                cell.menuName.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                cell.menuName.text = arrTitle[indexPath.row]
                
                let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
                if language == "ar"{
                    cell.backView.onesideRoundCorners(corners: [.topLeft, .bottomLeft], radius: 30)
                }
                else {
                    cell.backView.onesideRoundCorners(corners: [.topRight, .bottomRight], radius: 30)
                }
                cell.backView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        else if userType == "3"{
            
            if indexPath.row == 3{
                //com
                cell.countLabel.isHidden = false
                //DispatchQueue.main.async {
                    self.cell.countLabel.text = self.unreadNoticount
                    self.cell.countLabel.layer.cornerRadius = 15
                    self.cell.countLabel.layer.masksToBounds = true
               // }
            }
            else{
                cell.countLabel.isHidden = true
            }
            
            if spCheckArray[indexPath.row] == "0"
            {
                cell.menuName.textColor = UIColor.white
                cell.menuName.text = arrTitle[indexPath.row]
                
                cell.backView.backgroundColor = UIColor.clear
            }
            else
            {
                cell.menuName.textColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
                cell.menuName.text = arrTitle[indexPath.row]
                cell.backView.onesideRoundCorners(corners: [.topRight, .bottomRight], radius: 30)
                cell.backView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //return UITableView.automaticDimension
        return 60
        
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let mainViewController = sideMenuController!
        
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        if userType == "2"{
            
            if indexPath.row == 0{
                
//            let LoginVC1: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: LoginVC1)
//            sideMenuViewController?.hideMenuViewController()
                
                
                userCheckArray[0] = "1"
                
                userCheckArray[1] = "0"
                userCheckArray[2] = "0"
                userCheckArray[3] = "0"
                userCheckArray[4] = "0"
                userCheckArray[5] = "0"
                menuTableView.reloadData()
                
                let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(HomeViewController, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
                
//                let navigationController = mainViewController.rootViewController as! NavigationController
//                let viewController: UIViewController!
//
//                if navigationController.viewControllers.first is HomeViewController {
//                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
//                }
//                else {
//                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
//                }
//
//                navigationController.setViewControllers([viewController], animated: false)
//
//                // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
//                // You can use delay to avoid this and probably other unexpected visual bugs
//                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                
                
                
            }
            else if indexPath.row == 1{

                userCheckArray[0] = "0"
               
                userCheckArray[1] = "1"
                userCheckArray[2] = "0"
                userCheckArray[3] = "0"
                userCheckArray[4] = "0"
                userCheckArray[5] = "0"
                 menuTableView.reloadData()
                
             /*   let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is UserRequestsVC {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "UserRequestsVC")
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "UserRequestsVC")
                }
                
                navigationController.setViewControllers([viewController], animated: false)
                
                // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
                // You can use delay to avoid this and probably other unexpected visual bugs
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                */
                
                
                let UserRequestsVC = self.storyboard?.instantiateViewController(withIdentifier: "UserRequestsVC") as! UserRequestsVC
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(UserRequestsVC, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
                
           
            }
            else if indexPath.row == 2{
                
                userCheckArray[0] = "0"
                
                userCheckArray[1] = "0"
                userCheckArray[2] = "1"
                userCheckArray[3] = "0"
                userCheckArray[4] = "0"
                userCheckArray[5] = "0"
                menuTableView.reloadData()
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is UserProfileVC {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "UserProfileVC")
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "UserProfileVC")
                }
                
                navigationController.setViewControllers([viewController], animated: false)
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                

            }
            else if indexPath.row == 3{
                
                userCheckArray[0] = "0"
                
                userCheckArray[1] = "0"
                userCheckArray[2] = "0"
                userCheckArray[3] = "1"
                userCheckArray[4] = "0"
                userCheckArray[5] = "0"
                menuTableView.reloadData()
//                let navigationController = mainViewController.rootViewController as! NavigationController
//                let viewController: UIViewController!
//
//                if navigationController.viewControllers.first is NotificationsVC {
//                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificationsVC")
//                }
//                else {
//                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificationsVC")
//                }
//
//                navigationController.setViewControllers([viewController], animated: false)
//
//                // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
//                // You can use delay to avoid this and probably other unexpected visual bugs
//                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                
                
                let NotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
                NotificationsVC.checkStr = ""
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(NotificationsVC, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
              

            }
            else if indexPath.row == 4{
                
                userCheckArray[0] = "0"
                
                userCheckArray[1] = "0"
                userCheckArray[2] = "0"
                userCheckArray[3] = "0"
                userCheckArray[4] = "1"
                userCheckArray[5] = "0"
                menuTableView.reloadData()
                
              /*  let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is TermsConditionsVC {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "TermsConditionsVC")
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "TermsConditionsVC")
                }
                
                navigationController.setViewControllers([viewController], animated: false)
                
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                */

                
                let TermsConditionsVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionsVC") as! TermsConditionsVC
                TermsConditionsVC.checkStr = ""
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(TermsConditionsVC, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
                
            }
            else if indexPath.row == 5{
                    userCheckArray[0] = "0"
                    
                    userCheckArray[1] = "0"
                    userCheckArray[2] = "0"
                    userCheckArray[3] = "0"
                    userCheckArray[4] = "0"
                    userCheckArray[5] = "1"
                    menuTableView.reloadData()
                
                  //commented
                changeLanguage()
                
            }
        }
        else if userType == "3"{
            
            if indexPath.row == 0{
//                let SpHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpHomeVC") as! SpHomeVC
//                self.navigationController?.pushViewController(SpHomeVC, animated: true)
                
                spCheckArray[0] = "1"
                spCheckArray[1] = "0"
                spCheckArray[2] = "0"
                spCheckArray[3] = "0"
                spCheckArray[4] = "0"
                spCheckArray[5] = "0"
//                spCheckArray[5] = "0"
//                spCheckArray[6] = "0"
//                spCheckArray[7] = "0"
//                spCheckArray[8] = "0"
              
                menuTableView.reloadData()
                
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is SpHomeVC {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SpHomeVC")
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SpHomeVC")
                }
                
                navigationController.setViewControllers([viewController], animated: false)
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
                
            }
        /*    else if indexPath.row == 1{
                self.checkValue = 1

                spCheckArray[0] = "0"
                spCheckArray[1] = "1"
                spCheckArray[2] = "0"
                spCheckArray[3] = "0"
                spCheckArray[4] = "0"
                spCheckArray[5] = "0"
                spCheckArray[6] = "0"
                spCheckArray[7] = "0"
                spCheckArray[8] = "0"
                
                menuTableView.reloadData()
            
                let OrderTypeListVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                OrderTypeListVC.checkIntValue = self.checkValue
                OrderTypeListVC.checkStr = ""
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(OrderTypeListVC, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
            
            }
            else if indexPath.row == 2{
                self.checkValue = 4
                
                spCheckArray[0] = "0"
                spCheckArray[1] = "0"
                spCheckArray[2] = "1"
                spCheckArray[3] = "0"
                spCheckArray[4] = "0"
                spCheckArray[5] = "0"
                spCheckArray[6] = "0"
                spCheckArray[7] = "0"
                spCheckArray[8] = "0"
                
                menuTableView.reloadData()
                
                let OrderTypeListVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                OrderTypeListVC.checkIntValue = self.checkValue
                OrderTypeListVC.checkStr = ""
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(OrderTypeListVC, animated: true)
                
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
                
            }
            else if indexPath.row == 3{
                self.checkValue = 2
                
                spCheckArray[0] = "0"
                spCheckArray[1] = "0"
                spCheckArray[2] = "0"
                spCheckArray[3] = "1"
                spCheckArray[4] = "0"
                spCheckArray[5] = "0"
                spCheckArray[6] = "0"
                spCheckArray[7] = "0"
                spCheckArray[8] = "0"
                
                menuTableView.reloadData()

                let OrderTypeListVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                OrderTypeListVC.checkIntValue = self.checkValue
                OrderTypeListVC.checkStr = ""
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(OrderTypeListVC, animated: true)
                
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
                
                
            }
            else if indexPath.row == 4{
                self.checkValue = 3
                
                spCheckArray[0] = "0"
                spCheckArray[1] = "0"
                spCheckArray[2] = "0"
                spCheckArray[3] = "0"
                spCheckArray[4] = "1"
                spCheckArray[5] = "0"
                spCheckArray[6] = "0"
                spCheckArray[7] = "0"
                spCheckArray[8] = "0"
                
                menuTableView.reloadData()
                
                let OrderTypeListVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderTypeListVC") as! OrderTypeListVC
                OrderTypeListVC.checkIntValue = self.checkValue
                OrderTypeListVC.checkStr = ""
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(OrderTypeListVC, animated: true)
                
                mainViewController.hideLeftView(animated: true, completionHandler: nil)

            }*/
            else if indexPath.row == 1{
                
                spCheckArray[0] = "0"
                spCheckArray[1] = "1"
                spCheckArray[2] = "0"
                spCheckArray[3] = "0"
                spCheckArray[4] = "0"
                spCheckArray[5] = "0"
//                spCheckArray[5] = "1"
//                spCheckArray[6] = "0"
//                spCheckArray[7] = "0"
//                spCheckArray[8] = "0"
                
                menuTableView.reloadData()
                
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is SpPaymentsVC {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SpPaymentsVC")
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SpPaymentsVC")
                    
                }
                
                navigationController.setViewControllers([viewController], animated: false)
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
          

            }
            else if indexPath.row == 2{
                
                spCheckArray[0] = "0"
                spCheckArray[1] = "0"
                spCheckArray[2] = "1"
                spCheckArray[3] = "0"
                spCheckArray[4] = "0"
                spCheckArray[5] = "0"
//                spCheckArray[5] = "0"
//                spCheckArray[6] = "1"
//                spCheckArray[7] = "0"
//                spCheckArray[8] = "0"
                
                menuTableView.reloadData()
                
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is SpProfileVC {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SpProfileVC")
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "SpProfileVC")
                    
                }
                
                navigationController.setViewControllers([viewController], animated: false)
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
               
            }
            else if indexPath.row == 3{
                
                spCheckArray[0] = "0"
                spCheckArray[1] = "0"
                spCheckArray[2] = "0"
                spCheckArray[3] = "1"
                spCheckArray[4] = "0"
                spCheckArray[5] = "0"
//                spCheckArray[5] = "0"
//                spCheckArray[6] = "0"
//                spCheckArray[7] = "1"
//                spCheckArray[8] = "0"
                
                menuTableView.reloadData()
                
                let NotificationsVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
                NotificationsVC.checkStr = ""
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(NotificationsVC, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
                
                /*let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is NotificationsVC {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificationsVC")
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificationsVC")
                    
                }
                
                navigationController.setViewControllers([viewController], animated: false)
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)*/
            }
            else if indexPath.row == 4{
                spCheckArray[0] = "0"
                spCheckArray[1] = "0"
                spCheckArray[2] = "0"
                spCheckArray[3] = "0"
                spCheckArray[4] = "1"
                spCheckArray[5] = "0"
//                spCheckArray[5] = "0"
//                spCheckArray[6] = "0"
//                spCheckArray[7] = "0"
//                spCheckArray[8] = "1"
                
                menuTableView.reloadData()
                
                let navigationController = mainViewController.rootViewController as! NavigationController
                let viewController: UIViewController!
                
                if navigationController.viewControllers.first is TermsConditionsVC {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "TermsConditionsVC")
                }
                else {
                    viewController = self.storyboard!.instantiateViewController(withIdentifier: "TermsConditionsVC")
                    
                }
                
                navigationController.setViewControllers([viewController], animated: false)
                mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)

            }
            else if indexPath.row == 5{
                spCheckArray[0] = "0"
                spCheckArray[1] = "0"
                spCheckArray[2] = "0"
                spCheckArray[3] = "0"
                spCheckArray[4] = "0"
                spCheckArray[5] = "1"
                menuTableView.reloadData()
                
             //commented
                changeLanguage()
                
            }
        }
    }
    
}

