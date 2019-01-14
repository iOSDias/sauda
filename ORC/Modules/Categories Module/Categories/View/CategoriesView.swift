//
//  CategoriesView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DeviceKit

class CategoriesView: UIView {
    lazy var imgView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "shopping")
        return iv
    }()
    
    lazy var tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray1
        
        [imgView, tableView].forEach({addSubview($0)})
        imgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Constants.height * 0.2)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom)
            make.left.right.equalToSuperview()
            if Device() == .iPhoneX || Device() == .simulator(.iPhoneX) {
                make.bottom.equalToSuperview().offset(-34)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
