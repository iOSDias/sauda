//
//  AlertView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import SwiftEntryKit
import DeviceKit
import UIKit

class AlertView: UIView {
    
    // MARK: - Constant
    private enum Constant {
        static let buttonSide: CGFloat = 32.0
        static let closeButtonRightOffset: CGFloat = UIScreen.baseOffset
        static let titleLabelRightOffset: CGFloat = UIScreen.baseOffset
        static let titleLabelLeftOffset: CGFloat = Constant.closeButtonRightOffset + Constant.buttonSide + Constant.titleLabelRightOffset
    }
    
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Device.current.fontSize, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        titleLabel.text = message
        
        [titleLabel, closeButton].forEach({ addSubview($0) })
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIScreen.baseOffset)
            make.right.equalToSuperview().offset(-Constant.closeButtonRightOffset)
            make.width.height.equalTo(Constant.buttonSide)
            
            if !titleLabel.moreThanOneLine(width: UIScreen.width - Constant.titleLabelLeftOffset - Constant.titleLabelRightOffset) {
                make.bottom.equalToSuperview().offset(-UIScreen.baseOffset)
            }
        }
        
        titleLabel.snp.makeConstraints { (make) in
            if titleLabel.moreThanOneLine(width: UIScreen.width - Constant.titleLabelLeftOffset - Constant.titleLabelRightOffset) {
                make.top.equalToSuperview().offset(UIScreen.baseOffset)
                make.bottom.equalToSuperview().offset(-UIScreen.baseOffset)
            } else {
                make.centerY.equalTo(closeButton)
            }
            make.centerX.equalToSuperview()
            make.right.equalTo(closeButton.snp.left).offset(-Constant.titleLabelRightOffset)
            make.left.equalToSuperview().offset(Constant.titleLabelLeftOffset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARKL - Methods
    @objc func closeButtonTapped() {
        SwiftEntryKit.dismiss()
    }
}

