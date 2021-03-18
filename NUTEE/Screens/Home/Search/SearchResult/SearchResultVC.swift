//
//  SearchResultVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {

    // MARK: - UI components
    
    let searchResultFeedCVCell = SearchResultFeedCVCell()
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraints()
        searchResultFeedCVCell.homeVC = self
    }
    
    // MARK: - Helper
    
    func makeConstraints() {
        view.backgroundColor = .white
        
        view.addSubview(searchResultFeedCVCell)
        
        searchResultFeedCVCell.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func afterSetKeyword(keyword: String) {
        navigationItem.title = keyword
        
        searchResultFeedCVCell.keyword = keyword
        searchResultFeedCVCell.getPostsService(lastId: 0, limit: 10) { [self] (Post) in
            searchResultFeedCVCell.postContent = Post.body
            searchResultFeedCVCell.afterFetchNewsFeed()
        }
    }
    
}
