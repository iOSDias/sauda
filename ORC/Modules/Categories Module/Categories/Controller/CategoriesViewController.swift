//
//  CategoriesViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoriesViewController: IndicatorViewableViewController {
    
    // MARK: Properties
    var basketButton: BBBadgeBarButtonItem!
    var mainView = CategoriesView()
    var data: [Category] = [] {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.User.hasToken() ? updateBasketCount() : fetchCategories()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(bottomLayoutGuide.length)
    }
}

extension CategoriesViewController {
    
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = Functions.createTitleLabel(title: "Категории", textColor: .white)
    
        basketButton = Functions.createBasketBarButton(color: .white)
        navigationItem.rightBarButtonItem = basketButton
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

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {

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
        let category =  data[indexPath.row]
        let dvc = SubcategoriesViewController()
        dvc.navigationTitle = category.category_name
        dvc.data = category.children
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension CategoriesViewController {
    
    // MARK : Request Methods
    private func updateBasketCount() {
        startAnimating()
        
        Functions.getCartCount { [unowned self] optional in
            if let count = optional {
                self.basketButton.badgeValue = count
            } else {
                "Не удалось получить количество товаров в коризне".showAlertView(context: .error)
            }
            self.fetchCategories()
        }
    }
    
    private func fetchCategories() {
        if let categoriesJsonString = UserDefaults.standard.string(forKey: Constants.CATEGORIES_STR) {
            let json = categoriesJsonString.data(using: String.Encoding.utf8).flatMap({try? JSON(data: $0)}) ?? JSON(NSNull())
            self.data = ArrayConverter.createOrUpdateArrayOfModels(command: .Categories, json) as! [Category]
            self.stopAnimating()
        } else {
            getData()
        }
    }
    
    private func getData() {
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: .categories) { [unowned self] optional  in
            if let json = optional, let array = ArrayConverter.createOrUpdateArrayOfModels(command: Arrays.Categories, json["data"]) as? [Category] {
                self.data = array
                if !array.isEmpty {
                    UserDefaults.standard.set(array.toJSONString()!, forKey: Constants.CATEGORIES_STR)
                }
            }
            
            self.stopAnimating()
        }
    }
}
