//
//  UserRequestCell.swift
//  Saleem
//
//  Created by Suman Guntuka on 21/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class UserRequestCell: UITableViewCell {

    @IBOutlet var trackOrderBtn: UIButton!
    @IBOutlet var viewDetailsBtn: UIButton!
    
    @IBOutlet var orderNoStatic: UILabel!
    @IBOutlet var dateTimeStatic: UILabel!
    @IBOutlet var statusStatic: UILabel!
    
    @IBOutlet var orderNoLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
