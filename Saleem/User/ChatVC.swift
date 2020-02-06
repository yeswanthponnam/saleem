//
//  ChatVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 24/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import Alamofire
import TPKeyboardAvoidingSwift
import IQKeyboardManagerSwift

class ChatVC: UIViewController {

    //direct userchat
    //["sender_id": "40", "receiver_id": "78", "API-KEY": "9173645", "request_id": "134", "lang": ""]
    
    //direct sp chat
    //["API-KEY": "9173645", "request_id": "134", "sender_id": "78", "receiver_id": "40", "lang": ""]
    
    
    // @IBOutlet var scroll: UIScrollView!
    //user track values sending
   
    
    @IBOutlet var scroll: UIScrollView!
    var reqIdStr : String?
    var providerIdStr : String?
    
    var senderStr : String = ""
    var recieverStr : String = ""
    
   // @IBOutlet var msgView: UIView!
    
    @IBOutlet var sendBtnOutlet: UIButton!
    @IBOutlet weak var myTblview: UITableView!
    @IBOutlet weak var textViewBack: UIView!
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var placeholderlbl: UILabel!
    
    var profileImg : String!
    
    var messages = [String]()
    var dateArr = [String]()
    var typeDiffArr = [String]()
    var message_typeArray = [String]()
    var sender_imageArray = [String]()
    var receiver_imageArray = [String]()
    
    var chatsData: [[String:Any]]!
    
    @IBOutlet var backMsgView: UIView!
    //for image uploading
    var sendingImgPicker = UIImagePickerController()
    var pickerImage  = UIImage()
    
    var appDelegate = AppDelegate()
    var isKeyboardAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        //self.title = "Chat"
        self.navigationItem.title = languageChangeString(a_str: "Chat")
        placeholderlbl.text = languageChangeString(a_str: "Type here")
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.profileImg = UserDefaults.standard.object(forKey: "userImage") as? String
        
        
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "backwhite"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(self.onClcikBack), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        //navigationController?.navigationBar.barTintColor = UIColor.init(red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        myTblview.rowHeight = UITableView.automaticDimension
        myTblview.estimatedRowHeight = 10000
        
        if Reachability.isConnectedToNetwork() {
            
            self.chatingHistrory()
        }else
        {
            self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageSentCall), name: NSNotification.Name(rawValue:"messageSent"), object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardDidShowNotification), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardDidShow), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.logNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(KeyboardChangeFrame),name:UIResponder.keyboardDidChangeFrameNotification,object: nil)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
