//
//  ProfileView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DeviceKit

class ProfileView: UIView {
    lazy var tableView = UITableView()

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
        
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            if Device() == .iPhoneX || Device() == .simulator(.iPhoneX) {
                make.bottom.equalToSuperview().offset(-34)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
