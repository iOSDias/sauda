//
//  NetworkLayer.swift
//  ORC
//
//  Created by Dias Ermekbaev on 10.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public enum APIError: Error {
    case badRequest(JSON)
}

extension APIError: LocalizedError {
    public func errorDescription(key: String) -> String? {
        switch self {
        case .badRequest(let json):
            return json[key].stringValue
        }
    }
}

class NetworkLayer: NSObject {
    let internetError   = "Нет интернет соединения.\nПроверьте подключение"
    let serverError     = "Нет доступа к серверу.\nПроизводится обновление."
    
    static let shared = NetworkLayer()
    
    func sendRequest(command: NetworkRouter, completion: @escaping Constants.completion) {
        
        Alamofire.request(command).validate().responseJSON { (response) in
            let statuscode = response.response?.statusCode
        
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let isSuccess = json["isSuccess"].boolValue
                
                if isSuccess {
                    completion(json)
                } else {
                    json["message"].stringValue.showAlertView(context: .error)                    
                    completion(nil)
                }
            case .failure(let error):
                completion(nil)
                
                if command.path != "discounts" {
                    self.showErrorMessage(statuscode: statuscode, myRequest: command)
                }
            }
        }
    }
}

extension NetworkLayer {
    func showErrorMessage(statuscode: Int?, myRequest: URLRequestConvertible?) {
        var text: String = ""
        
        if statuscode == nil {
            text = internetError
        } else if let statusCode = statuscode {
            let statusCodeString = statusCode.description
            if statusCodeString.first == "4" {
                text = serverError
            } else {
                request(myRequest!).responseString(completionHandler: { (response) in
                    if let string = response.result.value {
                        text = string
                    }
                })
            }
        }
        
        text.showAlertView(context: .error)
    }
}
