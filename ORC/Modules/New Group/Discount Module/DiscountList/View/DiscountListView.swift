//
//  DiscountListView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DeviceKit

class DiscountListView: UIView {
    var searchView = SearchView()
    var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        backgroundColor = .white
        [searchView, tableView].forEach({ addSubview($0) })
        searchView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.left.right.equalToSuperview()
            if Device() == .iPhoneX || Device() == .simulator(.iPhoneX) {
                make.bottom.equalToSuperview().offset(-34)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
