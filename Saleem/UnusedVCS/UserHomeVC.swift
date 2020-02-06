//
//  UserHomeVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 18/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit


class UserHomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,SSASideMenuDelegate {

    let kHeaderSectionTag: Int = 6900;
    var rowsWhichAreChecked = [IndexPath]()
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    
    

    @IBOutlet var homeTV: UITableView!
    
    @IBOutlet var backBtn: UIBarButtonItem!
    var leftBarButton : UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sectionNames = [ "Select Mobile Brand", "Select Model", "Select Issue" ];
        sectionItems = [ ["Samsung", "Apple", "MI", "Huawei", "Nokia", "Sony", "LG"],
                         ["Samsung J7", "Apple X", "MI 5", "Nokia S8","Sony Xperia","LG 8"],
                         ["Touch Problem", "Battery Problem", "Sensor Problem","Speaker Problem","Camera Problem"]
        ];
        self.homeTV!.tableFooterView = UIView()
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
 
//        backBtn.target = self
//        backBtn.action = #selector(presentLeftMenuViewController)
        
        backBtn.target = self
        backBtn.action = #selector(showLeftView(sender:))
        
        navigationController?.navigationBar.barTintColor = UIColor (red: 41.0/255.0, green: 121.0/255.0, blue: 255.0/255.0, alpha: 1.0)
       
    }
    
    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    @objc func myLeftSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myLeftSideBarButtonItemTapped")
        
        leftBarButton.target = self
        leftBarButton.action = #selector(presentLeftMenuViewController)
        
    }
    
    @objc func selectorName(){
    
    }
    
    @IBAction func backAction(_ sender: Any) {
        backBtn.target = self
        backBtn.action = #selector(presentLeftMenuViewController)
    }
    
    
    @IBAction func sendRequestAction(_ sender: Any) {
        let reqVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserReqOrderDetailsVC") as! UserReqOrderDetailsVC
        self.navigationController?.pushViewController(reqVC, animated: false)
    }
    
    
    //delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            homeTV.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.homeTV.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sectionNames.count != 0) {
            return self.sectionNames[section] as? String
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTV.dequeueReusableCell(withIdentifier: "UserHomeTVCell", for: indexPath) as! UserHomeTVCell
        let section = self.sectionItems[indexPath.section] as! NSArray
        cell.titleLabel.textColor = UIColor.black
        cell.titleLabel.text = section[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //UIColor.colorWithHexString(hexStr: "#408000")
        header.textLabel?.textColor = UIColor.black
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "droup")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(UserHomeVC.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.homeTV!.beginUpdates()
            self.homeTV!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.homeTV!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.homeTV!.beginUpdates()
            self.homeTV!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.homeTV!.endUpdates()
        }
    }
    
}




/*
 
 asdf ;lkj abcdefghij ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj
 asdf ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj ;lkj
 asdf ;lkj asdf ;lkj
 qwertyuiop
 qwerty yuiop qwerty yuiop
 qwerty yuiop qwer
 qwerty yuiop
 
 Learn about touch typing and assess your current skill level.
 
 Learn about touch typing and assess your current skil level.
 learn abkout touch typing and assess your current skill level.
 
 
 */