//        self.view.addGestureRecognizer(tapGesture)
//        tapGesture.cancelsTouchesInView = false
        

    }
    @objc func dismissKeyBoard()
    {
        msgTxtView.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
//            NotificationCenter.default.addObserver(  self,  selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
       
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       IQKeyboardManager.shared.enable = true
       IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    @objc func messageSentCall()
    {
        self.chatingHistrory()
    }

    @objc func onClcikBack()
    {
       // _ = self.navigationController?.popViewController(animated: true)
        let userType = UserDefaults.standard.object(forKey: "type") as? String
        if appDelegate.chatTypeStr == "appDelchat"{
            if userType == "2"{
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
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                print("setup type"); navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "SpHomeVC")], animated: false)
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let mainViewController = story.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: 3)
                
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = mainViewController
                UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            }
        }
        else{
        self.navigationController?.popViewController(animated: true)
        }
    }
  
    @IBAction func uploadImageBtnAction(_ sender: Any) {
        
        self.sendingImgPicker.allowsEditing = false
        self.sendingImgPicker.sourceType = .photoLibrary
        self.sendingImgPicker.delegate = self
        self.sendingImgPicker.mediaTypes = ["public.image"]
        self.present(self.sendingImgPicker, animated: true, completion: nil)
        
       /* let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Photo", style: .default) { action -> Void in
            
            //self.attachPickerCheckValue = 1
            self.sendingImgPicker.allowsEditing = false
            self.sendingImgPicker.sourceType = .photoLibrary
            self.sendingImgPicker.delegate = self
            self.sendingImgPicker.mediaTypes = ["public.image"]
            self.present(self.sendingImgPicker, animated: true, completion: nil)
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)*/
        
    }
    

    @IBAction func sendMsgBtnAction(_ sender: Any) {
        if msgTxtView.text.count > 0 {
            
            messages.append(("\(msgTxtView.text!)" as NSString) as String)
            typeDiffArr.append("1")
            
            textViewBack.isHidden = true
            self.view.endEditing(true)
            
            textViewBack.isHidden = false
            
            self.myTblview.scrollsToTop  = true
            if Reachability.isConnectedToNetwork() {
                
                self.messageSendServiceCall ()
            }else
            {
                self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                // showToastForAlert (message:"Please ensure you have proper internet connection.")
            }
            
            
        }
    }
    
    //MARK:- CHAT HISTORY SERVICE CALL
    func chatingHistrory()
    {
        // https://www.volive.in/mobilefix/services/chat_history?API-KEY=9173645&lang=en&request_id=5&sender_id=2&receiver_id=6
        let language = UserDefaults.standard.object(forKey: "currentLanguage")
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        let spId = UserDefaults.standard.object(forKey: "spId") as? String
        
        let gallery = "\(Base_Url)chat_history?"
        
        let parameters: Dictionary<String, Any> = ["API-KEY": APIKEY,"request_id":reqIdStr!, "sender_id" : userID! , "receiver_id" :providerIdStr!  ,"lang" : language ?? ""]
       // let parameters: Dictionary<String, Any> = ["API-KEY": APIKEY, "sender_id" : self.senderStr , "receiver_id" : self.recieverStr ,"lang" : language ?? ""]
        
        print(parameters)
        
        Alamofire.request(gallery, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as? Int
                let message = responseData["message"] as? String
                if status == 1
                {
                    
                    DispatchQueue.main.async {
                        
                        self.messages = [String]()
                        self.typeDiffArr = [String]()
                        self.dateArr = [String]()
                        self.message_typeArray = [String]()
                        self.sender_imageArray = [String]()
                        self.receiver_imageArray = [String]()
                        
                        let chat_data = responseData["chat_data"] as? [String:Any]
                        self.chatsData = chat_data?["chat_messages"] as? [[String:Any]]
                        print("chats data is\(self.chatsData!)")
                        for eachitem in self.chatsData! {
                            
                            let message = eachitem["message"] as? String
                            let time = eachitem["time"] as? String
                            let message_type = eachitem["message_type"] as? String
                            
                            let sender_image = eachitem["sender_image"] as? String
                            let receiver_image = eachitem["receiver_image"] as? String
                            
                            
                            let sender_id = eachitem["sender_id"] as? String
                            
                            // self.messages?.add("\(message!)" as NSString)
                            self.messages.append(("\(message!)" as NSString) as String)
                            self.dateArr.append(("\(time!)" as NSString) as String)
                            self.message_typeArray.append(("\(message_type!)" as NSString) as String)
                            self.sender_imageArray.append(String(format: "%@%@", base_path,sender_image!))
                            self.receiver_imageArray.append(String(format: "%@%@", base_path,receiver_image!))
                            
                            if sender_id == self.providerIdStr!
                                //self.senderStr
                            {
                                self.typeDiffArr.append("0")
                                
                            }else
                            {
                                self.typeDiffArr.append("1")
                            }
                        }
                        print(self.messages as Any)
                        print(self.typeDiffArr as Any)
                        print(self.message_typeArray as Any)
                        
                        self.myTblview.reloadData()
//
                        if self.messages.count > 0
                        {
                            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                            self.myTblview.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }else
                        {

                        }
                     
                    }
                    // self.myTblview.contentOffset = CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude)
                }
                else
                {
                    DispatchQueue.main.async {
                        
                        self.showToast(message: message!)
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                    }
                }
            }
        }
    }
    
    //MARK:MESSAGE SEND SERVICE CALL
    func messageSendServiceCall()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        /*
         API-KEY:9173645
         lang:en
         request_id:
         sender_id:
         receiver_id:
         message: (text)
         chat_file: (single file)*/
        
        let signup = "\(Base_Url)service_request_chat"
        
        //let deviceToken = "12345"
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        let parameters: Dictionary<String, Any> = [ "request_id" : reqIdStr!, "sender_id":userID!, "receiver_id" : providerIdStr!,"message":self.msgTxtView.text!, "chat_file":"","lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        
        Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                
                if status == 1
                {
                    if Reachability.isConnectedToNetwork() {
                        
                        self.chatingHistrory()
                    }else
                    {
                        self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                        // showToastForAlert (message:"Please ensure you have proper internet connection.")
                    }
                    
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.msgTxtView.text = ""
                        self.placeholderlbl .isHidden = false
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
    //IMAGE SENDING IN CHAT
    func imgSendCall()
    {
        /*
         API-KEY:9173645
         lang:en
         request_id:
         sender_id:
         receiver_id:
         message: (text)
         chat_file: (single file)*/
        
//        let userID = UserDefaults.standard.object(forKey: "userId") as! String
//        let doctorID = UserDefaults.standard.object(forKey: "doctorID") as! String
//        let language = UserDefaults.standard.object(forKey: "currentLanguage") as! String
//
//        let parameters: Dictionary<String, Any> = [ "sender_id" : userID , "receiver_id" : doctorID ,"status" : "2" , "message" : "" , "lang" : language ]
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let userID = UserDefaults.standard.object(forKey: "userId") as? String
        let parameters: Dictionary<String, Any> = [ "request_id" : reqIdStr!, "sender_id":userID!, "receiver_id" : providerIdStr!,"message":"","lang" : language,"API-KEY":APIKEY]
        
        print(parameters)
        print(parameters)
        
        //let imgData = UIImage.jpegData(pickerImage)
            //UIImageJPEGRepresentation(pickerImage, 0.2)!
        let imgData = pickerImage.jpegData(compressionQuality: 0.2)!
        print(imgData)
        
        print(parameters)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "chat_file",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         to:"\(Base_Url)service_request_chat")
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
                        if Reachability.isConnectedToNetwork() {
                            
                            self.chatingHistrory()
                        }else
                        {
                            self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
                            // showToastForAlert (message:"Please ensure you have proper internet connection.")
                        }
                       
                        DispatchQueue.main.async {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                        }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        //self.showToastForAlert(message: message)
                        self.showToast(message: message)
                    }

                }
                
            case .failure(let encodingError):
                print(encodingError)
                MobileFixServices.sharedInstance.dissMissLoader()
            }
        }
    }
    
  /*  @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            var height : CGFloat
            print("Notification: Keyboard will show")
            print("keyboard height show\(keyboardHeight)")
           // myTblview.setBottomInset(to: keyboardHeight)
           // self.myTblview.scrollsToTop = true
           // self.view.frame.origin.y = keyboardHeight
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
           
        print("Notification: Keyboard will hide")
            print("keyboard height hide\(keyboardHeight)")
        //myTblview.setBottomInset(to: 0.0)
            
            
        self.view.frame.origin.y += keyboardHeight
        }
    }*/
    
