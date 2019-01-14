//
//  BasketProductTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class BasketProductTableViewCell: UITableViewCell {
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray1
        return view
    }()
    
    lazy var productImgView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "default_image")
        iv.backgroundColor = .red
        return iv
    }()
    
    lazy var nameLabel: TopAlignedLabel = {
        let label = TopAlignedLabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var oldPriceLabel = UILabel()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Functions.font(type: .regular, size: .big)
        label.textAlignment = .left
        return label
    }()
    
    lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.green1
        label.textColor = .white
        label.textAlignment = .center
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.text = "В наличии"
        return label
    }()
    
    lazy var moreLessView = MoreLessView()
    
    lazy var amountLabel : UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.big)
        label.textAlignment = .right
        return label
    }()
    
    var data: Product! {
        didSet {
            productImgView.image = UIImage(named: "default_image")
            
            if !data.images.isEmpty {
                if let urlString = data.images.first?.image_path {
                    productImgView.kf.setImage(with: Functions.generateImageURL(string: urlString))
                }
            }
            
            oldPriceLabel.attributedText = (Constants.currency + " " + data.product_price.forTraingZero()).strikeThrough(font: Functions.font(type: FontType.regular, size: FontSize.big))
            oldPriceLabel.snp.updateConstraints { (update) in
                update.width.equalTo(oldPriceLabel.intrinsicContentSize.width)
            }
            
            if let percent = data.discount?.discount_percent {
                priceLabel.text = Constants.currency + " " + (Int(data.product_price) * percent/100).description
                discountLabel.text = percent.description + Constants.percentage
                discountLabel.snp.updateConstraints { (update) in
                    update.width.equalTo(discountLabel.intrinsicContentSize.width + 20)
                }
            } else {
                priceLabel.text = Constants.currency + " " + data.product_price.forTraingZero()
                
                oldPriceLabel.snp.updateConstraints { (update) in
                    update.width.equalTo(0)
                }
                
                priceLabel.snp.updateConstraints { (update) in
                    update.left.equalTo(oldPriceLabel.snp.right).offset(0)
                }
            }
            
            moreLessView.valueLabel.text = data.cart_count.description + " шт."

            nameLabel.text = data.product_name
            amountLabel.text = (data.product_price * Double(data.cart_count)).forTraingZero() + " " + Constants.currency  
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [topView, bottomView].forEach({ contentView.addSubview($0 )})
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.65)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        [productImgView, nameLabel, oldPriceLabel, priceLabel, discountLabel].forEach({ topView.addSubview($0) })
        
        productImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(productImgView.snp.height)
        }
        
        oldPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productImgView.snp.right).offset(10)
            make.bottom.equalTo(productImgView)
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(oldPriceLabel)
            make.height.equalTo(22)
            make.left.equalTo(oldPriceLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
        }
        
        discountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImgView)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalTo(discountLabel.intrinsicContentSize.width + 10)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImgView)
            make.left.equalTo(productImgView.snp.right).offset(10)
            make.right.equalTo(discountLabel.snp.left).offset(-5)
            make.bottom.equalTo(oldPriceLabel.snp.top).offset(-5)
        }
        
        [moreLessView, amountLabel].forEach({ bottomView.addSubview($0) })
        
        moreLessView.valueLabel.font = Functions.font(type: FontType.regular, size: FontSize.big)
        moreLessView.valueLabel.backgroundColor = .white
        moreLessView.valueLabel.layer.cornerRadius = 5
        moreLessView.valueLabel.clipsToBounds = true
        
        moreLessView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        amountLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.height.equalTo(22)
            make.centerY.equalTo(moreLessView)
            make.left.equalTo(moreLessView.snp.right).offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
