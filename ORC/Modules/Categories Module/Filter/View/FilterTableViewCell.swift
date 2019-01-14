//
//  FilterTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 11/22/18.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    // MARK: - Properties
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .gray4
        textField.autocorrectionType = .no
        return textField
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray5
        return view
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: CGFloat(UIScreen.width - 2 * Constants.baseOffset - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25)))
        label.textAlignment = .center
        return label
    }()
    
    var field: FilterField! {
        didSet {
            textField.text = field.value
            
            if let text = field.textFieldRightViewValue {
                rightLabel.text = text
                textField.rightView = rightLabel
                textField.rightViewMode = .always
            }
        }
    }
    
    // MARK: - Methods
    private func configureViews() {
        [textField, separator].forEach({ contentView.addSubview($0) })
        
        separator.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(1)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(separator.snp.top)
            make.left.right.equalTo(separator)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
