//
//  DescriptionTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 26.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.textColor = UIColor.gray3
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var data: Product! {
        didSet {
            label.text = data.product_description
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.baseOffset)
            make.top.equalToSuperview().offset(UIScreen.baseOffset)
            make.right.equalToSuperview().offset(-UIScreen.baseOffset)
            make.bottom.equalToSuperview().offset(-UIScreen.baseOffset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
