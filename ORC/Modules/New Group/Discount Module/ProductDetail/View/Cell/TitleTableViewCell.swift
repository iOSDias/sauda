//
//  TitleTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 26.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import Cosmos

class TitleTableViewCell: UITableViewCell {
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue1
        label.font = Functions.font(type: FontType.regular, size: FontSize.big)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.big)
        return label
    }()
    
    var starView: CosmosView = {
        let view = CosmosView()
        view.settings.filledColor = .blue1
        view.settings.emptyColor = .white
        view.settings.emptyBorderWidth = 1
        view.settings.emptyBorderColor = .black
        view.settings.fillMode = StarFillMode.half
        view.rating = 5
        view.settings.totalStars = 5
        view.settings.starMargin = 0
        view.settings.starSize = 25
        view.settings.updateOnTouch = true
        view.isUserInteractionEnabled = Constants.User.hasToken()
        return view
    }()
    
    lazy var reviewAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        return label
    }()
    
    lazy var allReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Все отзывы & Оценки", for: .normal)
        button.setImage(UIImage(named: "arrow-right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        button.setTitleColor(.gray, for: .normal)
        button.tintColor = .gray
        button.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    var data: Product! {
        didSet {
            if let percent = data.discount?.discount_percent {
                priceLabel.text = "₸" + (Int(data.product_price) * percent/100).description
            } else {
                priceLabel.text = "₸" + data.product_price.forTraingZero()
            }
            
            nameLabel.text = data.product_name
            
            if let rank = data.avg_rank {
                reviewAmountLabel.text = "(" + rank.avg_count.description + ")"
            } else {
                reviewAmountLabel.text = "(1)"
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [nameLabel, priceLabel, starView, reviewAmountLabel, allReviewButton].forEach({ contentView.addSubview($0) })
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.height.equalTo(22)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(Constants.baseOffset)
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
        }
        
        allReviewButton.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(32)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        starView.snp.makeConstraints { (make) in
            make.centerY.equalTo(allReviewButton)
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.height.equalTo(25)
            make.width.equalTo(25 * 5)
        }

        reviewAmountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(starView)
            make.left.equalTo(starView.snp.right).offset(3)
            make.right.equalTo(allReviewButton.snp.left).offset(-5)
            make.height.equalTo(22)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
