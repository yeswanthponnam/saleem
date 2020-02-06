//
//  ImageCell.swift
//  Saleem
//
//  Created by Suman Guntuka on 12/04/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    //document upload in sp profile
    @IBOutlet var uploadImageView: UIImageView!
    @IBOutlet var checkImageView: UIImageView!
    
    //add card in user profile
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cardNoLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    
    //document upload in signup
    
    @IBOutlet var uploadDocImageView: UIImageView!
   
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var checkDocImageView: UIImageView!
    
}
