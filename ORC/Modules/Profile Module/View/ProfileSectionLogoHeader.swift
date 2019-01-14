//
//  ProfileSectionLogoHeader.swift
//  ORC
//
//  Created by Dias Ermekbaev on 23.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class ProfileSectionLogoHeader: UIView {
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.small)
        label.textAlignment = .center
        label.text = "Версия " + Constants.appVersion + " (iOS)[2017]"
        return label
    }()
    
    lazy var logoImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo-colored")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [versionLabel, logoImgView, separator].forEach({addSubview($0)})
        
        separator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        logoImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-16)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(logoImgView.snp.width).multipliedBy(0.2)
        }
        
        versionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImgView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
