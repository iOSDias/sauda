//
//  DiscountProductCollectionViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class DiscountProductCollectionViewCell: UICollectionViewCell {
    lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.green1
        label.textColor = .white
        label.textAlignment = .center
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        label.text = "В наличии"
        return label
    }()
    
    lazy var oldPriceLabel = UILabel()
    
    lazy var likeImgView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.tintColor = UIColor.gray4
        iv.image = #imageLiteral(resourceName: "like-black").withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var productImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "default_image")
        return iv
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Functions.font(type: .regular, size: .middle)
        label.textAlignment = .left
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = Functions.font(type: FontType.regular, size: FontSize.middle)
        return label
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray4
        label.textAlignment = .left
        label.font = Functions.font(type: FontType.regular, size: FontSize.middle)
        return label
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray1
        return view
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Добавить", for: .normal)
        btn.setTitleColor(UIColor.blue1, for: .normal)
        return btn
    }()
    
    lazy var moreLessView = MoreLessView()
    
    var data: Product! {
        didSet {
            productImgView.image = UIImage(named: "default_image")
                        
            if !data.images.isEmpty {
                if let urlString = data.images.first?.image_path {
                    productImgView.kf.setImage(with: Functions.generateImageURL(string: urlString))
                }
            }
        
            oldPriceLabel.attributedText = (Constants.currency + " " + data.product_price.forTraingZero()).strikeThrough(font: Functions.font(type: FontType.regular, size: FontSize.middle))
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
            moreLessView.valueLabel.text = data.cart_count.description
            
            changeVisibleOfAddButton(show: data.cart_count == 0)
            
            nameLabel.text = data.product_name
            weightLabel.text = data.product_weight.forTraingZero() + " гр"
            
            if data.isFavourite {
                setLikeState()
            } else {
                setUnlikeState()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        [likeImgView, productImgView, priceLabel, nameLabel, weightLabel, separator, addButton, moreLessView, discountLabel, oldPriceLabel].forEach({addSubview($0)})

        likeImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.baseOffset)
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalTo(likeImgView.snp.width)
        }
        
        discountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(likeImgView)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.height.equalToSuperview().multipliedBy(0.09)
            make.width.equalTo(discountLabel.intrinsicContentSize.width + 10)
        }
        
        productImgView.snp.makeConstraints { (make) in
            make.top.equalTo(likeImgView.snp.bottom).offset(Constants.baseOffset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(productImgView.snp.width).multipliedBy(1.2)
        }
        
        oldPriceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(productImgView.snp.bottom).offset(10)
            make.width.height.equalTo(22)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImgView.snp.bottom).offset(10)
            make.height.equalTo(22)
            make.left.equalTo(oldPriceLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        weightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        separator.snp.makeConstraints { (make) in
            make.top.equalTo(weightLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(separator.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        moreLessView.snp.makeConstraints { (make) in
            make.edges.equalTo(addButton)
        }
    }
    
    func likeButtonSelected() {
        let isLiked = (likeImgView.tintColor == UIColor.blue1) ? true : false
        
        if isLiked {
            setUnlikeState()
        } else {
            setLikeState()
        }
    }
    
    func setLikeState() {
        likeImgView.tintColor = UIColor.blue1
        likeImgView.image = #imageLiteral(resourceName: "like-full").withRenderingMode(.alwaysTemplate)
    }
    
    func setUnlikeState() {
        likeImgView.tintColor = UIColor.gray4
        likeImgView.image = #imageLiteral(resourceName: "like-black").withRenderingMode(.alwaysTemplate)
    }
    
    func changeVisibleOfAddButton(show: Bool) {
        addButton.isHidden = !show
        moreLessView.isHidden = show
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
