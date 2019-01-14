//
//  TutorialMainView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class TutorialMainView: UIView {
    
    // MARK: Constants
    enum Constant {
        enum Title {
            static let button = "Пропустить"
        }
        
        enum Image {
            static let arrow = UIImage(named: "arrow_right")
        }
    }
    
    // MARK: - Properties
    private let tutorialManager = TutorialManager()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(tutorialManager.items.count),
                                        height: scrollView.frame.size.height)
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.87), for: .normal)
        button.setTitle("Пропустить", for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = tutorialManager.items.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.purple1
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named: "arrow_right"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [scrollView, skipButton, nextButton, pageControl].forEach({ addSubview($0) })
        
        skipButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.size.height)
            make.right.equalToSuperview().offset(-Constants.baseOffset * 2)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(30)
        }
        
        let pageControlBottomSpace = UIScreen.height * 0.2555 - 109
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-(UIScreen.height * 0.0625 + 25 + pageControlBottomSpace/2))
            make.height.equalTo(5)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-25)
            make.height.equalToSuperview().multipliedBy(0.0625)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