//    @objc func keyboardDidShowNotification(notification: NSNotification){
//        if !isKeyboardAppear {
//                        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                            if self.view.frame.origin.y == 0{
//                                self.view.frame.origin.y -= keyboardSize.height
//                                print("Notification: Keyboard will show")
//                                print("keyboard height show\(keyboardSize.height)")
//                                var contentInset:UIEdgeInsets = self.myTblview.contentInset
//                                contentInset.top = keyboardSize.height
//                                self.myTblview.contentInset = contentInset
//
//                                //get indexpath
//                                let indexpath = NSIndexPath(row: 1, section: 0)
//                                self.myTblview.scrollToRow(at: indexpath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
//                            }
//                        }
//                        isKeyboardAppear = true
//                    }
//                else
//                    {
//                        print("will show else\(isKeyboardAppear)")
//                }
//    }
    
   /* @objc func logNotification(notification: NSNotification){
    print("notification change\(notification)")
        if !isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                    print("Notification: logNotification")
                    print("keyboard height show logNotification\(keyboardSize.height)")
                    var contentInset:UIEdgeInsets = self.myTblview.contentInset
                    contentInset.top = keyboardSize.height
                    self.myTblview.contentInset = contentInset
                    if self.messages.count > 0{
                        //get indexpath
                        let indexpath = IndexPath(row: self.messages.count-1, section: 0)
                        //NSIndexPath(row: 1, section: 0)
                        self.myTblview.scrollToRow(at: indexpath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
                    }
                }
            }
            isKeyboardAppear = true
        }
        else
        {
            print("logNotification\(isKeyboardAppear)")
        }
    }*/
    @objc func keyboardDidShow(notification: NSNotification){
        print("keyboard didshow called")
        if !isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                    print("Notification: keyboard didshow called")
                    print("keyboard height didshow\(keyboardSize.height)")
                    var contentInset:UIEdgeInsets = self.myTblview.contentInset
                    contentInset.top = keyboardSize.height
                    self.myTblview.contentInset = contentInset
                    if self.messages.count > 0{
                    //get indexpath
                    let indexpath = IndexPath(row: self.messages.count-1, section: 0)
                        //NSIndexPath(row: 1, section: 0)
                    self.myTblview.scrollToRow(at: indexpath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
                    }
                }
            }
            isKeyboardAppear = true
        }
        else
        {
            print("keyboard didshow else\(isKeyboardAppear)")
        }
    }
