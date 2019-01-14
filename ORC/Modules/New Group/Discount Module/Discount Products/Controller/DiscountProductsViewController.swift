//
//  DiscountProductsViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class DiscountProductsViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var basketButton: BBBadgeBarButtonItem!
    var mainView = SingleCollectionView()
    var id: Int = -1
    var data: [Product] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    var refreshControl = UIRefreshControl()
    var navigationTitle: String = ""
    
    // MARK: - Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.left.right.equalToSuperview()
            if UIDevice.current.hasHomeButton {
                make.bottom.equalToSuperview().offset(-34)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        basketButton = Functions.createBasketBarButton(color: UIColor.gray4)
        configureCollectionView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
        Constants.User.hasToken() ? updateBasketCount() : getProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureViews()
    }
}

extension DiscountProductsViewController {
    
    // MARK: Configure Views
    private func configureViews() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureNavigationBar() {
        guard let navigationController = navigationController else { return }
        navigationItem.titleView = Functions.createTitleLabel(title: navigationTitle, textColor: .black)
        let backButton = BackButton(color: .black)
        backButton.delegate = self
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = basketButton
        
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configureCollectionView() {
        refreshControl.addTarget(self, action: #selector(getProducts), for: .valueChanged)
        mainView.collectionView.refreshControl = refreshControl
        mainView.collectionView.backgroundColor = .gray1
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(DiscountProductCollectionViewCell.self, forCellWithReuseIdentifier: "DiscountProductCollectionViewCell")
    }
}

extension DiscountProductsViewController: BackButtonProtocol, UIGestureRecognizerDelegate {
    @objc func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DiscountProductsViewController {
    
    // MARK: - Actions and Methods

    @objc func productLiked(recognizer: UITapGestureRecognizer) {
        if Constants.User.hasToken() {
            addProductToFavourites(recognizer: recognizer)
        } else {
            // TODO: - Auth alert view
            AuthorizationAlertManager.shared.show(baseVC: UIApplication.topViewController()!)
        }
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        if Constants.User.hasToken() {
            addProductToCart(sender: sender)
        } else {
            // TODO: - Auth alert view
            AuthorizationAlertManager.shared.show(baseVC: UIApplication.topViewController()!)
        }
    }
    
    @objc func plusButtonTapped(sender: UIButton) {
        let index = sender.tag
        let id = data[index].product_id

        let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! DiscountProductCollectionViewCell
        cell.moreLessView.startAnimating()
        
        Functions.changeProductCount(id: id, decrement: 0) { [weak self] optional, _ in
            guard let `self` = self else { return }

            if let product = optional {
                self.data[index].cart_count = product.cart_count
                self.mainView.collectionView.reloadData()
            }
            
            cell.moreLessView.stopAnimating()
        }
    }
    
    @objc func minusButtonTapped(sender: UIButton) {
        let index = sender.tag
        let id = data[index].product_id
        let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! DiscountProductCollectionViewCell
        cell.moreLessView.startAnimating()
        
        Functions.changeProductCount(id: id, decrement: 1) { [weak self] optional, count in
            guard let `self` = self else { return }

            if let product = optional {
                self.data[index].cart_count = product.cart_count
                self.mainView.collectionView.reloadData()
            } else if let cartCount = count {
                self.data[index].cart_count = cartCount
                self.mainView.collectionView.reloadData()
                self.updateBasketCount(isAnimating: false)
            }
            
            cell.moreLessView.stopAnimating()
        }
    }
}

extension DiscountProductsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (self.view.frame.width/2) - 1
        let height = width * 0.1 + 2 * Constants.baseOffset + 128 + width * 0.4 * 1.2
        
        return CGSize(width: ceil(width), height: ceil(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscountProductCollectionViewCell", for: indexPath) as! DiscountProductCollectionViewCell
        cell.data = data[indexPath.item]
        [cell.addButton, cell.likeImgView, cell.moreLessView.plusButton, cell.moreLessView.minusButton].forEach({$0.tag = indexPath.item})
        cell.likeImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(productLiked)))
        cell.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        cell.moreLessView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        cell.moreLessView.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dvc = ProductDetailViewController()
        dvc.product_id = data[indexPath.item].product_id
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension DiscountProductsViewController {
    
    // MARK: - Request Methods
    
    private func updateBasketCount(isAnimating: Bool = true) {
        if isAnimating {
            startAnimating()
        }
        
        Functions.getCartCount { [unowned self] optional in
            if let count = optional {
                self.basketButton.badgeValue = count
            } else {
                "Не удалось получить количество товаров в коризне".showAlertView(context: .error)
            }
            
            if isAnimating {
                self.getProducts()
            }
        }
    }
    
    @objc private func getProducts() {
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: .discountProducts(id)) { [unowned self] optional in
            if let json = optional {
                self.data = ArrayConverter.createOrUpdateArrayOfModels(command: Arrays.Products, json["data"]) as! [Product]
            }
            
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            
        }
    }
    
    private func addProductToCart(sender: UIButton) {
        let index = sender.tag
        let id = data[index].product_id
        let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! DiscountProductCollectionViewCell
        cell.changeVisibleOfAddButton(show: false)
        
        cell.moreLessView.startAnimating()
        
        Functions.changeProductCount(id: id, decrement: 0) { [weak self] optional, _ in
            guard let `self` = self else { return }
            
            if let product = optional {
                self.updateBasketCount(isAnimating: false)
                self.data[index].cart_count = product.cart_count
                self.mainView.collectionView.reloadData()
            }
            
            cell.moreLessView.stopAnimating()
        }
    }
    
    private func addProductToFavourites(recognizer: UITapGestureRecognizer) {
        let index = recognizer.view!.tag
        
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: .fav(data[index].product_id)) { [unowned self] json in
            if json != nil  {
                let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! DiscountProductCollectionViewCell
                cell.likeButtonSelected()
            }
            
            self.stopAnimating()
        }
    }
}
