//
//  SearchResultVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SearchResultVC: FeedContainerVC {
    
    // MARK: - Variables and Properties
    
    var searchResult = ""

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.SearchResultFeedCVCell, for: indexPath) as! SearchResultFeedCVCell
        
        cell.homeVC = self
        cell.word = self.searchResult
        cell.getPostsService(lastId: 0, limit: 10) { (Post) in
            cell.postContent = Post.body
            cell.afterFetchNewsFeed()
            
            if cell.postContent?.count == 0 {
                cell.newsFeedTableView.setEmptyView(title: "검색 결과가 없습니다", message: "검색어를 확인해 주세요")
            }
        }
        
        return cell
    }
}
