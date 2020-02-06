//
//  PaymentVC.swift
//  Saleem
//
//  Created by volivesolutions on 25/01/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import Alamofire

class PaymentVC: UIViewController {

    var reqIdStr : String?
    
    var paymentTypeStr : String?
//    var totalAmount : String?
//    var couponStr : String?
    
    var total_amount: String?
    var coupon_code: String?
    
    var discount_amount: String?
    
    @IBOutlet var payNowBtn: UIButton!
    @IBOutlet var savedCardsLabel: UILabel!
    @IBOutlet var addcardBtn: UIButton!
    
    @IBOutlet var cardImageView: UIImageView!
    @IBOutlet var cardRadioImageView: UIImageView!
    
    @IBOutlet var cashImageView: UIImageView!
    @IBOutlet var cashRadioImageView: UIImageView!
    
    @IBOutlet var cardsHeightConstarint: NSLayoutConstraint!
    @IBOutlet var detailsView: UIView!
    @IBOutlet var cardBtn: UIButton!
    @IBOutlet var cashBtn: UIButton!
    @IBOutlet var payNowHeight: NSLayoutConstraint!
    
    @IBOutlet var mainViewHeight: NSLayoutConstraint!
    @IBOutlet var detailsViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailsViewHeight.constant = 0
        self.cardsHeightConstarint.constant = 0
        self.savedCardsLabel.isHidden = true
        self.addcardBtn.isHidden = true
    
        self.navigationItem.title = languageChangeString(a_str: "Payment")
        self.cardBtn.setTitle(languageChangeString(a_str: "Pay by Cash"), for: UIControl.State.normal)
        self.cashBtn.setTitle(languageChangeString(a_str: "Pay With Card"), for: UIControl.State.normal)
        self.payNowBtn.setTitle(languageChangeString(a_str: "PAY NOW"), for: UIControl.State.normal)
        self.addcardBtn.setTitle(languageChangeString(a_str: "ADD CARD"), for: UIControl.State.normal)
        self.savedCardsLabel.text = languageChangeString(a_str: "")
        
        self.detailsView.isHidden = true
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 450.0)
        self.mainViewHeight.constant = 456
        paymentTypeStr = "cash"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func card(_ sender: Any) {
        paymentTypeStr = "cash"
        self.cardBtn.layer.backgroundColor = UIColor.init(red: 207.0/255.0, green: 227.0/255.0, blue: 253.0/255.0, alpha: 1).cgColor
        self.cashBtn.layer.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
        self.cardImageView.image = UIImage.init(named: "SelectedCard")
        self.cashImageView.image = UIImage.init(named: "UnSelectedCash")
        
        self.cardRadioImageView.image = UIImage.init(named: "SelectedRadio")
        self.cashRadioImageView.image = UIImage.init(named: "UnSelectedRadio")
        
//        self.cardBtn.setTitleColor(UIColor.init(red: 0.0/255.0, green: 124.0/255.0, blue: 249.0/255.0, alpha: 1), for: UIControl.State.normal)
//        self.cashBtn.setTitleColor(UIColor.init(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1), for: UIControl.State.normal)
        
        self.cardBtn.setTitleColor(UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1), for: UIControl.State.normal)
        self.cashBtn.setTitleColor(UIColor.init(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1), for: UIControl.State.normal)

        
        self.detailsView.isHidden = true
        self.detailsViewHeight.constant = 0
        self.cardsHeightConstarint.constant = 0
        
        self.savedCardsLabel.isHidden = true
        self.addcardBtn.isHidden = true
        self.payNowHeight.constant = 50
        self.payNowBtn.setTitle(languageChangeString(a_str: "PAY NOW"), for: UIControl.State.normal)
    }
    
    @IBAction func cash(_ sender: Any) {
        paymentTypeStr = "card"
        self.cashBtn.layer.backgroundColor = UIColor.init(red: 207.0/255.0, green: 227.0/255.0, blue: 253.0/255.0, alpha: 1).cgColor
        self.cardBtn.layer.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
        self.cashImageView.image = UIImage.init(named: "SelectedCash")
        self.cardImageView.image = UIImage.init(named: "UnSelectedCard")
        
        self.cashRadioImageView.image = UIImage.init(named: "SelectedRadio")
        self.cardRadioImageView.image = UIImage.init(named: "UnSelectedRadio")
        
//        self.cashBtn.setTitleColor(UIColor.init(red: 0.0/255.0, green: 124.0/255.0, blue: 249.0/255.0, alpha: 1), for: UIControl.State.normal)
//        self.cardBtn.setTitleColor(UIColor.init(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1), for: UIControl.State.normal)
        self.cashBtn.setTitleColor(UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1), for: UIControl.State.normal)
        self.cardBtn.setTitleColor(UIColor.init(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1), for: UIControl.State.normal)
        self.detailsViewHeight.constant = 450
        self.cardsHeightConstarint.constant = 140
        
        self.detailsView.isHidden = true
        self.savedCardsLabel.isHidden = false
        self.addcardBtn.isHidden = false
        self.payNowHeight.constant = 50
        self.payNowBtn.setTitle(languageChangeString(a_str: "PAY NOW"), for: UIControl.State.normal)
    }
    
    @IBAction func addCard(_ sender: Any) {
        self.detailsView.isHidden = false
//        self.detailsViewHeight.constant = 450
        self.payNowHeight.constant = 0
        self.mainViewHeight.constant = 400 + 450
        
        self.savedCardsLabel.isHidden = false
        self.addcardBtn.isHidden = false
        self.payNowBtn.setTitle("", for: UIControl.State.normal)
    }
    
    
    @IBAction func payNowAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            
            makePaymentServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
//        let SuccessfulVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessfulVC") as! SuccessfulVC
//        SuccessfulVC.reqIdStr = self.reqIdStr
//        self.navigationController?.pushViewController(SuccessfulVC, animated: false)
    }
    
    @IBAction func savePayAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            
            makePaymentServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MAKE PAYMENT SERVICE CALL
    func makePaymentServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         coupon_code:(optional)
         discount_amount:(optional)
         total_amount:
         payment_method:(cash/card)*/
        
        let signup = "\(Base_Url)make_payment"
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqIdStr!,  "coupon_code" : self.coupon_code!,"total_amount":self.total_amount! ,"discount_amount":self.discount_amount!,"payment_method":paymentTypeStr!,"lang" : language,"API-KEY":APIKEY]
        //,"latitude":self.latitudeString!,"longitude":self.longitudeString!
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
                        let SuccessfulVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessfulVC") as! SuccessfulVC
                        SuccessfulVC.reqIdStr = self.reqIdStr
                        self.navigationController?.pushViewController(SuccessfulVC, animated: false)
                       // self.showToast(message: message)
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
