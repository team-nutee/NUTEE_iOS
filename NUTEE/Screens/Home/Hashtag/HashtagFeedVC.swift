//
//  HashtagFeedVC.swift
//  NUTEE
//
//  Created by eunwoo on 2021/03/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class HashtagFeedVC: UIViewController {
    
    // MARK: - UI components
    
    let hashtagFeedCVCell = HashtagFeedCVCell()
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraints()
        hashtagFeedCVCell.homeVC = self
    }
    
    // MARK: - Helper
    
    func makeConstraints() {
        view.backgroundColor = .white
        
        view.addSubview(hashtagFeedCVCell)
        
        hashtagFeedCVCell.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func afterSetKeyword(keyword: String) {
        navigationItem.title = "#" + keyword
        
        hashtagFeedCVCell.keyword = keyword
        hashtagFeedCVCell.getPostsService(lastId: 0, limit: 10) { [self] (Post) in
            hashtagFeedCVCell.postContent = Post.body
            hashtagFeedCVCell.afterFetchNewsFeed()
        }
    }
    
}
