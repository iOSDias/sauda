//
//  FilterHeaderView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 11/22/18.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FilterHeaderView: UIView {

    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    // MARK: - Methods
    private func configureViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constants.baseOffset)
            make.right.equalToSuperview().offset(-Constants.baseOffset)
            make.centerY.equalToSuperview()
        }
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
