//
//  ImagePreviewVC.swift
//  Tickt
//
//  Created by Admin on 11/05/21.
//

import UIKit

class ImagePreviewVC: BaseVC, UIScrollViewDelegate {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    var image: UIImage?
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetp()
    }
            
    func initialSetp() {
        imageScrollView.maximumZoomScale = 3
        imageScrollView.minimumZoomScale = 1        
        if image != nil {
            previewImageView.image = image
        }
        
        if urlString != nil {
            previewImageView.sd_setImage(with: URL(string: urlString!), placeholderImage: nil)
        }
    }
        
    @IBAction func backButtonAction(_ sender: UIButton) {
        pop()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImageView
    }
}
