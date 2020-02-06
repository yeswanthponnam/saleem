//
//  SpSignupVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 25/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import MOLH
import CoreTelephony

class SpSignupVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate,UIDocumentMenuDelegate ,UIDocumentPickerDelegate {

    var phoneNumberStart : String?
    var phoneNumber1Start : String?
    var newLength :NSInteger?
    
    var locationManager = CLLocationManager()
    
    @IBOutlet var docsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var docsCollectionView: UICollectionView!
    @IBOutlet var statusBackView: UIView!
    @IBOutlet var statusBackViewHeightConstarint: NSLayoutConstraint!
    
    @IBOutlet var statusDocLabel: UILabel!
    @IBOutlet var welcomeToStaticLabel: UILabel!
    @IBOutlet var signupToCreateAccountStaticLabel: UILabel!
    @IBOutlet var individualStaticLabel: UILabel!
    @IBOutlet var companyStaticLabel: UILabel!
    
    @IBOutlet var countryCodeTF: UITextField!
    
    @IBOutlet var emailAddressStaticLabel: UILabel!
    @IBOutlet var phoneNumberStaticLabel: UILabel!
    @IBOutlet var createPwdStaticLabel: UILabel!
    @IBOutlet var confirmPwdStaticLabel: UILabel!
    
    @IBOutlet var iagreeBtn: UIButton!
    @IBOutlet var termsCondBtn: UIButton!
    
    @IBOutlet var signUpBtn: UIButton!
    
    @IBOutlet var alreadyHaveAccountStaticLabel: UILabel!
    @IBOutlet var signInBtn: UIButton!
    var sendingImgPicker = UIImagePickerController()
    var pickedImage = UIImage()
    var mediaTypeString : String?
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var addressTV: UITextView!
    
    @IBOutlet var hijriCalenderBtn: UIButton!
    
    @IBOutlet var custombackView: UIView!
    @IBOutlet var companyCustomBackView: UIView!
    @IBOutlet var commonBackView: UIView!
    
    @IBOutlet weak var lbl_CertificateUpload: UILabel!
    @IBOutlet weak var company_Custom_View_hightConstain: NSLayoutConstraint!
    @IBOutlet weak var custom_View_HightConstain: NSLayoutConstraint!
    @IBOutlet weak var txt_Location: UITextField!
    @IBOutlet weak var txt_ConfirmPassword: UITextField!
    @IBOutlet weak var txt_CreatePassword: UITextField!
    @IBOutlet weak var txt_PhoneNumber: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_BirthDate: UITextField!
    @IBOutlet weak var txt_ID: UITextField!
    @IBOutlet weak var txt_Gender: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var btn_Company: UIButton!
    @IBOutlet weak var btn_Individual: UIButton!
    
    @IBOutlet var createPwdBtn: UIButton!
    @IBOutlet var confirmPwdBtn: UIButton!
    
    @IBOutlet var genderStaticLabel: UILabel!
    @IBOutlet var idStaticLabel: UILabel!
    @IBOutlet var birthDateStaticLabel: UILabel!
    
    @IBOutlet var companyNumberStaticLabel: UILabel!
    @IBOutlet weak var txt_CompanyNumber: UITextField!
    
    var cell : ImageCell!
    @IBOutlet var nameStaticLabel: UILabel!
    
    var checkTerms : Bool!
    var checkTermStr : String! = ""
    
    @IBOutlet var checkTermBtn: UIButton!
    
    //@IBOutlet weak var lbl_Name: UILabel!
    var checkValue : Int!
    
    var checkUserType : String!
    
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    var genderArray = [languageChangeString(a_str: "Male"),languageChangeString(a_str: "Female")]
    var genderString : String! = ""
    var genderIdArray = ["0","1"]
    var genderIdString : String! = ""
    //for document upload
    var docFileExtension : String!
    var docFileData : Data!
    var pdfUrl : URL!
    var fileNameStr : String! = ""
    var mimeTypeStr : String! = ""
    
    //for present set location values
   
    
  //commented today  var myArray: [Any] = []
    var myArray: [Any] = []
    var typeArray = [String]()
    var bidImgsArr  = [Data]()
    //for date picker
    
    var datePicker : UIDatePicker?
    var dateToolBar : UIToolbar?
    
    //for map
    var streetAddress : String! = ""
    var addressStr : String! = ""
    var latitudeString : String! = ""
    var longitudeString : String! = ""
    
     var parameters = [String: String]()
    
    var currentLocation:CLLocationCoordinate2D!
    
//    lazy var locationManager: CLLocationManager = {
//
//        var _locationManager = CLLocationManager()
//        _locationManager.delegate = self
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        //kCLLocationAccuracyNearestTenMeters
//        _locationManager.activityType = .automotiveNavigation
//        _locationManager.distanceFilter = 10.0
//        return _locationManager
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberStart = "0"
        phoneNumber1Start = "5"
        //self.mapView.delegate = self
        checkTerms = false
        txt_CreatePassword.isSecureTextEntry = true
        txt_ConfirmPassword.isSecureTextEntry = true
        DispatchQueue.main.async {
            if MOLHLanguage.isRTLLanguage(){
                self.countryCodeTF.roundCorners(corners: [.topRight,.bottomRight], radius: 10.0)
                self.txt_PhoneNumber.roundCorners(corners: [.topLeft,.bottomLeft], radius: 10.0)
            }else{
                self.countryCodeTF.roundCorners(corners: [.topLeft,.bottomLeft], radius: 10.0)
                self.txt_PhoneNumber.roundCorners(corners: [.topRight,.bottomRight], radius: 10.0)
            }
            
        }
        
