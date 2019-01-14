//
//  CreateOrderViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DeviceKit
import CoreLocation

protocol CreateOrderVCProtocol {
    func orderCreated()
}

class CreateOrderViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var mainView = CreateOrderView()
    var rows: [[OrderDetail]] = []
    var sections = ["Вы можете изменить Доставку на Самовывоз, но это может привести к изменениям в корзине", "", ""]
    var productCount: Int = 0
    var amount: Double = 0
    var latitude: Double = 0
    var longitude: Double = 0
    var isCheckBoxSelected: Bool = false
    var timer: Timer? = nil
    var delegate: CreateOrderVCProtocol? = nil
    
    let locationManager = CLLocationManager()
    
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
        createFields()
        configureNavigationBar()
        configureTableView()
        configureCLLocationManager()
        mainView.bottomButton.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
    }
}

extension CreateOrderViewController {
    
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = Functions.createTitleLabel(title: "Оформление заказа", textColor: .black)
        
        let backButton = BackButton(color: .black)
        backButton.delegate = self
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.rightBarButtonItem = EmptyBarButton()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configureTableView() {
        mainView.tableView.tableFooterView = UIView()
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(OrderFieldTableViewCell.self, forCellReuseIdentifier: "OrderFieldTableViewCell")
        mainView.tableView.register(CheckBoxTableViewCell.self, forCellReuseIdentifier: "CheckBoxTableViewCell")
    }
    
    private func createFields() {
        rows = [[OrderDetails.street, OrderDetails.house, OrderDetails.apartment, OrderDetails.floor, OrderDetails.entrance, OrderDetails.note],
                [OrderDetails.recipient, OrderDetails.phoneNumber]
        ]
        
        OrderDetails.phoneNumber.value = Constants.User.phone
    }
    
    private func configureCLLocationManager() {
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
}

extension CreateOrderViewController: CLLocationManagerDelegate {
    
    // MARK: - Location Manager Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocation = manager.location else { return }
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
        stopAnimating()
        
        let geoCoder = CLGeocoder()
        let locale = Locale.init(identifier: "ru")
        if #available(iOS 11.0, *) {
            geoCoder.reverseGeocodeLocation(currentLocation, preferredLocale: locale) { [weak self] optional, error in
                guard let `self` = self else { return }
                
                if let placeMark = optional, placeMark.count > 0 {
                    let place = placeMark[0]
                    OrderDetails.street.value = place.customAddress
                    self.mainView.tableView.reloadData()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension CreateOrderViewController: BackButtonProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - Actions and Methods
    internal func backButtonTapped() {
        OrderDetails.clearFields()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc private func bottomButtonTapped() {
        if !isCheckBoxSelected {
            "Вы должны принять наше пользовательское соглашение".showAlertView(context: .warning)
        } else {
            createOrder()
        }
    }
    
    @objc private func getCurrentLocation() {
        startAnimating()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func checkBoxTapped(sender: UIButton) {
        isCheckBoxSelected = !isCheckBoxSelected
        
        sender.setImage(isCheckBoxSelected ? UIImage(named: "checked"): UIImage(named: "uncheck"), for: .normal)
    }
}

extension CreateOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK : TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        } else {
            return rows[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.section != 2 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "OrderFieldTableViewCell", for: indexPath) as! OrderFieldTableViewCell
            cell1.field = rows[indexPath.section][indexPath.row]
            cell1.rightButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
            cell1.textField.delegate = self
            cell1.textField.tag = indexPath.section * 1000 + indexPath.row
            cell = cell1
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "CheckBoxTableViewCell", for: indexPath) as! CheckBoxTableViewCell
            cell2.checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
            cell = cell2
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: UIView!
        
        if section == 0 {
            let view = HeaderWithLabel()
            view.titleLabel.text = sections[section]
            header = view
        } else {
            header = UIView(frame: CGRect(x: 0, y: 0, width: Constants.width, height: Constants.height * 0.014))
            header.backgroundColor = UIColor.gray2
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = FooterView()
        footer.amount = amount
        footer.count = productCount
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 2 ? UITableView.automaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? UITableView.automaticDimension : Constants.height * 0.014
    }
}

extension CreateOrderViewController: UITextFieldDelegate {
    
    // MARK : TextField Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.keyboardType == .decimalPad {
            let dotsCount = textField.text!.components(separatedBy: ".").count - 1
            
            if dotsCount > 0 && (string == "." || string == ",") {
                return false
            }
            
            if string == "," {
                textField.text! += "."
                return false
            }
            
            let zeroCount = textField.text!.components(separatedBy: "0").count - 1
            if zeroCount > 0 && (string == "0") && textField.text?.count == 1 {
                return false
            }
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(getHints),
            userInfo: ["textField": textField],
            repeats: false)
        return true
    }
    
    @objc private func getHints(timer: Timer) {
        var userInfo = timer.userInfo as! [String: UITextField]
        let tf = userInfo["textField"]!
        
        let row = tf.tag%1000
        let section = tf.tag/1000
        
        guard let text = tf.text else { return }
        
        switch section {
        case 0:
            switch row {
            case 0: OrderDetails.street.value = text
            case 1: OrderDetails.house.value = text
            case 2: OrderDetails.apartment.value = text
            case 3: OrderDetails.floor.value = text
            case 4: OrderDetails.entrance.value = text
            case 5: OrderDetails.note.value = text
            default:
                print("")
            }
        case 1:
            if row == 0 {
                OrderDetails.recipient.value = text
            } else if row == 1 {
                OrderDetails.phoneNumber.value = text
            }
        default:
            print("")
        }
    }
}

extension CreateOrderViewController {
    
    // MARK : Request Methods
    private func createOrder() {
        startAnimating()
        
        let address = [OrderDetails.street.value, OrderDetails.house.value, OrderDetails.apartment.value, OrderDetails.floor.value, OrderDetails.entrance.value].filter({ $0 != "" }).joined(separator: ",")
        NetworkLayer.shared.sendRequest(command: .createOrder(latitude, longitude, address)) { [unowned self] json in
            
            if json != nil {
                self.backButtonTapped()
                self.delegate?.orderCreated()
            }
            
            self.stopAnimating()
        }
    }
}
