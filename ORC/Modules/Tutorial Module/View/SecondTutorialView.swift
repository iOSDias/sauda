//
//  SecondTutorialView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 12/21/18.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class SecondTutorialView: UIView {
    lazy var backgroundImageView: UIImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "tutorial-2")
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
