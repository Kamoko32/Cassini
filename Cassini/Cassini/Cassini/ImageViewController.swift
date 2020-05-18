//
//  ImageViewController.swift
//  Cassini
//
//  Created by Kamil Gucik on 20/03/2020.
//  Copyright © 2020 Kamil Gucik. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
            fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            scrollView?.setContentOffset(CGPoint(x: scrollView.contentSize.width * 0.5, y: scrollView.contentSize.height * 0.5), animated: false)
            spinner?.stopAnimating()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/22
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsety = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsety, left: offsetX, bottom: offsety, right: offsetX)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageView = UIImageView()
    
    
    
    private func fetchImage () {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                    self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageURL == nil {
            imageURL = DemoURLs.stanford
        }
    }
}
