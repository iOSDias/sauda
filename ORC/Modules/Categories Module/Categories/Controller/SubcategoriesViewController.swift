//
//  SubcategoriesViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 24.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class SubcategoriesViewController: IndicatorViewableViewController {
    
    // MARK: Properties
    var mainView = CategoriesView()
    var data: [Category] = []
    var navigationTitle: String = ""
    var basketButton: BBBadgeBarButtonItem!
    
    // MARK: Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        mainView.imgView.snp.updateConstraints { (update) in
            update.height.equalTo(0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Constants.User.hasToken() {
            updateBasketCount()
        }
        configureViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            
        } else {
            mainView.snp.updateConstraints { make in
                make.top.equalTo(topLayoutGuide.length)
                make.bottom.equalTo(-bottomLayoutGuide.length)
            }
        }
    }

}

extension SubcategoriesViewController {
    
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = Functions.createTitleLabel(title: navigationTitle, textColor: .black)

        let backButton = BackButton(color: .black)
        backButton.delegate = self
        navigationItem.leftBarButtonItem = backButton
        
        basketButton = Functions.createBasketBarButton(color: .black)
        navigationItem.rightBarButtonItem = basketButton
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configureTableView() {
        mainView.tableView.tableFooterView = UIView()
        mainView.tableView.separatorStyle = .singleLine
        mainView.tableView.separatorColor = UIColor.gray4
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SubcategoriesViewController: BackButtonProtocol, UIGestureRecognizerDelegate {
    @objc internal func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension SubcategoriesViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK : TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = data[indexPath.row].category_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = FilteredProductsViewController()
        dvc.id = data[indexPath.row].category_id
        dvc.navigationTitle = data[indexPath.row].category_name
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension SubcategoriesViewController {
    
    // MARK: - Request Methods
    private func updateBasketCount() {
        startAnimating()
        
        Functions.getCartCount { [unowned self] optional in
            if let count = optional {
                self.basketButton.badgeValue = count
            } else {
                "Не удалось получить количество товаров в коризне".showAlertView(context: .error)
            }
            
            self.stopAnimating()
        }
    }
}