@objc func keyboardWillShow(notification: NSNotification) {
    print("keyboard will show called")
//        if !isKeyboardAppear {
//            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y == 0{
//                    self.view.frame.origin.y -= keyboardSize.height
//                    print("Notification: Keyboard will show")
//                    print("keyboard height show\(keyboardSize.height)")
//                    var contentInset:UIEdgeInsets = self.myTblview.contentInset
//                    contentInset.top = keyboardSize.height
//                    self.myTblview.contentInset = contentInset
//
//                    //get indexpath
//                    let indexpath = NSIndexPath(row: 1, section: 0)
//                    self.myTblview.scrollToRow(at: indexpath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
//                }
//            }
//            isKeyboardAppear = true
//        }
//    else
//        {
//            print("will show else\(isKeyboardAppear)")
//    }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboard hide called")
        if isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                    print("Notification: Keyboard will hide")
                    print("keyboard height hide\(keyboardSize.height)")
                    let contentInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    self.myTblview.contentInset = contentInset
     
                }
            }
            isKeyboardAppear = false
        }
        else
        {
            print("will hide else\(isKeyboardAppear)")
        }
    }
    @objc func KeyboardChangeFrame(_ notification: Notification){
        print("keyboardwillchangeframe called")
        UIApplication.shared.keyWindow?.backgroundColor = UIColor.white
         if isKeyboardAppear {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print("New Keyboard Height:",keyboardHeight)
            
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                print("Notification: Keyboard will show")
                print("keyboard height show\(keyboardSize.height)")
                var contentInset:UIEdgeInsets = self.myTblview.contentInset
                contentInset.top = keyboardSize.height
                self.myTblview.contentInset = contentInset
                if self.messages.count > 0{
                    //get indexpath
                    let indexpath = IndexPath(row: self.messages.count-1, section: 0)
                    //NSIndexPath(row: 1, section: 0)
                    self.myTblview.scrollToRow(at: indexpath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
                }
            }
            
            
        }
             isKeyboardAppear = true
        }
         else{
            print("keyboard will change frame")
        }
    }
/*  @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            //self.view.frame.origin.y -= keyboardSize.height
            var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)

            var contentInset:UIEdgeInsets = self.myTblview.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.myTblview.contentInset = contentInset

            //get indexpath
            let indexpath = NSIndexPath(row: 1, section: 0)
            self.myTblview.scrollToRow(at: indexpath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }*/
    
    
//    @objc func keyboardWillShow(_ notification: Notification) {
//
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//
//            UserDefaults.standard.set(keyboardHeight, forKey: "key")
//
//             print("keyboardHeight\(keyboardHeight)")
//        }
//    }
    
   

}
extension UITableView {
    
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
        
        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}
