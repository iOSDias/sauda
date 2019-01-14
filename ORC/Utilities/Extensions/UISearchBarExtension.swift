//
//  UISearchBarExtension.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation

extension UISearchBar {
    func adjustPlaceholder() {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        (textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel)?.adjustsFontSizeToFitWidth = true
    }
}
