//
//  ImageSlideTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 26.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import ImageSlideshow

class ImageSlideTableViewCell: UITableViewCell {
    lazy var imageSlider: ImageSlideshow = {
        let slider = ImageSlideshow()
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.blue1
        pageIndicator.pageIndicatorTintColor = UIColor.gray4
        slider.pageIndicator = pageIndicator
        
        slider.backgroundColor = UIColor.clear
        slider.activityIndicator = DefaultActivityIndicator()
        slider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: PageIndicatorPosition.Vertical.under)
        slider.slideshowInterval = 5.0
        slider.contentScaleMode = UIView.ContentMode.scaleAspectFill
        slider.activityIndicator = DefaultActivityIndicator()
        return slider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(imageSlider)
        imageSlider.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
