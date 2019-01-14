//
//  FavouritesViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 15.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import DeviceKit

class FavouritesViewController: IndicatorViewableViewController {
    
    // MARK: - Properties
    var basketButton: BBBadgeBarButtonItem!
    var mainView = SingleCollectionView()
    var refreshControl = UIRefreshControl()
    var data: [Product] = [] {
        didSet {
            self.mainView.collectionView.reloadData()
        }
    }
    
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
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
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

extension FavouritesViewController {
    
    // MARK: - ConfigureViews Methods
    private func configureViews() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor.blue1, UIColor.purple1])
    }
    
    func configureNavigationBar() {
        navigationItem.titleView = Functions.createTitleLabel(title: "Избранные", textColor: .white)
        basketButton = Functions.createBasketBarButton(color: .white)
        navigationItem.rightBarButtonItem = basketButton
    }
    
    func configureCollectionView() {
        refreshControl.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
        mainView.collectionView.refreshControl = refreshControl
        mainView.collectionView.backgroundColor = UIColor.gray1
        mainView.collectionView.emptyDataSetSource = self
        mainView.collectionView.emptyDataSetDelegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(DiscountProductCollectionViewCell.self, forCellWithReuseIdentifier: "DiscountProductCollectionViewCell")
    }
}

extension FavouritesViewController {
    
    // MARK: Actions and Methods
    @objc func productLiked(recognizer: UITapGestureRecognizer) {
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
    
    @objc func addButtonTapped(sender: UIButton) {
        let index = sender.tag
        let id = data[index].product_id
        let cell = self.mainView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! DiscountProductCollectionViewCell
        cell.changeVisibleOfAddButton(show: false)
        
        cell.moreLessView.startAnimating()
        
        Functions.changeProductCount(id: id, decrement: 0) { [weak self] optional, count in
            guard let `self` = self else { return }

            if let product = optional {
                self.updateBasketCount(isAnimating: false)
                self.data[index].cart_count = product.cart_count
                self.mainView.collectionView.reloadData()
            }
            
            cell.moreLessView.stopAnimating()
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
            } else if count != nil {
                cell.changeVisibleOfAddButton(show: true)
                self.updateBasketCount(isAnimating: false)
            }
            
            cell.moreLessView.stopAnimating()
        }
    }
}

extension FavouritesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

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
        UIApplication.topViewController()?.navigationController?.pushViewController(dvc, animated: true)
    }
}

extension FavouritesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK : EmptyData Methods
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Нет избранных", attributes: [NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.purple1])
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}


extension FavouritesViewController {
    
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
                self.getData()
            }
        }
    }
    
    @objc private func updateTableView() {
        Constants.User.hasToken() ? getData(isAnimating: false) : refreshControl.endRefreshing()
    }
    
    func getData(isAnimating: Bool = false) {
        if isAnimating {
            startAnimating()
        }
        
        NetworkLayer.shared.sendRequest(command: .getFavourites) { [weak self] optional in
            guard let `self` = self else { return }

            if let json = optional, let array = ArrayConverter.createOrUpdateArrayOfModels(command: Arrays.Products, json["data"]["data"]) as? [Product] {
                self.data = array
            }
            
            self.refreshControl.endRefreshing()
            self.stopAnimating()
        }
    }
}
