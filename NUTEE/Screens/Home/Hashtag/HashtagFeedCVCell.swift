//
//  HashtagFeedCVCell.swift
//  NUTEE
//
//  Created by eunwoo on 2021/03/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

import Foundation

class HashtagFeedCVCell: SearchResultFeedCVCell {
    
    //MARK: - Server connect
    
    override func getPostsService(lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.searchHashtag(tag: self.keyword ?? "", lastId: lastId, limit: limit) { [self] responsedata in
            
            switch responsedata {
            case .success(let res):
                let response = res as! Post
                newsPost = response
                completionHandler(newsPost!)
                
            case .requestErr(let message):
                setFetchNewsFeedFail("\(message)")
                
            case .pathErr:
                setFetchNewsFeedFail("서버 연결에 오류가 있습니다")
                
            case .serverErr:
                setFetchNewsFeedFail("서버에 오류가 있습니다")

            case .networkFail :
                setFetchNewsFeedFail("네트워크에 오류가 있습니다")

            }
        }
    }
}
