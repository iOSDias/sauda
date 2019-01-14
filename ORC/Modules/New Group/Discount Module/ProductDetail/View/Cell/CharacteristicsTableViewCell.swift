//
//  CharacteristicsTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 26.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class CharacteristicsTableViewCell: UITableViewCell {
    var titles: [String] = []
    var values: [String] = []

    var leftLabels: [UILabel] = []
    var rightLabels: [UILabel] = []
    
    var data: Product! {
        didSet {
            titles = ["Вес", "Размер", "Компания", "Адрес", "Телефон"]
            values = [data.product_weight.forTraingZero(), data.product_size.forTraingZero(), data.producer.producer_name, data.producer.producer_address, data.producer.producer_tel1]
            data.fields_and_values.forEach { (fv) in
                let field = fv.field.field_name
                let value = fv.value.value
                titles.insert(field, at: 0)
                values.insert(value, at: 0)
            }
            configureViews()
        }
    }
    
    private func configureViews() {
        leftLabels.removeAll()
        rightLabels.removeAll()
        
        titles.forEach { (title) in
            let leftLabel = UILabel()
            leftLabel.text = title
            leftLabel.font = Functions.font(type: FontType.regular, size: FontSize.normal)
            leftLabel.textColor = UIColor.gray3
            leftLabels.append(leftLabel)
            
            let rightLabel = UILabel()
            rightLabel.font = Functions.font(type: FontType.regular, size: FontSize.normal)
            rightLabel.textAlignment = .right
            rightLabels.append(rightLabel)
            
            [leftLabel, rightLabel].forEach({ contentView.addSubview($0) })
        }
        
        leftLabels.enumerated().forEach { (index, label) in
            label.snp.makeConstraints({ (make) in
                if index == 0 {
                    make.top.equalToSuperview().offset(Constants.baseOffset)
                } else {
                    make.top.equalTo(leftLabels[index - 1].snp.bottom).offset(Constants.baseOffset)
                }
                
                make.left.equalToSuperview().offset(Constants.baseOffset)
                make.width.equalTo(label.intrinsicContentSize.width)
                make.height.equalTo(22)
                
                if label == leftLabels.last {
                    make.bottom.equalToSuperview().offset(-Constants.baseOffset)
                }
            })
        }
        
        values.enumerated().forEach { (index, text) in
            rightLabels[index].text = text
        }
        
        rightLabels.enumerated().forEach { (index, label) in
            label.snp.makeConstraints({ (make) in
                if index == 0 {
                    make.top.equalToSuperview().offset(Constants.baseOffset)
                } else {
                    make.top.equalTo(leftLabels[index - 1].snp.bottom).offset(Constants.baseOffset)
                }
                
                make.right.equalToSuperview().offset(-Constants.baseOffset)
                make.left.equalTo(leftLabels[index].snp.right).offset(5)
                make.height.equalTo(22)
            })
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
