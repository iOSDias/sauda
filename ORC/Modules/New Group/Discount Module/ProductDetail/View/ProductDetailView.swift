//
//  ProductDetailView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 26.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class ProductDetailView: UIView {
    
    // MARK : - Properties
    lazy var tableView = UITableView()
    lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue1
        button.setTitle("Добавить в корзину", for: .normal)
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
    
    lazy var separator = UIView()

    lazy var moreLessView = MoreLessView()
    
    
    // MARK: - Methods
    private func configureViews() {
        backgroundColor = .white
        
        separator.backgroundColor = UIColor.gray4
        
        [tableView, bottomButton, moreLessView, separator].forEach({ addSubview($0) })
        
        bottomButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Constants.height * 0.08)
        }
        
        separator.isHidden = true
        separator.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomButton.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        moreLessView.isHidden = true
        moreLessView.valueLabel.font = Functions.font(type: FontType.regular, size: FontSize.big)
        moreLessView.snp.makeConstraints { (make) in
            make.center.equalTo(bottomButton)
            make.width.equalToSuperview()
            make.height.equalTo(Constants.height * 0.04)
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
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomButton.snp.top)
        }
    }
    
    func changeBottomButtonState() {
        moreLessView.isHidden = bottomButton.isHidden
        separator.isHidden = bottomButton.isHidden
        buttonIcon.isHidden = !bottomButton.isHidden
        bottomButton.isHidden = !bottomButton.isHidden
    }
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
