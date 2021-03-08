//
//  SearchResultVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SearchResultVC: FeedContainerVC {
        
    var searchResult: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.searchResult ?? ""
    }
    
    override func getPostsService(lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.searchPosts(word: self.searchResult ?? "", lastId: lastId, limit: limit) { responsedata in
            
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
