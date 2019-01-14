//
//  HeaderWithLabel.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class HeaderWithLabel: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.small)
        label.textColor = UIColor.gray4
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        [titleLabel, separator].forEach({ addSubview($0) })
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
        }
        
        separator.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.height * 0.014)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