extension ChatVC : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
////
//        NotificationCenter.default.addObserver(  self,  selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil
//        )
        
        
//        var yOffset : CGFloat
//        yOffset = 0
//        if self.myTblview.contentSize.height > self.myTblview.bounds.size.height{
//            yOffset = self.myTblview.contentSize.height - self.myTblview.bounds.size.height
//        }
//        self.myTblview.setContentOffset(CGPoint.init(x: 0, y: yOffset), animated: false)
//        self.myTblview.reloadData()
//
//        DispatchQueue.main.async {
//            if self.messages.count >= 1 {
//                let section = self.messages.count - 1
//                let row = self.messages[section].count - 1
//                let indexPath = IndexPath(row: row, section: 0 )
//                self.myTblview.scrollToRow(at: indexPath, at: .top, animated: true)
//            }
//        }

        
        return true
        
    }
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        if self.msgTxtView.text == ""{
//            msgTxtView.text = "type here.."
//        }
//        return true
//    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//        placeholderlbl.isHidden = true
//
////        msgTxtView.layer.borderColor = UIColor (red: 252.0/255.0, green: 64.0/255.0, blue: 65.0/255.0, alpha: 1.0).cgColor
////        msgTxtView.layer.borderWidth = 1.0
//
//    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        placeholderlbl.isHidden = true;
        
     //   let myString = UserDefaults.standard.object(forKey: "key") as? CGFloat
//
//        UIView.animate(withDuration: 0.3, animations: {
//            //y: self.textViewBack.frame.origin.y - myString!
//            self.textViewBack.frame = CGRect(x:self.textViewBack.frame.origin.x, y: self.textViewBack.frame.origin.y, width:self.textViewBack.frame.size.width, height:self.textViewBack.frame.size.height);
//
//            self.myTblview.frame = CGRect(x: self.myTblview.frame.origin.x, y: self.myTblview.frame.origin.y , width: self.myTblview.frame.size.width, height: self.myTblview.frame.size.height)
//            //height: self.myTblview.frame.size.height - myString!
//            if self.messages.count > 0{
//
//                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
//                self.myTblview.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }else
//            {
//            }
//        })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
      //  let myString = UserDefaults.standard.object(forKey: "key") as? CGFloat
        
        UIView.animate(withDuration: 0.3, animations: {
            
//            self.roleStr = UserDefaults.standard.object(forKey: "role") as! String
//
//            if self.roleStr == "user"
//            {
//                self.textViewBack.frame = CGRect(x:self.textViewBack.frame.origin.x, y:self.textViewBack.frame.origin.y + myString! , width:self.textViewBack.frame.size.width, height:self.textViewBack.frame.size.height)
//
//                self.myTblview.frame = CGRect(x: self.myTblview.frame.origin.x, y: self.myTblview.frame.origin.y, width: self.myTblview.frame.size.width, height: self.view.frame.size.height - (self.textViewBack.frame.size.height + 60))
//            }else
//            {
//                self.textViewBack.frame = CGRect(x:self.textViewBack.frame.origin.x, y:self.textViewBack.frame.origin.y + myString! , width:self.textViewBack.frame.size.width, height:self.textViewBack.frame.size.height)
//
//                self.myTblview.frame = CGRect(x: self.myTblview.frame.origin.x, y: self.myTblview.frame.origin.y, width: self.myTblview.frame.size.width, height: self.view.frame.size.height - self.textViewBack.frame.size.height)
//            }
            //
          /*  self.textViewBack.frame = CGRect(x:self.textViewBack.frame.origin.x, y:self.textViewBack.frame.origin.y + myString!, width:self.textViewBack.frame.size.width, height:self.textViewBack.frame.size.height)

            self.myTblview.frame = CGRect(x: self.myTblview.frame.origin.x, y: self.myTblview.frame.origin.y, width: self.myTblview.frame.size.width, height: self.view.frame.size.height + myString!)
                //self.view.frame.size.height - self.textViewBack.frame.size.height)*/
            
//                self.textViewBack.frame = CGRect(x:self.textViewBack.frame.origin.x, y:self.textViewBack.frame.origin.y + myString! , width:self.textViewBack.frame.size.width, height:self.textViewBack.frame.size.height)
//
//                self.myTblview.frame = CGRect(x: self.myTblview.frame.origin.x, y: self.myTblview.frame.origin.y, width: self.myTblview.frame.size.width, height: self.view.frame.size.height - self.textViewBack.frame.size.height)
           // self.textViewBack.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            //y:self.textViewBack.frame.origin.y + myString!
//            self.textViewBack.frame = CGRect(x:self.textViewBack.frame.origin.x, y:self.textViewBack.frame.origin.y, width:self.textViewBack.frame.size.width, height:self.textViewBack.frame.size.height)
//            self.myTblview.frame = CGRect(x: self.myTblview.frame.origin.x, y: self.myTblview.frame.origin.y, width: self.myTblview.frame.size.width, height: self.view.frame.size.height - (self.textViewBack.frame.size.height))

           
        })
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource , UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        if messages.count == 0
            //nil
        {
            return 0
        }
        else{
            return (messages.count)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell : ChatTextCell
        
        if "\(typeDiffArr[indexPath.row])" == "0" {
            
            if message_typeArray[indexPath.row] == "text"{
                cell = myTblview.dequeueReusableCell(withIdentifier: "cell1") as! ChatTextCell
                
                cell.otherMsgLbl.text = "\(messages[indexPath.row] as NSString)"
                
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapLink))
//                //UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
//                cell.otherMsgLbl.addGestureRecognizer(tap)
                //cell.otherMsgLbl.isUserInteractionEnabled = true
                
                
                
                cell.othertimeLbl.text = "\(dateArr[indexPath.row] as NSString)"
                cell.otherPimage.sd_setImage(with: URL(string: sender_imageArray[indexPath.row] ), placeholderImage: UIImage(named:"profile"))
                
                //cell.otherBackView.layer.cornerRadius = 3.0
                DispatchQueue.main.async {
                    cell.otherBackView.layer.masksToBounds = true
                    cell.otherBackView.roundCorners(corners: [.topRight,.bottomLeft,.bottomRight], radius: 10.0)
                    
                    cell.otherPimage.layer.cornerRadius = cell.otherPimage.frame.size.height/2
                    cell.otherPimage.clipsToBounds = true
                }
                
                
                if indexPath.row != 0{
                    
                    if "\(typeDiffArr[indexPath.row])" == "\(typeDiffArr[indexPath.row - 1])"{
                        
                        DispatchQueue.main.async {
                            cell.otherPimage.layer.cornerRadius = cell.otherPimage.frame.size.height/2
                            cell.otherPimage.clipsToBounds = true
                        }
                       
                        
                        if self.profileImg == nil
                        {
                            cell.otherPimage.image = UIImage(named:"profile")
                        }else
                        {
                            
                            cell.otherPimage.sd_setImage(with: URL(string: sender_imageArray[indexPath.row] ), placeholderImage: UIImage(named:"profile"))
                        }
                        
                    }else{
                        //cell.otherPimage.isHidden = true
                        DispatchQueue.main.async {
                        cell.otherPimage.layer.cornerRadius = cell.otherPimage.frame.size.height/2
                        cell.otherPimage.clipsToBounds = true
                        }
                        // cell.otherPimage.sd_setImage(with: URL(string: self.profileImg! ), placeholderImage: UIImage(named:"profile pic"))
                        
                        //COM JUST cell.otherPimage.isHidden = false
                        if self.profileImg == nil
                        {
                            cell.otherPimage.image = UIImage(named:"profile")
                        }else
                        {
                            
                            cell.otherPimage.sd_setImage(with: URL(string: sender_imageArray[indexPath.row] ), placeholderImage: UIImage(named:"profile"))
                        }
                    }
                }
                return cell
            }
                
           else if message_typeArray[indexPath.row] == "image"{
                cell = myTblview.dequeueReusableCell(withIdentifier: "cell4") as! ChatTextCell
                cell.otherReceiveImageView.sd_setImage(with: URL(string: String(format: "%@%@", base_path, messages[indexPath.row])), placeholderImage: UIImage(named:"pdfImage"))
                cell.otherImageTimeLabel.text = "\(dateArr[indexPath.row] as NSString)"
                DispatchQueue.main.async {
                cell.otherProfileImageCell4.layer.cornerRadius = cell.otherProfileImageCell4.frame.size.height/2
                cell.otherProfileImageCell4.clipsToBounds = true
                }
                cell.otherProfileImageCell4.sd_setImage(with: URL(string: sender_imageArray[indexPath.row] ), placeholderImage: UIImage(named:"profile"))
                DispatchQueue.main.async {
                    cell.otherImageBackView.layer.masksToBounds = true
                    cell.otherImageBackView.roundCorners(corners: [.topRight,.bottomLeft,.bottomRight], radius: 10.0)
                }
                return cell
            }
    
        }
        
            //my msg
        else if "\(typeDiffArr[indexPath.row])" == "1"{
            
            if message_typeArray[indexPath.row] == "text"{
                cell = myTblview.dequeueReusableCell(withIdentifier: "cell2") as! ChatTextCell
                cell.myMsgLbl.text = "\(messages[indexPath.row])"
                cell.mytimeLbl.text = "\(dateArr[indexPath.row] as NSString)"
                cell.myImage.sd_setImage(with: URL(string: self.profileImg! ), placeholderImage: UIImage(named:"profile"))
                //cell.myBackView.layer.cornerRadius = 3.0
                
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTapLink))
//                //UITapGestureRecognizer(target: self, action: #selector("tapFunction:"))
//                cell.myMsgLbl.addGestureRecognizer(tap)
               // cell.myMsgLbl.isUserInteractionEnabled = true
                
