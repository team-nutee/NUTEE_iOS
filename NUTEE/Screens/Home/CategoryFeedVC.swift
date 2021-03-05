//
//  CategoryFeedVC.swift
//  NUTEE
//
//  Created by eunwoo on 2021/02/13.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class CategoryFeedVC: FeedContainerVC {
    
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NUTEE"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.CategoryFeedCVCell, for: indexPath) as! CategoryFeedCVCell
        
        cell.category = self.category ?? ""
        cell.homeVC = self
        cell.getPostsService(lastId: 0, limit: 10) { (Post) in
            cell.postContent = Post.body
            cell.afterFetchNewsFeed()
            
            if cell.postContent?.count == 0 {
                cell.newsFeedTableView.setEmptyView(title: "게시글이 없습니다", message: "게시글을 작성해주세요✏️")
            }
        }
        
        return cell
    }
}