        //self.orderidView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
        let network_Info = CTTelephonyNetworkInfo()
        let carrier: CTCarrier? = network_Info.subscriberCellularProvider
        print("country code is: \(carrier?.mobileCountryCode ?? "")")
        //will return the actual country code
        print("ISO country code is: \(carrier?.isoCountryCode ?? "")")
        
        if carrier?.isoCountryCode == "in" {
            self.countryCodeTF.text = "+91" //
        }else{
            self.countryCodeTF.text = "+966"
        }
        
        welcomeToStaticLabel.text = languageChangeString(a_str: "Welcome to")
        signupToCreateAccountStaticLabel.text = languageChangeString(a_str: "Sign up to Create account")
        individualStaticLabel.text = languageChangeString(a_str: "Individual")
        companyStaticLabel.text = languageChangeString(a_str: "Company")
        
        nameStaticLabel.text = languageChangeString(a_str: "Name")
        genderStaticLabel.text = languageChangeString(a_str: "Gender")
        idStaticLabel.text = languageChangeString(a_str: "ID")
        birthDateStaticLabel.text = languageChangeString(a_str: "Birth date")
        
        emailAddressStaticLabel.text = languageChangeString(a_str: "E-mail Address")
        phoneNumberStaticLabel.text = languageChangeString(a_str: "Phone number")
        createPwdStaticLabel.text = languageChangeString(a_str: "Create password")
        confirmPwdStaticLabel.text = languageChangeString(a_str: "Confirm password")
        lbl_CertificateUpload.text = languageChangeString(a_str: "Certification Documents")
        self.iagreeBtn.setTitle(languageChangeString(a_str: "I agree to the"), for: UIControl.State.normal)
        self.termsCondBtn.setTitle(languageChangeString(a_str: "Terms and Conditions"), for: UIControl.State.normal)
        self.signUpBtn.setTitle(languageChangeString(a_str: "SIGN UP"), for: UIControl.State.normal)
        self.signInBtn.setTitle(languageChangeString(a_str: "Sign in Now!"), for: UIControl.State.normal)
        alreadyHaveAccountStaticLabel.text = languageChangeString(a_str: "Already have an account?")
        
        txt_Name.placeholder = languageChangeString(a_str: "Name")
        txt_Gender.placeholder = languageChangeString(a_str: "Gender")
        txt_ID.placeholder = languageChangeString(a_str: "1055482876")
        
        txt_BirthDate.placeholder = languageChangeString(a_str: "1440-10-23")
        
        txt_Email.placeholder = languageChangeString(a_str: "provider@yopmail.com")
        //txt_Email.placeholder = languageChangeString(a_str: "E-mail Address")
        //txt_PhoneNumber.placeholder = languageChangeString(a_str: "Starts With 966")
        txt_PhoneNumber.placeholder = languageChangeString(a_str: "0518420022")
        txt_CreatePassword.placeholder = languageChangeString(a_str: "Create password")
        txt_ConfirmPassword.placeholder = languageChangeString(a_str: "Confirm password")
        
