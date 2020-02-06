//
//  UserProfileVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 28/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MOLH

class UserProfileVC: UIViewController {

    @IBOutlet var cardBackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cardListCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var cardListCollectionView: UICollectionView!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var mobileNumberTF: UITextField!
    @IBOutlet var nameStaticLabel: UILabel!
    @IBOutlet var emailStaticLabel: UILabel!
    @IBOutlet var mobileStaticLabel: UILabel!
    @IBOutlet var changePwdBtn: UIButton!
    @IBOutlet var savedCardsStaticLabel: UILabel!
    @IBOutlet var pwdTF: UITextField!
    @IBOutlet var confirmPwdTF: UITextField!
    @IBOutlet var userImage: UIImageView!
    
    var pwdField: UITextField!
    var confirmPwdField: UITextField!
    var checkValue :Int!
    var card_numberArray = [String]()
    var card_typeArray = [String]()
    var name_on_cardArray = [String]()
    var expiry_dateArray = [String]()
    var card_idArray = [String]()
    var cvvArray = [String]()
    var card_type_nameArray = [String]()
    
    var deleteCardIdStr : String?
    var arrayCount = Int()
    
    var pickerImage  = UIImage()
    var pickerImage1  = UIImage()
    var pickedImage  = UIImage()
    
    
    @IBOutlet var profilePicBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = languageChangeString(a_str: "My Profile")
        self.nameStaticLabel.text = languageChangeString(a_str: "Name")
        self.emailStaticLabel.text = languageChangeString(a_str: "Email")
        self.mobileStaticLabel.text = languageChangeString(a_str: "Mobile Number")
        self.savedCardsStaticLabel.text = languageChangeString(a_str: "Saved Cards")
        self.editButton.setTitle(languageChangeString(a_str: "Edit"), for: UIControl.State.normal)
        self.changePwdBtn.setTitle(languageChangeString(a_str: "Change Password"), for: UIControl.State.normal)
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let barButtonItem1 = UIBarButtonItem(title: languageChangeString(a_str:"Edit"), style: .plain, target: self, action: #selector(backButtonTapped1))
        self.navigationItem.rightBarButtonItem = barButtonItem1
       
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        if MOLHLanguage.isRTLLanguage(){
            self.emailTF.textAlignment = .right
            self.mobileNumberTF.textAlignment = .right
            self.nameTF.textAlignment = .right
        }
        else{
            self.emailTF.textAlignment = .left
            self.mobileNumberTF.textAlignment = .left
            self.nameTF.textAlignment = .left
        }
        
        if Reachability.isConnectedToNetwork() {
            
            getProfileDetailsServiceCall()
            
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
        }
        
        
        checkValue = 1
        
        imagePicker.delegate = self
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.clipsToBounds = true
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(showLeftView(sender:)), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        self.nameTF.setBottomLineBorderColor()
        self.emailTF.setBottomLineBorderColor()
        self.mobileNumberTF.setBottomLineBorderColor()
        self.pwdTF.setBottomLineBorderColor()
        self.confirmPwdTF.setBottomLineBorderColor()
        
        self.profilePicBtn.isEnabled = false
        self.nameTF.isUserInteractionEnabled = false
        self.emailTF.isUserInteractionEnabled = false
        self.mobileNumberTF.isUserInteractionEnabled = false
        self.pwdTF.isUserInteractionEnabled = false
        self.confirmPwdTF.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc fileprivate func backButtonTapped1() {
        
        if checkValue == 1{
            self.navigationItem.rightBarButtonItem?.title = languageChangeString(a_str:"Save")
            
            self.nameTF.setBottomLineBorder()
            self.emailTF.setBottomLineBorder()
            self.mobileNumberTF.setBottomLineBorder()
            self.pwdTF.setBottomLineBorder()
            self.confirmPwdTF.setBottomLineBorder()
            
            self.profilePicBtn.isEnabled = true
            self.nameTF.isUserInteractionEnabled = false
            self.emailTF.isUserInteractionEnabled = true
            self.mobileNumberTF.isUserInteractionEnabled = false
            self.pwdTF.isUserInteractionEnabled = true
            self.confirmPwdTF.isUserInteractionEnabled = true
            
            checkValue = 2
            
//            self.custom_ScrollView.contentOffset = CGPoint(x: 0, y: 0)
//            self.documnetHeightConstarint.constant = 240
        }
        else{
            
            self.nameTF.setBottomLineBorderColor()
            self.emailTF.setBottomLineBorderColor()
            self.mobileNumberTF.setBottomLineBorderColor()
            self.pwdTF.setBottomLineBorderColor()
            self.confirmPwdTF.setBottomLineBorderColor()
            
            self.profilePicBtn.isEnabled = false
            self.nameTF.isUserInteractionEnabled = false
            self.emailTF.isUserInteractionEnabled = false
            self.mobileNumberTF.isUserInteractionEnabled = false
            self.pwdTF.isUserInteractionEnabled = false
            self.confirmPwdTF.isUserInteractionEnabled = false
            
            self.navigationItem.rightBarButtonItem?.title = languageChangeString(a_str:"Edit")
            checkValue = 1
            if Reachability.isConnectedToNetwork() {
                
                editProfileServiceCall()
                
            }else
            {
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            }
            
        }
    }
    
    
    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }

