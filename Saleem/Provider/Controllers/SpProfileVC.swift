//
//  SpProfileVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 24/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import MOLH

class SpProfileVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate,UIDocumentMenuDelegate ,UIDocumentPickerDelegate {

    @IBOutlet var checkBtnNew: UIButton!
    @IBOutlet var checkImageView: UIImageView!
    var genderStrValue: String?
    @IBOutlet var checkOrderBtn: UIButton!
    
    var request_typeStr : String?
    
    var checkTerms : Bool!
    var checkTermStr : String! = ""
    
    @IBOutlet var nameStaticLabel: UILabel!
    @IBOutlet var genderStaticLabel: UILabel!
    @IBOutlet var idStaticLabel: UILabel!
    @IBOutlet var birthDateStaticLabel: UILabel!
    @IBOutlet var emailStaticLabel: UILabel!
    @IBOutlet var phoneNumberStaticLabel: UILabel!
    
    @IBOutlet var changepwdStaticlLabel: UILabel!
    @IBOutlet var passwordStaticLabel: UILabel!
    @IBOutlet var confirmPwdStaticLabel: UILabel!
    
    @IBOutlet var certificationDocStaticLabel: UILabel!
    
    @IBOutlet var yourServiceLocationStaticLabel: UILabel!
    
    @IBOutlet var chooseYourSerLocationStaticLabel: UILabel!
    //foe cell selection
    var saveBool : Bool!
    var tagsCheckArray = [String]()
    var IdString : String!
    var idArray = [String]()
    var checkArr = [String]()
    
    var parameters = [String: String]()
    var documentList : [[String: Any]]!
    
    var documentNamesArray = [String]()
    var document_idarray = [String]()
    var doc_typeArray = [String]()
    var docType : String!
    
    //for document upload
    var docFileExtension : String!
    var docFileData : Data!
    var pdfUrl : URL!
    var fileNameStr : String! = ""
    var mimeTypeStr : String! = ""
    
    //commented today  var myArray: [Any] = []
    var myArray: [Any] = []
    
    
    @IBOutlet var locationTextView: UITextView!
    
    @IBOutlet var uploadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var uploadDocBtn: UIButton!
    @IBOutlet var uploadDocLabel: UILabel!
    @IBOutlet var documentCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var noDocumentsLabel: UILabel!
    @IBOutlet var documentCollectionView: UICollectionView!
    
    @IBOutlet var serviceLocationLabel: UILabel!
    @IBOutlet var providerNameLabel: UILabel!
    
    var pickerImage  = UIImage()
    var pickerImage1  = UIImage()
    var pickedImage  = UIImage()
    
    var imagePicker = UIImagePickerController()
    @IBOutlet var profilePicBtn: UIButton!
    
    @IBOutlet var documnetHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var changePassword_View: UIView!
    @IBOutlet weak var custom_ScrollView: UIScrollView!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var txt_Name: UITextField!
    
    @IBOutlet var providerImageView: UIImageView!
    @IBOutlet var choseLocationView_hightConstain: NSLayoutConstraint!
    @IBOutlet var chooseLocatioHeight: NSLayoutConstraint!
    
    
    @IBOutlet var chooseLocationView: UIView!
    
    
    //@IBOutlet weak var choseLocationView_hightConstain: NSLayoutConstraint!
    @IBOutlet weak var img_checkBox: UIImageView!
    
    @IBOutlet weak var choseLocationService_View: UIView!
    @IBOutlet weak var yourServiceLocation_highthConstrain: NSLayoutConstraint!
    @IBOutlet weak var txt_DateOfBirth: UITextField!
    @IBOutlet weak var txt_Gender: UITextField!
    
    @IBOutlet weak var txt_Email: UITextField!
    
    @IBOutlet weak var txt_ID: UITextField!
    
    @IBOutlet var txt_Location: UITextView!
  //  @IBOutlet weak var txt_Location: UITextField!
    @IBOutlet weak var txt_PhoneNumber: UITextField!
    
    @IBOutlet weak var txt_ConformPassword: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    var checkValue :Int!
    
    //for map
    
    @IBOutlet var myLocationBtn: UIButton!
    @IBOutlet var expandBtn: UIButton!
    @IBOutlet var locationNewBtn: UIButton!
    
    @IBOutlet var mapView: GMSMapView!
    
    var streetAddress : String! = ""
    var addressStr : String! = ""
    var latitudeString : String! = ""
    var longitudeString : String! = ""
   
    
    var currentLocation:CLLocationCoordinate2D!
    
    lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTerms = false
        self.mapView.delegate = self
        
        self.nameStaticLabel.text = languageChangeString(a_str: "Name")
        self.genderStaticLabel.text = languageChangeString(a_str: "Gender")
        self.idStaticLabel.text = languageChangeString(a_str: "ID")
        self.birthDateStaticLabel.text = languageChangeString(a_str: "Birth date")
        self.emailStaticLabel.text = languageChangeString(a_str: "Email")
        self.phoneNumberStaticLabel.text = languageChangeString(a_str: "Phone number")
        
        self.changepwdStaticlLabel.text = languageChangeString(a_str: "Change Password")
        self.passwordStaticLabel.text = languageChangeString(a_str: "Password")
        self.confirmPwdStaticLabel.text = languageChangeString(a_str: "Confirm password")
        
        self.certificationDocStaticLabel.text = languageChangeString(a_str: "Certification Documents")
        self.noDocumentsLabel.text = languageChangeString(a_str: "no documents")
        self.uploadDocLabel.text = languageChangeString(a_str: "Upload Documents")
        self.yourServiceLocationStaticLabel.text = languageChangeString(a_str: "Your service location")
        self.chooseYourSerLocationStaticLabel.text = languageChangeString(a_str: "Choose your service location")
        
