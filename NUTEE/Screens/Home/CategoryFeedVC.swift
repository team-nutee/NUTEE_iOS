//
//  CategoryFeedVC.swift
//  NUTEE
//
//  Created by eunwoo on 2021/02/13.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import SnapKit

class CategoryFeedVC: FeedContainerVC {
    
    var category: String?
    
    override func getPostsService(lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.getCategoryPosts(category: self.category ?? "", lastId: lastId, limit: limit) { responsedata in
            
            switch responsedata {
            case .success(let res):
                let response = res as! Post
                self.feedContainerCVCell.newsPost = response
                completionHandler(self.feedContainerCVCell.newsPost!)
                
            case .requestErr(let message):
                self.feedContainerCVCell.setFetchNewsFeedFail("\(message)")
                
            case .pathErr:
                self.feedContainerCVCell.setFetchNewsFeedFail("서버 연결에 오류가 있습니다")
                
            case .serverErr:
                self.feedContainerCVCell.setFetchNewsFeedFail("서버에 오류가 있습니다")
                
            case .networkFail :
                self.feedContainerCVCell.setFetchNewsFeedFail("네트워크에 오류가 있습니다")
                
            }
        }
    }
}
