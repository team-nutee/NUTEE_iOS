//
//  UserCommentFeedCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class UserCommentFeedCVCell: FeedContainerCVCell {
    
    override func fetchNewsFeed() {
        
        getMyCommentPostsService(lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.afterFetchNewsFeed()
            
            if self.postContent?.count == 0 {
                self.newsFeedTableView.setEmptyView(title: "댓글을 작성한 게시물", message: "댓글을 작성한 게시물이 여기에 표시됩니다")
            }
        }
    }
    
    override func loadMorePosts(lastId: Int) {
        if postContent?.count != 0 {
            getMyCommentPostsService(lastId: lastId, limit: 10) { (Post) in
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
        getMyCommentPostsService(lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.newsFeedTableView.reloadData()
            
            if self.postContent?.count == 0 {
                self.newsFeedTableView.setEmptyView(title: "댓글을 작성한 게시물", message: "댓글을 작성한 게시물이 여기에 표시됩니다")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}
