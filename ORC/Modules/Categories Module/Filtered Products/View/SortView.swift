//
//  SortView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 21.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class SortView: UIView {
    
    // MARK: - Enums
    private enum Constant {
        enum Image {
            static let icon = UIImage(named: "sort")!
            static let button = UIImage(named: "sort-button-icon")!
        }
    }

    // MARK: - Properties
    lazy var iconImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = Constant.Image.icon.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .blue1
        return imageView
    }()
    
    lazy var verticalSeparator1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    lazy var verticalSeparator2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    lazy var verticalSeparator3: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    lazy var typeButton: ButtonWithImage = {
        let button = ButtonWithImage(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .left
        button.setImage(Constant.Image.button, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var directionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .blue1
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Фильтры", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // MARK: - Methods
    private func congifureViews() {
        backgroundColor = .white
        let iconView = UIView()
        let typeView = UIView()
        let directionView = UIView()
        let filterView = UIView()
        
        [iconView, typeView, directionView, filterView, verticalSeparator1, verticalSeparator2, verticalSeparator3].forEach({ addSubview($0) })
        
        iconView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        iconView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview()
        }
        
        verticalSeparator1.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        typeView.snp.makeConstraints { (make) in
            make.left.equalTo(verticalSeparator1.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        typeView.addSubview(typeButton)
        typeButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        verticalSeparator2.snp.makeConstraints { (make) in
            make.left.equalTo(typeView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        directionView.snp.makeConstraints { (make) in
            make.left.equalTo(verticalSeparator2.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        directionView.addSubview(directionButton)
        directionButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview()
        }
        
        verticalSeparator3.snp.makeConstraints { (make) in
            make.left.equalTo(directionView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        filterView.snp.makeConstraints { (make) in
            make.left.equalTo(verticalSeparator3.snp.right)
            make.top.bottom.right.equalToSuperview()
        }
        
        filterView.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        congifureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
