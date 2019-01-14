//
//  LikeButton.swift
//  ORC
//
//  Created by Dias Ermekbaev on 26.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

protocol LikeButtonProtocol {
    func likeButtonTapped()
}

class LikeButton: UIBarButtonItem {
    var delegate: LikeButtonProtocol? = nil
    
    init(color: UIColor) {
        super.init()
        image = UIImage(named: "like-black")!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        style = .plain
        target = self
        action = #selector(likeButtonTapped)
    }
    
    func changeButtonState() {
        let isLiked = image == UIImage(named: "like-full")!.withRenderingMode(.alwaysTemplate) ? true:false
        if isLiked {
            image = UIImage(named: "like-black")!.withRenderingMode(.alwaysTemplate)
        } else {
            image = UIImage(named: "like-full")!.withRenderingMode(.alwaysTemplate)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func likeButtonTapped() {
        delegate?.likeButtonTapped()
    }
    
}
