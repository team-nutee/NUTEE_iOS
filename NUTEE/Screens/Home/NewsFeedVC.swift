//
//  NewsFeedVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/22.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

import SnapKit
import Then

class NewsFeedVC: UIViewController {
    
    // MARK: - UI components
    
    let newsFeedTableView = UITableView()
    
    var refreshControl: UIRefreshControl!
    
    // MARK: - Variables and Properties
    
//    var newsPostsArr: NewsPostsContent?
//    var newsPosts: NewsPostsContent?
//    var newsPost: NewsPostsContentElement?
    
    var loadCompleteButton = UIButton()
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNewsFeed()
        setTableView()
//        self.view.addSubview(loadCompleteBtn)
        
//        initColor()
//        setRefresh()
//
//        setLoadBtn()
//        self.loadCompleteBtn.addTarget(self, action: #selector(loadingBtn), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
//        Analytics.logEvent("mainview", parameters: [
//           "name": "메인 뷰 선택" as NSObject,
//           "full_text": "메인 뷰 선택" as NSObject
//           ])
//
//        getNewsPostsService(postCnt: 10, lastId: 0, completionHandler: {(returnedData)-> Void in
//            if self.newsPostsArr?.count ?? 0 > 0 {
//                var tmpNewsPost: NewsPostsContentElement?
//                // 기존의 최신 게시글 id
//                tmpNewsPost = self.newsPostsArr?[0]
//                let lastestPostId = tmpNewsPost?.id
//                // 업데이트 된 최신 게시글 id
//                tmpNewsPost = self.newsPosts?[0]
//                let updatedLastestPostId = tmpNewsPost?.id
//
//                // 새로 올라온 게시글이 있을 경우
//                if(updatedLastestPostId ?? 0 > lastestPostId ?? 0){
//                    UIView.animate(withDuration: 1,
//                                   delay: 0,
//                                   usingSpringWithDamping: 0.6,
//                                   initialSpringVelocity: 1,
//                                   options: [.curveEaseIn],
//                                   animations: {
//                                    self.loadCompleteBtn.alpha = 1
//                                    self.loadCompleteBtn.transform = CGAffineTransform.init(translationX: 0, y: 50)
//                    })
//
//                }
//
//            } else {
//                self.newsPostsArr = self.newsPosts
//                self.newsTV.reloadData()
//            }
//        }
//
//        )
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    // MARK: -Helper
    
    func initNewsFeed() {
        _ = newsFeedTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(NewsFeedTVCell.self, forCellReuseIdentifier: "NewsFeedTVCell")
            
            $0.separatorInset.left = 0
            $0.separatorStyle = .none
        }
    }
    
    func setTableView() {
        view.addSubview(newsFeedTableView)
        
        newsFeedTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
//    func setLoadBtn(){
//
//        let btnLabel = NSMutableAttributedString(string: "새 글 업데이트")
//        loadCompleteBtn.setAttributedTitle(btnLabel, for: .normal)
//        loadCompleteBtn.titleLabel?.font = .boldSystemFont(ofSize: 13)
//        loadCompleteBtn.makeRounded(cornerRadius: 15)
//        loadCompleteBtn.borderColor = .nuteeGreen
//        loadCompleteBtn.borderWidth = 0.5
//        //        loadCompleteBtn.backgroundColor = .greenLighter
//        loadCompleteBtn.translatesAutoresizingMaskIntoConstraints = false
//        loadCompleteBtn.topAnchor.constraint(equalTo: self.newsTV.topAnchor, constant: 0).isActive = true
//        loadCompleteBtn.centerXAnchor.constraint(equalTo: self.newsTV.centerXAnchor).isActive = true
//        loadCompleteBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        loadCompleteBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        loadCompleteBtn.backgroundColor = .white
//
//        loadCompleteBtn.alpha = 0
//    }
    
//    @objc func loadingBtn(){
//        updatePosts()
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       usingSpringWithDamping: 0.6,
//                       initialSpringVelocity: 1,
//                       options: [.curveEaseIn],
//                       animations: {
//                        self.loadCompleteBtn.alpha = 0
//                        self.loadCompleteBtn.transform = CGAffineTransform.init(translationX: 0, y: 0)
//        })
//
//        let indexPath = IndexPath(row: 0, section: 0)
//        newsTV.scrollToRow(at: indexPath, at: .top, animated: true)
//    }
//
//    // 로그인이 되어있는지 체크
//    func checkLogin() {
//        if KeychainWrapper.standard.data(forKey: "Cookies") == nil {
//
//            let storyboard = UIStoryboard(name: "Login", bundle: nil)
//            let vc = storyboard.instantiateViewController(identifier: "LoginVC") as! LoginVC
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
//
//    func initColor() {
//        self.tabBarController?.tabBar.tintColor = .nuteeGreen
//    }
    
//    func setRefresh() {
//        refreshControl = UIRefreshControl()
//        newsTV.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(updatePosts), for: UIControl.Event.valueChanged)
//    }
//
//    @objc func updatePosts() {
//        getNewsPostsService(postCnt: 10, lastId: 0, completionHandler: {(returnedData)-> Void in
//            self.newsPostsArr = self.newsPosts
//            self.newsTV.reloadData()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.refreshControl.endRefreshing()
//            }
//        })
//
//    }
//
//    func loadMorePosts(lastId: Int) {
//        if newsPosts?.count != 0 {
//            getNewsPostsService(postCnt: 10, lastId: lastId, completionHandler: {(returnedData)-> Void in
//                self.newsPostsArr?.append(contentsOf: self.newsPosts!)
//                self.newsTV.reloadData()
//                self.newsTV.tableFooterView = nil
//            })
//        } else {
//            print("더 이상 불러올 게시글이 없습니다.")
//        }
//    }
    
}

