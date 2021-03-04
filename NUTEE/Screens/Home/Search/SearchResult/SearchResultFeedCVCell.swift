//
//  SearchResultFeedCVCell.swift
//  NUTEE
//
//  Created by eunwoo on 2021/03/04.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

class SearchResultFeedCVCell: FeedContainerCVCell {
    
    var word = ""
    
    override func getPostsService(lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.searchPosts(word: self.word, lastId: lastId, limit: limit) { responsedata in
            
            switch responsedata {
            case .success(let res):
                let response = res as! Post
                self.newsPost = response
                completionHandler(self.newsPost!)
                
            case .requestErr(let message):
                self.setFetchNewsFeedFail("\(message)")
                
            case .pathErr:
                self.setFetchNewsFeedFail("서버 연결에 오류가 있습니다")
                
            case .serverErr:
                self.setFetchNewsFeedFail("서버에 오류가 있습니다")

            case .networkFail :
                self.setFetchNewsFeedFail("네트워크에 오류가 있습니다")

            }
        }
    }
}
