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
    
    let dummyButton = ResizableButton()
    
    // MARK: - Variables and Properties
    
    var categoryList = ["자유", "연애", "기숙사", "어쩌고", "저쩌고", "길게한번써보기","어쩌구저쩌구카테고리", "기숙사", "어쩌고", "저쩌고", "길게한번써보기","어쩌구저쩌구카테고리", "길게한번써보기","어쩌구저쩌구카테고리", "기숙사","어쩌구저쩌구카테고리", "기숙사"]
    
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
        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
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

        _ = dummyButton.then {
            $0.setTitle(categoryList[indexPath.row], for: .normal)
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleLabel?.sizeToFit()
        }
        
        var size = dummyButton.titleLabel?.bounds.size.width ?? 0
        if size <= dummyButton.minimumWidth {
            size = dummyButton.minimumWidth
        } else {
            size += dummyButton.insetLeftRight * 2
        }

        return CGSize(width: size, height: dummyButton.height)
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
            
            $0.setBorder(borderColor: .veryLightPink, borderWidth: 1)
        }
        
        contentView.addSubview(categoryButton)
        categoryButton.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }   
    }

}
