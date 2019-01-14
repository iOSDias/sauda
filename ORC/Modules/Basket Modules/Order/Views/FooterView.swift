//
//  FooterView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FooterView: UIView {
    lazy var topLeftLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.textColor = UIColor.gray4
        return label
    }()
    
    lazy var bottomLeftLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.textColor = UIColor.gray4
        label.text = "Стоимость доставки:"
        return label
    }()
    
    lazy var topRightLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    lazy var bottomRightLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.textColor = .black
        label.textAlignment = .right
        label.text = "Бесплатно"
        return label
    }()
    
    var count: Int! {
        didSet {
            topLeftLabel.text = count.description + " товар" + count.productEndingType() + " на сумму:"
            topLeftLabel.snp.updateConstraints { (update) in
                update.width.equalTo(topLeftLabel.intrinsicContentSize.width)
            }
        }
    }
    
    var amount: Double! {
        didSet {
            topRightLabel.text = amount.forTraingZero() + " " + Constants.currency

        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        [topLeftLabel, topRightLabel, bottomLeftLabel, bottomRightLabel].forEach({ addSubview($0) })
        topLeftLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.baseOffset * 2)
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        
        topRightLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.baseOffset * 2)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.left.equalTo(topLeftLabel.snp.right).offset(5)
            make.height.equalTo(22)
        }
        
        bottomLeftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLeftLabel.snp.bottom).offset(Constants.baseOffset)
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.width.equalTo(bottomLeftLabel.intrinsicContentSize.width)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-Constants.baseOffset)
        }
        
        bottomRightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLeftLabel.snp.bottom).offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.left.equalTo(bottomLeftLabel.snp.right).offset(5)
            make.height.equalTo(22)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
