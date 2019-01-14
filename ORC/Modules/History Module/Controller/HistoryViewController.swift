//
//  HistoryViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class HistoryViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var basketButton: BBBadgeBarButtonItem!
    lazy var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    var data: [HistoryData] = [] 
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        congigureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
        
        if Constants.User.hasToken() {
            updateBasketCount()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            
        } else {
            tableView.snp.updateConstraints { make in
                make.top.equalTo(topLayoutGuide.length)
                make.bottom.equalTo(-bottomLayoutGuide.length)
            }
        }
    }
}

extension HistoryViewController {
    
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
    }
    
    func congigureNavigationBar() {
        navigationItem.titleView = Functions.createTitleLabel(title: "История", textColor: .white)
        basketButton = Functions.createBasketBarButton(color: .white)
        navigationItem.rightBarButtonItem = basketButton
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(HistoryDataTableViewCell.self, forCellReuseIdentifier: "HistoryDataTableViewCell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDataTableViewCell", for: indexPath) as! HistoryDataTableViewCell
        cell.selectionStyle = .none
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .normal, title: "Удалить") { [unowned self] action, index in
            self.cancelPurchase(index: indexPath.row)
        }
        remove.backgroundColor = .red1
        return [remove]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HistorySectionHeader()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.height * 0.07
    }
}

// MARK : EmptyData Methods

extension HistoryViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Constants.historyEmptyDataTitle, attributes: [NSAttributedString.Key.font: Functions.font(type: FontType.regular, size: FontSize.huge), NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Constants.historyEmptyDataDescription, attributes: [NSAttributedString.Key.font: Functions.font(type: FontType.regular, size: FontSize.big), NSAttributedString.Key.foregroundColor: UIColor.gray4])

    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "historyEmptyImage")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

extension HistoryViewController {
    
    private func updateBasketCount() {
        startAnimating()
        
        Functions.getCartCount { [unowned self] optional in
            if let count = optional {
                self.basketButton.badgeValue = count
            } else {
                "Не удалось получить количество товаров в коризне".showAlertView(context: .error)
            }
            self.getData()
        }
    }
    
    @objc private func updateTableView() {
        Constants.User.hasToken() ? getData(isAnimating: false) : refreshControl.endRefreshing()
    }
    
    @objc private func getData(isAnimating: Bool = true) {
        if isAnimating {
            startAnimating()
        }
        
        NetworkLayer.shared.sendRequest(command: .getHistory) { [unowned self] optional in

            if let json = optional, let array = ArrayConverter.createOrUpdateArrayOfModels(command: Arrays.HistoryData, json["data"]["data"]) as? [HistoryData] {
                self.data = array
                self.tableView.reloadData()
            }
            
            self.refreshControl.endRefreshing()
            self.stopAnimating()
        }
    }
    
    private func cancelPurchase(index: Int) {
        startAnimating()
    
        guard let id = data[index].group_id else { return }
        
        NetworkLayer.shared.sendRequest(command: NetworkRouter.cancelPurchase(id)) { [unowned self] json in
            if json != nil {
                self.data.remove(at: index)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.tableView.endUpdates()
            }
            
            self.stopAnimating()
        }
    }
}