        if MOLHLanguage.isRTLLanguage(){
            self.txt_Email.textAlignment = .right
            self.txt_Password.textAlignment = .right
            self.txt_ConformPassword.textAlignment = .right
            self.txt_Location.textAlignment = .right
            self.locationTextView.textAlignment = .right
            self.txt_Gender.textAlignment = .right
            txt_PhoneNumber.textAlignment = .right
        }
        else{
            self.txt_Email.textAlignment = .left
            self.txt_Password.textAlignment = .left
            self.txt_ConformPassword.textAlignment = .left
            self.txt_Location.textAlignment = .left
            self.locationTextView.textAlignment = .left
            self.txt_Gender.textAlignment = .left
            txt_PhoneNumber.textAlignment = .left
        }
        
//        let barButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
//                                            style: .plain,
//                                            target: self,
//                                            action: #selector(backButtonTapped))
//
        let barButtonItem1 = UIBarButtonItem(title: languageChangeString(a_str: "Edit"), style: .plain, target: self, action: #selector(backButtonTapped1))
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(showLeftView(sender:)), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        //navigationController?.navigationBar.barTintColor = UIColor.init(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
//        self.navigationItem.leftBarButtonItem = barButtonItem
//        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
        self.navigationItem.rightBarButtonItem = barButtonItem1
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationItem.title = languageChangeString(a_str: "My Profile")
        if Reachability.isConnectedToNetwork() {
            
            SPgetProfileDetailsServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocation(_:)), name: NSNotification.Name(rawValue: "getLocation"), object: nil)
      
        
        imagePicker.delegate = self
        providerImageView.layer.cornerRadius = providerImageView.frame.size.height/2
        providerImageView.clipsToBounds = true
        
        self.profilePicBtn.isEnabled = false
        //self.documentCollectionView.isUserInteractionEnabled = false
        
        self.txt_ID.setBottomLineBorderColor()
        self.txt_Name.setBottomLineBorderColor()
        self.txt_Gender.setBottomLineBorderColor()
        self.txt_Email.setBottomLineBorderColor()
        self.txt_DateOfBirth.setBottomLineBorderColor()
        self.txt_PhoneNumber.setBottomLineBorderColor()
        self.txt_Password.setBottomLineBorderColor()
        self.txt_ConformPassword.setBottomLineBorderColor()
       // self.img_checkBox.isHidden = true
        self.uploadDocLabel.isHidden = true
        self.uploadDocBtn.isHidden = true
        self.uploadViewHeightConstraint.constant = 0
        
        self.choseLocationView_hightConstain.constant = 0
        self.chooseLocatioHeight.constant = 0
        self.chooseLocationView.isHidden = true
        
        self.mapView.isHidden = true
        self.locationNewBtn.isHidden = true
        self.myLocationBtn.isHidden = true
        self.expandBtn.isHidden = true
        
        self.txt_Location.isHidden = true
        self.btn_Delete.isHidden = true
       //commented self.documnetHeightConstarint.constant = 170
       
        checkValue = 1
       
        self.txt_Name.isUserInteractionEnabled = false
        self.txt_Email.isUserInteractionEnabled = false
        self.txt_Gender.isUserInteractionEnabled = false
        self.txt_ID.isUserInteractionEnabled = false
        self.txt_DateOfBirth.isUserInteractionEnabled = false
        self.txt_PhoneNumber.isUserInteractionEnabled = false
        