//                if let url = URL(string: String(format: "%@%@", "http://", messages[indexPath.row])) {
//                    if UIApplication.shared.canOpenURL(url) {
//                        if #available(iOS 10.0, *) {
//                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                        } else {
//                            UIApplication.shared.openURL(url)
//                        }
//                    }
//                }
//                else{
//                    print("fail")
//                }
                
                DispatchQueue.main.async {
                    cell.myImage.layer.cornerRadius = cell.myImage.frame.size.height/2
                    cell.myImage.clipsToBounds = true
                cell.myBackView.layer.masksToBounds = true
                cell.myBackView.roundCorners(corners: [.topLeft,.bottomLeft,.bottomRight], radius: 10.0)
                }
                if indexPath.row != 0{
                    
                    if "\(typeDiffArr[indexPath.row])" == "\(typeDiffArr[indexPath.row - 1])"{
                        DispatchQueue.main.async {
                        cell.myImage.layer.cornerRadius = cell.myImage.frame.size.height/2
                        cell.myImage.clipsToBounds = true
                        }
                        if self.profileImg == nil
                        {
                            cell.myImage.image = UIImage(named:"profile")
                        }else
                        {
                            cell.myImage.sd_setImage(with: URL(string: self.profileImg! ), placeholderImage: UIImage(named:"profile"))
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                        cell.myImage.layer.cornerRadius = cell.myImage.frame.size.height/2
                        cell.myImage.clipsToBounds = true
                        }
                        if self.profileImg == nil
                        {
                            cell.myImage.image = UIImage(named:"profile")
                        }else
                        {
                            cell.myImage.sd_setImage(with: URL(string: self.profileImg! ), placeholderImage: UIImage(named:"profile"))
                        }
                    }
                }
                return cell
            }
            else if message_typeArray[indexPath.row] == "image"{
                    cell = myTblview.dequeueReusableCell(withIdentifier: "cell3") as! ChatTextCell
                    cell.mySendImageView.sd_setImage(with: URL(string: String(format: "%@%@", base_path, messages[indexPath.row])), placeholderImage: UIImage(named:"pdfImage"))
                    cell.myImageTimeLabel.text = "\(dateArr[indexPath.row] as NSString)"
                DispatchQueue.main.async {
                    cell.myProfileImageCell3.layer.cornerRadius = cell.myProfileImageCell3.frame.size.height/2
                    cell.myProfileImageCell3.clipsToBounds = true
                }
                    cell.myProfileImageCell3.sd_setImage(with: URL(string: self.profileImg! ), placeholderImage: UIImage(named:"profile"))
                    DispatchQueue.main.async {
                    cell.myImageBackView.layer.masksToBounds = true
                    cell.myImageBackView.roundCorners(corners: [.topLeft,.bottomLeft,.bottomRight], radius: 10.0)
                }
                return cell
            }
   
        }
        return UITableViewCell()
    }

