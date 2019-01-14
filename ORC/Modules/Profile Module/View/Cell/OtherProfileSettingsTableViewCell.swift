//
//  OtherProfileSettingsTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 23.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class OtherProfileSettingsTableViewCell: UITableViewCell {
    lazy var iconImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        return label
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray3
        return view
    }()
    
    var data: ProfileRow! {
        didSet {
            iconImgView.image = data.icon
            titleLabel.text = data.title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [iconImgView, titleLabel, separator].forEach({addSubview($0)})
        
        separator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        iconImgView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-11)
            make.width.height.equalTo(Constants.width * 0.05)
            make.left.equalToSuperview().offset(Constants.baseOffset)
        })
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgView.snp.right).offset(Constants.baseOffset)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Constants.baseOffset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
