//
//  ProfileViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import StoreKit

class ProfileViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var mainView = ProfileView()
    var sections = ["Пользовательские настройки", "Уведомления", "Помощь", "Юр.сведения"]
    var basketButton: BBBadgeBarButtonItem!
    var selectedArrray: NSMutableArray = []
    var rows: [[ProfileRow]] = []
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        createFields()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
        ProfileRows.updateUserPhone()
        if Constants.User.hasToken() {
            updateBasketCount()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            
        } else {
            mainView.snp.updateConstraints { make in
                make.top.equalTo(topLayoutGuide.length)
                make.bottom.equalTo(-bottomLayoutGuide.length)
            }
        }
    }
}

extension ProfileViewController {
    
    // MARK: - Configure Views
    private func configureViews() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = Functions.createTitleLabel(title: "Профиль", textColor: .white)
        basketButton = Functions.createBasketBarButton(color: .white)
        navigationItem.rightBarButtonItem = basketButton
    }
    
    private func configureTableView() {
        mainView.tableView.tableFooterView = UIView()
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(UserDataTableViewCell.self, forCellReuseIdentifier: "UserDataTableViewCell")
        mainView.tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "NotificationsTableViewCell")
        mainView.tableView.register(OtherProfileSettingsTableViewCell.self, forCellReuseIdentifier: "OtherProfileSettingsTableViewCell")
    }
    
    private func createFields() {
        rows = [[ProfileRows.city, ProfileRows.phoneNumber],
                [ProfileRows.news, ProfileRows.discount],
                [ProfileRows.callCenter, ProfileRows.wpOperator, ProfileRows.star, ProfileRows.share],
                [ProfileRows.info, ProfileRows.confidentiality, ProfileRows.userCheck]]
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = sections.count + 1
        if Constants.User.hasToken() {
            sectionCount += 1
        }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            if(selectedArrray.contains(section)){
                return rows[section].count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "UserDataTableViewCell", for: indexPath) as! UserDataTableViewCell
            cell1.data = rows[indexPath.section][indexPath.row]
            cell = cell1
        } else if indexPath.section == 1 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
            cell2.data = rows[indexPath.section][indexPath.row]
            cell = cell2
        } else if indexPath.section == 2 {
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "OtherProfileSettingsTableViewCell", for: indexPath) as! OtherProfileSettingsTableViewCell
            cell3.data = rows[indexPath.section][indexPath.row]
            cell = cell3
        } else if indexPath.section == 3 {
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "OtherProfileSettingsTableViewCell", for: indexPath) as! OtherProfileSettingsTableViewCell
            cell4.data = rows[indexPath.section][indexPath.row]
            cell = cell4
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: UIView!
        
        if section < 4 {
            let v = ProfileSectionLabelHeader()
            if selectedArrray.contains(section) {
                v.arrowImgView.image = UIImage(named: "arrow_up")
            } else {
                v.arrowImgView.image = UIImage(named: "arrow_down")
            }
            v.tag = section
            v.isUserInteractionEnabled = true
            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedSectionButtonClicked)))
            v.titleLabel.text = sections[section]
            header = v
        } else if section == 4 {
            header = ProfileSectionLogoHeader()
        } else if section == 5 {
            let v = ProfileSectionButtonHeader()
            v.button.addTarget(self, action: #selector(exit), for: .touchUpInside)
            header = v
        }
        
        header.backgroundColor = .white
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        
        if section < 4 {
            height = 40
        } else if section == 4 {
            height = 120
        } else if section == 5 {
            height = 40
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:     technicalSupportCall()
            case 1:     technicalSupportChat()
            case 2:     tryInternalRateApp()
            case 3:     shareAppInfo()
            default:    print("")
            }
        case 3:
            switch indexPath.row {
            case 0:     openWebViewPage(type: .CompanyInfo)
            case 1:     openWebViewPage(type: .PrivacyPolicy)
            case 2:     openWebViewPage(type: .UserAgreement)
            default:    print("")
            }
        default:
            print("")
        }
    }
}

extension ProfileViewController {
    
    // MARK: - Actions
    @objc private func selectedSectionButtonClicked(sender: UITapGestureRecognizer) {
        let intIndex = sender.view?.tag
        let index = intIndex as AnyObject
        
        if (selectedArrray.contains(index)){
            selectedArrray.remove(index)
        } else {
            selectedArrray.add(index)
        }
        
        mainView.tableView.reloadSections(IndexSet(integer: intIndex!), with: .automatic)
    }
    
    private func technicalSupportCall() {
        let number = Constants.technical_support_phone
        guard let phoneCallURL = URL(string: "tel:\(number)") else {return}
        let application: UIApplication = UIApplication.shared
        
        let alert = UIAlertController(title: "", message: "Вы действительно хотите вызвать\n" + number, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Да", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                application.open(phoneCallURL)
            } else {
                application.openURL(phoneCallURL)
            }
        })
        let no = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func technicalSupportChat() {
        guard let url = URL(string: Constants.whatsapp_link) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            "Приложение WhatsApp не установлено на вашем телефоне.\nУстановите, пожалуйста, приложение и попробуйте снова".showAlertView(context: .warning)
        }
    }
    
    private func rateApp() {
        
        guard let url = URL(string: Constants.appstore_link) else { return }
        
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func tryInternalRateApp() {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        } else {
            rateApp()
        }
    }
    
    private func shareAppInfo() {
        let activityItems: [Any] = [Constants.appstore_link]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.addToReadingList, .openInIBooks]
        present(activityVC, animated: true, completion: nil)
    }
    
    private func openWebViewPage(type: WebPageType) {
        let dvc = WebViewPageViewController()
        dvc.type = type
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    @objc private func exit() {
        let alert = UIAlertController(title: "", message: "Вы уверены, что хотите выйти?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Выйти", style: UIAlertAction.Style.default, handler: { action in
            self.signout()
        }))
        alert.view.tintColor = UIColor.purple1
        self.present(alert, animated: true, completion: nil)
    }
    
    private func signout() {
        Constants.User.logout()
        Coordinator.shared.presentMainTabBarScreen()
        //Coordinator.shared.presentAuthorizationScreen()
    }
}

extension ProfileViewController {
    
    // MARK: - Request Methods
    private func updateBasketCount() {
        startAnimating()
        
        Functions.getCartCount { [unowned self] optional in
            
            if let count = optional {
                self.basketButton.badgeValue = count
            } else {
                "Не удалось получить количество товаров в коризне".showAlertView(context: .error)
            }
            
            self.stopAnimating()
        }
    }
}