        if MOLHLanguage.isRTLLanguage(){
            self.txt_Name.textAlignment = .right
            self.txt_Gender.textAlignment = .right
            self.txt_ID.textAlignment = .right
            self.txt_BirthDate.textAlignment = .right
            self.txt_Email.textAlignment = .right
            self.txt_CreatePassword.textAlignment = .right
            self.txt_ConfirmPassword.textAlignment = .right
            self.txt_CompanyNumber.textAlignment = .right
            self.addressTV.textAlignment = .right
            self.txt_PhoneNumber.textAlignment = .right
        }
        else{
            self.txt_Name.textAlignment = .left
            self.txt_Gender.textAlignment = .left
            self.txt_ID.textAlignment = .left
            self.txt_BirthDate.textAlignment = .left
            self.txt_Email.textAlignment = .left
            self.txt_CreatePassword.textAlignment = .left
            self.txt_ConfirmPassword.textAlignment = .left
            self.txt_CompanyNumber.textAlignment = .left
            self.addressTV.textAlignment = .left
            self.txt_PhoneNumber.textAlignment = .left
        }
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.getSelectedDate),
//            name: NSNotification.Name(rawValue: "getSelectedDate"),
//            object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSelectedToDate(_:)), name: NSNotification.Name(rawValue: "notificationName1"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.getLocation(_:)), name: NSNotification.Name(rawValue: "getLocation"), object: nil)
        
        createPickerView()
        showDatePicker()
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(backButtonTapped))
       
        self.navigationItem.leftBarButtonItem = barButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        //self.txt_Location.setBottomLineBorder()
        self.txt_ID.setBottomLineBorder()
        self.txt_Name.setBottomLineBorder()
        self.txt_Email.setBottomLineBorder()
        self.txt_Gender.setBottomLineBorder()
        self.txt_BirthDate.setBottomLineBorder()
        self.countryCodeTF.setBottomLineBorder()
        self.txt_PhoneNumber.setBottomLineBorder()
        self.txt_CreatePassword.setBottomLineBorder()
        self.txt_ConfirmPassword.setBottomLineBorder()
        self.txt_CompanyNumber.setBottomLineBorder()
        self.company_Custom_View_hightConstain.constant = 0
        
        self.docsViewHeightConstraint.constant = 50
        
        self.companyNumberStaticLabel.isHidden = true
        self.txt_CompanyNumber.isHidden = true
        
        self.genderStaticLabel.isHidden = false
        self.idStaticLabel.isHidden = false
        self.birthDateStaticLabel.isHidden = false
        
        self.txt_Gender.isHidden = false
        //self.custombackView.backgroundColor = UIColor.clear
        //self.custombackView.backgroundColor = UIColor.clear
        //self.commonBackView.backgroundColor = UIColor.clear
        
        //checkValue = 1
        
        
        //self.statusBackViewHeightConstarint.constant = 0
        //self.statusDocLabel.isHidden = true
        
        
        checkUserType = "3"
    
    }
    
   @objc func getLocation(_ notification: NSNotification){
        
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["key"] as? String
            longitudeString = dict["key1"] as? String
            addressStr = dict["key2"] as? String
            print("latitudeString",latitudeString)
            print("longitudeString",longitudeString)
            print("addressStr",addressStr)
        }
    
        self.addressTV.text = addressStr
    
    }
    
    
    @objc func getSelectedToDate(_ notification: NSNotification)
    {
        if let dateStr = notification.userInfo?["date2"] as? String {
            // do something with your image
            self.txt_BirthDate.text = dateStr
            print(dateStr)
        }

    }
