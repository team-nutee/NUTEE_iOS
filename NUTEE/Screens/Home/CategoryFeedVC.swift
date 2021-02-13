//
//  CategoryFeedVC.swift
//  NUTEE
//
//  Created by eunwoo on 2021/02/13.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import SnapKit
import SkeletonView

class CategoryFeedVC: UIViewController {
    
    // MARK: - UI components
        
    let categoryFeedTableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    // MARK: - Variables and Properties
    var feedContainerCVCell: FeedContainerCVCell?
    
    var homeVC: UIViewController?
    var category: String?
    
    var newsPost: Post? // 초기에 전부 다 받아오는 애
    var post: PostBody? // Body 요소 한 개
    var postContent: [PostBody]? // 받아온 것 중에서 Body만
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NUTEE"
        view.backgroundColor = .white
        
        initView()
        makeConstraints()
        
        fetchCategoryFeed()
        
        setRefresh()
    }
    
    // MARK: - helper
    
    func initView() {
        _ = categoryFeedTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(NewsFeedTVCell.self, forCellReuseIdentifier: Identify.NewsFeedTVCell)
            
            $0.separatorInset.left = 0
            $0.separatorStyle = .none
            
        }
    }
    
    func makeConstraints() {
        view.addSubview(categoryFeedTableView)
        
        categoryFeedTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func setRefresh() {
        categoryFeedTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updatePosts), for: UIControl.Event.valueChanged)
    }

    @objc func updatePosts() {
        getCategoryPostsService(category: self.category ?? "", lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.categoryFeedTableView.reloadData()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func fetchCategoryFeed() {
        getCategoryPostsService(category: self.category ?? "", lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.categoryFeedTableView.reloadData()
        }
    }
    
    func loadMorePosts(lastId: Int) {
        if postContent?.count != 0 {
            getCategoryPostsService(category: self.category ?? "", lastId: lastId, limit: 10) { (Post) in
                self.postContent?.append(contentsOf: Post.body)
                self.categoryFeedTableView.reloadData()
                self.categoryFeedTableView.tableFooterView = nil
            }
        }
    }
    
    func setFetchCategoryFeedFail() {
        categoryFeedTableView.isHidden = false

        categoryFeedTableView.setEmptyView(title: "오류 발생😢", message: "피드를 조회하지 못했습니다")
    }
}

// MARK: - TableView
extension CategoryFeedVC : SkeletonTableViewDelegate { }
extension CategoryFeedVC : SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return Identify.NewsFeedTVCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postContent?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.NewsFeedTVCell, for: indexPath) as! NewsFeedTVCell
        cell.selectionStyle = .none
        cell.addBorder(.bottom, color: .veryLightPink, thickness: 0)
        cell.categoryButton.isUserInteractionEnabled = false
        
        post = postContent?[indexPath.row]
        
        // 생성된 Cell 클래스로 NewsPost 정보 넘겨주기
        cell.newsPost = self.post
        cell.homeVC = self.homeVC
        cell.feedContainerCVCell = self.feedContainerCVCell
        cell.categoryFeedVC = self
        
        cell.fillDataToView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailNewsFeedVC = DetailNewsFeedVC()
        
        // 현재 게시물 id를 DetailNewsFeedVC로 넘겨줌
        detailNewsFeedVC.postId = postContent?[indexPath.row].id
        detailNewsFeedVC.feedContainerCVCell = self.feedContainerCVCell
        if detailNewsFeedVC.postId != nil {
            homeVC?.navigationController?.pushViewController(detailNewsFeedVC, animated: true)
        }
    }
    
    // 마지막 셀일 때 ActivateIndicator와 함께 새로운 cell 정보 로딩
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 로딩된 cell 중 마지막 셀 찾기
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            
            let spinner = UIActivityIndicatorView()
            
            categoryFeedTableView.tableFooterView = spinner
            categoryFeedTableView.tableFooterView?.isHidden = false
            
            if newsPost?.body.count != 0 && newsPost?.body.count != nil {
                // 불러올 포스팅이 있을 경우
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: categoryFeedTableView.bounds.width, height: CGFloat(44))
                spinner.hidesWhenStopped = true
                categoryFeedTableView.tableFooterView = spinner
                categoryFeedTableView.tableFooterView?.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.loadMorePosts(lastId: self.post?.id ?? 0)
                }
                
            } else {
                // 사용자 NewsFeed의 마지막 포스팅일 경우
                self.categoryFeedTableView.tableFooterView?.isHidden = true
                spinner.stopAnimating()
            }
            
            
        }
    }
}

// MARK: - Server Connect

extension CategoryFeedVC {
    func getCategoryPostsService(category: String, lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) {
        ContentService.shared.getCategoryPosts(category: category, lastId: lastId, limit: limit) { responsedata in
            
            switch responsedata {
            case .success(let res):
                let response = res as! Post
                self.newsPost = response
                completionHandler(self.newsPost!)
                
            case .requestErr(_):
                self.homeVC?.simpleNuteeAlertDialogue(title: "피드 조회 실패", message: "요청에 실패했습니다")
                self.setFetchCategoryFeedFail()
                
            case .pathErr:
                self.homeVC?.simpleNuteeAlertDialogue(title: "피드 조회 실패", message: "서버 연결에 오류가 있습니다")
                self.setFetchCategoryFeedFail()
                
            case .serverErr:
                self.homeVC?.simpleNuteeAlertDialogue(title: "피드 조회 실패", message: "서버에 오류가 있습니다")
                self.setFetchCategoryFeedFail()
                
            case .networkFail :
                self.homeVC?.simpleNuteeAlertDialogue(title: "피드 조회 실패", message: "네트워크에 오류가 있습니다")
                self.setFetchCategoryFeedFail()
                
            }
        }
    }
}
