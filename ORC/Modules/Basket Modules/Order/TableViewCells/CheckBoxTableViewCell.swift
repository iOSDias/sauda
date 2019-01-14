//
//  CheckBoxTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class CheckBoxTableViewCell: UITableViewCell {
    lazy var checkBox: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "uncheck"), for: .normal)
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Я согласен с правилами сервиса"
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let separator = UIView()
        separator.backgroundColor = UIColor.gray4
        
        [titleLabel, checkBox, separator].forEach({contentView.addSubview($0)})

        separator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        checkBox.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.height.width.equalTo(25)
            make.bottom.equalTo(separator.snp.top).offset(-10)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(checkBox.snp.right).offset(Constants.width * 0.025)
            make.centerY.equalTo(checkBox)
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
