//
//  IssuesCell.swift
//  Saleem
//
//  Created by Suman Guntuka on 27/03/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class IssuesCell: UITableViewCell {

    
    @IBOutlet var issueNameLabel: UILabel!
    @IBOutlet var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
