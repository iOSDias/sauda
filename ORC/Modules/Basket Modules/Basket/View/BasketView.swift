//
//  BasketView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 18.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class BasketView: UIView {
    lazy var tableView = UITableView()
    lazy var amountView = TotalAmountView()
    
    lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue1
        button.setTitle("Перейти к оформлению", for: .normal)
        button.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var buttonIcon: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.gray3
        iv.image = UIImage(named: "basket-white")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        [tableView, amountView, bottomButton].forEach({ addSubview($0) })
        
        bottomButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Constants.height * 0.08)
        }
        
        bottomButton.addSubview(buttonIcon)
        var width = Constants.width * 0.1
        if let image = buttonIcon.image {
            width = image.size.width
        }
        buttonIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(width)
        }
        
        amountView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomButton.snp.top)
            make.height.equalTo(Constants.height * 0.08)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(amountView.snp.top)
        }
    }

}
