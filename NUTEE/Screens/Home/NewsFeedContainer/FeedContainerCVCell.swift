//
//  FeedContainerCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/31.
//  Copyright © 2020 Nutee. All rights reserved.
//
import UIKit
import SnapKit
import SkeletonView
import SwiftKeychainWrapper

class FeedContainerCVCell : UICollectionViewCell {
    
    static let identifier = Identify.FeedContainerCVCell
    
    // MARK: - UI components
    
    let activityIndicator = UIActivityIndicatorView()
    
    let refreshControl = SmallRefreshControl()
    
    let newsFeedTableView = UITableView()
    
    // MARK: - Variables and Properties
    
    var homeVC: UIViewController?
    
    var newsPost: Post? // 초기에 전부 다 받아오는 애
    var post: PostBody? // Body 요소 한 개
    var postContent: [PostBody]? // 받아온 것 중에서 Body만
        
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        makeConstraints()
        
        fetchNewsFeed()
        
        setRefresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func initView() {
        _ = newsFeedTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(NewsFeedTVCell.self, forCellReuseIdentifier: Identify.NewsFeedTVCell)
            
            $0.separatorInset.left = 0
            $0.separatorStyle = .none
            
            $0.isHidden = true
        }
        
        _ = activityIndicator.then {
            $0.style = .medium
            $0.startAnimating()
        }
    }
    
    func makeConstraints() {
        contentView.addSubview(newsFeedTableView)
        contentView.addSubview(activityIndicator)
        
        newsFeedTableView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(newsFeedTableView.snp.top)
            $0.left.equalTo(newsFeedTableView.snp.left)
            $0.right.equalTo(newsFeedTableView.snp.right)
            $0.bottom.equalTo(newsFeedTableView.snp.bottom)
        }
    }

    func setRefresh() {
        newsFeedTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updatePosts), for: UIControl.Event.valueChanged)
    }
    
    @objc func updatePosts() {
        getPostsService(lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.newsFeedTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadMorePosts(lastId: Int) {
        if postContent?.count != 0 {
            getPostsService(lastId: lastId, limit: 10) { (Post) in
                self.postContent?.append(contentsOf: Post.body)
                self.newsFeedTableView.reloadData()
                self.newsFeedTableView.tableFooterView = nil
            }
        } else {
            print("더 이상 불러올 게시글이 없습니다.")
        }
    }
    
    func fetchNewsFeed() {
        getPostsService(lastId: 0, limit: 10) { (Post) in
            self.postContent = Post.body
            self.afterFetchNewsFeed()
        }
    }
    
    func setFetchNewsFeedFail(_ message: String) {
        refreshControl.endRefreshing()
        
        activityIndicator.stopAnimating()
        newsFeedTableView.isHidden = false
        
        newsFeedTableView.setEmptyView(title: "오류 발생😢", message: "피드를 조회하지 못했습니다")
        
        self.homeVC?.simpleNuteeAlertDialogue(title: "피드 조회 실패", message: message)
    }
    
    func afterFetchNewsFeed() {
        newsFeedTableView.reloadData()
        
        activityIndicator.stopAnimating()
        newsFeedTableView.isHidden = false
    }
    
    func deletePost(postId: Int) {
        postDeleteService(postId: postId, completionHandler: {
            self.fetchNewsFeed()
        })
    }
    
    func getPostsService(lastId: Int, limit: Int, completionHandler: @escaping (_ returnedData: Post) -> Void ) { }
}

// MARK: - TableView

extension FeedContainerCVCell : UITableViewDelegate { }
extension FeedContainerCVCell : UITableViewDataSource {
    
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
        let postItems = self.postContent?.count ?? 0

        if postItems == 0 {
            newsFeedTableView.setEmptyView(title: "게시글이 없습니다", message: "게시글을 작성해주세요✏️")
        } else {
            newsFeedTableView.restore()
        }

        return postItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.NewsFeedTVCell, for: indexPath) as! NewsFeedTVCell
        cell.selectionStyle = .none
        cell.addBorder(.bottom, color: .veryLightPink, thickness: 0)
        
        post = postContent?[indexPath.row]
        
        // 생성된 Cell 클래스로 NewsPost 정보 넘겨주기
        cell.newsPost = self.post
        cell.homeVC = self.homeVC
        cell.feedContainerCVCell = self
        
        cell.fillDataToView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailNewsFeedVC = DetailNewsFeedVC()
        
        // 현재 게시물 id를 DetailNewsFeedVC로 넘겨줌
        detailNewsFeedVC.postId = postContent?[indexPath.row].id
        detailNewsFeedVC.feedContainerCVCell = self
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
            
            newsFeedTableView.tableFooterView = spinner
            newsFeedTableView.tableFooterView?.isHidden = false
            
            if newsPost?.body.count != 0 && newsPost?.body.count != nil {
                // 불러올 포스팅이 있을 경우
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: newsFeedTableView.bounds.width, height: CGFloat(44))
                spinner.hidesWhenStopped = true
                newsFeedTableView.tableFooterView = spinner
                newsFeedTableView.tableFooterView?.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.loadMorePosts(lastId: self.post?.id ?? 0)
                }
                
            } else {
                // 사용자 NewsFeed의 마지막 포스팅일 경우
                self.newsFeedTableView.tableFooterView?.isHidden = true
                spinner.stopAnimating()
            }
            
            
        }
    }
}

//MARK: - Server connect

extension FeedContainerCVCell{
    
    // MARK: - Delete post
    func postDeleteService(postId: Int, completionHandler: @escaping () -> Void) {
        ContentService.shared.deletePost(postId) { (responsedata) in

            switch responsedata {
            case .success(_):
                completionHandler()
                
            case .requestErr(_):
                print("request error")

            case .pathErr:
                print(".pathErr")

            case .serverErr:
                print(".serverErr")

            case .networkFail :
                print("failure")
            }
        }
    }
    
    // MARK: - Report post
    func reportPost(postId: Int, content: String, completionHandler: @escaping () -> Void) {
        ContentService.shared.reportPost(postId, content) { (responsedata) in

            switch responsedata {
            case .success(_):
                break

            case .requestErr(_):
                print("request error")

            case .pathErr:
                print(".pathErr")

            case .serverErr:
                print(".serverErr")

            case .networkFail :
                print("failure")
            }
        }
    }
    
}
