//
//  TutorialViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    // MARK: Properties
    private var mainView = TutorialMainView()
    private var tutorialViews: [UIView] = [FirstTutorialView(), SecondTutorialView(), ThirdTutorialView()]
    private var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var tutorialManager = TutorialManager()
    
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.top.equalTo(view.safeArea.top)
//            } else {
//                make.top.equalTo(view.safeArea.top).offset(UIApplication.shared.statusBarFrame.size.height)
//            }
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTutorialViews()
        configureViews()
        setInfo(index: mainView.pageControl.currentPage)
        setupAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
}
extension TutorialViewController {
    
    // MARK: - Configure Views Methods
    private func configureTutorialViews() {
        for index in 0..<tutorialManager.items.count {
            //tutorialViews.append(TutorialView())
            
            frame.origin.x = mainView.scrollView.frame.size.width * CGFloat(index)
            frame.size = mainView.scrollView.frame.size
            
            tutorialViews[index].frame = frame
            
            mainView.scrollView.addSubview(tutorialViews[index])
        }
    }
    
    private func configureViews() {
        mainView.scrollView.delegate = self
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTouchUp), for: .touchUpInside)
        mainView.skipButton.addTarget(self, action: #selector(skipTutorial), for: .touchUpInside)
    }
    
    func setupAnimations() {
//        let currentPage = mainView.pageControl.currentPage
//        let imageView = tutorialViews[currentPage].imageView
//        let titleLabel = tutorialViews[currentPage].titleLabel
//        let subtitleLabel = tutorialViews[currentPage].subTitleLabel
//
//        imageView.animation = "pop"
//        imageView.curve = "spring"
//        imageView.duration = 4.0
//        imageView.force = 1.2
//        titleLabel.animation = "squeezeLeft"
//        titleLabel.curve = "spring"
//        titleLabel.duration = 1.5
//        subtitleLabel.animation = "squeezeRight"
//        subtitleLabel.curve = "spring"
//        subtitleLabel.duration = 1.5
//        imageView.animate()
//        titleLabel.animate()
//        subtitleLabel.animate()
    }
}

extension TutorialViewController {
    
    // MARK: - Actions
    private func setInfo(index: Int) {
//        let currentView = tutorialViews[index]
//        let content = tutorialManager.items[index]
        
//        currentView.imageView.image = content.image
//        currentView.titleLabel.text = content.title
//        currentView.subTitleLabel.text = content.subtitle
//        view.backgroundColor = content.backgroundColor
//        UIApplication.statusBarBackgroundColor = content.backgroundColor
//        mainView.nextButton.backgroundColor = content.buttonColor
//        mainView.pageControl.pageIndicatorTintColor = content.buttonColor
        
        if index == tutorialViews.count - 1 {
            mainView.nextButton.setImage(UIImage(named: "check"), for: .normal)
        }
    }
    
    @objc private func skipTutorial() {
        UIApplication.statusBarBackgroundColor = UIColor.blue1
        tutorialManager.isViewed = true
        //Coordinator.shared.presentAuthorizationScreen()
        Coordinator.shared.presentMainTabBarScreen()
    }
    
    @objc private func nextButtonTouchUp() {
        if mainView.pageControl.currentPage != tutorialManager.items.count - 1 {
            mainView.pageControl.currentPage += 1
            setInfo(index: mainView.pageControl.currentPage)
            let x = CGFloat(mainView.pageControl.currentPage) * mainView.scrollView.frame.size.width
            mainView.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            setupAnimations()
        } else {
            skipTutorial()
        }
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    
    // MARK: - ScrollView Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        mainView.pageControl.currentPage = Int(pageNumber)
        setInfo(index: Int(pageNumber))
        setupAnimations()
    }
    
}
