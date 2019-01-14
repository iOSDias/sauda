//
//  FilterProductsView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 22.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FilterProductsView: UIView {
    
    // MARK: - Properties
    lazy var sortView = SortView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    // MARK: - Methods
    private func configureViews() {
        [sortView, collectionView, separator].forEach({ addSubview($0) })
        
        sortView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        separator.snp.makeConstraints { (make) in
            make.top.equalTo(sortView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(separator.snp.bottom)
            make.left.right.bottom.equalToSuperview()
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