//
    //MARK:SHOW DATE PICKER
    func showDatePicker(){
        datePicker = UIDatePicker()
        // datePicker?.locale = NSLocale(localeIdentifier: "ar_SA") as Locale
        datePicker?.datePickerMode = .date
        datePicker?.backgroundColor = UIColor.white
        dateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        dateToolBar?.barStyle = .blackOpaque
        dateToolBar?.autoresizingMask = .flexibleWidth
        dateToolBar?.barTintColor = #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1)
        
        dateToolBar?.frame = CGRect(x: 0,y: (datePicker?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
        dateToolBar?.barStyle = UIBarStyle.default
        dateToolBar?.isTranslucent = true
        dateToolBar?.tintColor = #colorLiteral(red: 0.09803921569, green: 0.231372549, blue: 0.3764705882, alpha: 1)
        dateToolBar?.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.231372549, blue: 0.3764705882, alpha: 1)
        dateToolBar?.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: languageChangeString(a_str: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SpSignupVC.donePickerDate))
        doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: languageChangeString(a_str: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SpSignupVC.canclePickerDate))
        cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        dateToolBar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dateToolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.txt_BirthDate.inputView = datePicker
        self.txt_BirthDate.inputAccessoryView = dateToolBar
        // self.datePicker?.minimumDate =
        let date = Date()
        let hijri = Calendar(identifier: .islamic)
        var components = DateComponents()
        components.day = 0
        // let newDate: Date? = calendar.date(byAdding: components, to: date, options: [])
        //let newDate: Date? = calendar.date(byAdding: components, to:date, wrappingComponents:)
        let newDate : Date? = hijri.date(byAdding: components, to: date)
        datePicker?.calendar = hijri
        //datePicker?.minimumDate = newDate
        
    }
    
    //MARK:DONE PICKER DATE
    @objc func donePickerDate ()
    {
        //datePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        //to show islamic date
        let formatter = DateFormatter()
        let hijri = Calendar(identifier: .islamic)
        formatter.calendar = hijri
        formatter.dateFormat = "yyyy-MM-dd"
        //txt_date.textAlignment = NSTextAlignment.left
        txt_BirthDate.text! = formatter.string(from: (datePicker?.date)!)
        self.view.endEditing(true)
        txt_BirthDate.resignFirstResponder()
    }
    
    //MARK:CANCEL PICKER DATE
    @objc func canclePickerDate ()
    {
        self.view.endEditing(true)
        txt_BirthDate.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        var dateString : String!
//        dateString = UserDefaults.standard.object(forKey: "selDate") as? String ?? ""
//
//        self.txt_BirthDate.text = dateString
        
        self.navigationController?.navigationBar.isHidden = true
        if Reachability.isConnectedToNetwork()
        {
            isAuthorizedLocation()
        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
       
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
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }
 
    @objc fileprivate func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btn_Individul_Action(_ sender: UIButton) {
        //self.myArray = [Any]()
        //self.typeArray = [String]()
         checkUserType = "3"
        if myArray.isEmpty == true || typeArray.isEmpty == true{
            self.docsViewHeightConstraint.constant = 50
            print("There are no objects!")
        }else{
            self.docsViewHeightConstraint.constant = 172
            print("There are objects!")
        }
       // self.docsViewHeightConstraint.constant = 172
        self.custom_View_HightConstain.constant = 230
        self.company_Custom_View_hightConstain.constant = 0
        //self.custombackView.backgroundColor = UIColor.clear
        //self.commonBackView.backgroundColor = UIColor.clear
        
        self.genderStaticLabel.isHidden = false
        self.idStaticLabel.isHidden = false
        self.birthDateStaticLabel.isHidden = false
        
        self.txt_Gender.isHidden = false
        
        self.companyNumberStaticLabel.isHidden = true
        
        self.btn_Company.setImage(UIImage(named: "UnCheck"), for: .normal)
        self.btn_Individual.setImage(UIImage(named: "check"), for: .normal)
        self.nameStaticLabel.text = languageChangeString(a_str:"Name")
        self.txt_Name.placeholder = languageChangeString(a_str:"Name")
        self.lbl_CertificateUpload.text = languageChangeString(a_str: "Certification Documents")
//        self.statusBackViewHeightConstarint.constant = 0
//        self.statusDocLabel.isHidden = true
    }
    
    @IBAction func btn_Company_Action(_ sender: UIButton) {
        //self.myArray = [Any]()
        //self.typeArray = [String]()
         checkUserType = "4"
        if myArray.isEmpty == true || typeArray.isEmpty == true{
            self.docsViewHeightConstraint.constant = 50
            print("There are no objects!")
        }else{
            self.docsViewHeightConstraint.constant = 172
            print("There are objects!")
        }
        //self.docsViewHeightConstraint.constant = 172
        self.btn_Company.setImage(UIImage(named: "check"), for: .normal)
        self.btn_Individual.setImage(UIImage(named: "UnCheck"), for: .normal)
        
        self.genderStaticLabel.isHidden = true
        self.idStaticLabel.isHidden = true
        self.birthDateStaticLabel.isHidden = true
        
        self.txt_Gender.isHidden = true
        
       // self.commonBackView.backgroundColor = UIColor.clear
        
        //self.custombackView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.custom_View_HightConstain.constant = 0
        self.company_Custom_View_hightConstain.constant = 80
        
        self.companyNumberStaticLabel.isHidden = false
        self.txt_CompanyNumber.isHidden = false
        
        txt_CompanyNumber.placeholder = languageChangeString(a_str:"Company number")
        companyNumberStaticLabel.text = languageChangeString(a_str:"Company number")
        self.nameStaticLabel.text = languageChangeString(a_str:"Company name")
        self.txt_Name.placeholder = languageChangeString(a_str:"Company name")
        self.lbl_CertificateUpload.text = languageChangeString(a_str: "Upload Documents")
//        self.statusBackViewHeightConstarint.constant = 0
//        self.statusDocLabel.isHidden = true

    }
    @IBAction func btn_Back_Action(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
       
    }
    
    @IBAction func btn_AlreadySignIn_Action(_ sender: UIButton) {
    }
    
    
    @IBAction func hijriCalenderAction(_ sender: Any) {
        
        
       /* for calender let CalenderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
        UserDefaults.standard.set("toDate", forKey: "fromTo")
        self.present(CalenderVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(CalenderVC, animated: false)
        */
   
        
    }
    
    
    @IBAction func btn_SignUp_Action(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() {
            
            spSignUpServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
    }
    @IBAction func btn_TermsAndCondition_Action(_ sender: UIButton) {
        
        let TermsConditionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsConditionsVC") as! TermsConditionsVC
        TermsConditionsVC.checkStr = "terms"
        self.navigationController?.pushViewController(TermsConditionsVC, animated: false)
    }
    
    @IBAction func btn_Location_Expend_Action(_ sender: UIButton) {
        
              
//        @objc func buttonClicked(_sender:UIButton){
//
//            let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
//            let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
//            let cell = self.tableView.cellForRow(at: indexPath) as! UITableViewCell
//            print(cell.itemLabel.text)//print or get item
//        }
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpSetLocationVC") as! SpSetLocationVC
        self.present(gotoVC, animated: true, completion: nil)
        
        let locationdict : [String:String] = ["lat":latitudeString,"lang":longitudeString,"address":self.addressTV.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showUpdatedValueOnMap"), object: nil, userInfo: locationdict)
        
        //self.navigationController?.pushViewController(gotoVC, animated: true)
    }
    
    
    @IBAction func showCurrentLocationAction(_ sender: Any) {
        latitudeString = ""
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
    }
    @IBAction func checkTermAction(_ sender: Any) {
        if checkTerms == false{
            self.checkTermBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
            checkTerms = true
            checkTermStr = "1"
        }
        else{
            self.checkTermBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
            checkTerms = false
            checkTermStr = "0"
        }
        
    }
    
    
    @IBAction func uploadBtnDocumentsAction(_ sender: Any) {
        
       /*
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        documentPicker.delegate = self
//        if #available(iOS 11.0, *) {
//            documentPicker.allowsMultipleSelection = true
//        } else {
//            // Fallback on earlier versions
//        }
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)*/
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: languageChangeString(a_str: "Gallery"), style: .default) { action -> Void in
            
            //self.attachPickerCheckValue = 1
            self.sendingImgPicker.allowsEditing = false
            self.sendingImgPicker.sourceType = .photoLibrary
            self.sendingImgPicker.delegate = self
            self.sendingImgPicker.mediaTypes = ["public.image"]
            self.present(self.sendingImgPicker, animated: true, completion: nil)
            
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "iCloudDrive", style: .default) { action -> Void in
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
            documentPicker.delegate = self
            //        if #available(iOS 11.0, *) {
            //            documentPicker.allowsMultipleSelection = true
            //        } else {
            //            // Fallback on earlier versions
            //        }
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true)
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { action -> Void in }
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
        
    }
    @IBAction func uploadDocumentsAction(_ sender: Any) {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        documentPicker.delegate = self
        //documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        print("my required url is \(url)")
        mediaTypeString = ""
        pdfUrl = url
        let path = URL(fileURLWithPath: url.lastPathComponent).pathExtension
        // let name = URl(fileURLWithPath: url.firstPath).pathExtension
        docFileExtension = "\(path)"
        print("File Extension :",docFileExtension!)
        typeArray.append(docFileExtension)
        //changed the below line
        //let pdfData = try! Data(contentsOf: pdfUrl)
        let pdfData = try! Data(contentsOf: pdfUrl.asURL())
      // commented  let DocumentData : Data = pdfData
        docFileData = pdfData
        print("File Data===== : \(String(describing: docFileData))")
         print("pdfData===== : \(pdfData)")
        
        self.myArray.append(pdfUrl!)
        print("doccount1\(myArray.count)")
        print("uploaded successfully")
       // self.statusBackViewHeightConstarint.constant = 50
        self.docsViewHeightConstraint.constant = 172
       // docsCollectionView.reloadData()
        DispatchQueue.main.async {
            self.docsCollectionView.reloadData()
        }
//        self.statusDocLabel.isHidden = false
//        if self.myArray.count > 1{
//            self.statusDocLabel.text = String(format: "%d %@", self.myArray.count, "Documents uploaded successfully")
//        }else{
//            self.statusDocLabel.text = String(format: "%d %@", self.myArray.count, "Document uploaded successfully")
//        }
        
        print(self.myArray as Any)
        print("myarray===== : \(myArray)")
        
    }
    
    //PICKERVIEW CREATION
    
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
        pickerToolBar?.barTintColor = #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1)
        
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
        self.txt_Gender.inputView = self.pickerView
        self.txt_Gender.inputAccessoryView = self.pickerToolBar
        
        self.pickerView?.reloadInputViews()
        self.pickerView?.reloadAllComponents()
     
    }
    
    @objc func donePickerView(){
        
        self.txt_Gender.text = genderArray[0]
        genderIdString = genderIdArray[(pickerView?.selectedRow(inComponent: 0))!]
                if genderString.count > 0 {
                    self.txt_Gender.text = self.genderString ?? ""
                }else{
                    self.txt_Gender.text = genderArray[0]
                }
                self.view.endEditing(true)
        txt_Gender.resignFirstResponder()
    }
    
    @objc func cancelPickerView(){
                if (txt_Gender.text?.count)! > 0 {
                    self.view.endEditing(true)
                    txt_Gender.resignFirstResponder()
                }else{
                    self.view.endEditing(true)
                    txt_Gender.text = ""
                    txt_Gender.resignFirstResponder()
                }
        txt_Gender.resignFirstResponder()
    }
    
    
    @IBAction func createPwdShowHideAction(_ sender: Any) {
        if createPwdBtn.tag == 1 {
            txt_CreatePassword.isSecureTextEntry = false
            createPwdBtn.setImage(UIImage.init(named: "View_2"), for: UIControl.State.normal)
            createPwdBtn.tag = 2
        }
        else{
            txt_CreatePassword.isSecureTextEntry = true
            createPwdBtn.setImage(UIImage.init(named: "View_1"), for: UIControl.State.normal)
            createPwdBtn.tag = 1
        }
    }
    
    @IBAction func confirmPwdShowHideAction(_ sender: Any) {
        if confirmPwdBtn.tag == 1 {
            txt_ConfirmPassword.isSecureTextEntry = false
            confirmPwdBtn.setImage(UIImage.init(named: "View_2"), for: UIControl.State.normal)
            confirmPwdBtn.tag = 2
        }
        else{
            txt_ConfirmPassword.isSecureTextEntry = true
            confirmPwdBtn.setImage(UIImage.init(named: "View_1"), for: UIControl.State.normal)
            confirmPwdBtn.tag = 1
        }
    }
    
    //for map
    
    func wrapperFunctionToShowPosition(mapView:GMSMapView){
        let geocoder = GMSGeocoder()
        
        let latitud = mapView.camera.target.latitude
        let longitud = mapView.camera.target.longitude
        
        // let latitude = String(format: "%.8f", mapView.camera.target.latitude)
        //let longitude = String(format: "%.8f", mapView.camera.target.longitude)
        self.latitudeString = String(format: "%.8f", mapView.camera.target.latitude)
        self.longitudeString = String(format: "%.8f", mapView.camera.target.longitude)
        let position = CLLocationCoordinate2DMake( latitud, longitud)
        
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                // print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                guard let result = response?.results()?.first else{
                    return
                }
                print("adress of that location is \(result)")
                self.addressStr = result.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                // self.landMarkStr = result?.subLocality
                // self.cityStr = result?.locality
                
                print("Address Str Is :\(self.addressStr ?? "")")
                //print("LandMark Str Str Is :\(self.landMarkStr ?? "")")
                DispatchQueue.main.async {
                    self.addressTV.text = self.addressStr
                }
            }
        }
        
    }
    
    //mapview delegate methods
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("didchange")
        //called everytime
        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
        wrapperFunctionToShowPosition(mapView: mapView)
    }
    
    //MARK:DID UPDATE LOCATIONS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate location")
        
        if latitudeString == ""{
             print("latitudeString is empty")
            let userLocation:CLLocation = locations[0] as CLLocation
            self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
             let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
             let position = CLLocationCoordinate2D(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)
            print(position)
            DispatchQueue.main.async {
                
                self.mapView.camera = camera
                self.mapView.delegate = self
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.locationManager.stopUpdatingLocation()
            }
           // self.mapView?.animate(to: camera)
           
        }
        else{
            print("latitudeString is not empty")
            let latitud = Double(self.latitudeString ?? "") ?? 0.0
            let longitud = Double(self.longitudeString ?? "") ?? 0.0
            let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude:longitud, zoom: 15)
             let position = CLLocationCoordinate2D(latitude:  latitud, longitude: longitud)
              print(position)
            DispatchQueue.main.async {
                
                self.mapView.camera = camera
                self.mapView.delegate = self
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.locationManager.stopUpdatingLocation()
            }
            //self.mapView?.animate(to: camera)
            
        }
    
        manager.stopUpdatingLocation()
    }
    
    //SP SIGNUP SERVICECALL
    func spSignUpServiceCall()
    {
     
        /*
         API-KEY:9173645
         lang:en
         user_type:(3=individual,4=company)
         name: (provider name/ company name)
         gender:(male/female) for individual only
         email:
         phone:
         password:
         confirm_password:
         agree_tc:1=checked,0=not checked
         id_proof: (provider ID/ company number)
         dob: (YYYY-MM-DD) for individual only
         address:
         latitude:
         longitude:
         device_name: (android/ios)
         device_token:
         document[]:(multiple files array)*/
        //let signup = "\(Base_Url)provider_registration"
         MobileFixServices.sharedInstance.loader(view: self.view)
        let deviceToken = UserDefaults.standard.object(forKey: "deviceToken") as! String
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let countrywithPhoneNumberStr = String(format: "%@%@", self.countryCodeTF.text!,self.txt_PhoneNumber.text!)
        //self.txt_Gender.text!
        if checkUserType == "3"{
            self.parameters = [ "user_type" : "3","name" : self.txt_Name.text!,  "gender" : genderIdString!,"email":self.txt_Email.text! ,"phone" : countrywithPhoneNumberStr,"password" : self.txt_CreatePassword.text! , "confirm_password" : self.txt_ConfirmPassword.text! ,"agree_tc" : self.checkTermStr!,"id_proof" : txt_ID.text!,"dob" : txt_BirthDate.text!,"address" : addressTV.text!,"latitude" : latitudeString!,"longitude" : longitudeString!, "device_name" : "ios" , "device_token" : deviceToken , "lang" : language,"API-KEY":APIKEY]
        }
        else if checkUserType == "4"{
             self.parameters = [ "user_type" : "4","name" : self.txt_Name.text!,  "gender" : "","email":self.txt_Email.text! ,"phone" : countrywithPhoneNumberStr,"password" : self.txt_CreatePassword.text! , "confirm_password" : self.txt_ConfirmPassword.text! ,"agree_tc" : self.checkTermStr!,"id_proof" : txt_CompanyNumber.text!,"dob" : "","address" : addressTV.text!,"latitude" : latitudeString!,"longitude" : longitudeString!, "device_name" : "ios" , "device_token" : deviceToken , "lang" : language,"API-KEY":APIKEY]
        }
//        let parameters: Dictionary<String, Any> = [ "user_type" : "3","name" : self.txt_Name.text!,  "gender" : self.txt_Gender.text!,"email":self.txt_Email.text! ,"phone" : self.txt_PhoneNumber.text!,"password" : self.txt_CreatePassword.text! , "confirm_password" : self.txt_ConfirmPassword.text! ,"agree_tc" : "1","id_proof" : txt_ID.text!,"dob" : txt_BirthDate.text!,"address" : addressTV.text!,"latitude" : latitudeString!,"longitude" : longitudeString!, "device_name" : "ios" , "device_token" : deviceToken , "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)

        if docFileExtension == "doc"{
            self.fileNameStr = "file.doc"
            self.mimeTypeStr = "application/doc"
        }else if docFileExtension == "pdf"{
            self.fileNameStr = "file1.pdf"
            self.mimeTypeStr = "application/pdf"
        }else if docFileExtension == "JPG"{
            self.fileNameStr = "file2.JPG"
            self.mimeTypeStr = "application/JPG"
        }else if docFileExtension == "txt"{
            self.fileNameStr = "file3.txt"
            self.mimeTypeStr = "application/txt"
        }
        else if docFileExtension == "PNG"{
            self.fileNameStr = "file4.PNG"
            self.mimeTypeStr = "application/PNG"
        }
//        else{
//            self.fileNameStr = "file.docx"
//            self.mimeTypeStr = "application/docx"
//        }

        
        Alamofire.upload(multipartFormData: { multipartFormData in
   
            if self.mediaTypeString == "fromgallery"{
                for i in 0..<self.myArray.count {
                    
                    let imageData = self.pickedImage.jpegData(compressionQuality: 0.2)!
                        //UIImageJPEGRepresentation(self.myArray[i] as! UIImage, 0.2)!
                    
                    multipartFormData.append(imageData , withName: "document[]", fileName: "file5.jpg", mimeType: "image/jpeg")
                    
                    print(imageData as Any)
                }
                for (key, value) in self.parameters {
                    
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            else{
            for i in 0..<self.myArray.count {
                
               guard let storeUrl = self.myArray[i] as? URL
                else {
                    return
                    }
               
                    guard let storeUrlData = try? Data(contentsOf: storeUrl)
                        else{
                            return
                }
                
                multipartFormData.append(storeUrlData, withName: "document[]",fileName: self.fileNameStr!, mimeType: self.mimeTypeStr)
                
            }
            for (key, value) in self.parameters {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            }
            print(self.parameters)
            /*today      multipartFormData.append(self.docFileData , withName: "document[]", fileName: self.fileNameStr!, mimeType: self.mimeTypeStr!)
             
             
             for (key, value) in parameters {
             
             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }
             
             print(parameters)
             
             },
             to:"\(Base_Url)provider_registration")*/
        
            
        },
        to:"\(Base_Url)provider_registration"){ (result) in
            
            print(result)
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print(response.result.value ?? "")
                    
                    guard let responseData = response.result.value as? Dictionary<String, Any> else{
                        return
                    }
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        if let userDetailsData = responseData["provider_details"] as? Dictionary<String, AnyObject> {
                            
                            let providerName = userDetailsData["username"] as? String?
                            let providerEmail = userDetailsData["email"] as? String?
                            let providerImg = userDetailsData["profile_pic"] as? String?
                            
                            UserDefaults.standard.set(self.txt_ConfirmPassword.text!, forKey: "password")
                            UserDefaults.standard.set(self.txt_CreatePassword.text!, forKey: "password")
                            // let userImg = userDetailsData["image"] as? String?
                            //let userId = userDetailsData["user_id"] as? Int?
                            
                            // let userImage = String(format: "%@%@",base_path,userImg!!)
                            
                            let spid : String = userDetailsData["user_id"] as! String
                            let auth_level : String = userDetailsData["auth_level"] as! String
                            
                            // commentedlet x : Int = userDetailsData["user_id"] as! Int
                            // commented let xNSNumber = x as NSNumber
                            //let xString : String = xNSNumber.stringValue
                            
                            //user_image
                            let proImage = String(format: "%@%@",base_path,providerImg!!)
                            
                            UserDefaults.standard.set(providerName as Any, forKey: "userName")
                            UserDefaults.standard.set(providerEmail as Any, forKey: "userEmail")
                            UserDefaults.standard.set(spid as Any, forKey: "spId")
                            UserDefaults.standard.set(proImage as Any, forKey: "userImage")
                            UserDefaults.standard.set(auth_level as Any, forKey: "auth_level")
                       
                        }
                     
                        DispatchQueue.main.async {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            let verifyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyVC") as! VerifyVC
                            self.navigationController?.pushViewController(verifyVC, animated: false)
                            //self.showToast(message: message)
                        }
                    }
                    else
                    {
                        self.showToast(message: message)
                        MobileFixServices.sharedInstance.dissMissLoader()
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                MobileFixServices.sharedInstance.dissMissLoader()
            }
        }
     
    }
 
}



extension SpSignupVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        // Row count: rows equals array length.
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                    self.txt_Gender.text = genderArray[row]
                    self.genderString = genderArray[row]
                    genderIdString = genderIdArray[row]
    }
}


