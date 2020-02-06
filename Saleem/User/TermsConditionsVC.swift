//
//  TermsConditionsVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 24/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
class TermsConditionsVC: UIViewController {

    var checkStr : String?
    @IBOutlet var termsConditionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = languageChangeString(a_str: "Terms and Conditions")
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
        
        if Reachability.isConnectedToNetwork() {
            
            termsConditionsServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    
    @objc func showLeftView(sender: AnyObject?) {
        
        if  self.checkStr == "terms" {
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

    //MARK:TERMS & CONDITIONS SERVICE CALL
    func termsConditionsServiceCall(){
        MobileFixServices.sharedInstance.loader(view: self.view)
      
        let termsService = "\(Base_Url)terms_conditions"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters : Dictionary<String,Any> = ["lang" : language,"API-KEY":APIKEY]
        print(parameters)
        
        Alamofire.request(termsService, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String,Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                if status == 1{
                   
                    if let detailsDict = responseData["data"] as? Dictionary<String,AnyObject> {
                        
                        DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                          let termsStr = detailsDict["text"] as? String
                            let attrStr = try! NSAttributedString(
                                data: (termsStr?.data(using: .unicode, allowLossyConversion: true)!)!,
                                options:[.documentType: NSAttributedString.DocumentType.html,
                                         .characterEncoding: String.Encoding.utf8.rawValue],
                                documentAttributes: nil)
                            self.termsConditionsTextView.attributedText = attrStr
                            if MOLHLanguage.isRTLLanguage(){
                                self.termsConditionsTextView.textAlignment = .right
                            }
                            else{
                                self.termsConditionsTextView.textAlignment = .left
                            }
                            print("strr",self.termsConditionsTextView.attributedText)
                        }
                }
            }
            else{
                    MobileFixServices.sharedInstance.dissMissLoader()
                }
        }
    }
}

}
