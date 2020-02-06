//
//  SpFilterVC.swift
//  Saleem-SP
//
//  Created by volive solutions on 21/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit
import MOLH
class SpFilterVC: UIViewController {

    //for date picker
    var datePicker : UIDatePicker?
    var dateToolBar : UIToolbar?
    var currentTF : UITextField?
    
    @IBOutlet var applyFilterBtn: UIButton!
    @IBOutlet var filterStaticLabel: UILabel!
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var priceStaticLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var priceSlider: UISlider!
    @IBOutlet weak var txt_OrderToDate: UITextField!
    @IBOutlet weak var txt_OrderDate: UITextField!
    @IBOutlet weak var txt_Percentage: UITextField!
    @IBOutlet weak var txt_FiterPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterStaticLabel.text = languageChangeString(a_str: "Filters")
        priceStaticLabel.text = languageChangeString(a_str: "Price")
        resetBtn.setTitle(languageChangeString(a_str: "RESET"), for: UIControl.State.normal)
        applyFilterBtn.setTitle(languageChangeString(a_str: "APPLY FILTERS"), for: UIControl.State.normal)
        self.txt_OrderDate.placeholder = languageChangeString(a_str: "Order from date")
        self.txt_OrderToDate.placeholder = languageChangeString(a_str: "Order to date")
        self.txt_Percentage.placeholder = languageChangeString(a_str: "Percentage")
        
        showDatePicker()
        
        if MOLHLanguage.isRTLLanguage(){
            self.txt_OrderDate.textAlignment = .right
            self.txt_OrderToDate.textAlignment = .right
            
        }else{
            self.txt_OrderDate.textAlignment = .left
            self.txt_OrderToDate.textAlignment = .left
        }
        
        self.txt_OrderDate.text = UserDefaults.standard.object(forKey: "key") as? String ?? ""
        self.txt_OrderToDate.text = UserDefaults.standard.object(forKey: "key1") as? String ?? ""
        self.priceLabel.text = UserDefaults.standard.object(forKey: "key2") as? String ?? ""
        
        let myString = UserDefaults.standard.object(forKey: "key2") as? String ?? ""
        let myFloat = (myString as NSString).floatValue
        priceSlider.value = myFloat
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSelectedDate(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSelectedToDate(_:)), name: NSNotification.Name(rawValue: "notificationName1"), object: nil)
        
        self.txt_OrderDate.setBottomLineBorder()
        self.txt_OrderToDate.setBottomLineBorder()
   
    }

    @objc func getSelectedDate(_ notification: NSNotification)
    {
        if let dateStr = notification.userInfo?["date1"] as? String {
            // do something with your image
            self.txt_OrderDate.text = dateStr
            //self.orderToDate.text = dateStr
            print(dateStr)
        }
        
    }
    
    @objc func getSelectedToDate(_ notification: NSNotification)
    {
            if let dateStr = notification.userInfo?["date2"] as? String {
            // do something with your image
            
            self.txt_OrderToDate.text = dateStr
            print(dateStr)
        }
        
    }
    
 
    @IBAction func btn_Close_Action(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
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
            //UIColor.init(red: 32.0/255.0, green: 147.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
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
     
    }
    //MARK:DONE PICKER DATE
    @objc func donePickerDate ()
    {
        if currentTF == txt_OrderDate{
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            //txt_date.textAlignment = NSTextAlignment.left
            txt_OrderDate.text! = formatter.string(from: (datePicker?.date)!)
            self.view.endEditing(true)
            txt_OrderDate.resignFirstResponder()
            
        }
        else{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            //txt_date.textAlignment = NSTextAlignment.left
            txt_OrderToDate.text! = formatter.string(from: (datePicker?.date)!)
            self.view.endEditing(true)
            txt_OrderToDate.resignFirstResponder()
        }
        
    }
    
    //MARK:CANCEL PICKER DATE
    @objc func canclePickerDate ()
    {
        self.view.endEditing(true)
        txt_OrderDate.resignFirstResponder()
        txt_OrderToDate.resignFirstResponder()
    }
    @IBAction func btn_Reset_Action(_ sender: UIButton) {
        //var currentValue = Int(sender.value)
        priceSlider.value = Float(0)
        txt_Percentage.text = ""
        //priceLabel.text = "0 SAR"
        priceLabel.text = ""
        txt_OrderDate.text = ""
        txt_OrderToDate.text = ""
        UserDefaults.standard.removeObject(forKey: "key")
        UserDefaults.standard.removeObject(forKey: "key1")
        UserDefaults.standard.removeObject(forKey: "key2")
    }
    
    @IBAction func sliderPriceAction(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        print("Slider changing to \(currentValue) ?")
        priceLabel.text = "\(currentValue) SAR"
    }
  
    
    @IBAction func btn_ApplyFilter_Action(_ sender: UIButton) {
        
        UserDefaults.standard.setValue(self.txt_OrderDate.text!, forKey: "key")
        UserDefaults.standard.setValue(self.txt_OrderToDate.text!, forKey: "key1")
        UserDefaults.standard.setValue(self.priceLabel.text!, forKey: "key2")
      
        
        let imageDataDict:[String: String] = ["key": self.txt_OrderDate.text!,"key1":txt_OrderToDate.text!,"key2":priceLabel.text!,"key3": "spfilter"]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getSPFilterData"), object: nil, userInfo: imageDataDict)
        
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


extension SpFilterVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txt_OrderDate{
            let date = Date()
            let calendar = Calendar(identifier: .indian)
            var components = DateComponents()
            components.day = 0
            // let newDate: Date? = calendar.date(byAdding: components, to: date, options: [])
            //let newDate: Date? = calendar.date(byAdding: components, to:date, wrappingComponents:)
            let newDate : Date? = calendar.date(byAdding: components, to: date)
            //datePicker?.minimumDate = newDate
            self.txt_OrderDate.inputView = datePicker
            self.txt_OrderDate.inputAccessoryView = dateToolBar
        }
        else{
            let date = Date()
            let calendar = Calendar(identifier: .indian)
            var components = DateComponents()
            components.day = 0
            // let newDate: Date? = calendar.date(byAdding: components, to: date, options: [])
            //let newDate: Date? = calendar.date(byAdding: components, to:date, wrappingComponents:)
            let newDate : Date? = calendar.date(byAdding: components, to: date)
            //datePicker?.minimumDate = newDate
            self.txt_OrderToDate.inputView = datePicker
            self.txt_OrderToDate.inputAccessoryView = dateToolBar
        }
        currentTF = textField;
        return true
    }
}
