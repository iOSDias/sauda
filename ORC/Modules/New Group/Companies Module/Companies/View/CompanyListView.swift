//
//  CompanyListView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 19.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class CompanyListView: UIView {
    
    // MARK: Enums
    private enum Constant {
        enum Title {
            static let button = "Сканировать QR Code"
        }
    }

    // MARK: - Properties
    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.green1
        button.setTitle(Constant.Title.button, for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var tableView = UITableView()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [bottomButton, tableView].forEach({ addSubview($0) })
        bottomButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomButton.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
