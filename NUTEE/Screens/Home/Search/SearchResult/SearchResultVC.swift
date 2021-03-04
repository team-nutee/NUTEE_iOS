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
        // 글 업데이트 되는 코드 구현
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

            case .requestErr(_):
                self.simpleNuteeAlertDialogue(title: "요청 오류 발생", message: "피드를 조회하지 못했습니다")

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
