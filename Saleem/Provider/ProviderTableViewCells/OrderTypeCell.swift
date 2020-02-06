//
//  OrderTypeCell.swift
//  Saleem-SP
//
//  Created by volive solutions on 18/01/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class OrderTypeCell: UITableViewCell {

    
    @IBOutlet var deleteBtn: UIButton!
    
    @IBOutlet var viewNoOfIssuesBtn: UIButton!
    @IBOutlet var issueView: UIView!
    
    @IBOutlet var unavailableHeightConstarint: NSLayoutConstraint!
    @IBOutlet var rejectLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var rejectlLbel: UILabel!
    @IBOutlet weak var img_status: UIImageView!
    
    @IBOutlet var rejectLabel: UILabel!
    @IBOutlet weak var btn_ViewDetail: UIButton!
    
    //spinvoice cell values
    @IBOutlet weak var txt_Addition_Price: UITextField!
    @IBOutlet weak var txt_Estimate_Price: UITextField!
    
    //sp invoice cell static
    @IBOutlet var issueNameStatic: UILabel!
    @IBOutlet var additionPriceStatic: UILabel!
    
    @IBOutlet weak var txt_IssueName: UITextField!
    
    //orders list properties
    @IBOutlet weak var img_customer: UIImageView!
    
    //for payments display and spreqlist
    @IBOutlet var orderNoStatic: UILabel!
    @IBOutlet var orderNoLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var dateStatic: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    
    @IBOutlet var issueNameLabel: UILabel!
    
    //for payments cell values
    
    @IBOutlet var orderAmountStatic: UILabel!
    @IBOutlet var orderAmountLabel: UILabel!
    
    @IBOutlet var adminAmountStatic: UILabel!
    @IBOutlet var adminAmountLabel: UILabel!
    
    @IBOutlet var providerPaymentStatic: UILabel!
    @IBOutlet var providerPaymentLabel: UILabel!
    
    @IBOutlet var providerImageview: UIImageView!
    @IBOutlet var paymentModeStatic: UILabel!
    @IBOutlet var paymentModeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
