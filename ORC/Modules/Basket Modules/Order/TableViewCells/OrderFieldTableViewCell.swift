//
//  OrderFieldTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class OrderFieldTableViewCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.medium, size: FontSize.normal)
        return label
    }()
    
    var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Нет данных"
        tf.autocorrectionType = .no
        return tf
    }()
    
    var rightButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor.gray4
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "location")?.withRenderingMode(.alwaysTemplate), for: .normal)
        return btn
    }()
    
    var separator = UIView()
    var withButton: Bool = false
    
    var field: OrderDetail! {
        didSet {
            textField.keyboardType = field.keyboardType
            var title = field.title
            if field.isRequired {
                title = title + "*"
            }
            titleLabel.text = title
            textField.text = field.value
            
            withButton = field.withButton
            
            constraintsUpdating()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.width.equalTo(21)
            make.height.equalTo(21)
        }
        
        addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(rightButton.snp.left).offset(-5)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom)
            make.left.right.equalTo(textField)
            make.height.equalTo(1)
        }
    }
    
    func constraintsUpdating() {
        titleLabel.snp.updateConstraints { (update) in
            update.width.equalTo(titleLabel.intrinsicContentSize.width)
        }
        
        if !withButton {
            rightButton.snp.updateConstraints { (update) in
                update.width.equalTo(0)
            }
        }
    }
    
}
