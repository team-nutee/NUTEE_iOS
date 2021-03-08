//
//  FeedContainerVC.swift
//  NUTEE
//
//  Created by eunwoo on 2021/03/04.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class FeedContainerVC: UIViewController {

    // MARK: - UI components
    
    let feedContainerCVCell = FeedContainerCVCell()
        
    // MARK: - Variables and Properties
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NUTEE"
        
        makeConstraints()
        
        fetchNewsFeed()
        
        setRefresh()
    }
    
    // MARK: - Helper
    
    func makeConstraints() {
        view.backgroundColor = .white
        
        view.addSubview(feedContainerCVCell)
        
        feedContainerCVCell.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setRefresh() {
        feedContainerCVCell.refreshControl.addTarget(self, action: #selector(updatePosts), for: UIControl.Event.valueChanged)
    }
    
    @objc func updatePosts() {
        getPostsService(lastId: 0, limit: 10) { (Post) in
            self.feedContainerCVCell.postContent = Post.body
            self.feedContainerCVCell.newsFeedTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.feedContainerCVCell.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadMorePosts(lastId: Int) {
        if feedContainerCVCell.postContent?.count != 0 {
            getPostsService(lastId: lastId, limit: 10) { (Post) in
                self.feedContainerCVCell.postContent?.append(contentsOf: Post.body)
                self.feedContainerCVCell.newsFeedTableView.reloadData()
                self.feedContainerCVCell.newsFeedTableView.tableFooterView = nil
            }
        } else {
            print("더 이상 불러올 게시글이 없습니다.")
        }
    }
    
    func fetchNewsFeed() {
        getPostsService(lastId: 0, limit: 10) { (Post) in
            self.feedContainerCVCell.postContent = Post.body
            self.feedContainerCVCell.afterFetchNewsFeed()
        }
    }
    
    func getPostsService(lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) { }
}
