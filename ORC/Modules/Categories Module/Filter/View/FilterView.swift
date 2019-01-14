//
//  FilterView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 11/22/18.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FilterView: UIView {

    // MARK: - Properties
    lazy var tableView = UITableView()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        return view
    }()
    
    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Применить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue1
        return button
    }()
    
    // MARK: - Methods
    private func configureViews() {
        [tableView, bottomView].forEach({ addSubview($0) })
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        bottomView.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.baseOffset)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
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
