//
//  ProfileSectionButtonHeader.swift
//  ORC
//
//  Created by Dias Ermekbaev on 23.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class ProfileSectionButtonHeader: UIView {
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("ВЫЙТИ", for: .normal)
        btn.setTitleColor(UIColor.blue1, for: .normal)
        btn.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.normal)
        return btn
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray3
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [button, separator].forEach({ addSubview($0) })
        
        separator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(separator.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
