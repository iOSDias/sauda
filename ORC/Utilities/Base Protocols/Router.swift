//
//  Router.swift
//  ORC
//
//  Created by Dias Ermekbaev on 06.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

protocol Router: class {
    
    // MARK: - Properties
    var baseViewController: UIViewController? { get set }
    
    // MARK: - Methods
    func present(on baseVC: UIViewController, animated: Bool, context: Any?, completion: (() -> Void)?)
    func present(animated: Bool, context: Any?, completion: (() -> Void)?)
    func enqueueRoute(with context: Any?, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    
}

extension Router {
    
    // MARK: - Router default methods
    func present(on baseVC: UIViewController, context: Any?) {
        present(on: baseVC, animated: true, context: context, completion: nil)
    }
    
    func present(context: Any?) {
        present(animated: true, context: context, completion: nil)
    }
    
    func enqueueRoute(with context: Any?) {
        enqueueRoute(with: context, animated: true, completion: nil)
    }
    
    func enqueueRoute(with context: Any?, completion: (() -> Void)?) {
        enqueueRoute(with: context, animated: true, completion: completion)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}
