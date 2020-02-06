//
//  UserReqDetailsCell.swift
//  Saleem
//
//  Created by Suman Guntuka on 21/01/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class UserReqDetailsCell: UITableViewCell {

    
    @IBOutlet var userName: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var starButtonOne: UIButton!
    @IBOutlet var starButtontwo: UIButton!
    @IBOutlet var starButtonThree: UIButton!
    @IBOutlet var starButtonFour: UIButton!
    @IBOutlet var starButtonFive: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
