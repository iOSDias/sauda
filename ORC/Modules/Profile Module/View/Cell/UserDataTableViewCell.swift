//
//  UserDataTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 23.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class UserDataTableViewCell: UITableViewCell {
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
    
    lazy var subtitleLabel: TopAlignedLabel = {
        let label = TopAlignedLabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.textColor = UIColor.gray4
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
            subtitleLabel.text = data.subtitle
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [iconImgView, titleLabel, subtitleLabel, separator].forEach({ addSubview($0) })
        
        separator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        iconImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.width.height.equalTo(Constants.width * 0.05)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.baseOffset)
            make.height.equalTo(22)
            make.left.equalTo(iconImgView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.bottom.equalToSuperview().offset(-11)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