extension SpSignupVC : UITextFieldDelegate {
    
    //    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
    //                   replacementString string: String) -> Bool //swift 3
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
       // if textField == self.txt_PhoneNumber{
            
            let phoneNumberlength = 10
            let totalString = "\(self.txt_PhoneNumber.text)\(string)"
            var prefix : String! = ""
            if textField == self.self.txt_PhoneNumber{
                if textField == self.self.txt_PhoneNumber && range.location == 0{
                    if (!string.hasPrefix(phoneNumberStart!)){
                        return false
                    }
                    
                }
                else if textField == self.self.txt_PhoneNumber && range.location == 1{
                    if (!string.hasPrefix(phoneNumber1Start!)){
                        return false
                    }
                    //                else{return true}
                }
                else{
                    newLength = (textField.text?.count)! + string.count - range.length
                    return newLength! <= phoneNumberlength
                }
                if totalString.count == 1{
                    
                }
                //            if totalString.count >= 1{
                //                prefix = (totalString as? NSString)?.substring(to: 1)
                //                print("first letter \(prefix)")
                //                if (prefix == "5") {
                //
                //                    //phoneNumber_TF.text = totalString.replacingOccurrences(of: totalString, with: "+9665")
                //                }
                //
                //            else{
                //                newLength = (textField.text?.count)! + string.count - range.length
                //
                //                return newLength! <= phoneNumberlength
                //                    //return true
                //            }
                //            }
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let expression = "^([0-9]+)?(\\.([0-9]{1,2})?)?$"
                var regex: NSRegularExpression? = nil
                do {
                    regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
                } catch {
                }
                let numberOfMatches: NSInteger = (regex?.numberOfMatches(in: newString, options: [], range: NSMakeRange(0, newString.count)))!
                if(range.length + range.location > (textField.text?.count)!)
                {
                    return false
                }
                if numberOfMatches == 0{
                    return false
                }
                newLength = (textField.text?.count)! + string.count - range.length
                return newLength! <= phoneNumberlength
                
            }
            
//            let maxLength = 10
//            let currentString: NSString = textField.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
     //   }
        else if textField == self.txt_ID{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
}

extension SpSignupVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
         //docFileExtension = "png"
      //  docFileData = info[UIImagePickerController.InfoKey.originalImage] as! Data
//        self.myArray.append(pdfUrl!)
//        print(self.myArray as Any)
        typeArray.append("jpg")
//        let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
//        if (assetPath.absoluteString?.hasSuffix("JPG"))! {
//            typeArray.append("jpg")
//            print("JPG")
//        }
//        else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
//            typeArray.append("png")
//            print("PNG")
//        }
//
//        else {
//            print("Unknown")
//        }
        
        
        mediaTypeString = "fromgallery"
        let pickedImage2 = info[UIImagePickerController.InfoKey.originalImage]
        pickedImage = pickedImage2 as! UIImage
        print("png pickedImage2 \(String(describing: pickedImage2))")
        print("png pickedImage \(pickedImage)")
        
