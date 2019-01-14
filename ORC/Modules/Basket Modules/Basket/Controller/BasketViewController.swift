//
//  BasketViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwiftyJSON
import SwiftEntryKit

class BasketViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var mainView = BasketView()
    var refreshControl = UIRefreshControl()
    var data: [Product] = [] {
        didSet {
            if data.isEmpty {
                changeViewBottom(hide: true)
                amount = 0
            } else {
                changeViewBottom(hide: false)
            }
        }
    }
    
    var amount: Double! {
        didSet {
            mainView.amountView.amount = amount
        }
    }
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.left.right.equalToSuperview()
            if UIDevice.current.hasHomeButton {
                make.bottom.equalToSuperview().offset(-34)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureActions()
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureViews()
    }
}

extension BasketViewController {
    
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureActions() {
        mainView.bottomButton.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        guard let navigationController = navigationController else { return }
        
        navigationItem.hidesBackButton = false
        navigationItem.titleView = Functions.createTitleLabel(title: "Корзина", textColor: .black)
        
        let backButton = BackButton(color: .black)
        backButton.delegate = self
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.rightBarButtonItem = EmptyBarButton()
        
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configureTableView() {
        mainView.tableView.tableFooterView = UIView()
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(BasketProductTableViewCell.self, forCellReuseIdentifier: "BasketProductTableViewCell")
        mainView.tableView.emptyDataSetSource = self
        mainView.tableView.emptyDataSetDelegate = self
        mainView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
    }
}

extension BasketViewController: BackButtonProtocol, CreateOrderVCProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - BackButton Methods
    internal func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    internal func orderCreated() {
        tabBarController?.selectedIndex = 2
        navigationController?.popToRootViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BasketViewController {
    
    // MARK: - Actions and Methods
    private func calculateAmount() {
        var currentAmount: Double = 0
        data.forEach { (product) in
            currentAmount += Double(product.cart_count) * product.product_price
        }
        self.amount = currentAmount
    }
    
    private func changeViewBottom(hide: Bool) {
        var height: CGFloat = Constants.height * 0.08
        
        if hide {
            height = 0
        }
        
        [mainView.bottomButton, mainView.amountView].forEach { (view) in
            view.snp.updateConstraints({ (update) in
                update.height.equalTo(height)
            })
            view.isHidden = hide
        }
    }
    
    @objc private func bottomButtonTapped() {
        let dvc = CreateOrderViewController()
        dvc.delegate = self
        dvc.productCount = data.count
        dvc.amount = self.amount
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    @objc private func plusButtonTapped(sender: UIButton) {
        let index = sender.tag
        let id = data[index].product_id
        
        let cell = mainView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! BasketProductTableViewCell
        cell.moreLessView.startAnimating()
        
        Functions.changeProductCount(id: id, decrement: 0) { [weak self] optional, count in
            guard let `self` = self else { return }

            if let product = optional {
                self.data[index].cart_count = product.cart_count
                self.calculateAmount()
                self.mainView.tableView.reloadData()
            }
            
            cell.moreLessView.stopAnimating()
        }
    }
    
    @objc private func minusButtonTapped(sender: UIButton) {
        let index = sender.tag
        let id = data[index].product_id
        
        let cell = mainView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! BasketProductTableViewCell
        cell.moreLessView.startAnimating()

        Functions.changeProductCount(id: id, decrement: 1) { [weak self] optional, count in
            guard let `self` = self else { return }

            if let product = optional {
                self.data[index].cart_count = product.cart_count
                self.calculateAmount()
                self.mainView.tableView.reloadData()
            } else if count != nil {
                self.data.remove(at: index)
                self.calculateAmount()
                self.mainView.tableView.reloadData()
            }
            
            cell.moreLessView.stopAnimating()
        }
    }
    
    @objc private func cleanButtonTapped() {
        let alert = UIAlertController(title: "", message: "Очистить корзину?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .destructive, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Да", style: UIAlertAction.Style.default, handler: { action in
            self.startAnimating()
            
            NetworkLayer.shared.sendRequest(command: .cleanCart) { [unowned self] json in
                if json != nil {
                    self.data.removeAll()
                    self.mainView.tableView.reloadData()
                }
                
                self.stopAnimating()
            }
        }))
        alert.view.tintColor = UIColor.blue1
        self.present(alert, animated: true, completion: nil)
    }
}


extension BasketViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK : TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketProductTableViewCell", for: indexPath) as! BasketProductTableViewCell
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        [cell.moreLessView.plusButton, cell.moreLessView.minusButton].forEach({$0.tag = indexPath.row})
        cell.moreLessView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        cell.moreLessView.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .normal, title: "Удалить") { [unowned self] action, index in
            self.removeProductFromBasket(index: indexPath.row)
        }
        remove.backgroundColor = .red1
        return [remove]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.height * 0.2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = BasketSectionHeader()
        header.cleanButton.addTarget(self, action: #selector(cleanButtonTapped), for: .touchUpInside)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return data.isEmpty ? 0 : Constants.height * 0.05
    }
}

extension BasketViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK : EmptyData Methods
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Нет данных", attributes: [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.purple1])
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "empty")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}


extension BasketViewController {
    
    // MARK : Request Methods
    @objc private func getData() {
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: .getCart) { [unowned self] optional in
            if let json = optional {
                self.data = ArrayConverter.createOrUpdateArrayOfModels(command: Arrays.Products, json["data"]["list"]) as! [Product]
                self.calculateAmount()
                self.mainView.tableView.reloadData()
            }
            
            self.refreshControl.endRefreshing()
            self.stopAnimating()
        }
    }
    
    private func removeProductFromBasket(index: Int) {
        startAnimating()
        
        let id = self.data[index].cart_id!
        NetworkLayer.shared.sendRequest(command: .cartDelete(id), completion: { [unowned self] json in
            self.stopAnimating()
            
            if json != nil {
                self.data.remove(at: index)
                self.calculateAmount()
                self.mainView.tableView.beginUpdates()
                self.mainView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.mainView.tableView.endUpdates()
            }
        })
    }
}
