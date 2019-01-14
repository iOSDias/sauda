//
//  CustomNavigationBar.swift
//  ORC
//
//  Created by Dias Ermekbaev on 09.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray4
        return view
    }()
    
    var backButton: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .black
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.medium, size: FontSize.normal)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func hideBackButton() {
        backButton.isHidden = false
    }
    
    func showBackButton() {
        backButton.isHidden = false
    }
    
    func setupViews() {
        backgroundColor = .white
        [backButton, titleLabel, separator].forEach({addSubview($0)})
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(backButton.snp.height)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(22)
            make.width.equalTo(Constants.width * 0.5)
        }
        
        separator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
