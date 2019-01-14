//
//  DiscountProductsView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DeviceKit

class SingleCollectionView: UIView {
    var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        backgroundColor = UIColor.gray4
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
