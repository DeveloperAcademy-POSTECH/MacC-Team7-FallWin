//
//  ImageZoomViewController.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import UIKit

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {
    var image: UIImage?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let imageView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initView()
        
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFit
        
        self.scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
    }
    
    private func initView() {
        self.scrollView.addSubview(self.imageView)
        self.view.addSubview(self.scrollView)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: self.scrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: self.scrollView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.scrollView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self.scrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([top, left, right, bottom])
        
        let imageTop = NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self.scrollView, attribute: .top, multiplier: 1, constant: 0)
        let imageLeading = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.scrollView, attribute: .leading, multiplier: 1, constant: 0)
        let imageTrailing = NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self.scrollView, attribute: .trailing, multiplier: 1, constant: 0)
        let imageBottom = NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self.scrollView, attribute: .bottom, multiplier: 1, constant: 0)
        let imageHeight = NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.scrollView, attribute: .height, multiplier: 1, constant: 0)
        imageHeight.priority = .defaultLow
        let imageWidth = NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: self.scrollView, attribute: .width, multiplier: 1, constant: 0)
        let imageCenterX = NSLayoutConstraint(item: self.imageView, attribute: .centerX, relatedBy: .equal, toItem: self.scrollView, attribute: .centerX, multiplier: 1, constant: 0)
        let imageCenterY = NSLayoutConstraint(item: self.imageView, attribute: .centerY, relatedBy: .equal, toItem: self.scrollView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([imageTop, imageLeading, imageTrailing, imageBottom, imageHeight, imageWidth, imageCenterX, imageCenterY])
        
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
