//
//  ViewController.swift
//  Saleem
//
//  Created by volivesolutions on 25/01/19.
//  Copyright © 2019 Prashanth. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import MOLH

class HomeViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,GMSAutocompleteViewControllerDelegate {
   
    var locationManager = CLLocationManager()
    
    var checkmapStr : String! = ""
    var checkMapStr1 : String! = ""
    
    @IBOutlet var newViewHeightConstraint: NSLayoutConstraint!
    
    var issueDescNewStr :String?
    
    @IBOutlet var describeIssueLabel: UILabel!
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var addressTextView: UITextView!
    
    @IBOutlet var issueLabel: UILabel!
    @IBOutlet var issueDescTV: UITextView!
    
    @IBOutlet var issueHeightConstarint: NSLayoutConstraint!
    @IBOutlet var issueStack: UIStackView!
    @IBOutlet var issueImageView: UIImageView!
    
    @IBOutlet var issueNamesStack: UIStackView!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
    @IBOutlet var brandViewHeight: NSLayoutConstraint!
    @IBOutlet var modelViewHeight: NSLayoutConstraint!
    
    @IBOutlet var circleHeight: NSLayoutConstraint!
    @IBOutlet var pinHeight: NSLayoutConstraint!
    
    @IBOutlet var brandStack: UIStackView!
    @IBOutlet var modelStack: UIStackView!
    
    @IBOutlet var brandImageView: UIImageView!
    @IBOutlet var modelImageView: UIImageView!
    @IBOutlet var locationImageView: UIImageView!
    
    @IBOutlet var menuBtn: UIBarButtonItem!
    
    @IBOutlet var createRequestBtn: UIButton!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    var barButton : UIBarButtonItem!
    let btnLeftMenu = UIButton()
    
    var barButtonItem : UIBarButtonItem!
    
    var checkString : String?
    var saveBool : Bool!
    
    @IBOutlet var issuesTableView: UITableView!
    
    @IBOutlet var mobileBrandTF: UITextField!
    @IBOutlet var mobileModelTF: UITextField!
    
    //for brand arrays
    var brandIDArray = [String]()
    var brandNameArray = [String]()
    var brandString : String! = ""
    var brandIdString : String! = ""
    //for model arrays
    var modelIDArray = [String]()
    var modelNameArray = [String]()
    var modelString : String! = ""
    var modelIdString : String! = ""
    
    //for issues arrays
    var issueIDArray = [String]()
    var issueNameArray = [String]()
    
    var tagsCheckArray = [String]()
    
    var IdString : String!
    var idIssueNameString : String!
    
    //storing issue id
    var idArray = [String]()
    var checkArr = [String]()
    
    //storing issuename
    var idIssueNameArray = [String]()
    //var idIssueNameArray: [String] = []
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var textfieldCheckValue : Int!
    
    var editString : String?
    var issueDescString : String?
    
    var streetAddress : String! = ""
    var addressStr : String! = ""
    var latitudeString : String! = ""
    var longitudeString : String! = ""
   
    var currentLocation:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        self.mapView.delegate = self
//        locationManager.startUpdatingLocation()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor (red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        
        self.mobileBrandTF.placeholder = languageChangeString(a_str: "Select Mobile brand")
        self.mobileModelTF.placeholder = languageChangeString(a_str: "Select Model")
        
        self.describeIssueLabel.text = languageChangeString(a_str: "Describe your issue")
        self.createRequestBtn.setTitle(languageChangeString(a_str: "CREATE REQUEST"), for: UIControl.State.normal)
        self.issueLabel.text = languageChangeString(a_str: "Select the issue")
        
        if MOLHLanguage.isRTLLanguage(){
            self.mobileBrandTF.textAlignment = .right
            self.mobileModelTF.textAlignment = .right
            self.addressTextView.textAlignment = .right
            self.issueDescTV.textAlignment = .right
        }
        else{
            self.mobileBrandTF.textAlignment = .left
            self.mobileModelTF.textAlignment = .left
            self.addressTextView.textAlignment = .left
            self.issueDescTV.textAlignment = .left
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pushViewController6),
            name: NSNotification.Name(rawValue: "pushView6"),
            object: nil)
       // self.mapView.isMyLocationEnabled = true
        
        
       /* if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()

        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
       
        }*/
        
        if editString == "edit"{
            self.mobileBrandTF.text = self.brandString
            self.mobileModelTF.text = self.modelString
            self.issueDescTV.text = self.issueDescString
            self.describeIssueLabel.isHidden = true
            var string = ""
            string = idIssueNameArray.joined(separator: ",")
            issueLabel.text = string
            UserDefaults.standard.set("filt", forKey: "savebS")
        }else{
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocation(_:)), name: NSNotification.Name(rawValue: "getLocation"), object: nil)
     
        menuBtn.target = self
        menuBtn.action = #selector(showLeftView(sender:))
        
