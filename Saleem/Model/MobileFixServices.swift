//
//  MobileFixServices.swift
//  Saleem
//
//  Created by Suman Guntuka on 16/03/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView

class MobileFixServices: NSObject {
    
    static let sharedInstance = MobileFixServices()
    
    //signUp getperamters
    var _name: String!
    var _email: String!
    var _mobileNumber: String!
    var _message: String!
    
    var errMessage: String!
    let imageV = UIImageView()
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    func loader(view: UIView) -> () {
    
    DispatchQueue.main.async {
    self.indicator.frame = CGRect(x: 0,y: 0,width: 75,height: 75)
    self.indicator.layer.cornerRadius = 8
    self.indicator.center = view.center
    self.indicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    view.addSubview(self.indicator)
    self.indicator.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1)
    self.indicator.bringSubviewToFront(view)
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    self.indicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
    }
    }
    
    func dissMissLoader()  {
    
    indicator.stopAnimating()
    imageV.removeFromSuperview()
    UIApplication.shared.endIgnoringInteractionEvents()
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func noInternetConnectionlabel (inViewCtrl:UIView) {
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .transitionCurlUp, animations: {
    
    let lblNew = UILabel()
    lblNew.frame = CGRect(x: 0, y: 0, width: inViewCtrl.frame.size.width, height: 50)
    lblNew.backgroundColor = UIColor.gray
    lblNew.textAlignment = .center
    lblNew.text = "No Internet Connection"
    lblNew.textColor = UIColor.white
    inViewCtrl.addSubview(lblNew)
    lblNew.font=UIFont.systemFont(ofSize: 18)
    lblNew.alpha = 0.5
    lblNew.transform = .identity
    }, completion: nil)
    }
    
    }
    
    
extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
}


extension UIViewController {
    
    func showToast(message : String) {
        
        
        let appearance = SCLAlertView.SCLAppearance(
            
            showCircularIcon: true
           
        )
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "splash screen logo") //Replace the IconImage text with the image name Logo
        // let alertViewIcon = UIImage(named: "Logo")
        //        alertView.showInfo(languageChangeString(a_str: "Alert" )!, subTitle: message ,closeButtonTitle: (languageChangeString(a_str: "DONE")!) , circleIconImage: alertViewIcon)
       //COMMENTED alertView.showInfo(languageChangeString(a_str:"Alert")!, subTitle: message ,closeButtonTitle: languageChangeString(a_str:"DONE"), circleIconImage: alertViewIcon)
        // alertView.showInfo("", subTitle: "", closeButtonTitle: (languageChangeString(a_str: "DONE")!))
        alertView.showInfo(languageChangeString(a_str: "Alert")!, subTitle: message ,closeButtonTitle:languageChangeString(a_str: "Done"), circleIconImage: alertViewIcon)
    }
    
    func showToastForAlert(message : String) {
        
        let message = message
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true)
        // duration in seconds
        let duration: Double = 3
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
            
        }
        
        func showToastForInternet (message : String) {
            
            let message = message
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            self.present(alert, animated: true)
            // duration in seconds
            let duration: Double = 3
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                
                alert.dismiss(animated: true)
                
            }
            
            
        }
    }
    
    
}


//// Valodation Toasts

//extension UIViewController {
//
//    func showToastForAlert(message : String) {
//
//        CRNotifications.showNotification(type: CRNotifications.success, title: languageChangeString(a_str: "Success")!, message: message, dismissDelay: 2, completion: {
//        })
//    }
//
//    func showToastForError(message : String) {
//
//        CRNotifications.showNotification(type: CRNotifications.error, title: languageChangeString(a_str: "Error")!, message: message, dismissDelay: 2)
//    }
//}

func languageChangeString(a_str: String) -> String?{
    
    var path: Bundle?
    var selectedLanguage:String = String()
    
    //selectedLanguage = UserDefaults.standard.string(forKey: "currentLanguage")!
    selectedLanguage = UserDefaults.standard.string(forKey: "currentLanguage") as? String ?? ""
    //let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
    print(selectedLanguage)
    
    if selectedLanguage == ENGLISH_LANGUAGE {
        
        if let aType = Bundle.main.path(forResource: "en", ofType: "lproj") {
            path = Bundle(path: aType)!
        }
    }
    else if selectedLanguage == ARABIC_LANGUAGE {
        if let aType = Bundle.main.path(forResource: "ar", ofType: "lproj") {
            path = Bundle(path: aType)!
        }
    }
    else {
        if let aType = Bundle.main.path(forResource: "en", ofType: "lproj") {
            path = Bundle(path: aType)!
        }
    }
    
    let str: String = NSLocalizedString(a_str, tableName: "LocalizableMobileFix", bundle: path!, value: "", comment: "")
    
    return str
}


