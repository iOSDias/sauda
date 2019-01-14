//
//  CodeConfirmationViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 10.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class CodeConfirmationViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var mainView = CodeConfirmationView()
    var timer: Timer!
    var totalTime = 60
    var phone: String = ""
    var code: [String] = ["", "", "", ""]

    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        mainView.sendCodeAgainButton.addTarget(self, action: #selector(sendCodeAgain), for: .touchUpInside)
        startTimer()
        for (index, textField) in mainView.textFields.enumerated() {
            textField.delegate = self
            textField.tag = index
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureBottomButton()
        mainView.textFields.first!.becomeFirstResponder()
    }
}

extension CodeConfirmationViewController {
    
    // MARK: - ConfigureViews Methods
    private func configureNavigationBar() {
        let backButton = BackButton(color: .black)
        backButton.delegate = self
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = Functions.createTitleLabel(title: "Авторизация", textColor: .black)
        navigationItem.rightBarButtonItem = EmptyBarButton()
    }
    
    private func configureBottomButton() {
        mainView.bottomButton.setGradientBackground(firstColor: UIColor.blue1, secondColor: UIColor.purple1)
        mainView.bottomButton.addTarget(self, action: #selector(prepareForLogin), for: .touchUpInside)
    }
    
    private func configureTextField() {
        mainView.textFields.forEach({ $0.placeholderFont = $0.font })
    }
}

extension CodeConfirmationViewController: BackButtonProtocol {
    
    // MARK: - Actions
    @objc internal func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func sendCodeAgain() {
        startTimer()
    }
    
    @objc private func prepareForLogin() {
        if code.contains("") {
            "Заполните пустые поля".showAlertView(context: .error)
        } else {
            login(code: (code.joined() as NSString).integerValue)
        }
    }
    
    @objc private func login(code: Int) {
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: .confirm("7" + phone, code)) { [weak self] optional in
            guard let strongSelf = self else { return }
            
            strongSelf.stopAnimating()
            
            if let json = optional, let jsonString = json["data"].rawString(), let model = UserData(JSONString: jsonString) {
                Constants.User = model
                Coordinator.shared.presentMainTabBarScreen()
            } 
        }
    }
}

extension CodeConfirmationViewController: UITextFieldDelegate {
    
    // MARK : TextField Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.selectedTextRange = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        prepareForLogin()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "." || string == "," {
            return false
        }
        
        if string.count > 1 {
            return false
        }
        
        code[textField.tag] = string
        textField.text = string
        
        if textField != mainView.textFields.last {
            mainView.textFields[textField.tag + 1].becomeFirstResponder()
        } else {
            view.endEditing(true)
            login(code: (code.joined() as NSString).integerValue)
        }
        
        return true
    }
}

extension CodeConfirmationViewController {
    
    // MARK: - Timer methods
    private func startTimer() {
        mainView.sendCodeAgainButton.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTime() {
        mainView.sendCodeAgainButton.setTitle("Отправить код повторно через \(totalTime) секунд", for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    private func endTimer() {
        timer.invalidate()
        mainView.sendCodeAgainButton.setTitle("Отправить код повторно", for: .normal)
        mainView.sendCodeAgainButton.isUserInteractionEnabled = true
    }
}
