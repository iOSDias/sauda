//
//  CodeConfirmationView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 10.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DeviceKit

class CodeConfirmationView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Вам отправлен\nкод подтверждения на номер"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = Functions.font(type: FontType.regular, size: FontSize.huge)
        return label
    }()
    
    var textFields: [SkyFloatingLabelTextField] = []
    
    lazy var sendCodeAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить код повторно", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.big)
        return button
    }()
    
    lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Завершить", for: .normal)
        button.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.big)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        backgroundColor = .white
        
        for _ in 0..<4 {
            let textField = SkyFloatingLabelTextField()
            textField.autocorrectionType = .no
            textField.placeholder = ""
            textField.title = ""
            textField.textColor = UIColor.blue1
            textField.lineColor = .black
            textField.selectedLineColor = .blue
            textField.keyboardType = .decimalPad
            textField.textAlignment = .center
            textField.font = Functions.font(type: FontType.medium, size: FontSize.tutorialTitle)
            addSubview(textField)
            textFields.append(textField)
        }

        
        [titleLabel, sendCodeAgainButton, bottomButton].forEach({addSubview($0)})
        
        let height = titleLabel.text!.height(withConstrainedWidth: UIScreen.width, font: titleLabel.font)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.baseOffset * 5)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
        }

        textFields.enumerated().forEach { (index, textField) in
            let digitWidth = (Constants.width - 2 * Constants.baseOffset - 30)/4

            textField.snp.makeConstraints({ (make) in
                if index == 0 {
                    make.left.equalToSuperview().offset(Constants.baseOffset)
                } else {
                    make.left.equalTo(textFields[index - 1].snp.right).offset(10)
                }
                
                make.top.equalTo(titleLabel.snp.bottom).offset(Constants.baseOffset * 4)
                make.width.equalTo(digitWidth)
                make.height.equalToSuperview().multipliedBy(0.1)
                
                if index == textFields.endIndex {
                    make.right.equalToSuperview().offset(-Constants.baseOffset)
                }
            })
        }
        
        sendCodeAgainButton.snp.makeConstraints { (make) in
            make.top.equalTo(textFields.first!.snp.bottom).offset(Constants.baseOffset * 2)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        bottomButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.height.equalToSuperview().multipliedBy(0.06)
            if Device() == .iPhoneX || Device() == .simulator(.iPhoneX) {
                make.bottom.equalToSuperview().offset(-(34 + Constants.baseOffset))
            } else {
                make.bottom.equalToSuperview().offset(-Constants.baseOffset)
            }
        }
    }

}
