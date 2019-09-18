//
//  ImageZoomViewController.swift
//  ImageGallery-Assignment4
//
//  Created by Usama Azam on 18/09/2019.
//  Copyright © 2019 iParagons. All rights reserved.
//

import UIKit

class ImageZoomViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/4
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(displayImageView)
        }
    }
    
    var displayImageView = UIImageView()
    
    var image: UIImage? {
        get {
            return displayImageView.image
        }
        set {
            displayImageView.image = newValue
            displayImageView.frame.size = view.frame.size
            scrollView?.contentSize = displayImageView.frame.size
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return displayImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
