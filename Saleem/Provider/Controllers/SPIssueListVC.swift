//
//  SPIssueListVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 13/02/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class SPIssueListVC: UIViewController {

    @IBOutlet var issueListTableView: UITableView!
    var issueNamearray = [String]()
    
    @IBOutlet var listOfissuesStaticLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        listOfissuesStaticLabel.text = languageChangeString(a_str: "LIST OF ISSUES")
        issueNamearray = UserDefaults.standard.object(forKey: "list") as! [String]
        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SPIssueListVC: UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return issueNamearray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var  cell : NotificationsCell
        
        cell = issueListTableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
        cell.issueNameLabel.text = issueNamearray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        //return 96
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}




