//
//  ProfileSectionLabelHeader.swift
//  ORC
//
//  Created by Dias Ermekbaev on 23.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class ProfileSectionLabelHeader: UIView {
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray3
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray5
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        return label
    }()
    
    var arrowImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "arrow_down")
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [titleLabel, arrowImgView, separator].forEach({ addSubview($0) })
        separator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        arrowImgView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalTo(arrowImgView.snp.height)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowImgView.snp.left).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
