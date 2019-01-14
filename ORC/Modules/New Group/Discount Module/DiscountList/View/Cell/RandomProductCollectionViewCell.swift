//
//  RandomProductCollectionViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 23.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class RandomProductCollectionViewCell: UICollectionViewCell {
    lazy var imgView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.small)
        label.textAlignment = .center
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.purple1
        label.font = Functions.font(type: FontType.regular, size: FontSize.small)
        return label
    }()
    
    var data: Product! {
        didSet {
            imgView.image = UIImage(named: "default_image")

            if !data.images.isEmpty {
                if let urlString = data.images.first?.image_path {
                    imgView.kf.setImage(with: Functions.generateImageURL(string: urlString))
                }
            }
            
            titleLabel.text = data.product_name
            priceLabel.text = data.product_price.forTraingZero() + " " + Constants.currency
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imgView, priceLabel, titleLabel].forEach({addSubview($0)})
        
        priceLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8)
            make.height.equalTo(22)
            make.right.equalToSuperview().offset(-8)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(priceLabel.snp.top).offset(-8)
            make.left.equalToSuperview().offset(8)
            make.height.equalTo(22)
            make.right.equalToSuperview().offset(-8)
        }
        
        imgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
