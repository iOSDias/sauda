//
//  HistoryDataTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 24.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class HistoryDataTableViewCell: UITableViewCell {
    
    private enum Constant {
        enum Size {
            enum RoundView {
                static let size: CGFloat = 16
            }
        }
        
        enum Image {
            static let calendar = UIImage(named: "calendar")!
        }
        
        enum Font {
            static let monthLabel = Functions.font(type: FontType.light, size: .normal)
            static let dayLabel = Functions.font(type: FontType.regular, size: .big)
            static let purchaseTotal = Functions.font(type: FontType.regular, size: .normal)
        }
    }
    
    // MARK: - Properties
    lazy var leftView = UIView()
    lazy var rightView = UIView()
    lazy var verticalSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray2
        return view
    }()
    
    lazy var horizontalSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray2
        return view
    }()
    
    lazy var roundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.Size.RoundView.size/2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray2.cgColor
        return view
    }()
    
    lazy var calendarImgView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = Constant.Image.calendar
        return imageView
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.dayLabel
        label.textAlignment = .center
        return label
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.monthLabel
        label.textAlignment = .center
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.purchaseTotal
        label.textColor = .blue1
        return label
    }()
    
    lazy var purchaseTotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue1
        label.textAlignment = .right
        label.font = Constant.Font.purchaseTotal
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(HistoryProductTableViewCell.self, forCellReuseIdentifier: "HistoryProductTableViewCell")
        return tableView
    }()
    
    private var height: CGFloat = 0
    
    private var statusTitle: String {
        switch data.group_status {
        case 0:     return "В обработке"
        case 1:     return "Заявка принята"
        case 2:     return "Курьер принял"
        case 3:     return "Заявка доставлена"
        case 4:     return "Заявка завершена"
        default:    return ""
        }
    }
    
    private var statusColor: UIColor {
        switch data.group_status {
        case 4:     return UIColor.red1
        default:    return UIColor.green1
        }
    }
    
    var data: HistoryData! {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var day: Int = 22
            var month: Int = 11
            
            if let date = dateFormatter.date(from: data.created_at) {

                let components = Calendar.current.dateComponents([.day, .month], from: date)
                if let componentsDay = components.day {
                    day = componentsDay
                }
                if let componentsMonth = components.month {
                    month = componentsMonth
                }
            }
            
            dayLabel.text = day.description
            monthLabel.text = month.stringOfMonthNumber
            
            statusLabel.text = statusTitle
            
            purchaseTotalLabel.text = data.group_total + " " + Constants.currency
            
            roundView.backgroundColor = statusColor
            
            height = 0
            let width = 0.8 * (UIScreen.width * 0.7 - 1) - 10 - 2 * Constants.baseOffset
            data.purchases.forEach { (purchase) in
                let nameHeight = purchase.product.product_name.height(withConstrainedWidth: width, font: Functions.font(type: FontType.regular, size: FontSize.normal))
                height += 48 + nameHeight
            }
            
            configureViews()
        }
    }
    
    // MARK: - Methods

    
    private func configureViews() {
        [leftView, verticalSeparator, horizontalSeparator, roundView, rightView].forEach({ contentView.addSubview($0) })
        
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalTo(rightView)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        [calendarImgView, monthLabel].forEach({ leftView.addSubview($0) })
        
        let imageSize = Constant.Image.calendar.size
        let imageHeight = UIScreen.width * 0.3 * 0.5 * imageSize.height / imageSize.width
        calendarImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(imageHeight)
        }
        
        calendarImgView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(imageHeight/8)
            make.centerX.equalToSuperview()
        }
        
        monthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(calendarImgView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }
        
        verticalSeparator.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
            make.left.equalTo(leftView.snp.right)
        }
        
        contentView.bringSubviewToFront(roundView)
        roundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(verticalSeparator)
            make.width.height.equalTo(Constant.Size.RoundView.size)
        }
        
        horizontalSeparator.snp.makeConstraints { (make) in
            make.centerY.equalTo(roundView)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        rightView.snp.makeConstraints { (make) in
            make.left.equalTo(verticalSeparator.snp.right)
            make.right.top.bottom.equalToSuperview()
        }
        
        [statusLabel, purchaseTotalLabel, tableView].forEach({ rightView.addSubview($0) })

        statusLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(22)
            make.width.equalTo(statusLabel.intrinsicContentSize.width)
        }

        purchaseTotalLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.centerY.equalTo(statusLabel)
            make.left.equalTo(statusLabel.snp.right).offset(8)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
            make.bottom.equalToSuperview()
        }
        tableView.reloadData()
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HistoryDataTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryProductTableViewCell", for: indexPath) as! HistoryProductTableViewCell
        cell.selectionStyle = .none
        cell.data = data.purchases[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = ProductDetailViewController()
        dvc.product_id = data.purchases[indexPath.row].product.product_id
        UIApplication.topViewController()?.navigationController?.pushViewController(dvc, animated: true)
    }
}


