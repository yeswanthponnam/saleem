//
//  NotificationsVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 24/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire


class NotificationsVC: UIViewController {

    var checkStr : String?
    var params = [String: String]()
    var notification_titleArray = [String]()
    var timeArray = [String]()
    
    @IBOutlet var notificationListTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = languageChangeString(a_str: "Notifications")
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(showLeftView(sender:)), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        
        if Reachability.isConnectedToNetwork(){
            notificationListServiceCall()
        }
        else{
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
   
    }
    
    @objc func showLeftView(sender: AnyObject?) {
        
        if  self.checkStr == "home" {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
        }
   
    }
    
    @objc func onClcikBack()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK:SERVICE CALL FOR NOTIFICATION LIST
    
    func notificationListServiceCall ()
    {
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let userID = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        let notifications = "\(Base_Url)notifications?"
        
        if userType == "2"{
            params = ["user_id":userID,"API-KEY" : APIKEY ,"lang" : language ]
        }
            
        else{
            params = ["user_id":spId!,"API-KEY" : APIKEY ,"lang" : language ]
        }
        
        
        print(params)
        
        Alamofire.request(notifications, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.notification_titleArray = [String]()
                self.timeArray = [String]()
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let new_notifications = responseData["new_notifications"] as? String
                    
                    let notifications = responseData["notifications"] as? [[String:Any]]
                 
                    for each in notifications! {
                        
                        let notification_title = each["notification_title"]  as! String
                        let time = each["time"]  as! String
                       
                        self.notification_titleArray.append(notification_title)
                        self.timeArray.append(time)
                    }
                    
                    let imageDataDict:[String: String] = ["key": new_notifications!]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateNotificationCount"), object: nil, userInfo: imageDataDict )
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.notificationListTV.reloadData()
                    }
                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.notificationListTV.reloadData()
                    self.showToast(message: message!)
                }
            }
        }
    }
    
   
    
}

extension NotificationsVC: UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notification_titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var  cell : NotificationsCell
        
        cell = notificationListTV.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
        cell.titleLabel.text = notification_titleArray[indexPath.row]
        cell.timeLabel.text = timeArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //return UITableView.automaticDimension
        return 86
    }
    
}


