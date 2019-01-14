//
//  NetworkRouter.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import Foundation
import Alamofire

public enum NetworkRouter: URLRequestConvertible {
    private static let _baseURLPath = "https://sauda.biz/public/api/v1/"
    
    case confirm(String, Int)
    case signIn(String, String)
    case discounts
    case cartCount
    case discountProducts(Int)
    case fav(Int)
    case addCart(Int, Int)
    case getCart
    case cartDelete(String)
    case createOrder(Double, Double, String)
    case getFavourites
    case getHistory
    case userInfo
    case categories
    case cleanCart
    case becomeConstantCustomer(Int)
    case getSuppliers
    case deleteSupplierRelation(Int)
    case getProductDetail(Int)
    case getProductsWithoutFilter(Int)
    case getProductsWithFilter(Int, [String:Any])
    case cancelPurchase(Int)
    
    //MARK: - HTTP METHOD
    var method: HTTPMethod {
        switch self {
        case .confirm, .signIn, .fav, .addCart, .createOrder, .becomeConstantCustomer, .getProductsWithoutFilter, .getProductsWithFilter:
            return .post
        case .discounts, .cartCount, .discountProducts, .getCart, .cartDelete, .getFavourites, .getHistory, .userInfo, .categories, .cleanCart, .getSuppliers, .deleteSupplierRelation, .getProductDetail:
            return .get
            
        case .cancelPurchase:
            return .delete
        }
    }
    
    //MARK: - PATH
    var path: String {
        switch self {
        case .confirm:
            return "customer/confirm"
        case .signIn:
            return "customer/signin"
        case .discounts:
            return "discounts"
        case .cartCount:
            return "cart/count"
        case .discountProducts(let id):
            return "discount/\(id)"
        case .fav:
            return "fav"
        case .addCart:
            return "cart/add"
        case .getCart:
            return "cart/get"
        case .cartDelete(let id):
            return "cart/delete/\(id)"
        case .createOrder:
            return "purchase/buy"
        case .getFavourites:
            return "favs"
        case .getHistory:
            return "purchase/history"
        case .userInfo:
            return "user/info"
        case .categories:
            return "category/list"
        case .cleanCart:
            return "cart/clean"
        case .becomeConstantCustomer:
            return "become/constant/customer"
        case .getSuppliers:
            return "my/suppliers"
        case .deleteSupplierRelation(let id):
            return "delete/relation/\(id)"
        case .getProductDetail(let id):
            return "product/\(id)"
        case .getProductsWithoutFilter(let id):
            return "product/filter?producer=\(id)"
        case .getProductsWithFilter(let id, _):
            return "product/filter/\(id)"
        case .cancelPurchase(let id):
            return "purchase/cancel/\(id)"
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .confirm(let phone, let code):
            return ["phone" : phone,
                    "sms" : code]
        case .signIn(let phone, let key):
            return ["phone" : phone,
                    "key" : key]
        case .fav(let id):
            return ["product_id" : id]
        case .addCart(let id, let decrement):
            return ["product_id": id,
                    "decrement": decrement]
        case .createOrder(let lat, let lng, let info):
            return ["lat": lat,
                    "lng": lng,
                    "information": info]
        case .becomeConstantCustomer(let id):
            return ["qr": id]
        case .getProductsWithFilter(_, let params):
            return params
        default:
            return [:]
        }
        
    }
    
    public func addAuthHeader(_ request: inout URLRequest) {
        switch self {
        case .confirm, .signIn:
            break
        default:
            let token = Constants.User.token
            request.setValue(token, forHTTPHeaderField: "Token")
        }
    }
    
    public func addContentType(_ request: inout URLRequest) {
        switch self.method {
        case .get, .delete:
            break
        default:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    static var baseURLPath: String = NetworkRouter._baseURLPath
    
    public func urlPath() -> String {
        return NetworkRouter.baseURLPath + path
    }
    
    public func asURLRequest() throws -> URLRequest {
        var url = try NetworkRouter.baseURLPath.asURL()
        if let urlStringWithoutPercentEncoding = url.appendingPathComponent(path).absoluteString.removingPercentEncoding {
            url = URL(string: urlStringWithoutPercentEncoding)!
        } else {
            url = url.appendingPathExtension(path)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(60)
        addContentType(&request)
        addAuthHeader(&request)
        
        if method == .post {
            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = jsonData
                let datastring = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                print("PARAMS: -", datastring ?? "")
                return try URLEncoding.default.encode(request, with: nil)
            } catch {
                print("error")
            }
        }
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

