//
//  AuthorizationView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 09.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AuthorizationView: UIView {
    lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "clearBack")
        return iv
    }()
    
    lazy var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.medium, size: FontSize.normal)
        label.textAlignment = .center
        label.text = "Pixel 2018, Караганда"
        label.textColor = .white
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        return label
    }()
    
    lazy var phoneTF: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.iconText = "+7 "
        textField.iconFont = Functions.font(type: FontType.regular, size: FontSize.normal)
        textField.iconColor = .black
        textField.selectedIconColor = .black
        textField.autocorrectionType = .no
        textField.placeholder = "Введите номер телефона*"
        textField.title = "Ваш номер телефона*"
        textField.textColor = .black
        textField.tintColor = UIColor.blue1
        textField.lineColor = .black
        textField.selectedTitleColor = UIColor.blue1
        textField.selectedLineColor = UIColor.blue1
        textField.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        return textField
    }()
    
    lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(UIColor.blue1, for: .normal)
        button.layer.borderColor = UIColor.blue1.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.isUserInteractionEnabled = false
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
    
    func changeEnterButtonState(toEnabled: Bool) {
        enterButton.isUserInteractionEnabled = toEnabled

        if toEnabled {
            enterButton.setTitleColor(.white, for: .normal)
            enterButton.layer.borderWidth = 0
            enterButton.backgroundColor = UIColor.blue1
        } else {
            enterButton.setTitleColor(UIColor.blue1, for: .normal)
            enterButton.layer.borderColor = UIColor.blue1.cgColor
            enterButton.layer.borderWidth = 1
            enterButton.backgroundColor = .white
        }
    }
    
    func configUI() {
        backgroundColor = .white
    
        [imgView, bottomLabel, centerView].forEach({addSubview($0)})
        
        [phoneTF, enterButton].forEach({centerView.addSubview($0)})
        
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bottomLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        centerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.baseOffset * 4 + 44)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(UIScreen.height * 0.25)
        }
        
        let space = (Constants.height * 0.25 * 0.5 - Constants.baseOffset * 2) / 2
        
        enterButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.bottom.equalToSuperview().offset(-space)
        }
        
        phoneTF.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.height.equalTo(45)
            make.bottom.equalTo(enterButton.snp.top).offset(-Constants.baseOffset * 2)
        }
    }
}
