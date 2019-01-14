//
//  HistoryProductTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 24.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class HistoryProductTableViewCell: UITableViewCell {
    
    // MARK: - Enums
    enum Constant {
        enum Offset {
            enum ProductImageView {
                static let left: CGFloat = Constants.baseOffset
            }
            
            enum NameLabel {
                static let left: CGFloat = 10
                static let right: CGFloat = Constants.baseOffset
                static let top: CGFloat = 10
            }
            
            enum Separator {
                static let horizontal: CGFloat = Constants.baseOffset
            }
            
            enum CalculationLabel {
                static let top: CGFloat = 5
                static let right: CGFloat = Constants.baseOffset
                static let left: CGFloat = 10
                static let bottom: CGFloat = 10
            }
        }
        
        enum Size {
            enum ProductImageView {
                static let width: CGFloat = (UIScreen.width * 0.7 - 1) * 0.2
            }
            
            enum Separator {
                static let height: CGFloat = 1
            }
            
            enum CalculationLabel {
                static let height: CGFloat = 22
            }
        }
        
        enum Font{
            static let nameLabel = Functions.font(type: FontType.regular, size: FontSize.normal)
        }
    }
    
    // MARK: - Properties
    lazy var productImageView = CustomImageView()
    
    lazy var nameLabel: TopAlignedLabel = {
        let label = TopAlignedLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Constant.Font.nameLabel
        label.textColor = .black
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.textColor = .gray4
        return label
    }()
    
    lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.textColor = .gray4
        label.textAlignment = .right
        return label
    }()
    
    var data: Purchase! {
        didSet {
            productImageView.image = UIImage(named: "default_image")
            
            if !data.product.images.isEmpty {
                if let urlString = data.product.images.first?.image_path {
                    productImageView.kf.setImage(with: Functions.generateImageURL(string: urlString))
                }
            }

            nameLabel.text = data.product.product_name
            let quantity = data.purchase_count + " штук"
            let total = data.purchase_total + " " + Constants.currency
            countLabel.text = quantity
            totalPriceLabel.text = total
            
            countLabel.snp.updateConstraints { (update) in
                update.width.equalTo(countLabel.intrinsicContentSize.width)
            }
            
            let height = nameLabel.text?.height(withConstrainedWidth: UIScreen.width * 0.7 - 1 - Constant.Size.ProductImageView.width - Constant.Offset.ProductImageView.left - Constant.Offset.NameLabel.left - Constant.Offset.NameLabel.right, font: nameLabel.font)
            nameLabel.snp.updateConstraints { (update) in
                update.height.equalTo(height!)
            }
        }
    }
    
    private func configureViews() {
        [productImageView, nameLabel, countLabel, totalPriceLabel].forEach({ contentView.addSubview($0) })

        productImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constant.Offset.ProductImageView.left)
            make.width.equalTo(Constant.Size.ProductImageView.width)
            make.top.equalTo(nameLabel)
            make.bottom.equalTo(countLabel)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constant.Offset.NameLabel.top)
            make.right.equalToSuperview().offset(-Constant.Offset.NameLabel.right)
            make.left.equalTo(productImageView.snp.right).offset(Constant.Offset.NameLabel.left)
            make.height.equalTo(22)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constant.Offset.CalculationLabel.top)
            make.left.equalTo(nameLabel)
            make.height.equalTo(Constant.Size.CalculationLabel.height)
            make.width.equalTo(22)
            make.bottom.equalToSuperview().offset(-Constant.Offset.CalculationLabel.bottom)
        }
        
        totalPriceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(countLabel)
            make.right.equalTo(nameLabel)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
