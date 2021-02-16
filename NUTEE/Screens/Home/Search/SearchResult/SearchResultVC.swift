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
    
    let searchResultTableView = UITableView()

    // MARK: - Variables and Properties
    
    var searchResult = ""
    
    var newsPost: Post? // 초기에 전부 다 받아오는 애
    var post: PostBody? // Body 요소 한 개
    var postContent: [PostBody]? // 받아온 것 중에서 Body만

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getSearchPostsService(word: searchResult, lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.searchResultTableView.reloadData()
        }
        
        setTableView()
    }

    // MARK: - Helper
    
    func setTableView() {
        _ = searchResultTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(NewsFeedTVCell.self, forCellReuseIdentifier: "NewsFeedTVCell")
            
            $0.separatorStyle = .none
        }
        
        
        self.view.addSubview(searchResultTableView)
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }

}

// MARK: - TableView Delegate

extension SearchResultVC: UITableViewDelegate { }
extension SearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let postItems = self.postContent?.count ?? 0

        if postItems == 0 {
            searchResultTableView.setEmptyView(title: "검색 결과가 없습니다", message: "검색어를 확인해주세요")
        } else {
            searchResultTableView.restore()
        }

        return postItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeueReusableCell(withIdentifier: "NewsFeedTVCell", for: indexPath) as! NewsFeedTVCell
        cell.selectionStyle = .none
        cell.categoryButton.isUserInteractionEnabled = false
        
        post = postContent?[indexPath.row]
        
        // 생성된 Cell 클래스로 NewsPost 정보 넘겨주기
        cell.newsPost = self.post
        
        cell.fillDataToView()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailNewsFeedVC = DetailNewsFeedVC()
        
        self.navigationController?.pushViewController(detailNewsFeedVC, animated: true)
    }

}

// MARK: - Server connect

extension SearchResultVC {
    func getSearchPostsService(word: String, lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.getSearchPosts(word: word, lastId: lastId, limit: limit) { responsedata in

            switch responsedata {
            case .success(let res):
                let response = res as! Post
                self.newsPost = response
                completionHandler(self.newsPost!)

            case .requestErr(_):
                self.searchResultTableView.setEmptyView(title: "요청 오류 발생😢", message: "피드를 조회하지 못했습니다")

            case .pathErr:
                print("error")
                self.searchResultTableView.setEmptyView(title: "서버 오류 발생😢", message: "피드를 조회하지 못했습니다")

            case .serverErr:
                print("error")
                self.searchResultTableView.setEmptyView(title: "서버 오류 발생", message: "피드를 조회하지 못했습니다")

            case .networkFail :
                print("error")
                self.searchResultTableView.setEmptyView(title: "네트워크 오류 발생", message: "피드를 조회하지 못했습니다")

            }
        }
    }
}
