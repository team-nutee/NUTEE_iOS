//
//  CategoryFeedVC.swift
//  NUTEE
//
//  Created by eunwoo on 2021/02/13.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class CategoryFeedVC: FeedContainerVC {
    
    // MARK: - Variables and Properties
    
    var category = ""

    // MARK: - Helper

    @objc override func updatePosts() {
        let index = IndexPath(item: 1, section: 1)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.FeedContainerCVCell, for: index) as! FeedContainerCVCell
        
        getCategoryPostsService(category: self.category, lastId: 0, limit: 10) { (Post) in
            cell.postContent = Post.body
            cell.newsFeedTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - CollectionView Delegate

extension CategoryFeedVC {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.FeedContainerCVCell, for: indexPath) as! FeedContainerCVCell
        
        cell.homeVC = self
        getCategoryPostsService(category: self.category, lastId: 0, limit: 10) { (Post) in
            cell.postContent = Post.body
            cell.afterFetchNewsFeed()
            
            if cell.postContent?.count == 0 {
                cell.newsFeedTableView.setEmptyView(title: "게시글이 없습니다", message: "게시글을 작성해주세요✏️")
            }
        }
        
        return cell
    }
}

// MARK: - Server Connect

extension CategoryFeedVC {
    func getCategoryPostsService(category: String, lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.getCategoryPosts(category: category, lastId: lastId, limit: limit) { responsedata in
            
            switch responsedata {
            case .success(let res):
                let response = res as! Post
                completionHandler(response)
                
            case .requestErr(let message):
                self.simpleNuteeAlertDialogue(title: "요청 오류 발생", message: "\(message)")

            case .pathErr:
                self.simpleNuteeAlertDialogue(title: "서버 오류 발생", message: "피드를 조회하지 못했습니다")

            case .serverErr:
                self.simpleNuteeAlertDialogue(title: "서버 오류 발생", message: "피드를 조회하지 못했습니다")

            case .networkFail :
                self.simpleNuteeAlertDialogue(title: "네트워크 오류 발생", message: "피드를 조회하지 못했습니다")

            }
        }
    }
}
