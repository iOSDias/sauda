//
//  HomeViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 19.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import Parchment

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var controllerArray : [IndicatorViewableViewController] = [DiscountListViewController(), CompanyListViewController()]
    var pagingViewController: FixedPagingViewController!
    var basketButton: BBBadgeBarButtonItem!

    override func loadView() {
        super.loadView()
        
        configurePageMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedVC = pagingViewController.pageViewController.selectedViewController {
            selectedVC.viewWillAppear(animated)
        }
        
        if Constants.User.hasToken() {
            updateBasketCount()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            
        } else {
            pagingViewController.view.snp.updateConstraints { make in
                make.top.equalTo(topLayoutGuide.length)
                make.bottom.equalTo(-bottomLayoutGuide.length)
            }
        }
    }
}

extension HomeViewController {
    
    // MARK: - Configure Views
    private func configureViews() {
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "ORC"))
        navigationItem.leftBarButtonItem = EmptyBarButton()
        basketButton = Functions.createBasketBarButton(color: .white)
        navigationItem.rightBarButtonItem = basketButton
    }
    
    private func configurePageMenu() {
        let titles = ["Акции", "Компании"]
        
        for (index, controller) in controllerArray.enumerated() {
            controller.parentNavigationController = self.navigationController
            controller.title = titles[index]
        }
        pagingViewController = FixedPagingViewController(viewControllers: controllerArray)
        pagingViewController.contentInteraction = .none
        pagingViewController.menuItemSize = .fixed(width: Constants.width/2, height: 50)
        pagingViewController.font = Functions.font(type: FontType.regular, size: .normal)
        pagingViewController.selectedFont = Functions.font(type: .regular, size: .normal)
        pagingViewController.indicatorColor = UIColor.blue1
        pagingViewController.selectedTextColor = .black
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.view.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
}

extension HomeViewController {
    
    private func updateBasketCount() {
        Functions.getCartCount { [weak self] optional in
            guard let `self` = self else { return }
            
            if let count = optional {
                self.basketButton.badgeValue = count
            } else {
                "Не удалось получить количество товаров в коризне".showAlertView(context: .error)
            }
        }
    }
}
