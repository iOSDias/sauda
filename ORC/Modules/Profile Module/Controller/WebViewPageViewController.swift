//
//  WebViewPageViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 24.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DeviceKit

class WebViewPageViewController: IndicatorViewableViewController {
    lazy var webView = UIWebView()
    var navTitle: String = ""
    var urlString = ""
    
    var type: WebPageType! {
        didSet {
            navTitle = type.title
            urlString = type.link
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.backgroundColor = .white
        webView.snp.makeConstraints { (make) in
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
        configureViews()
        configureWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
    }
}

extension WebViewPageViewController: BackButtonProtocol, UIGestureRecognizerDelegate {
    
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = Functions.createTitleLabel(title: navTitle, textColor: .black)
        let backButton = BackButton(color: .black)
        backButton.delegate = self
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = EmptyBarButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configureWebView() {
        webView.scrollView.bounces = false
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.loadRequest(URLRequest(url: URL(string: urlString)!))
    }
    
    @objc func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension WebViewPageViewController: UIWebViewDelegate {
    
    // MARK: - WebView Methods
    func webViewDidStartLoad(_ webView: UIWebView) {
        startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopAnimating()
    }
}
