//
//  ViewController.swift
//  Saleem
//
//  Created by Suman Guntuka on 18/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class SelectUserTypeVC: UIViewController {
    
    @IBOutlet var customerBtn: UIButton!
    @IBOutlet var providerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customerBtn.setTitle(languageChangeString(a_str: "CUSTOMER"), for: UIControl.State.normal)
        self.providerBtn.setTitle(languageChangeString(a_str: "PROVIDER"), for: UIControl.State.normal)
        
        self.customerBtn.layer.borderColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        self.providerBtn.layer.borderColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        
        self.customerBtn.layer.borderWidth = 1.0
        self.providerBtn.layer.borderWidth = 1.0
       
    }

    override func  viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func customerBtnAction(_ sender: Any) {
        
        self.customerBtn.backgroundColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        self.customerBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        self.providerBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.providerBtn.setTitleColor(#colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1), for: UIControl.State.normal)
        
        self.customerBtn.layer.borderColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        self.providerBtn.layer.borderColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        
        self.customerBtn.layer.borderWidth = 1.0
        self.providerBtn.layer.borderWidth = 1.0
        
       // UserDefaults.standard.setValue("1", forKey: "type")
        UserDefaults.standard.setValue("2", forKey: "type")
        UserDefaults.standard.set(true, forKey: "log")
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(login, animated: false)
  
    }
    
    @IBAction func providerBtnAction(_ sender: Any) {
        
        self.providerBtn.backgroundColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        self.providerBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        self.customerBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.customerBtn.setTitleColor(#colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1), for: UIControl.State.normal)
        
        self.customerBtn.layer.borderColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        self.providerBtn.layer.borderColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        
        self.customerBtn.layer.borderWidth = 1.0
        self.providerBtn.layer.borderWidth = 1.0
        
       // UserDefaults.standard.setValue("2", forKey: "type")
         UserDefaults.standard.setValue("3", forKey: "type")
        UserDefaults.standard.set(true, forKey: "log")
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(login, animated: false)
        
        
    }
 
}

