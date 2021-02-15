//
//  UserPostFeedCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

class UserPostFeedCVCell: FeedContainerCVCell {
    
    override func fetchNewsFeed() {
        
        getUserPostsService(id: self.memberId ?? 0, lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.afterFetchNewsFeed()
        }
    }
    
    override func loadMorePosts(lastId: Int) {
        if postContent?.count != 0 {
            getUserPostsService(id: self.memberId ?? 0, lastId: lastId, limit: 10) { (Post) in
                self.postContent?.append(contentsOf: Post.body)
                self.newsFeedTableView.reloadData()
                self.newsFeedTableView.tableFooterView = nil
            }
        } else {
            print("더 이상 불러올 게시글이 없습니다.")
        }
    }
    
    @objc override func updatePosts() {
        getUserPostsService(id: self.memberId ?? 0, lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.newsFeedTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}
