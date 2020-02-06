//
//  MenuCell.swift
//  Saleem
//
//  Created by Suman Guntuka on 23/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    
    @IBOutlet var menuName: UILabel!
    
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
