//
//  FilterVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 21/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit
import MOLH

class FilterVC: UIViewController {

    @IBOutlet var filterStaticLabel: UILabel!
    
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var priceStaticLabel: UILabel!
    @IBOutlet var applyFilterBtn: UIButton!
    
    //for date picker
    var datePicker : UIDatePicker?
    var dateToolBar : UIToolbar?
    var currentTF : UITextField?
    
    @IBOutlet var orderFromDate: UITextField!
    @IBOutlet var orderToDate: UITextField!
    
    @IBOutlet var statusTF: UITextField!
    
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var priceSlider: UISlider!
    //0=pending,1=completed,2=in progress,3=cancelled
    var statusString : String! = ""
    var statusArray = [languageChangeString(a_str: "pending"),languageChangeString(a_str:"completed"),languageChangeString(a_str:"in progress"),languageChangeString(a_str:"cancelled")]
    var statusIdArray = ["0","1","2","3"]
    var statusIdString : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        showDatePicker()
        
        self.filterStaticLabel.text = languageChangeString(a_str: "Filters")
        self.priceStaticLabel.text = languageChangeString(a_str: "Price")
        self.resetBtn.setTitle(languageChangeString(a_str: "RESET"), for: UIControl.State.normal)
        self.applyFilterBtn.setTitle(languageChangeString(a_str: "APPLY FILTERS"), for: UIControl.State.normal)
        self.orderFromDate.placeholder = languageChangeString(a_str: "Order from date")
        self.orderToDate.placeholder = languageChangeString(a_str: "Order to date")
        self.statusTF.placeholder = languageChangeString(a_str: "Select Status")
        
        self.orderFromDate.text = UserDefaults.standard.object(forKey: "key") as? String ?? ""
        self.orderToDate.text = UserDefaults.standard.object(forKey: "key1") as? String ?? ""
        self.priceLabel.text = UserDefaults.standard.object(forKey: "key2") as? String ?? ""
        self.statusTF.text = UserDefaults.standard.object(forKey: "key5") as? String ?? ""
        self.statusIdString = UserDefaults.standard.object(forKey: "key3") as? String ?? ""
        
        let myString = UserDefaults.standard.object(forKey: "key2") as? String ?? ""
        let myFloat = (myString as NSString).floatValue
        priceSlider.value = myFloat
        
