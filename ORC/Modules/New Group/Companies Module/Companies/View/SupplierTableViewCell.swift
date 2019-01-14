//
//  SupplierTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 20.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class SupplierTableViewCell: UITableViewCell {
    
    // MARK: - Enums
    private enum Constant {
        enum Offset {
            enum ImgView {
                static var top = 10
                static var bottom = 10
                static var left = Constants.baseOffset
            }
            
            enum NameLabel {
                static var left = 10
                static var right = Constants.baseOffset
            }
            
            enum Separator {
                static var horizontal = Constants.baseOffset
            }
        }
        
        enum Size {
            enum ImgView {
                static var side = UIScreen.width * 0.25
            }
            
            enum Separator {
                static var height = 1
            }
        }
    }

    // MARK: - Properties
    lazy var imgView = CustomImageView()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray4
        return view
    }()
    
    var data: Supplier! {
        didSet {
            nameLabel.text = data.producer.producer_name
        }
    }
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [imgView, nameLabel, separator].forEach({ contentView.addSubview($0) })
        
        imgView.image = UIImage(named: "default_image")
        
        separator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(Constant.Size.Separator.height)
            make.left.equalToSuperview().offset(Constant.Offset.Separator.horizontal)
            make.right.equalToSuperview().offset(-Constant.Offset.Separator.horizontal)
        }
        
        imgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constant.Offset.ImgView.top)
            make.bottom.equalTo(separator.snp.top).offset(-Constant.Offset.ImgView.bottom)
            make.left.equalToSuperview().offset(Constant.Offset.ImgView.left)
            make.width.height.equalTo(Constant.Size.ImgView.side)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(Constant.Offset.NameLabel.left)
            make.right.equalToSuperview().offset(-Constant.Offset.NameLabel.right)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
