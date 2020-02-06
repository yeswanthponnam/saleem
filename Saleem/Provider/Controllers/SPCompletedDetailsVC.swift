//
//  SPCompletedDetailsVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 18/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import MOLH
class SPCompletedDetailsVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {

    
    @IBOutlet var estimateAmountCommonView: UIView!
    @IBOutlet var generateInvoiceBtn: UIButton!
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var orderNoStatic: UILabel!
    @IBOutlet var orderNoLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var customerNameStatic: UILabel!
    @IBOutlet var mobileBrandStatic: UILabel!
    @IBOutlet var visitDateTimeStatic: UILabel!
    @IBOutlet var problemTypeStatic: UILabel!
    
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var mobileBrandLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var problemTypeLabel: UILabel!
    
    @IBOutlet var issueDescStatic: UILabel!
    @IBOutlet var issueDescTV: UITextView!
    
    @IBOutlet var issueViewUnderLine: UIView!
  
    var invoiceStatusStr : String?
    
    var reqID : String?
    @IBOutlet var mapView: GMSMapView!
    var googleMapView : GMSMapView?

    var currentLocation:CLLocationCoordinate2D!
    
    var latitudeString : String! = ""
    var longitudeString : String! = ""
    var marker:GMSMarker!
    
    var issuesList : [[String: Any]]!
    var issue_nameArray = [String]()
    
    @IBOutlet var viewIssuesBtn: UIButton!
    @IBOutlet var issueView: UIView!
    
    var indexValue : Int!
    
    @IBOutlet var estimateAmount: UILabel!
    
    @IBOutlet var estimateAmountLabel: UILabel!
    
    @IBOutlet var reasonForRejectView: UIView!
    
    @IBOutlet var rejectReasonStatic: UILabel!
    @IBOutlet var rejectReasonLabel: UILabel!
    
    var checkInt:Int!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderNoStatic.text = languageChangeString(a_str: "Order No")
        customerNameStatic.text = languageChangeString(a_str: "Customer Name")
        mobileBrandStatic.text = languageChangeString(a_str: "Mobile brand")
        visitDateTimeStatic.text = languageChangeString(a_str: "Visit date & time")
        problemTypeStatic.text = languageChangeString(a_str: "Problem Type")
        issueDescStatic.text = languageChangeString(a_str: "Issue description")
        self.rejectReasonStatic.text = languageChangeString(a_str: "Reason For Rejection")
        self.generateInvoiceBtn.setTitle(languageChangeString(a_str: "GENERATE INVOICE"), for: UIControl.State.normal)
        
        if MOLHLanguage.isRTLLanguage(){
            self.issueDescTV.textAlignment = .right
        }
        else{
            self.issueDescTV.textAlignment = .left
        }
        
        self.mapView.delegate = self
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))

        self.navigationItem.leftBarButtonItem = barButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationItem.title = languageChangeString(a_str: "Details")
        
