//
//  Functions.swift
//  ORC
//
//  Created by Dias Ermekbaev on 09.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import SwiftyJSON

class Functions: NSObject {
    static func font(type: FontType, size: FontSize) -> UIFont {
        return UIFont(name: "Ubuntu" + type.value, size: size.value)!
    }
    
    static func createTitleLabel (title: String, textColor: UIColor) -> UILabel {
        let frame = CGRect(x: 0, y: 0, width: Constants.width * 0.5, height: 40)
        let tlabel = UILabel(frame: frame)
        tlabel.font = Functions.font(type: .medium, size: .big)
        tlabel.text = title
        tlabel.numberOfLines = 1
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textColor = textColor
        tlabel.textAlignment = .center
        return tlabel
    }
    
//    static func startActivityIndicator() {
//        if UIApplication.shared.isIgnoringInteractionEvents == false {
//            UIApplication.shared.beginIgnoringInteractionEvents()
//        }
//        UIApplication.topViewController()?.view.makeToastActivity(.center)
//    }
//
//    static func stopActivityIndicator() {
//        if UIApplication.shared.isIgnoringInteractionEvents == true {
//            UIApplication.shared.endIgnoringInteractionEvents()
//        }
//        UIApplication.topViewController()?.view.hideToastActivity()
//    }
    
    static func createBasketBarButton(color: UIColor) -> BBBadgeBarButtonItem {
        let barButton = BBBadgeBarButtonItem(customUIButton: BasketButton(color: color))!
        barButton.shouldHideBadgeAtZero = false
        barButton.badgeValue = "0"
        barButton.badgeBGColor = UIColor.blue1
        barButton.badgeOriginX = -20
        barButton.badgeOriginY = 3
        return barButton
    }
    
    static func getCartCount(completion: @escaping Constants.cartCountCompletion) {
        NetworkLayer.shared.sendRequest(command: .cartCount) { optional in
            
            if let json = optional {
                completion(json["data"]["count"].stringValue)
            } else {
                completion(nil)
            }
        }
    }
    
    static func changeProductCount(id: Int, decrement: Int, completion: @escaping (_ product: Product?, _ count: Int?) -> ()) {
        NetworkLayer.shared.sendRequest(command: .addCart(id, decrement)) { (optional) in
            (UIApplication.topViewController() as! IndicatorViewableViewController).stopAnimating()
            
            if let json = optional, let jsonString = json["data"]["product"].rawString()  {
                if let model = Product(JSONString: jsonString) {
                    completion(model, model.cart_count)
                } else {
                    completion(nil, json["cart_count"].intValue)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
    
    static func checkResponseForError(json: JSON) -> JSON? {
        let isSuccess = json["isSuccess"].boolValue
        
        if isSuccess {
            return json["data"]
        } else {
            json["message"].stringValue.showAlertView(context: .error)
            return nil
        }
    }
    
    static func generateImageURL(string: String) -> URL? {
        let urlString = Constants.discount_product_image_url + string
        return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
    }

}
