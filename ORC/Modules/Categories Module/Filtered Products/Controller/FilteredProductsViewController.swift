//
//  FilteredProductsViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 21.11.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit

class FilteredProductsViewController: IndicatorViewableViewController {
    
    // MARK: Properties
    private var mainView = FilterProductsView()
    private var refreshControl = UIRefreshControl()
    private var data: [Product] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    var basketButton: BBBadgeBarButtonItem!
    var id: Int!
    var navigationTitle = ""
    var sortType = SortModel(type: .price, direction: .asc)
    var alertView: UIAlertController!
    
    
    // MARK: Life Cycles
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.bottom.equalTo(view.safeArea.bottom)
            make.left.right.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureActions()
        configureAlertView()
        configureCollectionView()
        Constants.User.hasToken() ? updateBasketCount() : getProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
    }
}

extension FilteredProductsViewController {
    
    //MARK: - Configure Views
    private func configureViews() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureActions() {
        mainView.sortView.typeButton.addTarget(self, action: #selector(typeButtonTouchUp), for: .touchUpInside)
        mainView.sortView.directionButton.addTarget(self, action: #selector(directionButtonTouchUp), for: .touchUpInside)
        mainView.sortView.filterButton.addTarget(self, action: #selector(filterButtonTouchUp), for: .touchUpInside)
        
        mainView.sortView.typeButton.setTitle(sortType.type.value, for: .normal)
        mainView.sortView.directionButton.setImage(sortType.direction.icon, for: .normal)
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = Functions.createTitleLabel(title: navigationTitle, textColor: .black)
        
        let backButton = BackButton(color: .black)
        backButton.delegate = self
        navigationItem.leftBarButtonItem = backButton
        
        basketButton = Functions.createBasketBarButton(color: .black)
        navigationItem.rightBarButtonItem = basketButton
    
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configureCollectionView() {
        refreshControl.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
        mainView.collectionView.refreshControl = refreshControl
        mainView.collectionView.backgroundColor = UIColor.gray1
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(DiscountProductCollectionViewCell.self, forCellWithReuseIdentifier: "DiscountProductCollectionViewCell")
    }
    
    private func configureAlertView() {
        alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertView.view.tintColor = UIColor.black
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Отмена", style: .cancel) { action -> Void in
        }
        alertView.addAction(cancelAction)
        
        for type in [SortType.price, SortType.newness] {
            let action: UIAlertAction = UIAlertAction(title: type.value, style: .default){ action -> Void in
                self.alertButtonTouchUp(type: type)
            }
            
            alertView.addAction(action)
        }
    }
}

extension FilteredProductsViewController: BackButtonProtocol, UIGestureRecognizerDelegate {
    @objc internal func backButtonTapped() {
        FilterFields.clearFields()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc private func typeButtonTouchUp() {
        present(alertView, animated: true, completion: nil)
    }
    
    @objc private func directionButtonTouchUp() {
        sortType.direction = sortType.direction == .asc ? .desc : .asc
        mainView.sortView.directionButton.setImage(sortType.direction.icon, for: .normal)
        getProducts()
    }
    
    @objc private func filterButtonTouchUp() {
        let dvc = FilterViewController()
        dvc.updateHandler = { [weak self] in
            self?.getProducts()
        }
        let navigationController = UINavigationController(rootViewController: dvc)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func alertButtonTouchUp(type: SortType) {
        mainView.sortView.typeButton.setTitle(type.value, for: .normal)
        sortType.type = type
        getProducts()
    }
    
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

extension FilteredProductsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        cell.discountLabel.isHidden = true
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

extension FilteredProductsViewController {
    
    // MARK: - Request Methods
    private func updateBasketCount(isAnimating: Bool = true) {
        if isAnimating {
            startAnimating()
        }
        
        Functions.getCartCount { [weak self] optional in
            guard let `self` = self else { return }
            
            if let count = optional {
                self.basketButton.badgeValue = count
            } else {
                "Не удалось получить количество товаров в коризне".showAlertView(context: .error)
            }
            
            if isAnimating {
                self.getProducts(isAnimating: false)
            }
        }
    }
    
    @objc func updateTableView() {
        getProducts(isAnimating: false)
    }
    
    @objc func getProducts(isAnimating: Bool = true) {
        if isAnimating {
            startAnimating()
        }
        
        NetworkLayer.shared.sendRequest(command: NetworkRouter.getProductsWithFilter(id, generateParameters())) { [weak self] optional in
            guard let `self` = self else { return }
            
            if let json = optional {
                self.data = ArrayConverter.createOrUpdateArrayOfModels(command: Arrays.Products, json["data"]["data"]) as! [Product]
            }
            
            self.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func generateParameters() -> [String:Any] {
        var parameters: [String:Any] = [:]
        
        let searchFilter = FilterFields.searchFilter
        let minPriceFilter = FilterFields.minPriceFilter
        let maxPriceFilter = FilterFields.maxPriceFilter
        
        parameters[sortType.type.title] = sortType.direction.value
        
        if let value = searchFilter.value {
            parameters[searchFilter.title] = value
        }
        
        if minPriceFilter.value != nil || maxPriceFilter.value != nil {
            var priceParameters: [String:Any] = [:]
            if let value = minPriceFilter.value {
                priceParameters[minPriceFilter.title] = value
            }
            
            if let value = maxPriceFilter.value {
                priceParameters[maxPriceFilter.title] = value
            }
            
            parameters["price"] = priceParameters
        }
        
        return parameters
    }
    
    private func addProductToFavourites(recognizer: UITapGestureRecognizer) {
        let index = recognizer.view!.tag
        
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: .fav(data[index].product_id)) { [weak self] json in
            guard let `self` = self else { return }
            
            if json != nil  {
                let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! DiscountProductCollectionViewCell
                cell.likeButtonSelected()
            }
            
            self.stopAnimating()
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
}
