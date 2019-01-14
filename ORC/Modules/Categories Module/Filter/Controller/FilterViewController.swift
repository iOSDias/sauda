//
//  FilterViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 11/22/18.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    // MARK: - Properties
    private var mainView = FilterView()
    private var fields = [FilterFields.searchFilter, FilterFields.minPriceFilter, FilterFields.maxPriceFilter]
    private var oldValues: [String?] = []
    var updateHandler: (() -> ())!

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
        configureNavigationBar()
        configureTableView()
        configureLocalFilters()
        mainView.bottomButton.addTarget(self, action: #selector(bottomButtonTouchUp), for: .touchUpInside)
    }
}

extension FilterViewController {
    
    // MARK: - Configure Views
    private func configureLocalFilters() {
        fields.forEach({ oldValues.append($0.value) })
    }
    
    private func configureNavigationBar() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .white
        
        navigationItem.titleView = Functions.createTitleLabel(title: "Фильтр", textColor: .black)
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTouchUp))
        cancelBarButtonItem.tintColor = .red1
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        let resetBarButtonItem = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(resetButtonTouchUp))
        resetBarButtonItem.tintColor = .red1
        navigationItem.rightBarButtonItem = resetBarButtonItem
    }
    
    private func configureTableView() {
        mainView.tableView.tableFooterView = UIView()
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
    }
}

extension FilterViewController {
    
    // MARK: - Actions Views
    @objc func cancelButtonTouchUp() {
        view.endEditing(true)
        fields.enumerated().forEach { (index, field) in
            field.value = oldValues[index]
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func resetButtonTouchUp() {
        view.endEditing(true)
        FilterFields.clearFields()
        mainView.tableView.reloadData()
    }
    
    @objc func bottomButtonTouchUp() {
        view.endEditing(true)
        updateHandler()
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        cell.textField.tag = indexPath.section
        cell.textField.delegate = self
        cell.field = field
        
        if field.title == "min" || field.title == "max" {
            cell.textField.keyboardType = .decimalPad
            cell.textField.textAlignment = .right
        } else {
            cell.textField.keyboardType = .default
            cell.textField.textAlignment = .left
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FilterHeaderView()
        header.titleLabel.text = fields[section].header
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension FilterViewController: UITextFieldDelegate {
    
    // MARK: - TextField Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.selectedTextRange = nil
        
        fields[textField.tag].value = textField.text
    }
}
