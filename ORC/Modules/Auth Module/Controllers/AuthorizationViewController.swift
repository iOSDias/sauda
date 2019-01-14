//
//  AuthorizationViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 09.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class AuthorizationViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var mainView = AuthorizationView()
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.size.height)
            make.bottom.equalTo(view.safeArea.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.withTransparentBackground()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.removeTransparency()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.phoneTF.becomeFirstResponder()
    }
}

extension AuthorizationViewController {
    
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        let logoImgView = CustomImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        logoImgView.image = UIImage(named: "ORC")
        navigationItem.titleView = logoImgView
        navigationItem.hidesBackButton = false
        mainView.enterButton.addTarget(self, action: #selector(prepareForLogin), for: .touchUpInside)
        
        //navigationItem.hidesBackButton = true
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(closeButtonTouchUp))
        cancelBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }

    private func configureTextFields() {
        mainView.phoneTF.placeholderFont = mainView.phoneTF.font
        mainView.phoneTF.delegate = self
        mainView.phoneTF.keyboardType = .decimalPad
    }
}

extension AuthorizationViewController {
    
    // MARK: - Actions
    @objc private func closeButtonTouchUp() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func prepareForLogin() {
        if mainView.phoneTF.text == "" {
            "Заполните пустые поля".showAlertView(context: .error)
        } else if let phone = mainView.phoneTF.text?.replacingOccurrences(of: "[\\)( ]", with: "", options: .regularExpression, range: nil) {
            if phone.count < 10 {
                "Введите корректный номер".showAlertView(context: .error)
            } else {
                customerSignIn(phone: phone)
            }
        }
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    
    // MARK : TextField Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "(" { textField.text = nil }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        prepareForLogin()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        let dotsCount = textField.text!.components(separatedBy: ".").count
        if dotsCount > 0 && (string == "." || string == ",") {
            return false
        }

        return checkPhoneNumberFormat(string: string, str: str)
    }
    
    private func checkPhoneNumberFormat(string: String, str: String) -> Bool {
        if string == "" {
            mainView.changeEnterButtonState(toEnabled: false)
            return true
        } else if str.count < 3 {
            if str.count == 1 {
                mainView.phoneTF.text = "("
            }
        } else if str.count == 5 {
            mainView.phoneTF.text = mainView.phoneTF.text! + ") "
        } else if str.count == 10 || str.count == 13 {
            mainView.phoneTF.text = mainView.phoneTF.text! + " "
        } else if str.count < 15 {
            mainView.changeEnterButtonState(toEnabled: false)
        } else if str.count > 14 {
            mainView.changeEnterButtonState(toEnabled: true)

            if str.count > 15 {
                return false
            }
        }
        return true
    }
}

// MARK : Request Methods

extension AuthorizationViewController {
    private func customerSignIn(phone: String) {
        mainView.phoneTF.resignFirstResponder()
        
        startAnimating()
                
        NetworkLayer.shared.sendRequest(command: .signIn("7" + phone, "key")) { [unowned self] optional in
            
            if let json = optional {
                json["message"].stringValue.showAlertView(context: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let dvc = CodeConfirmationViewController()
                    dvc.phone = phone
                    self.navigationController?.pushViewController(dvc, animated: true)
                }
            }
            
            self.stopAnimating()
        }
    }
}
