//
//  HistorySectionHeader.swift
//  ORC
//
//  Created by Dias Ermekbaev on 24.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class HistorySectionHeader: UIView {
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Даты"
        label.textAlignment = .center
        label.font = Functions.font(type: FontType.regular, size: FontSize.big)
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.text = "Заявки"
        label.textAlignment = .center
        label.font = Functions.font(type: FontType.regular, size: FontSize.big)
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
        [leftLabel, rightLabel, separator].forEach({addSubview($0)})
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        separator.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(leftLabel.snp.right)
            make.width.equalTo(1)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(separator.snp.right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