//    @objc func onTapLink(sender:UITapGestureRecognizer) {
//
//        print("tap working")
//
//        if let url = URL(string: "") {
//            if UIApplication.shared.canOpenURL(url) {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            }
//        }
//        else{
//            print("fail")
//        }
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if message_typeArray[indexPath.row] == "text"{
            return UITableView.automaticDimension
        }
        else{
            return 141
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if message_typeArray[indexPath.row] == "text"{
            print("tap working")
            
            if let url = URL(string: messages[indexPath.row]) {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                else{
                    print("failed")
                }
            }
            else{
                print("fail")
            }
        }
        else if message_typeArray[indexPath.row] == "image"{
        
            let zoomVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageVC") as! ZoomImageVC
            UserDefaults.standard.set(self.messages[indexPath.row], forKey: "selectedImage")
            //UserDefaults.standard.set(self.mediaTypeArray, forKey: "mediaType")
            
            self.present(zoomVC, animated: true, completion: nil)
        }
    }
}


extension ChatVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage2 = info[UIImagePickerController.InfoKey.originalImage]
            pickerImage = (pickedImage2 as? UIImage)!
            dismiss(animated:true, completion: nil)
        if Reachability.isConnectedToNetwork() {
            
            self.imgSendCall()
        }else
        {
            self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!)
            // showToastForAlert (message:"Please ensure you have proper internet connection.")
        }
        
    }
    
}


