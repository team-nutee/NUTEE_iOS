//
//  FavoriteFeedCVCell.swift
//  NUTEE
//
//  Created by eunwoo on 2021/01/22.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import Foundation

class FavoriteFeedCVCell: FeedContainerCVCell {
    
    override func fetchNewsFeed() {
        
        getFavoritePostsService(lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.afterFetchNewsFeed()
        }
    }
    
    override func loadMorePosts(lastId: Int) {
        if postContent?.count != 0 {
            getFavoritePostsService(lastId: lastId, limit: 10) { (Post) in
                self.postContent?.append(contentsOf: Post.body)
                self.newsFeedTableView.reloadData()
                self.newsFeedTableView.tableFooterView = nil
            }
        } else {
            print("더 이상 불러올 게시글이 없습니다.")
        }
    }
    
    override func setRefresh() {
        newsFeedTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updatePosts), for: UIControl.Event.valueChanged)
    }
    
    @objc override func updatePosts() {
        getFavoritePostsService(lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.newsFeedTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
}
