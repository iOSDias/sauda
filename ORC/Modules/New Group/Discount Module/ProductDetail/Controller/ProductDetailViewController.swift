//
//  ProductDetailViewController.swift
//  ORC
//
//  Created by Dias Ermekbaev on 26.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import Kingfisher
import ImageSlideshow

class ProductDetailViewController: IndicatorViewableViewController {
    
    // MARK: - Enums
    private enum SectionType: Int {
        case imageSlider = 0, mainInfo, characteristics, description, companyProducts, similarProducts
        
        var title: String {
            switch self {
            case .imageSlider:      return ""
            case .mainInfo:         return ""
            case .characteristics:  return "Характеристики"
            case .description:      return "Описание"
            case .companyProducts:  return "Еще от компании "
            case .similarProducts:  return "Похожие товары"
            }
        }
    }
    
    // MARK: - Properties
    var mainView = ProductDetailView()
    var product_id: Int!
    private var product: Product! {
        didSet {
            navigationItem.titleView = Functions.createTitleLabel(title: product.product_name, textColor: .black)
            if product.isFavourite {
                likeButton.changeButtonState()
            }
            
            if product.cart_count != 0 {
                mainView.moreLessView.valueLabel.text = product.cart_count.description
                mainView.changeBottomButtonState()
            }
            
            if product.images.isEmpty {
                imageSources.append(ImageSource(image: UIImage(named: "default_image")!))
            } else {
                product.images.forEach { (image) in
                    if let url = Functions.generateImageURL(string: image.image_path) {
                        imageSources.append(KingfisherSource(url: url))
                    }
                }
            }
        }
    }
    var imageSources: [InputSource] = []
    var likeButton: LikeButton!
    
    // MARK: - Life Cycle
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
        configureTableView()
        configureActions()
        getProductDetail()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
}

extension ProductDetailViewController {
    
    // MARK: - SetupViews Methods
    private func configureViews() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureActions() {
        mainView.moreLessView.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        mainView.moreLessView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        mainView.bottomButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        let backButton = BackButton(color: .black)
        backButton.delegate = self
        navigationItem.leftBarButtonItem = backButton
        
        likeButton = LikeButton(color: .black)
        likeButton.delegate = self
        navigationItem.rightBarButtonItem = likeButton
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func configureTableView() {
        mainView.tableView.tableFooterView = UIView()
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(ImageSlideTableViewCell.self, forCellReuseIdentifier: "ImageSlideTableViewCell")
        mainView.tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
        mainView.tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "DescriptionTableViewCell")
        mainView.tableView.register(CharacteristicsTableViewCell.self, forCellReuseIdentifier: "CharacteristicsTableViewCell")
        mainView.tableView.register(ProductsCollectionTableViewCell.self, forCellReuseIdentifier: "ProductsCollectionTableViewCell")
    }
}

extension ProductDetailViewController: BackButtonProtocol, UIGestureRecognizerDelegate {
    
    @objc internal func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ProductDetailViewController: LikeButtonProtocol {
    
    // MARK: - Actions
    @objc internal func likeButtonTapped() {
        if Constants.User.hasToken() {
            addProductToFavourites()
        } else {
            // TODO: - Auth alert view
            AuthorizationAlertManager.shared.show(baseVC: UIApplication.topViewController()!)
        }
    }
    
    @objc internal func addButtonTapped() {
        if Constants.User.hasToken() {
            addProductToCount()
        } else {
            // TODO: - Auth alert view
            AuthorizationAlertManager.shared.show(baseVC: UIApplication.topViewController()!)
        }
    }
    
    @objc private func plusButtonTapped() {
        mainView.moreLessView.startAnimating()
        
        Functions.changeProductCount(id: product.product_id, decrement: 0) { [weak self] optional, _ in
            guard let `self` = self else { return }

            if let product = optional {
                self.mainView.moreLessView.valueLabel.text = product.cart_count.description
            }
            
            self.mainView.moreLessView.stopAnimating()
        }
    }
    
    @objc private func minusButtonTapped() {
        
        mainView.moreLessView.startAnimating()
        
        Functions.changeProductCount(id: product.product_id, decrement: 1) { [weak self] optional, count in
            guard let `self` = self else { return }

            if let product = optional {
                self.mainView.moreLessView.valueLabel.text = product.cart_count.description
            } else if let cartCount = count {
                self.product.cart_count = cartCount
                self.mainView.changeBottomButtonState()
            }
            
            self.mainView.moreLessView.stopAnimating()
        }
    }
    
    @objc private func showAllProducts() {
        let dvc = CompanyProductsViewController()
        dvc.company_id = product.producer.producer_id
        dvc.navigationTitle = product.producer.producer_name
        navigationController?.pushViewController(dvc, animated: true)
    }
}

// MARK : TableView Methods

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return product == nil ? 0 : 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch SectionType(rawValue: indexPath.section)! {
        case .imageSlider:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "ImageSlideTableViewCell", for: indexPath) as! ImageSlideTableViewCell
            currentCell.imageSlider.setImageInputs(imageSources)
            cell = currentCell
        case .mainInfo:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            currentCell.data = product
            cell = currentCell
        case .characteristics:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicsTableViewCell", for: indexPath) as! CharacteristicsTableViewCell
            currentCell.data = product
            cell = currentCell
        case .description:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            currentCell.data = product
            cell = currentCell
        case .companyProducts:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "ProductsCollectionTableViewCell", for: indexPath) as! ProductsCollectionTableViewCell
            currentCell.array = product.producersProductsArray
            cell = currentCell
        case .similarProducts:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "ProductsCollectionTableViewCell", for: indexPath) as! ProductsCollectionTableViewCell
            currentCell.array = product.similarProductsArray
            cell = currentCell
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? Constants.height * 0.4 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = SectionType(rawValue: section)!
        let header = ProductDetailSectionHeader()
        header.titleLabel.text = sectionType.title
        
        if sectionType == .companyProducts {
            header.showAllButton.isHidden = false
            header.showAllButton.addTarget(self, action: #selector(showAllProducts), for: .touchUpInside)
            header.titleLabel.text = header.titleLabel.text! + product.producer.producer_name
        } else {
            header.showAllButton.isHidden = true
        }
        
        return header
    }
}

// MARK : Request Methods

extension ProductDetailViewController {
    
    private func getProductDetail() {
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: NetworkRouter.getProductDetail(product_id)) { [unowned self] optional in
            
            if let json = optional, let jsonString = json["data"]["product"].rawString(), let product = Product(JSONString: jsonString) {
                self.product = product
                self.mainView.tableView.reloadData()
            }
            
            self.stopAnimating()
        }
    }
    
    private func addProductToFavourites() {
        startAnimating()
        
        NetworkLayer.shared.sendRequest(command: .fav(product.product_id)) { [unowned self] json in
            if json != nil  {
                self.likeButton.changeButtonState()
            }
            
            self.stopAnimating()
        }
    }
    
    private func addProductToCount() {
        mainView.changeBottomButtonState()
        
        mainView.moreLessView.startAnimating()
        
        Functions.changeProductCount(id: product.product_id, decrement: 0) { [weak self] optional, _ in
            guard let `self` = self else { return }
            
            if let product = optional {
                self.mainView.moreLessView.valueLabel.text = product.cart_count.description
            }
            
            self.mainView.moreLessView.stopAnimating()
        }
    }
}