        self.myArray.append(pickedImage)
    
        print(self.myArray as Any)
        print("myarray===== : \(myArray)")
        print("doccount\(myArray.count)")
        print("uploaded successfully")
        //let docCount = self.myArray.count
        
        dismiss(animated:true, completion: nil)
        
        self.docsViewHeightConstraint.constant = 172
        DispatchQueue.main.async {
             self.docsCollectionView.reloadData()
        }
       
   
        
        //self.statusBackViewHeightConstarint.constant = 50
//        self.statusDocLabel.isHidden = false
//        if self.myArray.count > 1{
//            self.statusDocLabel.text = String(format: "%d %@", self.myArray.count, languageChangeString(a_str: "Documents uploaded successfully")!)
//        }else{
//        self.statusDocLabel.text = String(format: "%d %@", self.myArray.count, languageChangeString(a_str: "Document uploaded successfully")!)
//        }
       // self.showToastForAlert(message: languageChangeString(a_str: "Document uploaded successfully")!)
        }
    
}


extension SpSignupVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = docsCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell
        //docx pdf doc
        if typeArray[indexPath.item] == "jpg"{
        //|| typeArray[indexPath.item] == "png" || typeArray[indexPath.item] == "tif"{
            cell.uploadDocImageView.image = self.myArray[indexPath.item] as? UIImage
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(deleteClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
       else if typeArray[indexPath.item] == "docx" || typeArray[indexPath.item] == "doc"{
            cell.uploadDocImageView.image = UIImage.init(named: "docxImage")
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(deleteClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
       else if typeArray[indexPath.item] == "pdf"{
            cell.uploadDocImageView.image = UIImage.init(named: "pdfImage")
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(deleteClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
        return cell
    }
    
    @objc func deleteClicked(sender:UIButton){
        
        self.myArray.remove(at: sender.tag)
        self.typeArray.remove(at: sender.tag)
        print("myArraycount\(myArray.count)")
       
        DispatchQueue.main.async {
            self.docsCollectionView.reloadData()
        }
        print("myArray\(myArray)")
        print("typeArray\(typeArray)")
        if myArray.isEmpty == true || typeArray.isEmpty == true{
            self.docsViewHeightConstraint.constant = 50
            print("There are no objects!")
        }else{
            self.docsViewHeightConstraint.constant = 172
            print("There are objects!")
        }
    }
    
  
    
}

