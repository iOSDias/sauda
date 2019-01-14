//
//  DiscountListViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DiscountListViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var mainView = DiscountListView()
    var refreshControl = UIRefreshControl()
    var data: [Discount] = [] {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    var filteredData: [Discount] = []
    var isSearching: Bool = false
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.bottom.equalTo(view.safeArea.bottom)
            make.left.right.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.tableView.setContentOffset(.zero, animated: true)
        getDiscounts()
        configureViews()
    }
}

extension DiscountListViewController {
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
    }
    
    private func configureTableView() {
        mainView.tableView.tableFooterView = UIView()
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(DiscountTableViewCell.self, forCellReuseIdentifier: "DiscountTableViewCell")
        mainView.tableView.emptyDataSetSource = self
        mainView.tableView.emptyDataSetDelegate = self
        mainView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(getDiscounts), for: .valueChanged)
    }
}

extension DiscountListViewController {
    
    // MARK: - Actions
    @objc private func showAllProducts(sender: UIButton) {
        let index = sender.tag
        let dvc = DiscountProductsViewController()
        dvc.navigationTitle = currentData()[index].discount_name
        dvc.id = currentData()[index].discount_id
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension DiscountListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK : TableView Methods
    private func currentData() -> [Discount] {
        return isSearching ? filteredData : data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountTableViewCell", for: indexPath) as! DiscountTableViewCell
        cell.selectionStyle = .none
        cell.showAllButton.tag = indexPath.row
        cell.showAllButton.addTarget(self, action: #selector(showAllProducts), for: .touchUpInside)
        cell.data = currentData()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return Constants.height * 0.6
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DiscountProductsViewController()
        dvc.navigationTitle = currentData()[indexPath.row].discount_name
        dvc.id = currentData()[indexPath.row].discount_id
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension DiscountListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK : EmptyData Methods
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Нет акций", attributes: [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.purple1])
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}


extension DiscountListViewController {
    
    // MARK: - Hide/Show tabbar scrolling tableview
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            changeTabBar(hidden: true, animated: true)
        } else {
            changeTabBar(hidden: false, animated: true)
        }
    }
    
    private func changeTabBar(hidden:Bool, animated: Bool){
        let tabBar = self.tabBarController?.tabBar
        if tabBar!.isHidden == hidden{ return }
        let frame = tabBar?.frame
        let offset = (hidden ? (frame?.size.height)! : -(frame?.size.height)!)
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar?.isHidden = false
        if frame != nil {
            UIView.animate(withDuration: duration, animations: {
                tabBar!.frame = frame!.offsetBy(dx: 0, dy: offset)
            }, completion: {
                if $0 { tabBar?.isHidden = hidden }
            })
        }
    }
}

// MARK : SearchBar Methods

extension DiscountListViewController: UISearchBarDelegate {
    private func configureSearchBar() {
        mainView.searchView.searchBar.placeholder = "Поиск по названию товара"
        mainView.searchView.searchBar.adjustPlaceholder()
        mainView.searchView.searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        searchBar.resignFirstResponder()
        mainView.tableView.reloadData()
        mainView.tableView.setContentOffset(.zero, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filterData(filterText: searchText)
        }
        mainView.tableView.reloadData()
        mainView.tableView.setContentOffset(.zero, animated: true)
    }
    
    private func filterData(filterText: String) {
        filteredData.removeAll()
        
        for discount in data {
            var found = false
            
            if discount.discount_name.lowercased().range(of: filterText.lowercased()) != nil {
                found = true
            }
            
            if found {
                filteredData.append(discount)
            }
        }
    }
}


extension DiscountListViewController {
    
    // MARK : Request Methods
    @objc private func getDiscounts() {
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: .discounts) { [unowned self] optional in
            if let json = optional {
                self.data = ArrayConverter.createOrUpdateArrayOfModels(command: .Discounts, json["data"]["data"]) as! [Discount]
            }
            
            self.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
}
