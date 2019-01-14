//
//  CompanyListViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 19.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class CompanyListViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    private var mainView = CompanyListView()
    private var refreshControl = UIRefreshControl()
    private var data: [Supplier] = []
    
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
        view.backgroundColor = .white
        configureTableView()
        mainView.bottomButton.addTarget(self, action: #selector(openScannerPage), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
        
        if Constants.User.hasToken() {
            getCompanies()
        }
    }
}

extension CompanyListViewController {
    
    // MARK: - Configure Views
    private func configureViews() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
    }
    
    func configureTableView() {
        mainView.tableView.tableFooterView = UIView()
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(SupplierTableViewCell.self, forCellReuseIdentifier: "SupplierTableViewCell")
        mainView.tableView.emptyDataSetSource = self
        mainView.tableView.emptyDataSetDelegate = self
        mainView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
    }
}

extension CompanyListViewController: ScannerProtocol {
    
    // MARK: - Actions
    @objc func openScannerPage() {
        if Constants.User.hasToken() {
            guard let navigationController = navigationController else { return }
            let dvc = ScannerViewController()
            dvc.delegate = self
            navigationController.pushViewController(dvc, animated: true)
        } else  {
            // TODO: - Auth alert view
            AuthorizationAlertManager.shared.show(baseVC: UIApplication.topViewController()!)
        }
    }
    
    func updateCompanyList() {
        getCompanies(isAnimating: true)
    }
}

extension CompanyListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierTableViewCell", for: indexPath) as! SupplierTableViewCell
        cell.data = data[indexPath.row]
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .normal, title: "Удалить") { [unowned self] action, index in
            self.removeCompanyFromList(index: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = data[indexPath.row]
        let dvc = CompanyProductsViewController()
        dvc.company_id = product.producer.producer_id
        dvc.navigationTitle = product.producer.producer_name
        navigationController?.pushViewController(dvc, animated: true)
    }
}


extension CompanyListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK : EmptyData Methods
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Нет подписанных компаний", attributes: [NSAttributedString.Key.font: Functions.font(type: FontType.bold, size: FontSize.tutorialTitle), NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Отсканируйте QR-код!", attributes: [NSAttributedString.Key.font: Functions.font(type: FontType.medium, size: FontSize.tutorialSubtitle), NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "qr")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

extension CompanyListViewController {
    
    // MARK: - Request Methods
    @objc private func updateTableView() {
        getCompanies(isAnimating: false)
    }
    
    @objc private func getCompanies(isAnimating: Bool = true) {
        if isAnimating {
            startAnimating()
        }
        
        NetworkLayer.shared.sendRequest(command: NetworkRouter.getSuppliers) { [weak self] optional in
            guard let `self` = self else { return }
            
            if let json = optional, let array = ArrayConverter.createOrUpdateArrayOfModels(command: Arrays.Suppliers, json["data"]["data"]) as? [Supplier] {
                self.data = array
                self.mainView.tableView.reloadData()
            }
            
            self.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func removeCompanyFromList(index: Int) {
        startAnimating()
        
        let id = self.data[index].producer.producer_id
        NetworkLayer.shared.sendRequest(command: .deleteSupplierRelation(id), completion: { [unowned self] json in
            
            if json != nil {
                self.data.remove(at: index)
                self.mainView.tableView.beginUpdates()
                self.mainView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.mainView.tableView.endUpdates()
            }
            
            self.stopAnimating()
        })
    }
}
