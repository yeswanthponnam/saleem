//
//  CalenderVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 18/02/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit


class CalenderVC: UIViewController,BSIslamicCalendarDelegate {
    
    
    @IBOutlet var backView: UIView!
    
   
    @IBOutlet var calender_View: BSIslamicCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calender_View.setIslamicDatesInArabicLocale(true)
//        calender_View.setNeedsLayout()
//        calender_View.setNeedsDisplay()
//        calender_View.setShortInitials(true)
        calender_View.setShowIslamicMonth(true)
        calender_View.delegate = self

        
        
//        self.backView.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.7764705882, blue: 0.7137254902, alpha: 1)
//        self.backView.layer.cornerRadius = 5.0
//        self.backView.layer.borderWidth = 2.0 
        
        
    }

    
    func islamicCalendar(_ calendar: BSIslamicCalendar!, shouldSelect date: Date!) -> Bool {
        print("date %@",date)
     
        
        let dateString : String?
//        let formatter = DateFormatter()
//        //formatter.locale = Locale.init(identifier: "ar")
//        formatter.dateFormat = "yyyy-MM-dd"
//        dateString = formatter.string(from: date as Date)
        
        let islamic = NSCalendar(identifier:NSCalendar.Identifier.islamicCivil)!
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .long
        formatter1.timeStyle = .medium
        formatter1.calendar = islamic as Calendar
        formatter1.dateFormat = "yyyy-MM-dd"
        //formatter1.locale = NSLocale(localeIdentifier: "ar_SA") as Locale
        formatter1.string(from: date as Date)
        
        dateString = formatter1.string(from: date as Date)
        print("new format",dateString!)
        
//        let neDate = formatter1.date(from: dateString!)
//
//        var components = DateComponents()
//        components.day = 0
//        let newDate : Date? = islamic.date(byAdding: components, to: neDate!)
//
//        print(neDate!)
//        print(newDate!)
        
        let imageDataDict:[String: String] = ["date1": dateString!]
      let imageDataDict1:[String: String] = ["date2": dateString!]
        
        let compstr : String?
        compstr = UserDefaults.standard.object(forKey: "fromTo") as? String ?? ""
        
        if compstr == "fromDate"{
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
        }
        else  if compstr == "toDate"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName1"), object: nil, userInfo: imageDataDict1)
        }
      
      

//        if islamicCalendar(calendar, shouldSelect: date){
//            return true
//        }
//        else{
//            return false
//        }
        
        
        
        if calendar.compare(date, with: date){
            return false
        }
        else{
            return true
        }
        //return false

    }
    
    func islamicCalendar(_ calendar: BSIslamicCalendar!, dateSelected date: Date!, withSelectionArray selectionArry: [Any]!) {
        print(selectionArry)
        print("selected date is %@",date)
        
      //        NSLog(dat@"selections: %@",selectionArry);
        
    }
    
   
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
