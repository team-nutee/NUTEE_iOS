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

    // MARK: - Helper

    @objc override func updatePosts() {
        let index = IndexPath(item: 1, section: 1)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.FeedContainerCVCell, for: index) as! FeedContainerCVCell
        
        searchPostsService(word: searchResult, lastId: 0, limit: 10) { (Post) in
            cell.postContent = Post.body
            cell.newsFeedTableView.reloadData() // 이 부분이 안됨
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - CollectionView Delegate

extension SearchResultVC {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.FeedContainerCVCell, for: indexPath) as! FeedContainerCVCell
        
        cell.homeVC = self
        searchPostsService(word: self.searchResult, lastId: 0, limit: 10) { (Post) in
            cell.postContent = Post.body
            cell.afterFetchNewsFeed()
            
            if cell.postContent?.count == 0 {
                cell.newsFeedTableView.setEmptyView(title: "검색 결과가 없습니다", message: "검색어를 확인해 주세요")
            }
        }
        
        return cell
    }
}

// MARK: - Server connect

extension SearchResultVC {
    func searchPostsService(word: String, lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.searchPosts(word: word, lastId: lastId, limit: limit) { responsedata in

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
