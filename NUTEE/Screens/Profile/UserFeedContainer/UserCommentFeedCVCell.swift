//
//  UserCommentFeedCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

class UserCommentFeedCVCell: FeedContainerCVCell {
    
    override func fetchNewsFeed() {
        super.fetchNewsFeed()
        
        newsFeedTableView.backgroundColor = .green
    }
    
}