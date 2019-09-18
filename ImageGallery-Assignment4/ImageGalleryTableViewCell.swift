//
//  ImageGalleryTableViewCell.swift
//  ImageGallery-Assignment4
//
//  Created by Usama Azam on 18/09/2019.
//  Copyright © 2019 iParagons. All rights reserved.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var galleryNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(gesture:)))
        tapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGesture)
        
        self.galleryNameTextField.delegate = self
    }
    
    @objc func doubleTap(gesture: UITapGestureRecognizer) {
        print("double tap called")
        if self.tag != 1 {
            self.galleryNameTextField.EnableTextField()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.galleryNameTextField.DisableTextField()
        updateModel()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.galleryNameTextField.DisableTextField()
        updateModel()
        return false
    }
    
    var updateModel = {}

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

extension UITextField {
    func EnableTextField() {
        self.isEnabled = true
        self.becomeFirstResponder()
    }
    
    func DisableTextField() {
        self.isEnabled = false
        self.resignFirstResponder()
    }
}
