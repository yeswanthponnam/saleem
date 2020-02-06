//
//  DeviceProblemPopUpVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 24/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit



class DeviceProblemPopUpVC: UIViewController {
    
    @IBOutlet var deviceProblemStaticLabel: UILabel!
    
    @IBOutlet var viewInvoiceBtn: UIButton!
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewInvoiceBtn.setTitle(languageChangeString(a_str: "VIEW INVOICE"), for: UIControl.State.normal)
        deviceProblemStaticLabel.text = languageChangeString(a_str: "your device problem is fixed")
    }
    

    @IBAction func closeAcyion(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewInvoiceAction(_ sender: Any) {
//        let UserInvoiceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInvoiceVC") as! UserInvoiceVC
//        self.navigationController?.pushViewController(UserInvoiceVC, animated: false)
        
        
//        let rootViewController = self.window?.rootViewController as! UINavigationController
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let new = storyboard.instantiateViewController(withIdentifier: "UserInvoiceVC") as!
//        UserInvoiceVC
//
//        rootViewController.pushViewController(new, animated: false)
        
//
        NotificationCenter.default.post(name: Notification.Name("pushView6"), object: nil)
        self.dismiss(animated: true) {
            print("dismmissed")
        }
        
        
    }
    
}
