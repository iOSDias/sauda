//
//  TotalAmountView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class TotalAmountView: UIView {
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: .regular, size: FontSize.normal)
        label.textColor = UIColor.gray4
        label.text = "Общая сумма"
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: .regular, size: .huge)
        label.textColor = .black
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray4
        return view
    }()
    
    var amount: Double! {
        didSet {
            rightLabel.text = amount.forTraingZero() + " " + Constants.currency
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        backgroundColor = UIColor.gray1
        [leftLabel, rightLabel, separator].forEach({addSubview($0)})
        separator.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(leftLabel.intrinsicContentSize.width)
            make.height.equalTo(22)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(22)
            make.centerY.equalTo(leftLabel)
        }
    }
}