        self.txt_Password.isUserInteractionEnabled = false
        self.txt_ConformPassword.isUserInteractionEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
    }
    
    func isAuthorizedtoGetUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse  {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    @objc fileprivate func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
 
    @objc func getLocation(_ notification: NSNotification){
        
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["key"] as? String
            longitudeString = dict["key1"] as? String
            addressStr = dict["key2"] as? String
            print("latitudeString",latitudeString)
            print("longitudeString",longitudeString)
            print("addStr",addressStr)
        }
        
        self.txt_Location.text = addressStr
        
    }
    @objc fileprivate func backButtonTapped1() {
        
       // self.navigationController?.popViewController(animated: true)
        print("Tapped")
        if checkValue == 1{
        self.navigationItem.rightBarButtonItem?.title = languageChangeString(a_str: "Save")
        
        self.txt_ID.setBottomLineBorder()
        self.txt_Name.setBottomLineBorder()
        self.txt_Gender.setBottomLineBorder()
        self.txt_Email.setBottomLineBorder()
        self.txt_DateOfBirth.setBottomLineBorder()
        self.txt_PhoneNumber.setBottomLineBorder()
        self.txt_Password.setBottomLineBorder()
        self.txt_ConformPassword.setBottomLineBorder()
        // commenyed self.txt_Location.setBottomLineBorder()
        self.yourServiceLocation_highthConstrain.constant = 0
        //self.img_checkBox.isHidden = false
        self.uploadDocLabel.isHidden = false
        self.uploadDocBtn.isHidden = false
        self.uploadViewHeightConstraint.constant = 42
            
        self.profilePicBtn.isEnabled = true
        //self.documentCollectionView.isUserInteractionEnabled = true
       // self.choseLocationService_View.isHidden = false
        self.choseLocationView_hightConstain.constant = 207
        self.chooseLocatioHeight.constant = 115
        self.chooseLocationView.isHidden = false
            
        self.mapView.isHidden = false
        self.locationNewBtn.isHidden = false
        self.myLocationBtn.isHidden = false
        self.expandBtn.isHidden = false
            
            if MOLHLanguage.isRTLLanguage(){
                self.btn_Delete.titleEdgeInsets.right = 20
                self.btn_Delete.imageEdgeInsets.right = -20
                self.btn_Delete.setTitle(languageChangeString(a_str: "DELETE"), for: UIControl.State.normal)
            }else{
                self.btn_Delete.titleEdgeInsets.left = 20
                self.btn_Delete.imageEdgeInsets.left = -20
                self.btn_Delete.setTitle(languageChangeString(a_str: "DELETE"), for: UIControl.State.normal)
            }
       
        self.txt_Location.isHidden = false
        self.btn_Delete.isHidden = false
            
        self.txt_Name.isUserInteractionEnabled = true
        self.txt_Email.isUserInteractionEnabled = true
        self.txt_Gender.isUserInteractionEnabled = false
        self.txt_ID.isUserInteractionEnabled = true
        self.txt_DateOfBirth.isUserInteractionEnabled = false
        self.txt_PhoneNumber.isUserInteractionEnabled = true
            
        self.txt_Password.isUserInteractionEnabled = true
        self.txt_ConformPassword.isUserInteractionEnabled = true
            
        checkValue = 2
        
      // commented today for check mark selection
        self.documentCollectionView.reloadData()
        self.custom_ScrollView.contentOffset = CGPoint(x: 0, y: 0)
       // self.documnetHeightConstarint.constant = 240
        
        }
        else{
            
            self.txt_ID.setBottomLineBorderColor()
            self.txt_Name.setBottomLineBorderColor()
            self.txt_Gender.setBottomLineBorderColor()
            self.txt_Email.setBottomLineBorderColor()
            self.txt_DateOfBirth.setBottomLineBorderColor()
            self.txt_PhoneNumber.setBottomLineBorderColor()
            self.txt_Password.setBottomLineBorderColor()
            self.txt_ConformPassword.setBottomLineBorderColor()
            //self.img_checkBox.isHidden = true
            
            self.uploadDocLabel.isHidden = true
            self.uploadDocBtn.isHidden = true
            self.uploadViewHeightConstraint.constant = 0
            
            self.choseLocationView_hightConstain.constant = 0
            self.yourServiceLocation_highthConstrain.constant = 120
            
            self.txt_Name.isUserInteractionEnabled = false
            self.txt_Email.isUserInteractionEnabled = false
            self.txt_Gender.isUserInteractionEnabled = false
            self.txt_ID.isUserInteractionEnabled = false
            self.txt_DateOfBirth.isUserInteractionEnabled = false
            self.txt_PhoneNumber.isUserInteractionEnabled = false
            
            self.txt_Password.isUserInteractionEnabled = false
            self.txt_ConformPassword.isUserInteractionEnabled = false
            
            self.profilePicBtn.isEnabled = false
          //  self.documentCollectionView.isUserInteractionEnabled = false
            self.mapView.isHidden = true
            self.locationNewBtn.isHidden = true
            self.myLocationBtn.isHidden = true
            self.expandBtn.isHidden = true
            
            self.chooseLocatioHeight.constant = 0
            self.chooseLocationView.isHidden = true
            
            self.txt_Location.isHidden = true
            self.btn_Delete.isHidden = true
            self.navigationItem.rightBarButtonItem?.title = languageChangeString(a_str: "Edit")
            checkValue = 1
            
            //self.documnetHeightConstarint.constant = 170
            if Reachability.isConnectedToNetwork() {
                
                SPeditProfileServiceCall()
            }else
            {
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                // showToastForAlert (message:"Please ensure you have proper internet connection.")
            }
            
            
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
                    self.txt_Location.text = self.addressStr
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
      /*  print("didupdate location")
        let userLocation:CLLocation = locations[0] as CLLocation
        self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
        
        let position = CLLocationCoordinate2D(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)
        print(position)
        
        // self.setupLocationMarker(coordinate: position)
        
        DispatchQueue.main.async {
            
            self.mapView.camera = camera
        }
        self.mapView?.animate(to: camera)
        manager.stopUpdatingLocation()*/
        
        if latitudeString == ""{
            print("latitudeString is empty")
            let userLocation:CLLocation = locations[0] as CLLocation
            self.currentLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
            let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.latitude, longitude:currentLocation.longitude, zoom: 15)
            let position = CLLocationCoordinate2D(latitude:  currentLocation.latitude, longitude: currentLocation.longitude)
            print(position)
            DispatchQueue.main.async {
                
                self.mapView.camera = camera
            }
            self.mapView?.animate(to: camera)
            
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
            }
            self.mapView?.animate(to: camera)
            
        }
        
        
        
        manager.stopUpdatingLocation()
        
        
    }
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        print("my required url is \(url)")
        pdfUrl = url
        let path = URL(fileURLWithPath: url.lastPathComponent).pathExtension
        // let name = URl(fileURLWithPath: url.firstPath).pathExtension
        docFileExtension = "\(path)"
        print("File Extension :",docFileExtension!)
        //changed the below line
        //let pdfData = try! Data(contentsOf: pdfUrl)
        let pdfData = try! Data(contentsOf: pdfUrl.asURL())
        // commented  let DocumentData : Data = pdfData
        docFileData = pdfData
        print("File Data===== : \(docFileData)")
        print("pdfData===== : \(pdfData)")
        
        self.myArray.append(pdfUrl!)
        print(self.myArray as Any)
        print("myarray===== : \(myArray)")
        
    }
    
    
    @IBAction func profilePicUpdateAction(_ sender: Any) {
        let view = UIAlertController(title:languageChangeString(a_str: "Pick Image"), message: "", preferredStyle: .actionSheet)
        let PhotoLibrary = UIAlertAction(title:languageChangeString(a_str:"Choose a photo from your library"), style: .default, handler: { action in
            self.PhotoLibrary()
            view.dismiss(animated: true)
        })
        let camera = UIAlertAction(title:languageChangeString(a_str:"Take a new photo"), style: .default, handler: { action in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.camera()
            } else {
                self.noCamera()
            }
            view.dismiss(animated: true)
        })
        
        let cancel = UIAlertAction(title:languageChangeString(a_str:"Cancel"), style: .cancel, handler: { action in
        })
        view.addAction(camera)
        view.addAction(PhotoLibrary)
        view.addAction(cancel)
        present(view, animated: true)
    }
    
    func PhotoLibrary()
    {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true)
    }
    
    func camera()
    {
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
        self.imagePicker.cameraCaptureMode = .photo
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.present(self.imagePicker,animated: true,completion: nil)
    }
    
    func noCamera(){
        //  let alertVC = UIAlertController(
        //title: "No Camera",message: languageChangeString(a_str:"Sorry, this device has no camera"),preferredStyle: .alert)
        // let okAction = UIAlertAction(
        // title: languageChangeString(a_str:"Ok"),style:.default,handler: nil)
        let alertVC = UIAlertController(
            title: languageChangeString(a_str:"No Camera"),message:languageChangeString(a_str:"Sorry, this device has no camera"),preferredStyle: .alert)
        let okAction = UIAlertAction(
            title:languageChangeString(a_str:"OK"),style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,animated: true,completion: nil)
    }
    
    //SP GETPROFILE SERVICE CALL
    func SPgetProfileDetailsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        // https://www.volive.in/mobilefix/services/profile?API-KEY=9173645&lang=en&user_id=2
        /*
         API-KEY:9173645
         lang:en
         user_id:*/
        
        let getProfile = "\(Base_Url)profile"
        let spId = UserDefaults.standard.object(forKey: "spId") as? String
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let parameters: Dictionary<String, Any> = [ "user_id" :spId!, "lang" : language,"API-KEY":APIKEY]
        print(parameters)
        
        Alamofire.request(getProfile, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                self.documentNamesArray = [String]()
                self.document_idarray = [String]()
                self.doc_typeArray = [String]()
                if status == 1
                {
                    
                    if let userDetailsData = responseData["profile"] as? Dictionary<String, AnyObject> {
                        self.documentList = userDetailsData["user_documents"] as? [[String:Any]]
                        
                        if self.documentList.count > 0{
                           
                           // self.documentCollectionView.isHidden = false
                            
                            self.documentCollectionViewHeight.constant = 120
                            self.noDocumentsLabel.isHidden = true
                            self.documnetHeightConstarint.constant = 201
                            self.documentCollectionView.reloadData()
                            
                        }
                        else{
                            //self.documentCollectionView.isHidden = true
                            
                            self.documentCollectionViewHeight.constant = 0
                            self.noDocumentsLabel.isHidden = false
                            self.documnetHeightConstarint.constant = 120
                            self.documentCollectionView.reloadData()
                            
                        }
                        let userName = userDetailsData["name"] as? String?
                        let userEmail = userDetailsData["email"] as? String?
                        let phone = userDetailsData["phone"] as? String?
                        let userImg = userDetailsData["profile_pic"] as? String?
                        let id_proof = userDetailsData["id_proof"] as? String?
                        let gender = userDetailsData["gender"] as? String?
                        let request_type = userDetailsData["request_type"] as? String?
                        self.request_typeStr = request_type!
                        //var genderStr : String?
                        let dob = userDetailsData["dob"] as? String?
                        let address = userDetailsData["address"] as? String?
                        
                        
                        
                        // let userImage = String(format: "%@%@",base_path,userImg!!)
                        
                        let x : String = userDetailsData["user_id"] as! String
                        
                        // commentedlet x : Int = userDetailsData["user_id"] as! Int
                        // commented let xNSNumber = x as NSNumber
                        //let xString : String = xNSNumber.stringValue
                        
                        //user_image
                        let userImage = String(format: "%@%@",base_path,userImg!!)
                        
                        UserDefaults.standard.set(userName as Any, forKey: "userName")
                        UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                        UserDefaults.standard.set(phone as Any, forKey: "phoneNo")
                        UserDefaults.standard.set(x as Any, forKey: "userId")
                        UserDefaults.standard.set(userImage as Any, forKey: "userImage")
                        //  UserDefaults.standard.set(userImage as Any, forKey: "userImage")
                        
                        let name = UserDefaults.standard.object(forKey: "userName")
                        let email = UserDefaults.standard.object(forKey: "userEmail")
                        let phoneno = UserDefaults.standard.object(forKey: "phoneNo")
                        let image = UserDefaults.standard.object(forKey: "userImage") as! String
                        //let idstr = UserDefaults.standard.object(forKey: "id_proof")
                        
                        DispatchQueue.main.async {
                            self.txt_Name.text = name as? String
                            self.txt_Email.text = email as? String
                            self.txt_PhoneNumber.text = phoneno as? String
                            //self.providerImageView.sd_setImage(with: URL (string: image as! String), placeholderImage:
                               // UIImage(named: ""))
                            self.providerImageView.sd_setImage(with: URL (string: image), placeholderImage:
                                UIImage(named: ""))
                            self.txt_ID.text = id_proof as? String
                            
                            self.txt_DateOfBirth.text = dob as? String
                            self.txt_Password.text = UserDefaults.standard.object(forKey: "password") as? String
                            self.txt_ConformPassword.text = UserDefaults.standard.object(forKey: "password") as? String
                            UserDefaults.standard.set(self.txt_Password.text!, forKey: "password")
                            UserDefaults.standard.set(self.txt_ConformPassword.text!, forKey: "password")
                            self.locationTextView.text = address as? String
                            self.providerNameLabel.text = name as? String
                           
                            if gender == "1"{
                                
                                
                                self.checkOrderBtn.isHidden = false
                                self.checkBtnNew.isHidden = false
                                self.txt_Gender.text = languageChangeString(a_str: "Female")
                                self.checkOrderBtn.setTitle(languageChangeString(a_str: "Receive female orders only"), for: UIControl.State.normal)
                            }
                            else{
                                
                                self.checkOrderBtn.isHidden = true
                                self.checkBtnNew.isHidden = true
                                self.txt_Gender.text = languageChangeString(a_str: "Male")
                            }
                            
                            if request_type == "2"{
                                //now self.checkOrderBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
                                self.checkBtnNew.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
                                self.checkTerms = true
                            }
                            else{
                              //now  self.checkOrderBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
                                self.checkBtnNew.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
                                self.checkTerms = false
                            }
//
                        }
                        
                        //getting document list
                        for each in self.documentList!{
                            let doc_name = each["doc_name"] as! String
                            let doc = String(format: "%@%@",base_path,doc_name)
                            let document_id = each["document_id"] as! String
                            let doc_type = each["doc_type"] as! String
                            
                            let myInt2 = (document_id as NSString).integerValue
                            
                            let myString = String(myInt2)
                            
                            if UserDefaults.standard.object(forKey: "savebS") != nil
                            {
                                self.saveBool = true
                                let idArr = UserDefaults.standard.object(forKey: "IdsStringArr") ?? [String]()
                                    //as! Array<Any>
                                
                                self.checkArr = idArr as! [String]
                                
                                print(self.checkArr)
                                
                                if self.checkArr .contains(myString)
                                {
                                    let checkStr = "1"
                                    self.tagsCheckArray.append(checkStr)
                                    
                                }else
                                {
                                    let checkStr = "0"
                                    self.tagsCheckArray.append(checkStr)
                                }
                            }
                            else
                            {
                                let checkStr = "0"
                                self.tagsCheckArray.append(checkStr)
                            }
                            
                            self.document_idarray.append(document_id)
                            self.documentNamesArray.append(doc)
                            self.doc_typeArray.append(doc_type)
                        }
                    }
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.documentCollectionView.reloadData()
                        
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

    //EDIT SP PROFILE SERVICE CALL
    func SPeditProfileServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         user_id:(mandatory)
         name: (provider name/ company name)
         gender:(Male/Female) for user and individual only
         email: (mandatory)
         phone: (mandatory)
         password: (optional)
         confirm_password: (optional)
         profile_pic: (optional)
         id_proof: (provider ID/Company number)
         dob: (YYYY-MM-DD) for individual only
         address: (for provider and company)
         latitude: (for provider and company)
         longitude: (for provider and company)
         document[]: (optional)
         
         */
        if self.txt_Gender.text == "Male"{
            genderStrValue = "0"
        }
        else{
             genderStrValue = "1"
        }
//        let genderString = UserDefaults.standard.object(forKey: "gender") as? String ?? ""
//        if genderString == "1"{
//            self.txt_Gender.text = ""
//        }
//        else{
//            // self.checkOrderBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
//            self.checkOrderBtn.isHidden = true
//            self.txt_Gender.text = languageChangeString(a_str: "Male")
//        }
        let spId = UserDefaults.standard.object(forKey: "spId") as? String
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        //let parameters: Dictionary<String, Any>
        parameters = ["user_id":spId!,"lang":language,"name":self.txt_Name.text!,"id_proof":self.txt_ID.text!,"email":self.txt_Email.text!,"phone":self.txt_PhoneNumber.text!,"dob":self.txt_DateOfBirth.text!,"address":self.txt_Location.text!,"password":self.txt_Password.text!,"confirm_password":self.txt_ConformPassword.text!,"gender":genderStrValue!,"latitude":latitudeString,"longitude":longitudeString,"API-KEY":APIKEY]
        //"male"
        print("Edit Profile Is",parameters)
        //"78.44329979", "phone": "8888899999", "latitude": "17.41312287",
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
//        else {
//            self.fileNameStr = "file.docx"
//            self.mimeTypeStr = "application/docx"
//        }
        
        if pickerImage.size.width != 0 {
            
            let imgData = pickerImage.jpegData(compressionQuality: 0.2)!
            //swift3 let imgData = UIImageJPEGRepresentation(pickerImage, 0.2)!
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                //upload document
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
                
                multipartFormData.append(imgData, withName: "profile_pic",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in self.parameters {
                    
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
            },
                             to:"\(Base_Url)edit_profile")
            { (result) in
                
                print(result)
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        print(response.result.value ?? "")
                        
                        let responseData = response.result.value as? Dictionary<String, Any>
                        
                        let status = responseData!["status"] as! Int
                        let message = responseData!["message"] as! String
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            /*  if let responseData1 = responseData!["user details"] as? Dictionary<String, AnyObject> {
                             
                             print(responseData1)
                             
                             let username = responseData1["user_name"] as! String
                             let email = responseData1["email"] as! String
                             let image = String(format: "%@%@", base_path,
                             responseData1["user_image"] as! String)
                             
                             let imageStr = image
                             
                             //                                self.fullNameTF.text = username
                             //                                self.emailTF.text = email
                             //                                self.name.text = (UserDefaults.standard.object(forKey: "userName") as! String)
                             //                                self.email.text = (UserDefaults.standard.object(forKey: "userEmail") as! String)
                             //                                UserDefaults.standard.set(self.passwordTF.text!, forKey: "password")
                             //                                UserDefaults.standard.set(self.confirmPasswordTF.text!, forKey: "password")
                             DispatchQueue.main.async {
                             self.userImage.sd_setImage(with: URL (string: imageStr), placeholderImage:
                             UIImage(named: ""))
                             }
                             
                             
                             UserDefaults.standard.set(username, forKey: "userName")
                             UserDefaults.standard.set(email, forKey: "userEmail")
                             UserDefaults.standard.set(imageStr, forKey: "userImage")
                             
                             //                                self.name.text = (UserDefaults.standard.object(forKey: "userName") as! String)
                             //                                self.email.text = (UserDefaults.standard.object(forKey: "userEmail") as! String)
                             
                             //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileData"), object: nil)
                             
                             
                             self .dismiss(animated: true, completion: nil)
                             
                             self.showToastForAlert(message: message)
                             // self.viewDidLoad()
                             }*/
                            UserDefaults.standard.set(self.providerNameLabel.text!, forKey: "userName")
                            UserDefaults.standard.set(self.txt_Name.text!, forKey: "userName")
                            UserDefaults.standard.set(self.txt_Email.text!, forKey: "userEmail")
                            UserDefaults.standard.set(self.txt_PhoneNumber.text!, forKey: "phone")
                            UserDefaults.standard.set(self.txt_DateOfBirth.text!, forKey: "birthDate")
                            UserDefaults.standard.set(self.txt_ID.text!, forKey: "id1")
                            let image = String(format: "%@%@", base_path,
                                               responseData!["updated_image"] as! String)
                            
                            let imageStr = image
                            UserDefaults.standard.setValue(imageStr, forKey: "userImage")
                            DispatchQueue.main.async {
                                self.providerImageView.sd_setImage(with: URL (string: imageStr), placeholderImage:
                                    UIImage(named: ""))
                            }
                            UserDefaults.standard.set(self.txt_Password.text!, forKey: "password")
                            UserDefaults.standard.set(self.txt_ConformPassword.text!, forKey: "password")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileData"), object: nil)
                            DispatchQueue.main.async {
                                self.SPgetProfileDetailsServiceCall()
                            }
                            self .dismiss(animated: true, completion: nil)
                            
                            self.showToast(message: message)
                        }
                        else
                        {
                            //self.showToastForError(message: message)
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
        else{
            
            pickerImage1 = providerImageView.image!
            //swift4
            let imagedata = pickerImage1.jpegData(compressionQuality: 0.2)!
            //swift3 let imagedata = UIImageJPEGRepresentation(pickerImage1, 0.2)!
            print("ImageData Original",imagedata)
            // let imagedata = profileImage.image
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                
                //upload document
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
                
                multipartFormData.append(imagedata, withName: "profile_pic",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in self.parameters {
                    
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            },
                             to:"\(Base_Url)edit_profile")
            { (result) in
                
                print(result)
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        print(response.result.value ?? "")
                        
                        let responseData = response.result.value as? Dictionary<String, Any>
                        
                        let status = responseData!["status"] as! Int
                        let message = responseData!["message"] as! String
                        
                        if status == 1
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            /* if let responseData1 = responseData!["user details"] as? Dictionary<String, AnyObject> {
                             print(responseData1)
                             
                             let username = responseData1["user_name"] as! String
                             let email = responseData1["email"] as! String
                             let image = String(format: "%@%@", base_path,
                             responseData1["user_image"] as! String)
                             
                             let imageStr = image
                             
                             //                                self.fullNameTF.text = username
                             //                                self.emailTF.text = email
                             //self.passwordTF.text = username
                             //self.confirmPasswordTF.text = mobile
                             
                             /*UserDefaults.standard.set(self.passwordTF.text!, forKey: "password")
                             UserDefaults.standard.set(self.confirmPasswordTF.text!, forKey: "password")*/
                             
                             DispatchQueue.main.async {
                             self.userImage.sd_setImage(with: URL (string: imageStr), placeholderImage:
                             UIImage(named: ""))
                             }
                             
                             UserDefaults.standard.set(username, forKey: "userName")
                             UserDefaults.standard.set(email, forKey: "userEmail")
                             UserDefaults.standard.set(imageStr, forKey: "userImage")
                             
                             //                                self.name.text = (UserDefaults.standard.object(forKey: "userName") as! String)
                             //                                self.email.text = (UserDefaults.standard.object(forKey: "userEmail") as! String)
                             
                             // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileData"), object: nil)
                             
                             
                             self .dismiss(animated: true, completion: nil)
                             self.showToastForAlert(message: message)
                             }*/
                            
                            UserDefaults.standard.set(self.providerNameLabel.text!, forKey: "userName")
                            UserDefaults.standard.set(self.txt_Name.text!, forKey: "userName")
                            UserDefaults.standard.set(self.txt_Email.text!, forKey: "userEmail")
                            UserDefaults.standard.set(self.txt_PhoneNumber.text!, forKey: "phone")
                            UserDefaults.standard.set(self.txt_DateOfBirth.text!, forKey: "birthDate")
                            UserDefaults.standard.set(self.txt_ID.text!, forKey: "id1")
                            let image = String(format: "%@%@", base_path,
                                               responseData!["updated_image"] as! String)
                            
                            let imageStr = image
                            UserDefaults.standard.setValue(imageStr, forKey: "userImage")
                            DispatchQueue.main.async {
                                self.providerImageView.sd_setImage(with: URL (string: imageStr), placeholderImage:
                                    UIImage(named: ""))
                            }
                            UserDefaults.standard.set(self.txt_Password.text!, forKey: "password")
                            UserDefaults.standard.set(self.txt_ConformPassword.text!, forKey: "password")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileData"), object: nil)
                            DispatchQueue.main.async {
                                self.SPgetProfileDetailsServiceCall()
                            }
                            self .dismiss(animated: true, completion: nil)
                            
                            self.showToast(message: message)
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToast(message: message)
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    MobileFixServices.sharedInstance.dissMissLoader()
                }
            }
        }
    }
    
    /*
     ["message": Profile data, "status": 1, "base_url": https://www.volive.in/mobilefix/, "profile": {
     address = "1-10-119/1-5,120&121, Mayur Marg, Begumpet, Hyderabad, Telangana 500016, India";
     "auth_level" = 3;
     "country_code" = "+966";
     "created_on" = "2019-04-11 23:04:16";
     "device_name" = ios;
     "device_token" = B0A450F3D3CE6CBB0C0AD837B08D2A439B56A434E27A20809AE06750A6390B4A;
     dob = "1440-08-13";
     email = "provider@gmail.com";
     gender = 1;
     "id_proof" = 22;
     latitude = "17.43750600";
     longitude = "78.45319916";
     name = Provider;
     otp = 1234;
     "otp_status" = 1;
     password = e10adc3949ba59abbe56e057f20f883e;
     phone = 8888899999;
     "profile_pic" = "uploads/dde1da0809c02d17bce77cc5b9014a23.jpg";
     "request_type" = 1;
     "updated_on" = "2019-07-01 03:38:20";
     "user_documents" =     (
     {
     "doc_name" = "uploads/file2.JPG";
     "doc_type" = jpg;
     "document_id" = 144;
     "uploaded_on" = "2019-04-16 01:47:59";
     "user_id" = 78;
     },
     {
     "doc_name" = "uploads/file113.pdf";
     "doc_type" = pdf;
     "document_id" = 147;
     "uploaded_on" = "2019-04-16 01:54:40";
     "user_id" = 78;
     }
     );
     "user_id" = 78;
     "user_status" = 1;
     username = provider;
     }]
 
 */
    
    
    //SP DELETE DOCUMENT SERVICE CALL
    func deleteDocumentServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         document_id[]: array format
         */
        
        let signup = "\(Base_Url)delete_documents"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        //retrieving array values  and store into label
        var string = ""
        string = idArray.joined(separator: ",")
        
        let parameters: Dictionary<String, Any> = [ "document_id" : idArray,"lang" : language,"API-KEY":APIKEY]
        
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
                        self.SPgetProfileDetailsServiceCall()
                        self.showToast(message: message)
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
    
    //SP Select female/male orders service call
    func SPCheckOrderServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         provider_id:
         request_type:(1=all,2=requests from female only)
         */
        //Male  0 Female 1
        
        let signup = "\(Base_Url)request_type_status"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
       
        let spId = UserDefaults.standard.object(forKey: "spId") as? String ?? ""
       
        
//        if request_typeStr == "2"{
//            self.checkBtnNew.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
//            checkTermStr = "1"
//        }
//        else{
//            self.checkBtnNew.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
//            checkTermStr = "2"
//        }
        
//        if request_typeStr == "2"{
//            //self.checkOrderBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
//            self.checkImageView.image = UIImage.init(named: "UnCheck")
//            checkTermStr = "1"
//        }
//        else{
//            //self.checkOrderBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
//             self.checkImageView.image = UIImage.init(named: "check")
//            checkTermStr = "2"
//        }
//
        
        let parameters: Dictionary<String, Any> = [ "request_type" : checkTermStr!,  "provider_id" : spId,"lang" : language,"API-KEY":APIKEY]
        
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
                        print("succeess")
//                        if self.checkTerms == false{
//                            self.checkOrderBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
//                            self.checkTerms = true
//                            self.checkTermStr = "2"
//                        }
//                        else{
//                            self.checkOrderBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
//                            self.checkTerms = false
//                            self.checkTermStr = "1"
//                        }
                        
                        
//                        let userType = UserDefaults.standard.object(forKey: "type") as? String
//                        if userType == "2"{
//
//                            NotificationCenter.default.post(name: Notification.Name("pushView"), object: nil)
//                            self.dismiss(animated: true) {
//                                print("dismmissed")
//                            }
//                        }
//                        else{
//                            NotificationCenter.default.post(name: Notification.Name("pushView4"), object: nil)
//                            self.dismiss(animated: true) {
//                                print("dismmissed")
//                            }
//                        }
                        
                        //self.showToast(message: message)
                        
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
    
    
    @IBAction func uploadDocumentsAction(_ sender: Any) {
    
        self.myArray = [Any]()
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        documentPicker.delegate = self
        //documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
    }
    
    
    @IBAction func deleteDocumnetBtnAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            deleteDocumentServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    
    
    @IBAction func expandMapBtnAction(_ sender: Any) {
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpSetLocationVC") as! SpSetLocationVC
        self.present(gotoVC, animated: true, completion: nil)
        
        let locationdict : [String:String] = ["lat":latitudeString,"lang":longitudeString,"address":txt_Location.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showUpdatedValueOnMap"), object: nil, userInfo: locationdict)
    }
    
    @IBAction func myLocationBtnAction(_ sender: Any) {
        latitudeString = ""
        if Reachability.isConnectedToNetwork()
        {
            self.isAuthorizedtoGetUserLocation()
        }else
        {
            //showToastForError (message:"Please make sure that you have connected to proper internet.")
        }
    }
    
    
    @IBAction func checkBtnAction(_ sender: Any) {
        
        //SPCheckOrderServiceCall()
//        if request_typeStr == "2"{
//            self.checkBtnNew.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
//            checkTermStr = "1"
//        }
//        else{
//            self.checkBtnNew.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
//            checkTermStr = "2"
//        }
        
        if checkTerms == false{
            self.checkBtnNew.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
            checkTerms = true
            checkTermStr = "2"
        }
        else{
            self.checkBtnNew.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
            checkTerms = false
            checkTermStr = "1"
        
        }
        SPCheckOrderServiceCall()
    }
    
    @IBAction func checkNewBtnAction(_ sender: Any) {
        if checkTerms == false{
            self.checkBtnNew.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
            checkTerms = true
            checkTermStr = "2"
        }
        else{
            self.checkBtnNew.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
            checkTerms = false
            checkTermStr = "1"
            
        }
        SPCheckOrderServiceCall()
    }
    @IBAction func checkOrdersBtnAction(_ sender: Any) {
        
//        if request_typeStr == "2"{
//            //self.checkOrderBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
//            self.checkImageView.image = UIImage.init(named: "UnCheck")
//            checkTermStr = "1"
//        }
//        else{
//            //self.checkOrderBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
//            self.checkImageView.image = UIImage.init(named: "check")
//            checkTermStr = "2"
//        }
//
        
        //SPCheckOrderServiceCall()
//        if checkTerms == false{
//            self.checkOrderBtn.setImage(UIImage.init(named: "check"), for: UIControl.State.normal)
//            checkTerms = true
//            checkTermStr = "2"
//        }
//        else{
//            self.checkOrderBtn.setImage(UIImage.init(named: "UnCheck"), for: UIControl.State.normal)
//            checkTerms = false
//            checkTermStr = "1"
//        }
        
    }
}


extension SpProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //
    //        var selectedImage: UIImage?
    //        if let editedImage = info[.editedImage] as? UIImage {
    //            selectedImage = editedImage
    //            self.profileImage.image = selectedImage!
    //            picker.dismiss(animated: true, completion: nil)
    //        } else if let originalImage = info[.originalImage] as? UIImage {
    //            selectedImage = originalImage
    //            self.profileImage.image = selectedImage!
    //            picker.dismiss(animated: true, completion: nil)
    //        }
    //
    //    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        if let chosenImage = info[.originalImage] as? UIImage{
        //            //use image
        //        }
        if let img = info[.editedImage] as? UIImage
        {
            pickedImage = img
        }
        else if let img = info[.originalImage] as? UIImage
        {
            pickedImage = img
        }
        
        print("picked image",pickedImage)
        picker.dismiss(animated: true, completion: nil)
        // let pickedImage2 = info[UIImagePickerControllerOriginalImage]
        // print(pickedImage ?? "")
        
        providerImageView.image = pickedImage
        pickerImage = pickedImage
        
        //editProfileServiceCall()
        
    }
}

