//
//  SuccessfulVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 24/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import MOLH

class SuccessfulVC: UIViewController,UITextViewDelegate {

    var reqIdStr : String?
    var ratingStr : String! = ""
    
    @IBOutlet var successStaticLabel: UILabel!
    @IBOutlet var giveRatingStaticLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var submitBtn: UIButton!
    
    @IBOutlet var ratingButtonOne: UIButton!
    @IBOutlet var ratingButtonTwo: UIButton!
    @IBOutlet var ratingButtonThree: UIButton!
    @IBOutlet var ratingButtonFour: UIButton!
    @IBOutlet var ratingButtonFive: UIButton!
    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating")!
    let halfStarImage:  UIImage = UIImage(named: "check")!
    let emptyStarImage: UIImage = UIImage(named: "unselected_star")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = languageChangeString(a_str: "Successful")
        self.giveRatingStaticLabel.text = languageChangeString(a_str: "Give your Rating")
        self.successStaticLabel.text = languageChangeString(a_str: "Your Payment is Successful")
        self.commentLabel.text = languageChangeString(a_str: "Write Your Comment")
        self.submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        if MOLHLanguage.isRTLLanguage(){
            self.commentTextView.textAlignment = .right
        }
        else{
            self.commentTextView.textAlignment = .left
        }
    }
  
    @IBAction func submitAction(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            
            ratingServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.commentLabel.isHidden = true
    }
    
    
    @IBAction func ratingBtnOneAction(_ sender: UIButton) {
        
        ratingButtonOne .setImage(UIImage (named: "rating_one_selected"), for: .normal)
        ratingButtonTwo .setImage(UIImage (named: "star2blue"), for: .normal)
        ratingButtonThree.setImage(UIImage (named: "star3blue"), for: .normal)
        ratingButtonFour .setImage(UIImage (named: "star4blue"), for: .normal)
        ratingButtonFive .setImage(UIImage (named: "star5blue"), for: .normal)
        
        ratingStr = "1"

    }
    
    @IBAction func ratingBtnTwoAction(_ sender: UIButton) {
        
        ratingButtonOne .setImage(UIImage (named: "rating_one_selected"), for: .normal)
        ratingButtonTwo .setImage(UIImage (named: "rating_two_selected"), for: .normal)
        ratingButtonThree.setImage(UIImage (named: "star3blue"), for: .normal)
        ratingButtonFour .setImage(UIImage (named: "star4blue"), for: .normal)
        ratingButtonFive .setImage(UIImage (named: "star5blue"), for: .normal)
        
        ratingStr = "2"
        
    }
    
    @IBAction func ratingBtnThreeAction(_ sender: Any) {
        ratingButtonOne .setImage(UIImage (named: "rating_one_selected"), for: .normal)
        ratingButtonTwo .setImage(UIImage (named: "rating_two_selected"), for: .normal)
        ratingButtonThree.setImage(UIImage (named: "rating_three_selected"), for: .normal)
        ratingButtonFour .setImage(UIImage (named: "star4blue"), for: .normal)
        ratingButtonFive .setImage(UIImage (named: "star5blue"), for: .normal)
        
        ratingStr = "3"

    }
    
    @IBAction func ratingBtnFourAction(_ sender: Any) {
        ratingButtonOne .setImage(UIImage (named: "rating_one_selected"), for: .normal)
        ratingButtonTwo .setImage(UIImage (named: "rating_two_selected"), for: .normal)
        ratingButtonThree.setImage(UIImage (named: "rating_three_selected"), for: .normal)
        ratingButtonFour .setImage(UIImage (named: "rating_four_selected"), for: .normal)
        ratingButtonFive .setImage(UIImage (named: "star5blue"), for: .normal)
        
        ratingStr = "4"
    }
    
    @IBAction func ratingBtnFiveAction(_ sender: Any) {
        ratingButtonOne .setImage(UIImage (named: "rating_one_selected"), for: .normal)
        ratingButtonTwo .setImage(UIImage (named: "rating_two_selected"), for: .normal)
        ratingButtonThree.setImage(UIImage (named: "rating_three_selected"), for: .normal)
        ratingButtonFour .setImage(UIImage (named: "rating_four_selected"), for: .normal)
        ratingButtonFive .setImage(UIImage (named: "rating_five_selected"), for: .normal)
        
        ratingStr = "5"
    }
    
    
    
    //RATING SERVICECALL
    func ratingServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         request_rating: 1 to 5
         rating_comments:
         */
        
        let rating = "\(Base_Url)request_rating"
      
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqIdStr!,  "request_rating" :ratingStr! ,"rating_comments":self.commentTextView.text ?? "","lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(rating, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                        
                        self.showToast(message: message)
                        
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