//        barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
//                                            style: .plain,
//                                            target: self,
//                                            action: #selector(backButtonTapped))
//
//        self.navigationItem.leftBarButtonItem = barButtonItem
//        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.circleHeight.constant = 60
        self.tableViewHeightConstraint.constant = 0
        self.newViewHeightConstraint.constant = 418 - 128
        self.issueDescTV.delegate = self
    }

    override func viewDidLayoutSubviews() {
        self.addressTextView.setContentOffset(CGPoint.zero, animated: true)
        self.issueDescTV.setContentOffset(CGPoint.zero, animated: true)
    }
  
    @objc func pushViewController6(){
        let UserInvoiceVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInvoiceVC") as! UserInvoiceVC
        UserInvoiceVC.reqIdStr = UserDefaults.standard.string(forKey: "invoiceReqId")
        self.navigationController?.pushViewController(UserInvoiceVC, animated: false)
    }
    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    @objc fileprivate func backButtonTapped() {
        barButtonItem.target = self
        barButtonItem.action = #selector(presentLeftMenuViewController)
    }
    @objc func getLocation(_ notification: NSNotification){
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["key"] as? String
            longitudeString = dict["key1"] as? String
            addressStr = dict["key2"] as? String
            checkmapStr = dict["map"] as? String
            print("latitudeString",latitudeString)
            print("longitudeString",longitudeString)
            print("addressStr",addressStr)
            print("checkmapStr",checkmapStr)
        }
        
        self.addressTextView.text = addressStr
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        //locationManager delegates
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundRefreshHome), name: UIApplication.willEnterForegroundNotification, object: nil)
        isAuthorizedLocation()

    }
    
    func isAuthorizedLocation(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                //  self.showToastForAlert(message: "Access Denied")
                
                let alertController = UIAlertController(title: languageChangeString(a_str: "Location Services Disabled!") , message: languageChangeString(a_str: "Please enable Location Based Services for better results! We promise to keep your location private"), preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Cancel")!, comment: ""), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Settings")!, comment: ""), style: .default) { (UIAlertAction) in

                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }

                    //UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                }

                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)

                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = true
                
            }
        } else {
            print("Location services are not enabled")
            isAuthorizedtoGetUserLocation()
        }
    }
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
   func registerForLocationUpdates(){
    if CLLocationManager.locationServicesEnabled() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined, .restricted, .denied:
    print("No access")
    //  self.showToastForAlert(message: "Access Denied")
    
    let alertController = UIAlertController(title: languageChangeString(a_str: "Location Services Disabled!") , message: languageChangeString(a_str: "Please enable Location Based Services for better results! We promise to keep your location private"), preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Cancel")!, comment: ""), style: .cancel, handler: nil)
    let settingsAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Settings")!, comment: ""), style: .default) { (UIAlertAction) in
    
    if #available(iOS 10.0, *) {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
    } else {
    // Fallback on earlier versions
    }
    
    //UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(settingsAction)
    self.present(alertController, animated: true, completion: nil)
    
    
    
    
    case .authorizedAlways, .authorizedWhenInUse:
    print("Access")
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.startUpdatingLocation()
    mapView?.isMyLocationEnabled = true
    
    }
    } else {
    print("Location services are not enabled enter background to foreground")
        
    }
    
    }
    
    
    @objc func willEnterForegroundRefreshHome() {
        
        //Register for
        registerForLocationUpdates()
    }
    
    @objc func onClcikBack()
    {
//       btnLeftMenu.addTarget(SSASideMenu.init(contentViewController: SideMenuVC(), leftMenuViewController: SideMenuVC()), action: #selector(presentLeftMenuViewController), for: UIControl.Event.touchUpInside)
        
       // self.navigationController?.popViewController(animated: true)
       
    }
    
    func createPickerView(){
        pickerView = UIPickerView()
        pickerView?.frame = CGRect(x: 0, y:0, width: view.frame.size.width, height: 162)
        pickerView?.delegate = self
        pickerView?.dataSource = self
        let lightTextureColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        pickerView?.backgroundColor = lightTextureColor
        pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        pickerToolBar?.barStyle = .blackOpaque
        pickerToolBar?.autoresizingMask = .flexibleWidth
        pickerToolBar?.barTintColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        
        pickerToolBar?.frame = CGRect(x: 0,y: (pickerView?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
        pickerToolBar?.barStyle = UIBarStyle.default
        pickerToolBar?.isTranslucent = true
        pickerToolBar?.tintColor = #colorLiteral(red: 0.09803921569, green: 0.231372549, blue: 0.3764705882, alpha: 1)
        pickerToolBar?.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.231372549, blue: 0.3764705882, alpha: 1)
        pickerToolBar?.sizeToFit()
        
        
        let doneButton1 = UIBarButtonItem(title: languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        self.mobileBrandTF.inputView = self.pickerView
        self.mobileBrandTF.inputAccessoryView = self.pickerToolBar
        
        self.pickerView?.reloadInputViews()
        self.pickerView?.reloadAllComponents()
        
    }
    
    @objc func donePickerView(){
  
        if textfieldCheckValue == 1{
            self.brandString = brandNameArray[(pickerView?.selectedRow(inComponent: 0))!]
            self.mobileBrandTF.text = self.brandString
        brandIdString = brandIDArray[(pickerView?.selectedRow(inComponent: 0))!]
        if brandString.count > 0{
            self.mobileBrandTF.text = self.brandString ?? ""
        }else{
            self.mobileBrandTF.text = brandNameArray[0]
        }
        
        self.view.endEditing(true)
            mobileBrandTF.resignFirstResponder()
        }
        else{
            self.modelString = modelNameArray[(pickerView?.selectedRow(inComponent: 0))!]
            self.mobileModelTF.text = self.modelString
            modelIdString = modelIDArray[(pickerView?.selectedRow(inComponent: 0))!]
            if modelString.count > 0{
                self.mobileModelTF.text = self.modelString ?? ""
            }else{
                self.mobileModelTF.text = modelNameArray[0]
            }
            self.view.endEditing(true)
            mobileModelTF.resignFirstResponder()
        }
    }
    
    @objc func cancelPickerView(){
        
        if textfieldCheckValue == 1{
        if (mobileBrandTF.text?.count)! > 0 {
            self.view.endEditing(true)
            mobileBrandTF.resignFirstResponder()
        }else{
            self.view.endEditing(true)
            mobileBrandTF.text = ""
            mobileBrandTF.resignFirstResponder()
        }
        mobileBrandTF.resignFirstResponder()
        }
        else{
            if (mobileModelTF.text?.count)! > 0 {
                self.view.endEditing(true)
                mobileModelTF.resignFirstResponder()
            }else{
                self.view.endEditing(true)
                mobileModelTF.text = ""
                mobileModelTF.resignFirstResponder()
            }
            mobileModelTF.resignFirstResponder()
        }
    }
    
    
    @IBAction func expandAction(_ sender: Any) {
        
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpSetLocationVC") as! SpSetLocationVC
        self.present(gotoVC, animated: true, completion: nil)
        checkMapStr1 = "map1"
        let locationdict : [String:String] = ["lat":latitudeString,"lang":longitudeString,"address":self.addressTextView.text!,"map1":checkMapStr1]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showUpdatedValueOnMap"), object: nil, userInfo: locationdict)
    }
    
    @IBAction func brand(_ sender: Any) {
    }
    
    @IBAction func model(_ sender: Any) {
    }
    
    @IBAction func location(_ sender: Any) {
    }
    

//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if textView == self.issueDescTV{
//        let existingLines = self.issueDescTV.text.components(separatedBy: CharacterSet.newlines)
//        let newLines = text.components(separatedBy: CharacterSet.newlines)
//        let linesAfterChange = existingLines.count + newLines.count - 1
//        return linesAfterChange <= self.issueDescTV.textContainer.maximumNumberOfLines
//        }
//        return false
//    }



    @IBAction func selectIssueAction(_ sender: Any) {
        
        if editString == "edit"{
            if issuesTableView.frame.height == 0{
                
                idArray = [String]()
                saveBool = false
                
                idIssueNameArray = [String]()
                UserDefaults.standard.removeObject(forKey: "IdsStringissueArr")
                
                //added below two lines
                // UserDefaults.standard.removeObject(forKey: "savebS")
                //  UserDefaults.standard.removeObject(forKey: "IdsStringArr")
                if Reachability.isConnectedToNetwork() {
                    self.issuesListServiceCall()
                }else{
                    showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                }
                self.issueImageView.image = UIImage.init(named: "Up")
                self.newViewHeightConstraint.constant = 418
                self.tableViewHeightConstraint.constant = 128
            }
            else{
                UserDefaults.standard.set("filt", forKey: "savebS")
                self.issueImageView.image = UIImage.init(named: "Down")
                self.newViewHeightConstraint.constant = 418 - 128
                self.tableViewHeightConstraint.constant = 0
            }
        }
            
        else{
            let height: CGFloat = CGFloat(issueIDArray.count * 29)
            print("height\(height)")
            if tableViewHeightConstraint.constant == 0{
                
                idArray = [String]()
                saveBool = false
                
                idIssueNameArray = [String]()
                UserDefaults.standard.removeObject(forKey: "IdsStringissueArr")
                
                UserDefaults.standard.removeObject(forKey: "savebS")
                UserDefaults.standard.removeObject(forKey: "IdsStringArr")
                if Reachability.isConnectedToNetwork() {
                    self.issuesListServiceCall()
                }else{
                    showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                }
                self.issueImageView.image = UIImage.init(named: "Up")
                self.newViewHeightConstraint.constant = 418
                self.tableViewHeightConstraint.constant = CGFloat(issueIDArray.count) * 29
            }else{
                UserDefaults.standard.set("filt", forKey: "savebS")
                self.issueImageView.image = UIImage.init(named: "Down")
                self.newViewHeightConstraint.constant = 418 - 128
                self.tableViewHeightConstraint.constant = 0
            }
        }
        
        
// before working       if editString == "edit"{
//            if issuesTableView.frame.height == 128{
//                UserDefaults.standard.set("filt", forKey: "savebS")
//                self.issueImageView.image = UIImage.init(named: "Down")
//                self.newViewHeightConstraint.constant = 418 - 128
//                self.tableViewHeightConstraint.constant = 0
//            }
//            else{
//                idArray = [String]()
//                saveBool = false
//
//                idIssueNameArray = [String]()
//                UserDefaults.standard.removeObject(forKey: "IdsStringissueArr")
//
//                //added below two lines
//                // UserDefaults.standard.removeObject(forKey: "savebS")
//                //  UserDefaults.standard.removeObject(forKey: "IdsStringArr")
//
//                self.issuesListServiceCall()
//                self.issueImageView.image = UIImage.init(named: "Up")
//                self.newViewHeightConstraint.constant = 418
//                //issuesTableView.contentSize.height = 128
//                self.tableViewHeightConstraint.constant = 128
//            }
//        }
//
//        else{
//            if issuesTableView.frame.height == 128{
//                UserDefaults.standard.set("filt", forKey: "savebS")
//                self.issueImageView.image = UIImage.init(named: "Down")
//                self.newViewHeightConstraint.constant = 418 - 128
//                self.tableViewHeightConstraint.constant = 0
//            }
//            else{
//                idArray = [String]()
//                saveBool = false
//
//                idIssueNameArray = [String]()
//                UserDefaults.standard.removeObject(forKey: "IdsStringissueArr")
//
//                UserDefaults.standard.removeObject(forKey: "savebS")
//                UserDefaults.standard.removeObject(forKey: "IdsStringArr")
//
//                self.issuesListServiceCall()
//                self.issueImageView.image = UIImage.init(named: "Up")
//                self.newViewHeightConstraint.constant = 418
//                self.tableViewHeightConstraint.constant = 128
//                //issuesTableView.contentSize.height = 128
//            }
//        }


       /* if editString == "edit"{
            if tableViewHeightConstraint.constant == 128{
                UserDefaults.standard.set("filt", forKey: "savebS")
                self.issueImageView.image = UIImage.init(named: "Down")
                self.newViewHeightConstraint.constant = 418 - 128
                self.tableViewHeightConstraint.constant = 0
                
            }
            else{
                
                idArray = [String]()
                saveBool = false
                
                idIssueNameArray = [String]()
                UserDefaults.standard.removeObject(forKey: "IdsStringissueArr")
                
                //added below two lines
               // UserDefaults.standard.removeObject(forKey: "savebS")
              //  UserDefaults.standard.removeObject(forKey: "IdsStringArr")
                
                
                self.issuesListServiceCall()
                self.issueImageView.image = UIImage.init(named: "Up")
                self.newViewHeightConstraint.constant = 418
                self.tableViewHeightConstraint.constant = 128
            }
            
            
        }
        
        else{
            if tableViewHeightConstraint.constant == 128{
                UserDefaults.standard.set("filt", forKey: "savebS")
                self.issueImageView.image = UIImage.init(named: "Down")
                self.newViewHeightConstraint.constant = 418 - 128
                self.tableViewHeightConstraint.constant = 0
                
            }
            else{
                
                idArray = [String]()
                saveBool = false
                
                idIssueNameArray = [String]()
                UserDefaults.standard.removeObject(forKey: "IdsStringissueArr")
                
                UserDefaults.standard.removeObject(forKey: "savebS")
                UserDefaults.standard.removeObject(forKey: "IdsStringArr")
                
                
                self.issuesListServiceCall()
                self.issueImageView.image = UIImage.init(named: "Up")
                self.newViewHeightConstraint.constant = 418
                self.tableViewHeightConstraint.constant = 128
            }
        }*/
        
    }
  
    @IBAction func sendRequestAction(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                //  self.showToastForAlert(message: "Access Denied")
                
                let alertController = UIAlertController(title: languageChangeString(a_str: "Location Services Disabled!") , message: languageChangeString(a_str: "Please enable Location Based Services for better results! We promise to keep your location private"), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Cancel")!, comment: ""), style: .cancel, handler: nil)
                let settingsAction = UIAlertAction(title: NSLocalizedString( languageChangeString(a_str: "Settings")!, comment: ""), style: .default) { (UIAlertAction) in
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    //UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access location")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = true
                
                if brandIdString == ""{
                    self.showToast(message: languageChangeString(a_str:"Select Mobile brand")!)
                }else if modelIdString == ""{
                    self.showToast(message: languageChangeString(a_str:"Select Model")!)
                }else if idArray.count <= 0{
                    self.showToast(message: languageChangeString(a_str:"Select the issue")!)
                }
                else if self.issueDescTV.text == ""{
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToast(message: languageChangeString(a_str: "Please Enter description")!)
                    }
                }else{
                    let reqVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserReqOrderDetailsVC") as! UserReqOrderDetailsVC
                    reqVC.brandString = brandString
                    reqVC.modelString = modelString
                    reqVC.issueDescString = self.issueDescTV.text
                    reqVC.latitudeString = self.latitudeString
                    reqVC.longitudeString = self.longitudeString
                    reqVC.addressString = self.addressTextView.text
                    reqVC.idArray = self.idArray
                    reqVC.idIssueNameArray = self.idIssueNameArray
                    reqVC.modelIdString = self.modelIdString
                    reqVC.brandIdString = self.brandIdString
                    //UserDefaults.standard.set("filt", forKey: "savebS")
                    self.navigationController?.pushViewController(reqVC, animated: false)
                }
                
                
            }
        } else {
            print("Location services are not enabled")
            
        }
        
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        let reqVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        reqVC.checkStr = "home"
        self.navigationController?.pushViewController(reqVC, animated: false)
    }
    
    @IBAction func trackPendingRecentAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            userTrackingPendingServiceCall()
        }else{
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
        }
    }
    
    @IBAction func menuAction(_ sender: Any) {
//        menuBtn.target = self
//        menuBtn.action = #selector(presentLeftMenuViewController)
    }
    
    
    @IBAction func myCurrentLocationBtnAction(_ sender: Any) {
        
        latitudeString = ""
        longitudeString = ""
        self.checkmapStr = ""
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else{
        }
    }
    //MARK:TEXTVIEW DELAGATES
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.describeIssueLabel.isHidden = true
    }
    
    func wrapperFunctionToShowPosition(mapView:GMSMapView){
       let geocoder = GMSGeocoder()
        
        self.latitudeString = String(format: "%.8f", mapView.camera.target.latitude)
        self.longitudeString = String(format: "%.8f", mapView.camera.target.longitude)
       
        let latitud = Double(self.latitudeString ?? "") ?? 0.0
        let longitud = Double(self.longitudeString ?? "") ?? 0.0
        let position = CLLocationCoordinate2DMake( latitud, longitud)

        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
            }else {
                guard let result = response?.results()?.first else{
                    return 
                }
                print("adress of that location is \(result)")
                self.addressStr = result.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
               
                print("Address Str Is :\(self.addressStr ?? "")")
                DispatchQueue.main.async {
                    self.addressTextView.text = self.addressStr
                }
            }
        }
        
    }
    
    //MARK:MAP DELEGATES
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .restricted:
//            print("Location access was restricted.")
//        case .denied:
//            print("User denied access to location.")
//
//            self.isAuthorizedLocation()
//        case .notDetermined:
//            print("Location status not determined.")
//            self.isAuthorizedLocation()
//
//        case .authorizedAlways: fallthrough
//        case .authorizedWhenInUse:
//            print("Location status is OK.")
//
//        }
//    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("didchange")
        //called everytime
        // comented
        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    //MARK:Did update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        if editString == "edit"{
                if latitudeString == "" && longitudeString == ""{
                let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
                
                DispatchQueue.main.async {
                    self.mapView.camera = camera
                    self.mapView.delegate = self
                    self.mapView.isMyLocationEnabled = true
                    self.mapView.settings.myLocationButton = true
                    self.locationManager.stopUpdatingLocation()
                }
            }else{
            let latitud = Double(self.latitudeString ?? "") ?? 0.0
            let longitud = Double(self.longitudeString ?? "") ?? 0.0
            let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
            DispatchQueue.main.async {
                self.mapView.camera = camera
                self.mapView.delegate = self
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.locationManager.stopUpdatingLocation()
            }
            }
            
        }
        //flow from home to confirm location check
        else if checkmapStr == "confirm"{
            //if latitudeString != ""{
            let latitud = Double(self.latitudeString ?? "") ?? 0.0
            let longitud = Double(self.longitudeString ?? "") ?? 0.0
            let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
            DispatchQueue.main.async {
                self.mapView.camera = camera
                self.mapView.delegate = self
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.locationManager.stopUpdatingLocation()
            }
        }else if latitudeString != ""{
                    let latitud = Double(self.latitudeString ?? "") ?? 0.0
                    let longitud = Double(self.longitudeString ?? "") ?? 0.0
                    let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
                    DispatchQueue.main.async {
                        self.mapView.camera = camera
                        self.mapView.delegate = self
                        self.mapView.isMyLocationEnabled = true
                        self.mapView.settings.myLocationButton = true
                        self.locationManager.stopUpdatingLocation()
                    }
                }
        else{
            
            let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
                DispatchQueue.main.async {
                self.mapView.camera = camera
                self.mapView.delegate = self
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.locationManager.stopUpdatingLocation()
            }
        }
        locationManager.stopUpdatingLocation()
    }
 
    //MARK: - Custom PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: languageChangeString(a_str: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: languageChangeString(a_str: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
    }
    //MARK:TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if (textField == self.mobileBrandTF){
            
            textfieldCheckValue = 1
            if Reachability.isConnectedToNetwork() {
                self.brandListServiceCall()
            }else{
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            }
            self.pickUp(self.mobileBrandTF)
        }
        else if (textField == mobileModelTF) {
            textfieldCheckValue = nil
            if brandIdString == ""{
                self.showToast(message: languageChangeString(a_str: "Select Mobile brand")!)
             self.mobileModelTF.resignFirstResponder()
            }else{
                if Reachability.isConnectedToNetwork() {
                    modelListServiceCall()
                }else{
                    showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                }
            self.pickUp(self.mobileModelTF)
            }
        }
    }
    //MARK:PASTE TEXT IS NOT ENTERED IN TEXTFIELD
    func canPerformAction(_ action: Selector, withSender sender: UITextField) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

    //MARK:SERVICE CALL FOR BRANDS
    
    func brandListServiceCall ()
    {
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let brands = "\(Base_Url)all_brands?"
        let parameters: Dictionary<String, Any> = ["API-KEY" : APIKEY ,"lang" : language ]
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(brands, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.brandIDArray = [String]()
                self.brandNameArray = [String]()
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let brandList = responseData["brands_list"] as? [[String:Any]]
                    for each in brandList! {
                        let brand_id = each["brand_id"]  as! String
                        let brand_name = each["brand_name"]  as! String
                        self.brandIDArray.append(brand_id)
                        self.brandNameArray.append(brand_name)
                    }
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.pickerView?.reloadAllComponents()
                        self.pickerView?.reloadInputViews()
                    }
                }
                else{
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.showToast(message: message!)
                }
            }
        }
    }
    
    //MARK:SERVICE CALL FOR MODELS
    
    func modelListServiceCall ()
    {
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let models = "\(Base_Url)all_models?"
        let parameters: Dictionary<String, Any> = ["brand_id":brandIdString!,"API-KEY" : APIKEY ,"lang" : language ]
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(models, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.modelIDArray = [String]()
                self.modelNameArray = [String]()
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let modelsList = responseData["models_list"] as? [[String:Any]]
                    for each in modelsList! {
                        let model_id = each["model_id"]  as! String
                        let model_name = each["model_name"]  as! String
                        self.modelIDArray.append(model_id)
                        self.modelNameArray.append(model_name)
                    }
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.pickerView?.reloadAllComponents()
                        self.pickerView?.reloadInputViews()
                    }
                }
                else{
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.showToast(message: message!)
                }
            }
        }
    }
    
    //MARK: SERVICE CALL FOR ISSUES
    
    func issuesListServiceCall ()
    {
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let issuesList = "\(Base_Url)issues_list?"
        let parameters: Dictionary<String, Any> = ["API-KEY" : APIKEY ,"lang" : language ]
        print(parameters)
        MobileFixServices.sharedInstance.loader(view: self.view)
        Alamofire.request(issuesList, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                
                self.issueIDArray = [String]()
                self.issueNameArray = [String]()
                
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let issueList = responseData["issues_list"] as? [[String:Any]]
                    for each in issueList! {
                        let issue_id = each["issue_id"]  as! String
                        let issue_name = each["issue_name"]  as! String
                        
                        self.issueIDArray.append(issue_id)
                        self.issueNameArray.append(issue_name)
                        
                        let myInt2 = (issue_id as NSString).integerValue
                        let myString = String(myInt2)
                        
                        if UserDefaults.standard.object(forKey: "savebS") != nil
                        {
                            self.saveBool = true
                            let idArr = UserDefaults.standard.object(forKey: "IdsStringArr") as! Array<Any>
                            self.checkArr = idArr as! [String]
                            print(self.checkArr)
                            if self.checkArr .contains(myString){
                                let checkStr = "1"
                                self.tagsCheckArray.append(checkStr)
                            }else{
                                let checkStr = "0"
                                self.tagsCheckArray.append(checkStr)
                            }
                        }
                        else{
                            let checkStr = "0"
                            self.tagsCheckArray.append(checkStr)
                        }
                    }
                    self.issuesTableView.reloadData()
                }
                else{
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.showToast(message: message!)
                }
            }
        }
    }
    //MARK:USER TRACKPENDING SERVICE CALL
    func userTrackingPendingServiceCall ()
    {
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
     
        let trackPending = "\(Base_Url)user_track_pending?"
        let parameters = ["API-KEY": APIKEY , "user_id" :userID!, "lang" : language]
        print(parameters)
        Alamofire.request(trackPending, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print("response of tracking",responseData,trackPending)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let TrackOrderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackOrderVC") as! TrackOrderVC
                    TrackOrderVC.sepCheckStr = "toHome"
                    self.navigationController?.pushViewController(TrackOrderVC, animated: false)
                }
                else{
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToast(message: message)
                        
                    }
                }
            }
        }
    }
    
    
    //MARK:Tableview delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let height: CGFloat = CGFloat(issueIDArray.count * 29)
        if view.frame.size.height / 2 + 19 >= height {
            tableViewHeightConstraint.constant = CGFloat(issueIDArray.count * 29)
            print("view height \(view.frame.size.height - 38)\(height) ")
            newViewHeightConstraint.constant = tableViewHeightConstraint.constant + 418 - 128
        } else {
            print("less view height \(view.frame.size.height)")
            tableViewHeightConstraint.constant = view.frame.size.height / 2 + 19
            newViewHeightConstraint.constant = tableViewHeightConstraint.constant
        }
        return self.issueIDArray.count
        
      //commented just nnow
        //return issueIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = issuesTableView.dequeueReusableCell(withIdentifier: "IssuesCell", for: indexPath) as! IssuesCell
        cell.issueNameLabel.text = issueNameArray[indexPath.row]
        let issueIdStr = issueIDArray[indexPath.row]
        print(tagsCheckArray)
        if tagsCheckArray[indexPath.row] == "0" {
            cell.checkImageView.image = UIImage.init(named: "UnCheck")
            if idIssueNameArray.isEmpty{
                self.issueLabel.text = languageChangeString(a_str: "Select the issue")
            }
            else{
                
            }
            
        }else if tagsCheckArray[indexPath.row] == "1"{
          
            cell.checkImageView.image = UIImage(named: "check")
            
            idArray.append(issueIdStr)
            idIssueNameArray.append(cell.issueNameLabel.text!)
            
            print("Id Array Is :\(idArray)")
            print("Id issuename Array Is :\(idIssueNameArray)")
            
            IdString = idArray.joined(separator: ",")
            print(IdString)
            
            idIssueNameString = idIssueNameArray.joined(separator: ",")
            print(idIssueNameString)
          
            var string = ""
            string = idIssueNameArray.joined(separator: ",")
            self.issueLabel.text = string
            
            UserDefaults.standard.set( IdString , forKey: "bandIdsString")
            UserDefaults.standard.set( idArray , forKey: "IdsStringArr")
            
            UserDefaults.standard.set( idIssueNameString , forKey: "bandIdsissueString")
            UserDefaults.standard.set( idIssueNameArray , forKey: "IdsStringissueArr")
            
        }else{
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 29
        //return (self.issuesTableView.frame.size.height)/CGFloat(issueIDArray.count)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveBool = true
        if tagsCheckArray[indexPath.row] == "0" {
            tagsCheckArray.remove(at: indexPath.row)
            tagsCheckArray.insert("1", at: indexPath.row)
            
            IdString = ""
            idArray = [String]()
            
            idIssueNameString = ""
            idIssueNameArray = [String]()
            
            issuesTableView.reloadData()
            
        }else if tagsCheckArray[indexPath.row] == "1"{
            tagsCheckArray.remove(at: indexPath.row)
            tagsCheckArray.insert("0", at: indexPath.row)
            print(tagsCheckArray)
            IdString = ""
            idArray = [String]()
            
            idIssueNameString = ""
            idIssueNameArray = [String]()
           
            if !(self.tagsCheckArray.contains("1")){
                print("There are no items added")
                saveBool = false
                UserDefaults.standard.removeObject(forKey: "savebS")
            }
            issuesTableView.reloadData()
        }
        
    }
  
    @IBAction func onTapTextViewGesture(_ sender: Any) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
    }
    
    //MARK:PLACES DELEGATES
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Address Componants: \(String(describing: place.addressComponents))")
        print("Latitude :\(place.coordinate.latitude)")
        print("Longititude :\(place.coordinate.longitude)")
        
        self.addressStr = place.formattedAddress!
        self.addressTextView.text = self.addressStr
        
        self.latitudeString = String(format: "%.8f", place.coordinate.latitude)
        self.longitudeString = String(format: "%.8f", place.coordinate.longitude)
        self.mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude:place.coordinate.longitude, zoom: 15)
        
        DispatchQueue.main.async {
            self.mapView.camera = camera
        }
        self.mapView?.animate(to: camera)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
  /* today com func textViewDidChange(_ textView: UITextView) {
        textView.removeTextUntilSatisfying(maxNumberOfLines: 2)
        self.issueDescTV.textContainer.lineBreakMode = .byWordWrapping
        if textView.textContainer.maximumNumberOfLines == 2{
            print("over")
           let str = String(textView.text.dropLast())
            print("text over \(String(describing: str))")
            self.issueDescTV.textContainer.lineBreakMode = .byWordWrapping
        }
     
    }*/
    
  /* working solution for 4 lines  func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: font],
                                                         context: nil).size
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        var textWidth = textView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)).width
      
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
        
        let boundingRect = sizeOfString(string: newText, constrainedToWidth: Double(textWidth), font: textView.font!)
        let numberOfLines = boundingRect.height / textView.font!.lineHeight;
        
        return numberOfLines <= 2;
    }*/
    
    
}


/* today com extension UITextView {
    var numberOfCurrentlyDisplayedLines: Int {
        //let size = systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        //for Swift 4.2, replace with next line:
        let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        return Int(((size.height - layoutMargins.top - layoutMargins.bottom) / font!.lineHeight))
    }

    /// Removes last characters until the given max. number of lines is reached
    func removeTextUntilSatisfying(maxNumberOfLines: Int) {
        while numberOfCurrentlyDisplayedLines > (maxNumberOfLines) {
            
            text = String(text.dropLast())
            print("text\(String(describing: text))")
            layoutIfNeeded()
        }
    }
}*/

extension HomeViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        if (textfieldCheckValue == 1) {
            return brandIDArray.count
        }else{
            return modelIDArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        if (textfieldCheckValue == 1){
            return brandNameArray[row]
        }else{
            return modelNameArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (textfieldCheckValue == 1){
            self.mobileBrandTF.text =  brandNameArray[row]
            self.brandString = brandNameArray[row]
            brandIdString = brandIDArray[row]
        }else{
            mobileModelTF.text =  modelNameArray[row]
            self.modelString = modelNameArray[row]
            modelIdString = modelIDArray[row]
        }
    }
}

extension UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}


//https://maplebrains.com/