extension SpProfileVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documentNamesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ImageCell
        cell = documentCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        docType = doc_typeArray[indexPath.row]
        
        if docType == "pdf"{
           // cell.uploadImageView.sd_setImage(with: URL(string: documentNamesArray[indexPath.row]), placeholderImage: UIImage.init(named:"pdfImage"))
            cell.uploadImageView.image = UIImage.init(named: "pdfImage")
        }else if docType == "jpg"{
            cell.uploadImageView.sd_setImage(with: URL(string: documentNamesArray[indexPath.row]), placeholderImage: UIImage.init(named:""))
        }
        else if docType == "png"{
            cell.uploadImageView.sd_setImage(with: URL(string: documentNamesArray[indexPath.row]), placeholderImage: UIImage.init(named:""))
        }
        else if docType == "docx"{
            
            cell.uploadImageView.image = UIImage.init(named: "docxImage")
        }
//        else{
//        cell.uploadImageView.sd_setImage(with: URL(string: documentNamesArray[indexPath.row]), placeholderImage: UIImage.init(named:""))
//        }
        if checkValue == 1{
            cell.checkImageView.isHidden = true
            print("is hidden")
        }
        else{
            print("is not hidden")
             cell.checkImageView.isHidden = false
            let issueIdStr = document_idarray[indexPath.row]
            
            if tagsCheckArray[indexPath.row] == "0" {
                cell.checkImageView.image = UIImage.init(named: "UnCheck")
                
            }else if tagsCheckArray[indexPath.row] == "1"{
                
                
                cell.checkImageView.image = UIImage(named: "check")
                idArray.append(issueIdStr)
                
                print("Id Array Is :\(idArray)")
                
                IdString = idArray.joined(separator: ",")
                print(IdString)
                
                UserDefaults.standard.set( IdString , forKey: "bandIdsString") //setObject
                UserDefaults.standard.set( idArray , forKey: "IdsStringArr")
                
            }else{
                
            }
            
        }
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        if checkValue == 1{
          
            let strTempPdf = documentNamesArray[indexPath.row]
            UIApplication.shared.openURL(NSURL(string: strTempPdf)! as URL)
        }
        else{
        saveBool = true
        if tagsCheckArray[indexPath.row] == "0" {
            
            tagsCheckArray.remove(at: indexPath.row)
            tagsCheckArray.insert("1", at: indexPath.row)
            
            print(tagsCheckArray)
            
            IdString = ""
            idArray = [String]()
            
            documentCollectionView.reloadData()
    
            
        }
        else if tagsCheckArray[indexPath.row] == "1"{
            //UserDefaults.standard.set("filt", forKey: "savebS")
            //  UserDefaults.standard.removeObject(forKey: "savebS")
            tagsCheckArray.remove(at: indexPath.row)
            tagsCheckArray.insert("0", at: indexPath.row)
            print(tagsCheckArray)
            IdString = ""
            idArray = [String]()
       
            if !(self.tagsCheckArray.contains("1")){
                print("There are no items added")
                saveBool = false
                UserDefaults.standard.removeObject(forKey: "savebS")
            }
            documentCollectionView.reloadData()
            
        }
        
    }
    }
    
}