         if MOLHLanguage.isRTLLanguage(){
            self.statusTF.textAlignment = .right
            self.orderFromDate.textAlignment = .right
            self.orderToDate.textAlignment = .right
            
         }else{
            self.statusTF.textAlignment = .left
            self.orderFromDate.textAlignment = .left
            self.orderToDate.textAlignment = .left
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSelectedDate(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSelectedToDate(_:)), name: NSNotification.Name(rawValue: "notificationName1"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func getSelectedDate(_ notification: NSNotification)
    {
       
        if let dateStr = notification.userInfo?["date1"] as? String {
            // do something with your image
            self.orderFromDate.text = dateStr
            //self.orderToDate.text = dateStr
            print(dateStr)
        }
        
    }
    
    @objc func getSelectedToDate(_ notification: NSNotification)
    {
        
        if let dateStr = notification.userInfo?["date2"] as? String {
            // do something with your image
            
            self.orderToDate.text = dateStr
            print(dateStr)
        }
        
    }
    //MARK:SHOW DATE PICKER
    func showDatePicker(){
        datePicker = UIDatePicker()
        //datePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        datePicker?.datePickerMode = .date
        datePicker?.backgroundColor = UIColor.white
        dateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        dateToolBar?.barStyle = .blackOpaque
        dateToolBar?.autoresizingMask = .flexibleWidth
        dateToolBar?.barTintColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        
        dateToolBar?.frame = CGRect(x: 0,y: (datePicker?.frame.origin.y)!-44, width: self.view.frame.size.width,height: 44)
        dateToolBar?.barStyle = UIBarStyle.default
        dateToolBar?.isTranslucent = true
        dateToolBar?.tintColor = UIColor.init(red: 32.0/255.0, green: 147.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        dateToolBar?.backgroundColor = UIColor.init(red: 32.0/255.0, green: 147.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        dateToolBar?.sizeToFit()
        
        let doneButton = UIBarButtonItem(title:languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(FilterVC.donePickerDate))
        doneButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title:languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(FilterVC.canclePickerDate))
        cancelButton.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        dateToolBar?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dateToolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        self.orderFromDate.inputView = datePicker
//        self.orderFromDate.inputAccessoryView = dateToolBar
//        self.orderToDate.inputView = datePicker
//        self.orderToDate.inputAccessoryView = dateToolBar
        // self.datePicker?.minimumDate =
//        let date = Date()
//        let calendar = Calendar(identifier: .indian)
//        var components = DateComponents()
//        components.day = 0
//        // let newDate: Date? = calendar.date(byAdding: components, to: date, options: [])
//        //let newDate: Date? = calendar.date(byAdding: components, to:date, wrappingComponents:)
//        let newDate : Date? = calendar.date(byAdding: components, to: date)
//        datePicker?.minimumDate = newDate
        
    }
    //MARK:DONE PICKER DATE
    @objc func donePickerDate ()
    {
        //datePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        if currentTF == orderFromDate{
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            //txt_date.textAlignment = NSTextAlignment.left
            orderFromDate.text! = formatter.string(from: (datePicker?.date)!)
            self.view.endEditing(true)
            orderFromDate.resignFirstResponder()
            
        }
        else{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                //txt_date.textAlignment = NSTextAlignment.left
                orderToDate.text! = formatter.string(from: (datePicker?.date)!)
                self.view.endEditing(true)
                orderToDate.resignFirstResponder()
        }
   
    }
    
    //MARK:CANCEL PICKER DATE
    @objc func canclePickerDate ()
    {
        self.view.endEditing(true)
        orderFromDate.resignFirstResponder()
        orderToDate.resignFirstResponder()
    }
    
    //for status selection pickerview
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
        
        
        let doneButton1 = UIBarButtonItem(title: languageChangeString(a_str: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        self.statusTF.inputView = self.pickerView
        self.statusTF.inputAccessoryView = self.pickerToolBar
        
        self.pickerView?.reloadInputViews()
        self.pickerView?.reloadAllComponents()
        
    }
  
    
    @objc func donePickerView(){
        
        self.statusString = statusArray[(pickerView?.selectedRow(inComponent: 0))!]
        self.statusTF.text = self.statusString
        //brandIdString = brandIDArray[0]
        statusIdString = statusIdArray[(pickerView?.selectedRow(inComponent: 0))!]
        if statusString.count > 0{
            self.statusTF.text = self.statusString ?? ""
        }else{
            self.statusTF.text = statusArray[0]
        }
     
        self.view.endEditing(true)
        statusTF.resignFirstResponder()
   
    }
    
    @objc func cancelPickerView(){
      
        if (statusTF.text?.count)! > 0 {
            self.view.endEditing(true)
            statusTF.resignFirstResponder()
        }else{
            self.view.endEditing(true)
            statusTF.text = ""
            statusTF.resignFirstResponder()
        }
        statusTF.resignFirstResponder()
    }
    
    
    @IBAction func resetAction(_ sender: Any) {
        priceSlider.value = Float(0)
        priceLabel.text = "0 SAR"
        orderFromDate.text = ""
        orderToDate.text = ""
        statusTF.text = ""
        statusIdString = ""
        UserDefaults.standard.removeObject(forKey: "key")
        UserDefaults.standard.removeObject(forKey: "key1")
        UserDefaults.standard.removeObject(forKey: "key2")
        UserDefaults.standard.removeObject(forKey: "key3")
        UserDefaults.standard.removeObject(forKey: "key5")
    }
    
    @IBAction func sliderPriceChange(_ sender: UISlider) {
//        var currentValue = Int(sender.value)
//        print("Slider changing to \(currentValue) ?")
//        dispatch_async(dispatch_get_main_queue(){
//            priceSlider.text = "\(currentValue) Km"
//        })
        
        var currentValue = Int(sender.value)
        print("Slider changing to \(currentValue) ?")
        priceLabel.text = "\(currentValue) SAR"
        
    }
   
    @IBAction func CloseAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func applyFilterAction(_ sender: Any) {
        
        //UserDefaults.standard.setValue("filter", forKey: "filter")
     
        UserDefaults.standard.setValue(self.orderFromDate.text!, forKey: "key")
        UserDefaults.standard.setValue(self.orderToDate.text!, forKey: "key1")
        UserDefaults.standard.setValue(self.priceLabel.text!, forKey: "key2")
        UserDefaults.standard.setValue(self.statusIdString!, forKey: "key3")
        UserDefaults.standard.setValue(self.statusTF.text!, forKey: "key5")
        
        let imageDataDict:[String: String] = ["key": self.orderFromDate.text!,"key1":orderToDate.text!,"key2":priceLabel.text!,"key3": statusIdString!,"key4": "filter","key5": self.statusTF.text!]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getUserFilterData"), object: nil, userInfo: imageDataDict)
        
        //commented on 30
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func orderFromDateAction(_ sender: Any) {
        
       /*instead of islamic calender show date picker let CalenderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
        UserDefaults.standard.set("fromDate", forKey: "fromTo")
        self.present(CalenderVC, animated: true, completion: nil)*/
    }
    
    
    @IBAction func orderToDateAction(_ sender: Any) {
       /*instead of islamic calender show date picker let CalenderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalenderVC") as! CalenderVC
        UserDefaults.standard.set("toDate", forKey: "fromTo")
        self.present(CalenderVC, animated: true, completion: nil)*/
    }
}

extension FilterVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        // Row count: rows equals array length.
        return statusArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        return statusArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.statusTF.text =  statusArray[row]
        self.statusString = statusArray[row]
        statusIdString = statusIdArray[row]
        
    }
}

extension FilterVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.orderFromDate{
            let date = Date()
            let calendar = Calendar(identifier: .indian)
            var components = DateComponents()
            components.day = 0
            // let newDate: Date? = calendar.date(byAdding: components, to: date, options: [])
            //let newDate: Date? = calendar.date(byAdding: components, to:date, wrappingComponents:)
            let newDate : Date? = calendar.date(byAdding: components, to: date)
            //datePicker?.minimumDate = newDate
            self.orderFromDate.inputView = datePicker
            self.orderFromDate.inputAccessoryView = dateToolBar
        }
        else{
            let date = Date()
            let calendar = Calendar(identifier: .indian)
            var components = DateComponents()
            components.day = 0
            // let newDate: Date? = calendar.date(byAdding: components, to: date, options: [])
            //let newDate: Date? = calendar.date(byAdding: components, to:date, wrappingComponents:)
            let newDate : Date? = calendar.date(byAdding: components, to: date)
           // datePicker?.minimumDate = newDate
            self.orderToDate.inputView = datePicker
            self.orderToDate.inputAccessoryView = dateToolBar
        }
        currentTF = textField;
        return true
    }
}


