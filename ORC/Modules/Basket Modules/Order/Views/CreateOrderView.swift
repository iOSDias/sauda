//
//  CreateOrderView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class CreateOrderView: UIView {
    lazy var tableView = UITableView()

    lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue1
        button.setTitle("ОФОРМИТЬ", for: .normal)
        button.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [tableView, bottomButton].forEach({addSubview($0)})
        
        bottomButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
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
