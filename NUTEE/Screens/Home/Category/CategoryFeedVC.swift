//
//  CategoryFeedVC.swift
//  NUTEE
//
//  Created by eunwoo on 2021/02/13.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import SnapKit

class CategoryFeedVC: UIViewController {
    
    // MARK: - UI components
    
    let categoryFeedCVCell = CategoryFeedCVCell()
        
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraints()
        categoryFeedCVCell.homeVC = self
    }
    
    // MARK: - Helper
    
    func makeConstraints() {
        view.backgroundColor = .white
        
        view.addSubview(categoryFeedCVCell)
        
        categoryFeedCVCell.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func afterSetCategory(category: String) {
        navigationItem.title = category
        
        categoryFeedCVCell.category = category
        categoryFeedCVCell.getPostsService(lastId: 0, limit: 10) { [self] (Post) in
            categoryFeedCVCell.postContent = Post.body
            categoryFeedCVCell.afterFetchNewsFeed()
        }
    }
    
}
