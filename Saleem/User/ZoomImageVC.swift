//
//  ZoomImageVC.swift
//  Saleem
//
//  Created by Suman Guntuka on 01/06/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class ZoomImageVC: UIViewController {

    @IBOutlet var zoomImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

     let zoomImage = UserDefaults.standard.value(forKey: "selectedImage")
        DispatchQueue.main.async {
            self.zoomImageView.sd_setImage(with: URL(string: String(format: "%@%@", base_path, zoomImage as! CVarArg)), placeholderImage: UIImage(named:"pdfImage"))
        }
        
    }
    

    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
