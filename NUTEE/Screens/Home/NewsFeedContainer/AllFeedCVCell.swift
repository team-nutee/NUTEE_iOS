//
//  AllPostsFeedCVCell.swift
//  NUTEE
//
//  Created by eunwoo on 2021/01/22.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

class AllFeedCVCell: FeedContainerCVCell {
    override func fetchNewsFeed() {
        
        getAllPostsService(lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.afterFetchNewsFeed()
        }
    }
    
    override func loadMorePosts(lastId: Int) {
        if postContent?.count != 0 {
            getAllPostsService(lastId: lastId, limit: 10) { (Post) in
                self.postContent?.append(contentsOf: Post.body)
                self.newsFeedTableView.reloadData()
                self.newsFeedTableView.tableFooterView = nil
            }
        } else {
            print("더 이상 불러올 게시글이 없습니다.")
        }
    }
    
    @objc override func updatePosts() {
        getAllPostsService(lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.newsFeedTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}
