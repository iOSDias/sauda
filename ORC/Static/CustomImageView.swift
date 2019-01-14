//
//  CustomImageView.swift
//  ORC
//
//  Created by Dias Ermekbaev on 19.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import Spring

class CustomImageView: SpringImageView {
    init() {
        super.init(frame: .zero)
        initViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    func initViews() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
