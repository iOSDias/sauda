//
//  ProductDetailSectionHeader.swift
//  ORC
//
//  Created by Dias Ermekbaev on 26.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class ProductDetailSectionHeader: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.medium, size: FontSize.normal)
        return label
    }()
    
    lazy var showAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("См.все", for: .normal)
        button.setTitleColor(.blue1, for: .normal)
        button.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.big)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray3
        [titleLabel, showAllButton].forEach({ addSubview($0) })

        showAllButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.width.equalTo(showAllButton.titleLabel!.intrinsicContentSize.width)
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalTo(showAllButton.snp.left).offset(-5)
            make.height.equalTo(22)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
