//
//  ChatTextCell.swift
//  CarFixing
//
//  Created by Suman Guntuka on 23/02/18.
//  Copyright © 2018 volivesolutions. All rights reserved.
//

import UIKit

class ChatTextCell: UITableViewCell {
    
    @IBOutlet var mytimeLbl: UILabel!
    @IBOutlet weak var myMsgLbl: UILabel!
    @IBOutlet var myImage: UIImageView!
    
    @IBOutlet weak var otherMsgLbl: UILabel!
    @IBOutlet var othertimeLbl: UILabel!
    @IBOutlet weak var otherPimage: UIImageView!
    
    @IBOutlet weak var otherBackView: UIView!
    @IBOutlet weak var myBackView: UIView!
    
    
    @IBOutlet var myProfileImageCell3: UIImageView!
    @IBOutlet var mySendImageView: UIImageView!
    @IBOutlet var myImageTimeLabel: UILabel!
    
    
    @IBOutlet var otherProfileImageCell4: UIImageView!
    @IBOutlet var otherReceiveImageView: UIImageView!
    @IBOutlet var otherImageTimeLabel: UILabel!
    
    @IBOutlet var myImageBackView: UIView!
    @IBOutlet var otherImageBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
