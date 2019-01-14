//
//  DiscountTableViewCell.swift
//  ORC
//
//  Created by Dias Ermekbaev on 16.10.2018.
//  Copyright © 2018 Dias. All rights reserved.
//

import UIKit
import Kingfisher

class DiscountTableViewCell: UITableViewCell {
    
    private enum Constant {
        enum CollectionView {
            static var width: CGFloat = Constants.width/2.8 - 10
            static var height: CGFloat = Constant.CollectionView.width * 0.8 * 0.8 + 44 + 32
        }
    }
    lazy var imgView: CustomImageView = {
        let imgView = CustomImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "default_image")
        imgView.layer.cornerRadius = 8
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Functions.font(type: .regular, size: .big)
        label.textColor = UIColor.textStrong
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var showAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("См.все", for: .normal)
        button.setTitleColor(.blue1, for: .normal)
        button.titleLabel?.font = Functions.font(type: FontType.regular, size: FontSize.big)
        return button
    }()
    
    var data: Discount! {
        didSet {
            imgView.kf.setImage(with: URL(string: data.discount_image))
            titleLabel.text = data.discount_name
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        [imgView, titleLabel, collectionView, showAllButton].forEach({addSubview($0)})
        
        imgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            //make.height.equalToSuperview().multipliedBy(0.55)
            make.height.equalTo(Constants.height * 0.35)
        }
        
        showAllButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(showAllButton.intrinsicContentSize.width)
            make.height.equalTo(22)
            make.top.equalTo(imgView.snp.bottom).offset(15)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(showAllButton.snp.left).offset(-5)
            make.height.equalTo(22)
        }
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RandomProductCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(Constant.CollectionView.height)
            make.bottom.equalToSuperview()
        }
    }
}

extension DiscountTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data == nil {
            return 0
        } else {
            return data.randomProducts.count
        }
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
        //let height = Constants.height * 0.6 * 0.45 - 65
        return CGSize(width: ceil(Constant.CollectionView.width), height: ceil(Constant.CollectionView.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RandomProductCollectionViewCell
        cell.data = data.randomProducts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dvc = ProductDetailViewController()
        dvc.product_id = data.randomProducts[indexPath.item].product_id
        UIApplication.topViewController()?.navigationController?.pushViewController(dvc, animated: true)
    }
}