//        if checkInt == 3 {
//
//            self.reasonForRejectView.isHidden = true
//            self.estimateAmount.text = languageChangeString(a_str: "Fixed Amount")
//
//        }else{
//            self.reasonForRejectView.isHidden = false
//            self.estimateAmount.text = languageChangeString(a_str: "Estimation amount")
//        }
        
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        userImageView.clipsToBounds = true
        
        if Reachability.isConnectedToNetwork() {
            
            getSPCompleteRejectDetailsServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        

   /* apr 4     if indexValue == 0{
            self.viewIssuesBtn.isHidden = false
            self.issueView.isHidden = false
        }
        else{
            self.viewIssuesBtn.isHidden = true
            self.issueView.isHidden = true
        }*/
        
    }
    
    @objc fileprivate func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
  
    @IBAction func viewIssuesAction(_ sender: Any) {
        
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
        
    }

    @IBAction func generateInvoiceBtnAction(_ sender: Any) {
        
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpCreateInvoiceVC") as! SpCreateInvoiceVC
        gotoVC.reqID = self.reqID
        gotoVC.backCheckStr = "toComplete"
        self.navigationController?.pushViewController(gotoVC, animated: true)
        
    }
    //loading mapview
    func loadMaps(){
        self.mapView.delegate = self
        self.googleMapView?.delegate = self
        let dLati = Double(self.latitudeString ?? "") ?? 0.0
        let dLong = Double(self.longitudeString ?? "") ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: dLati, longitude: dLong, zoom: 12)
        self.googleMapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        self.marker = GMSMarker()
        self.marker!.position = CLLocationCoordinate2DMake(dLati, dLong)
        // marker.tracksViewChanges = true
        self.marker?.map = self.googleMapView
        self.mapView.addSubview(self.googleMapView!)
        self.googleMapView?.settings.setAllGesturesEnabled(false)
        self.marker?.icon = UIImage.init(named: "location")
    }
    
    //SP REQUESTDETAILS SERVICE CALL
    func getSPCompleteRejectDetailsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         provider_id:*/
        
        let getProfile = "\(Base_Url)provider_service_request_details"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "request_id" : reqID!,"provider_id":spId, "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(getProfile, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                //self.issue_idArray = [String]()
                self.issue_nameArray = [String]()
                //self.issue_statusArray = [String]()
                
                if status == 1
                {
                    
                    if let userDetailsData = responseData["request_details"] as? Dictionary<String, AnyObject> {
                        
                        self.issuesList = userDetailsData["issues_list"] as? [[String: Any]]
                        
                        let userName = userDetailsData["name"] as? String?
                        let brand_name = userDetailsData["brand_name"] as? String?
                        let order_id = userDetailsData["order_id"] as? String?
                        let address = userDetailsData["address"] as? String?
                        
                        let date = userDetailsData["date"] as? String?
                        let description = userDetailsData["description"] as? String?
                        let issues = userDetailsData["issues"] as? String?
                        let request_status = userDetailsData["request_status"] as? String?
                        let Image = userDetailsData["profile_pic"]  as! String
                        let image = String(format: "%@%@",base_path,Image)
                        let reject_reason = userDetailsData["reject_reason"] as? String?
                        let total_amount = userDetailsData["total_amount"] as? String?
                        
                        let invoice_status = userDetailsData["invoice_status"] as? String?
                        
                        self.latitudeString = userDetailsData["latitude"] as? String
                        self.longitudeString = userDetailsData["longitude"] as? String
                        
                        self.invoiceStatusStr = invoice_status!
                        
                        if self.checkInt == 3 {
                            if self.invoiceStatusStr == "0"{
                                self.generateInvoiceBtn.setTitle(languageChangeString(a_str: "GENERATE INVOICE"), for: UIControl.State.normal)
                                self.generateInvoiceBtn.isHidden = false
                                self.reasonForRejectView.isHidden = true
                                self.estimateAmount.isHidden = true
                                self.estimateAmountCommonView.isHidden = true
                            }
                            else{
                                self.generateInvoiceBtn.isHidden = true
                                self.reasonForRejectView.isHidden = true
                                self.estimateAmount.text = languageChangeString(a_str: "Fixed Amount")
                                self.estimateAmountCommonView.isHidden = false
                                self.estimateAmount.isHidden = false
                            }
                            
                        }else{
                            self.reasonForRejectView.isHidden = false
                            self.estimateAmountCommonView.isHidden = false
                            self.estimateAmount.isHidden = false
                            self.estimateAmount.text = languageChangeString(a_str: "Estimation amount")
                            self.generateInvoiceBtn.isHidden = true

                        }
                        
                        
                        for each in self.issuesList! {
                            
                            //let issue_id = each["issue_id"]  as! String
                            let issue_name = each["issue_name"]  as! String
                            //let issue_status = each["issue_status"]  as! String
                            
                            //self.issue_idArray.append(issue_id)
                            self.issue_nameArray.append(issue_name)
                            //self.issue_statusArray.append(issue_status)
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.customerNameLabel.text = userName as? String
                            self.orderNoLabel.text = order_id as? String
                            self.addressLabel.text = address as? String
                            self.mobileBrandLabel.text = brand_name as? String
                            self.dateLabel.text = date as? String
                            self.problemTypeLabel.text = issues as? String
                            self.issueDescTV.text = description as? String
                            self.userImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: ""))
                            self.rejectReasonLabel.text = reject_reason as? String
                            self.estimateAmountLabel.text = String(format: "%@ %@", total_amount!!,"SAR")
                               
                            
                            if (self.issuesList?.count)! > 1{
                                self.issueViewUnderLine.isHidden = false
                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapIssues))
                                //UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
                                self.problemTypeLabel.addGestureRecognizer(tap)
                            }
                            else{
                                self.issueViewUnderLine.isHidden = true
                            }
                            
                            
                            
                        }
                 
                    }
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.loadMaps()
                    }
                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    //self.showToastForAlert(message: message)
                    self.showToast(message: message)
                }
            }
        }
    }
    
    @objc func onTapIssues(sender:UITapGestureRecognizer) {
        
        print("tap working")
        UserDefaults.standard.setValue(self.issue_nameArray, forKey: "list")
        let mvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SPIssueListVC") as!
        SPIssueListVC
        self.present(mvc, animated: true, completion: nil)
    }
}
