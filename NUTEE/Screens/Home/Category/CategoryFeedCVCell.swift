//
//  CategoryFeedContainerCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/03/09.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import Foundation

class CategoryFeedCVCell: FeedContainerCVCell {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
        
    var category: String?
    
    // MARK: - Life Cycle
    
    // MARK: - Helper
    
    override func fetchNewsFeed() {
        // <--- make do nothing
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 부모 클래스와 동일 코드
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.NewsFeedTVCell, for: indexPath) as! NewsFeedTVCell
        cell.selectionStyle = .none
        cell.addBorder(.bottom, color: .veryLightPink, thickness: 0)
        
        post = postContent?[indexPath.row]
        
        // 생성된 Cell 클래스로 NewsPost 정보 넘겨주기
        cell.newsPost = self.post
        cell.homeVC = self.homeVC
        cell.feedContainerCVCell = self
        
        cell.fillDataToView()
        
        
        // <---- 차이점 ----> //
        // 카테고리 버튼 비활성화 //
        cell.categoryButton.isEnabled = false
        
        return cell
    }
    
    // MARK: - Server connect
    
    override func getPostsService(lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.getCategoryPosts(category: self.category ?? "", lastId: lastId, limit: limit) { [self] responsedata in
            
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
