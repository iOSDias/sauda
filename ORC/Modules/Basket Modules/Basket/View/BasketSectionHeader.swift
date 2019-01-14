//
//  BasketSectionHeader.swift
//  ORC
//
//  Created by Dias Ermekbaev on 24.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class BasketSectionHeader: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: .regular, size: FontSize.normal)
        label.textColor = UIColor.gray4
        label.text = "Список покупок"
        return label
    }()
    
    lazy var cleanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Очистить", for: .normal)
        button.setTitleColor(UIColor.green1, for: .normal)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = Functions.font(type: FontType.medium, size: FontSize.middle)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray1
        [titleLabel, cleanButton].forEach({addSubview($0)})
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(Constants.baseOffset)
        }
        
        var buttonWidth: CGFloat = 0
        
        if let width = cleanButton.titleLabel?.intrinsicContentSize.width {
            buttonWidth = width
        } else {
            buttonWidth = Constants.width * 0.2
        }
        
        cleanButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(buttonWidth)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