// MARK: - UITableView
extension NewsFeedVC : UITableViewDelegate { }

extension NewsFeedVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let postItems = newsPostsArr?.count ?? 0
//
//        if postItems == 0 {
//            newsTV.setEmptyView(title: "게시글이 없습니다", message: "게시글을 작성해주세요✏️")
//        } else {
//            newsTV.restore()
//        }
//
//        return postItems
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Custom셀인 'NewsFeedCell' 형식으로 생성
        let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: "NewsFeedTVCell", for: indexPath) as! NewsFeedTVCell

        cell.testLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
//        // 셀 선택시 백그라운드 변경 안되게 하기 위한 코드
//        cell.addBorder((.bottom), color: .lightGray, thickness: 0.1)
//        cell.selectionStyle = .none
//
//
//        // cell 초기화 진행
//        // emptyStatusView(tag: 404) cell에서 제거하기
//        if let viewWithTag = self.view.viewWithTag(404) {
//            viewWithTag.removeFromSuperview()
//        }
//
//        newsPost = newsPostsArr?[indexPath.row]
//
//        // 생성된 Cell클래스로 NewsPost 정보 넘겨주기
//        cell.newsPost = self.newsPost
//        cell.initPosting()
//
//        // VC 컨트롤 권한을 Cell클래스로 넘겨주기
//        cell.newsFeedVC = self
//        // NewsFeedVC와 FeedTVC 사이를 통신하기 위한 변수 연결작업
//        cell.delegate = self
//
//        // 사용자 프로필 이미지 탭 인식 설정
//        cell.setClickActions()

        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // DetailNewsFeed 창으로 전환
//        let detailNewsFeedSB = UIStoryboard(name: "DetailNewsFeed", bundle: nil)
//        let showDetailNewsFeedVC = detailNewsFeedSB.instantiateViewController(withIdentifier: "DetailNewsFeed") as! DetailNewsFeedVC
//
//        // 현재 게시물 id를 DetailNewsFeedVC로 넘겨줌
//        showDetailNewsFeedVC.postId = newsPostsArr?[indexPath.row].id
//        showDetailNewsFeedVC.getPostService(postId: showDetailNewsFeedVC.postId!, completionHandler: {(returnedData)-> Void in
//            showDetailNewsFeedVC.replyTV.reloadData()
//        })
//
//        // NewsFeedVC와 중간 매개 델리게이트(DetailNewsFeed) 사이를 통신하기 위한 변수 연결작업
//        showDetailNewsFeedVC.delegate = self
//
//        self.navigationController?.pushViewController(showDetailNewsFeedVC, animated: true)
//    }

    // 마지막 셀일 때 ActivateIndicator와 함께 새로운 cell 정보 로딩
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // 로딩된 cell 중 마지막 셀 찾기
//        let lastSectionIndex = tableView.numberOfSections - 1
//        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
//        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
//
//            let spinner = UIActivityIndicatorView()
//
//            newsTV.tableFooterView = spinner
//            newsTV.tableFooterView?.isHidden = false
//
//            if newsPosts?.count != 0 && newsPosts?.count != nil {
//                // 불러올 포스팅이 있을 경우
//                spinner.startAnimating()
//                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: newsTV.bounds.width, height: CGFloat(44))
//                spinner.hidesWhenStopped = true
//                newsTV.tableFooterView = spinner
//                newsTV.tableFooterView?.isHidden = false
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    self.loadMorePosts(lastId: self.newsPost?.id ?? 0)
//                }
//            } else {
//                // 사용자 NewsFeed의 마지막 포스팅일 경우
//                self.newsTV.tableFooterView?.isHidden = true
//                spinner.stopAnimating()
//                //                newsTV.tableFooterView = nil
//            }
//
//
//        }
//    }

}

//// MARK: - FeedTVC과 통신하여 게시글 삭제 후 테이블뷰 정보 다시 로드하기
//
//extension NewsFeedVC: FeedTVCDelegate, DetailHeaderViewDelegate {
//    func updateNewsTV() {
//        getNewsPostsService(postCnt: 10, lastId: 0, completionHandler: {returnedData -> Void in
//            self.newsPostsArr = self.newsPosts
//            self.newsTV.reloadData()
//        })
//    }
//
//    func backToUpdateNewsTV() {
//        getNewsPostsService(postCnt: 10, lastId: 0, completionHandler: {returnedData -> Void in
//            self.newsPostsArr = self.newsPosts
//            self.newsTV.reloadData()
//        })
//    }
//}
//
////MARK: - 뉴스피드 내용을 가져오기 위한 서버연결
//
//extension NewsFeedVC {
//    func getNewsPostsService(postCnt: Int, lastId: Int, completionHandler: @escaping (_ returnedData: NewsPostsContent) -> Void ) {
//        ContentService.shared.getNewsPosts(postCnt, lastId: lastId) { responsedata in
//
//            switch responsedata {
//            case .success(let res):
//                let response = res as! NewsPostsContent
//                self.newsPosts = response
//                completionHandler(self.newsPosts!)
//
//
//            case .requestErr(_):
//                print("request error")
//
//            case .pathErr:
//                print(".pathErr")
//
//            case .serverErr:
//                print(".serverErr")
//
//            case .networkFail :
//                print("failure")
//            }
//        }
//    }
//}