    @objc func onClcikBack()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePwdAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message:languageChangeString(a_str:"Change Password"), preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = languageChangeString(a_str:"Password")
            textField.textColor = UIColor.black
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .roundedRect
        })
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = languageChangeString(a_str:"Confirm Password")
            textField.textColor = UIColor.black
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .roundedRect
        })
        alertController.view.tintColor = UIColor(red: 64 / 255.0, green: 198 / 255.0, blue: 182 / 255.0, alpha: 1)
        alertController.addAction(UIAlertAction(title: languageChangeString(a_str:"SUBMIT"), style: .default, handler: { action in
            
            var textfields = alertController.textFields
            
            self.pwdField = textfields?[0]
            self.confirmPwdField = textfields?[1]
            if Reachability.isConnectedToNetwork() {
                self.changePwdServiceCall()
            }else{
                self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            }
    
        }))
        self.present(alertController, animated: true, completion: nil)
    
    }

  
    @IBAction func profilePicUpdateBtnAction(_ sender: Any) {
      
         let view = UIAlertController(title:languageChangeString(a_str:"Pick Image"), message: "", preferredStyle: .actionSheet)
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
        let alertVC = UIAlertController(
            title: languageChangeString(a_str:"No Camera"),message:languageChangeString(a_str:"Sorry, this device has no camera"),preferredStyle: .alert)
        let okAction = UIAlertAction(
            title:languageChangeString(a_str:"OK"),style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,animated: true,completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        
        if editButton.tag == 1{
            self.editButton.setTitle(languageChangeString(a_str:"Save"), for: UIControl.State.normal)
            self.cardListCollectionView.reloadData()
            editButton.tag = 2
//            self.navigationItem.title = "Edit Profile"
//            self.editBtn.title = "Save"
//            self.contentView.isUserInteractionEnabled = true
//            //self.editImageBtn.setImage(UIImage.init(named: "UploadImage"), for: UIControl.State.normal)
//            editBtn.tag = 0
//            self.userNameTF.setBottomLineBorder()
//            self.emailTF.setBottomLineBorder()
//            self.mobileNoTF.setBottomLineBorder()
//            self.passwordTF.setBottomLineBorder()
//            self.confirmPasswordTF.setBottomLineBorder()
//            self.addressTV.setBottomLineBorder()
//            self.languageBottomView.isHidden = false
        }else{
            //editButton.tag = 1
            self.editButton.setTitle(languageChangeString(a_str: "Edit"), for: UIControl.State.normal)
            self.cardListCollectionView.reloadData()
            editButton.tag = 1
//            self.navigationItem.title = "Profile"
//            self.editBtn.title = "Edit"
//            self.contentView.isUserInteractionEnabled = false
//            //self.editImageBtn.setImage(UIImage.init(named: "EditImage"), for: UIControl.State.normal)
//            self.userNameTF.removeBottomLineBorder()
//            self.emailTF.removeBottomLineBorder()
//            self.mobileNoTF.removeBottomLineBorder()
//            self.passwordTF.removeBottomLineBorder()
//            self.confirmPasswordTF.removeBottomLineBorder()
//            self.addressTV.removeBottomLineBorder()
//            self.languageBottomView.isHidden = true
            
        }
   
    }
    
    
    @IBAction func onTapChangePwd(_ sender: Any) {
        
        print("tap")
        let alertController = UIAlertController(title: languageChangeString(a_str: "Change Password"), message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = languageChangeString(a_str:"Enter Password")
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter First Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //USER GETPROFILE SERVICE CALL
    func getProfileDetailsServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
       // https://www.volive.in/mobilefix/services/profile?API-KEY=9173645&lang=en&user_id=2
        /*
         API-KEY:9173645
         lang:en
         user_id:*/
        
        let getProfile = "\(Base_Url)profile"
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let parameters: Dictionary<String, Any> = [ "user_id" : userID!, "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(getProfile, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                self.card_idArray = [String]()
                self.card_numberArray = [String]()
                self.card_typeArray = [String]()
                self.name_on_cardArray = [String]()
                self.expiry_dateArray = [String]()
                self.cvvArray = [String]()
                self.card_type_nameArray = [String]()
                
                if status == 1{
                    
                        if let userDetailsData = responseData["profile"] as? Dictionary<String, AnyObject> {
                        
                        let cardsList = userDetailsData["saved_cards"] as? [[String:AnyObject]]
                        self.arrayCount = cardsList!.count
                        let userName = userDetailsData["name"] as? String?
                        let userEmail = userDetailsData["email"] as? String?
                        let phone = userDetailsData["phone"] as? String?
                        let userImg = userDetailsData["profile_pic"] as? String?
                        
                        if self.arrayCount == 0{
                            self.editButton.setTitle(languageChangeString(a_str: "Add card"), for: UIControl.State.normal)
                            self.editButton.addTarget(self, action: #selector(self.addCardBtnAction(sender:)), for: UIControl.Event.touchUpInside)
                            self.cardListCollectionViewHeightConstraint.constant = 0
                            self.cardBackViewHeightConstraint.constant = 194 - 40
                        }
                        else{
                            self.cardListCollectionViewHeightConstraint.constant = 144
                            self.cardBackViewHeightConstraint.constant = 194
                        }
                            
                        let x : String = userDetailsData["user_id"] as! String
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
                        let image = UserDefaults.standard.object(forKey: "userImage")
                        
                        DispatchQueue.main.async {
                        self.nameTF.text = name as? String
                        self.emailTF.text = email as? String
                        self.mobileNumberTF.text = phoneno as? String
                        self.userImage.sd_setImage(with: URL (string: image as! String), placeholderImage:
                            UIImage(named: ""))
                        }
                        for each in cardsList! {
                            
                            let card_number = each["card_number"]  as! String
                            let card_type = each["card_type"]  as! String
                            let name_on_card = each["name_on_card"]  as! String
                            let expiry_date = each["expiry_date"]  as! String
                            let card_id = each["card_id"]  as! String
                            let cvv = each["cvv"]  as! String
                            let card_type_name = each["card_type_name"]  as! String
                            
                            self.card_idArray.append(card_id)
                            self.card_numberArray.append(card_number)
                            self.card_typeArray.append(card_type)
                            self.name_on_cardArray.append(name_on_card)
                            self.expiry_dateArray.append(expiry_date)
                            self.cvvArray.append(cvv)
                            self.card_type_nameArray.append(card_type_name)
                        }
                    }
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.cardListCollectionView.reloadData()
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
    
    @objc func addCardBtnAction(sender:UIButton){
        let editCard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCardDetailsVC") as! EditCardDetailsVC
        editCard.checkStr = "addCard"
        self.navigationController?.pushViewController(editCard, animated: false)
    }
    
     //MARK:USER CHANGE PASSWORD SERVICE CALL
    func changePwdServiceCall()
    {
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        let changePwd = "\(Base_Url)user_password_change"
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        
        let parameters: Dictionary<String, Any> = [ "user_id" : userID!, "password" : self.pwdField.text! , "confirm_password" : self.confirmPwdField.text! , "lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(changePwd, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1 {
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToast(message: message)
                    }
                }
                else{
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.showToast(message: message)
                }
            }
        }
    }
    
    //MARK:EDIT USER PROFILE SERVICE CALL
    func editProfileServiceCall()
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
        
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let parameters: Dictionary<String, Any>
        parameters = ["user_id":userID!,"lang":language,"name":self.nameTF.text!,"email":self.emailTF.text!,"phone":self.mobileNumberTF.text!,"gender":"","API-KEY":APIKEY]
        // parameters = [ "user_id":uID! , "name":self.fullNameTF.text!, "password":self.passwordTF.text!, "cpassword":self.confirmPasswordTF.text!,"lang":language]
        
        print("Edit Profile Is",parameters)
        
        if pickerImage.size.width != 0 {
            
                        
            let imgData = pickerImage.jpegData(compressionQuality: 0.2)!
           //swift3 let imgData = UIImageJPEGRepresentation(pickerImage, 0.2)!
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "profile_pic",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    
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
                        
                            UserDefaults.standard.set(self.nameTF.text!, forKey: "userName")
                            UserDefaults.standard.set(self.emailTF.text!, forKey: "userEmail")
                            UserDefaults.standard.set(self.mobileNumberTF.text!, forKey: "phone")
                            
                            let image = String(format: "%@%@", base_path,
                                               responseData!["updated_image"] as! String)
                            
                            let imageStr = image
                            UserDefaults.standard.set(imageStr, forKey: "userImage")
                            DispatchQueue.main.async {
                                self.userImage.sd_setImage(with: URL (string: imageStr), placeholderImage:
                                    UIImage(named: ""))
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileData"), object: nil)
                            self .dismiss(animated: true, completion: nil)
                            
                            self.showToast(message: message)
                        }
                        else{
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
            
            pickerImage1 = userImage.image!
            //swift4
            let imagedata = pickerImage1.jpegData(compressionQuality: 0.2)!
           //swift3 let imagedata = UIImageJPEGRepresentation(pickerImage1, 0.2)!
            print("ImageData Original",imagedata)
            // let imagedata = profileImage.image
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imagedata, withName: "profile_pic",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    
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
                           
                            UserDefaults.standard.set(self.nameTF.text!, forKey: "userName")
                            UserDefaults.standard.set(self.emailTF.text!, forKey: "userEmail")
                            UserDefaults.standard.set(self.mobileNumberTF.text!, forKey: "phone")
                            
                            let image = String(format: "%@%@", base_path,
                                               responseData!["updated_image"] as! String)
                            
                            let imageStr = image
                            UserDefaults.standard.set(imageStr, forKey: "userImage")
                            DispatchQueue.main.async {
                                self.userImage.sd_setImage(with: URL (string: imageStr), placeholderImage:
                                    UIImage(named: ""))
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileData"), object: nil)
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
 
}


extension UserProfileVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card_numberArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ImageCell
        cell = cardListCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell

        cell.nameLabel.text = name_on_cardArray[indexPath.row]
        cell.cardNoLabel.text = card_numberArray[indexPath.row]
        cell.dateLabel.text = expiry_dateArray[indexPath.row]
       
        if self.editButton.tag == 1{
            
            cell.editBtn.isHidden = false
            cell.deleteBtn.isHidden = false
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(editBtnAction(sender:)), for: UIControl.Event.touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(sender:)), for: UIControl.Event.touchUpInside)
            
        }
        else{
            cell.editBtn.isHidden = true
            cell.deleteBtn.isHidden = true
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(editBtnAction(sender:)), for: UIControl.Event.touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(sender:)), for: UIControl.Event.touchUpInside)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }

    @objc func editBtnAction(sender:UIButton){
        let cardid = sender.tag
        let cardTypeStr = sender.tag
        let nameOnCardStr = sender.tag
        let cardNumberStr = sender.tag
        let cardExpiryDateStr = sender.tag
        let cardCVVStr = sender.tag
        let cardIdStr = sender.tag
        
        let editCard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCardDetailsVC") as! EditCardDetailsVC
        editCard.cardIdStr = card_idArray[cardid]
        
        editCard.cardTypeStr = card_type_nameArray[cardTypeStr]
        editCard.cardTypeIDString = card_typeArray[cardIdStr]
        editCard.nameOnCardStr = name_on_cardArray[nameOnCardStr]
        editCard.cardNumberStr = card_numberArray[cardNumberStr]
        editCard.cardExpiryDateStr = expiry_dateArray[cardExpiryDateStr]
        editCard.cardCVVStr = cvvArray[cardCVVStr]
        self.navigationController?.pushViewController(editCard, animated: false)
        
    }
    @objc func deleteBtnAction(sender:UIButton){
        let cardid = sender.tag
        deleteCardIdStr = card_idArray[cardid]
        if Reachability.isConnectedToNetwork() {
            deleteCardsServiceCall()
        }else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
    }
    
    //MARK:DELETE CARDS SERVICE CALL
    func deleteCardsServiceCall()
    {
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
       
        let deleteCard = "\(Base_Url)delete_card"
        let params: Dictionary<String, Any> = [ "card_id" : deleteCardIdStr!, "lang" : language,"API-KEY":APIKEY]
     
        print(params)
        
        Alamofire.request(deleteCard, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.getProfileDetailsServiceCall()
                        self.showToast(message: message)
                    }
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.getProfileDetailsServiceCall()
                    self.showToast(message: message)
                }
            }
        }
    }
    
}
extension UserProfileVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.mobileNumberTF{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
}

extension UserProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
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
        userImage.image = pickedImage
        pickerImage = pickedImage

    }
}

