//
//  SearchResultVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

class SearchResultVC: UIViewController {

    // MARK: - UI components
    
    let searchResultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Variables and Properties
    
    var searchResult = ""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
    }

    // MARK: - Helper
    
    func setCollectionView() {
        _ = searchResultCollectionView.then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
            
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(FeedContainerCVCell.self, forCellWithReuseIdentifier: Identify.FeedContainerCVCell)
            
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(view.snp.top)
                $0.left.equalTo(view.snp.left)
                $0.right.equalTo(view.snp.right)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            
            $0.backgroundColor = .white
            
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
    }

}

// MARK: - CollectionView Delegate
extension SearchResultVC : UICollectionViewDelegate { }
extension SearchResultVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }

}
extension SearchResultVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: Identify.FeedContainerCVCell, for: indexPath) as! FeedContainerCVCell
        
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
