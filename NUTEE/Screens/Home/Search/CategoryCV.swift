//
//  CategoryCV.swift
//  NUTEE
//
//  Created by eunwoo on 2021/03/01.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class CategoryCV: UICollectionView {
    
    // MARK: - UI components
    
    let cell = CategoryCVCell()
    
    // MARK: - Variables and Properties
    
    var categoryList: [String] = []
    
    var homeVC: HomeVC?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: .init())
        
        setCategoryCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper

    func setCategoryCollectionView() {
        let layout = TagsLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        self.collectionViewLayout = layout
        self.backgroundColor = .white
        
        delegate = self
        dataSource = self
        
        register(CategoryCVCell.self, forCellWithReuseIdentifier: Identify.CategoryCVCell)
        
    }
    
}

// MARK: - CollectionView Container

extension CategoryCV : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        _ = cell.categoryButton.then {
            $0.setTitle(categoryList[indexPath.row], for: .normal)
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleLabel?.sizeToFit()
        }
        
        var size = cell.categoryButton.titleLabel?.bounds.size.width ?? 0
        if size <= cell.categoryButton.minimumWidth {
            size = cell.categoryButton.minimumWidth
        } else {
            size += cell.categoryButton.insetLeftRight * 2
        }

        return CGSize(width: size, height: cell.categoryButton.height)
    }
}

extension CategoryCV: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.CategoryCVCell, for: indexPath) as! CategoryCVCell
        
        cell.categoryButton.setTitle(categoryList[indexPath.row], for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryFeedVC = CategoryFeedVC()
        
        categoryFeedVC.homeVC = self.homeVC
        categoryFeedVC.category = categoryList[indexPath.row]
        
        homeVC?.navigationController?.pushViewController(categoryFeedVC, animated: true)
    }
}

// MARK: - Cell Definition

class CategoryCVCell: UICollectionViewCell {
    
    static let identifier = Identify.CategoryCVCell

    // MARK: - UI components
    
    let categoryButton = ResizableButton()
    
    // MARK: - Variables and Properties
        
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = categoryButton.then {
            $0.layer.cornerRadius = 14
            $0.backgroundColor = .white
            $0.isUserInteractionEnabled = false
            
            $0.setBorder(borderColor: .veryLightPink, borderWidth: 1)
        }
        
        contentView.addSubview(categoryButton)
        categoryButton.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }   
    }

}
