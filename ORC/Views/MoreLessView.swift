//
//  MoreLessView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 17.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MoreLessView: UIView {
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.blue1
        button.setImage(#imageLiteral(resourceName: "minus").withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.blue1
        button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: FontType.regular, size: FontSize.middle)
        label.textAlignment = .center
        label.text = "1"
        return label
    }()
    
    lazy var indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: NVActivityIndicatorType.pacman, color: .blue1, padding: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func startAnimating() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        valueLabel.isHidden = true
        indicatorView.startAnimating()
    }
    
    func stopAnimating() {
        UIApplication.shared.endIgnoringInteractionEvents()
        valueLabel.isHidden = false
        indicatorView.stopAnimating()
    }
    
    func configUI() {
        [minusButton, valueLabel, plusButton, indicatorView].forEach({addSubview($0)})
        
        minusButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(minusButton.snp.height)
            make.left.equalToSuperview().offset(8)
        }
        
        plusButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(minusButton)
            make.right.equalToSuperview().offset(-8)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(minusButton.snp.right).offset(5)
            make.right.equalTo(plusButton.snp.left).offset(-5)
            make.top.bottom.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }

}
