
//
//  NewsFeedCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/22.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

class NewsFeedTVCell: UITableViewCell {
    
    static let identifier = Identify.NewsFeedTVCell
    
    // MARK: - UI components
    
    let categoryButton = UIButton().then {
        $0.layer.cornerRadius = 7
        $0.backgroundColor = UIColor(red: 178, green: 178, blue: 178)

        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.titleLabel?.font = .systemFont(ofSize: 11)
        $0.setTitleColor(.white, for: .normal)
        
        $0.isUserInteractionEnabled = false
        
        $0.isSkeletonable = true
//        $0.showAnimatedGradientSkeleton()
    }
    var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = UIColor(red: 178, green: 178, blue: 178)
        
//        $0.isHidden = true
    }
    let moreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.tintColor = UIColor(red: 134, green: 134, blue: 134)
//        $0.isUserInteractionEnabled = false
    }
    
    var titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
//        $0.text = "제목"
        
        $0.isSkeletonable = true
//        $0.showAnimatedGradientSkeleton()
    }
    var contentTextView = UITextView().then {
//        $0.text = "간단한 내용"
        
        $0.textContainer.maximumNumberOfLines = 3
        $0.textContainer.lineBreakMode = .byTruncatingTail
        $0.font = .systemFont(ofSize: 13)
        $0.isUserInteractionEnabled = false
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 기본 설정 값인 0이 좌우 여백이 있기 때문에 조정 필요
        
        $0.isSkeletonable = true
//        $0.showAnimatedGradientSkeleton()
    }
    
    let postCountInfoContainerView = UIView().then {
        $0.isSkeletonable = true
//        $0.showAnimatedGradientSkeleton()
    }
    let viewCountButton = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.tintColor = UIColor(red: 134, green: 134, blue: 134)
        $0.isUserInteractionEnabled = false
    }
    var viewCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = UIColor(red: 134, green: 134, blue: 134)
        $0.sizeToFit()
    }
    let likeButton = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.tintColor = UIColor(red: 134, green: 134, blue: 134)
        $0.isUserInteractionEnabled = false
    }
    var likeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = UIColor(red: 134, green: 134, blue: 134)
        $0.sizeToFit()
    }
    let imageButton = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.tintColor = UIColor(red: 134, green: 134, blue: 134)
        $0.isUserInteractionEnabled = false
    }
    var imageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = UIColor(red: 134, green: 134, blue: 134)
        $0.sizeToFit()
    }
    let replyButton = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.tintColor = UIColor(red: 134, green: 134, blue: 134)
        $0.isUserInteractionEnabled = false
    }
    var replyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = UIColor(red: 134, green: 134, blue: 134)
        $0.sizeToFit()
    }

    // MARK: - Variables and Properties
    
    var homeVC: UIViewController?
    var delegate: NewsFeedTVCellDelegate?
    
    var newsPost: PostBody?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func makeConstraints() {
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        
        
        // Add SubViews
        contentView.addSubview(categoryButton)
        contentView.addSubview(dateLabel)
        contentView.addSubview(moreButton)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentTextView)
        
        contentView.addSubview(postCountInfoContainerView)
        postCountInfoContainerView.addSubview(viewCountButton)
        postCountInfoContainerView.addSubview(viewCountLabel)
        postCountInfoContainerView.addSubview(likeButton)
        postCountInfoContainerView.addSubview(likeLabel)
        postCountInfoContainerView.addSubview(imageButton)
        postCountInfoContainerView.addSubview(imageLabel)
        postCountInfoContainerView.addSubview(replyButton)
        postCountInfoContainerView.addSubview(replyLabel)
        
        // Make Constraints
        let TopAndBottomSpace = 10
        let leftAndRightSpace = 20
        categoryButton.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(24)
            
            $0.top.equalTo(contentView.snp.top).offset(TopAndBottomSpace)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
        }
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryButton)
            $0.left.equalTo(categoryButton.snp.right).offset(10)
        }
        moreButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(categoryButton)
            $0.right.equalTo(contentView.snp.right).inset(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryButton.snp.bottom).offset(10)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
        }
        contentTextView.snp.makeConstraints {
            
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
        }
        
        let buttonWidth = 15
        let buttonHeight = 11
        let betweenButtons = 10
        let betweenButtonAndLabel = 5
        postCountInfoContainerView.snp.makeConstraints {
            $0.height.equalTo(buttonHeight)
            
            $0.top.equalTo(contentTextView.snp.bottom).offset(10)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
            $0.bottom.equalTo(contentView.snp.bottom).inset(TopAndBottomSpace)
        }
        viewCountButton.snp.makeConstraints {
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
            
            $0.top.equalTo(postCountInfoContainerView.snp.top)
            $0.left.equalTo(postCountInfoContainerView.snp.left)
            $0.bottom.equalTo(postCountInfoContainerView.snp.bottom)
        }
        viewCountLabel.snp.makeConstraints{
            $0.centerY.equalTo(viewCountButton)
            $0.left.equalTo(viewCountButton.snp.right).offset(betweenButtonAndLabel)
        }
        likeButton.snp.makeConstraints {
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
            
            $0.centerY.equalTo(viewCountButton)
            $0.left.equalTo(viewCountLabel.snp.right).offset(betweenButtons)
        }
        likeLabel.snp.makeConstraints{
            $0.centerY.equalTo(likeButton)
            $0.left.equalTo(likeButton.snp.right).offset(betweenButtonAndLabel)
        }
        imageButton.snp.makeConstraints {
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
            
            $0.centerY.equalTo(viewCountButton)
            $0.left.equalTo(likeLabel.snp.right).offset(betweenButtons)
        }
        imageLabel.snp.makeConstraints{
            $0.centerY.equalTo(imageButton)
            $0.left.equalTo(imageButton.snp.right).offset(betweenButtonAndLabel)
        }
        replyButton.snp.makeConstraints {
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
            
            $0.centerY.equalTo(viewCountButton)
            $0.left.equalTo(imageLabel.snp.right).offset(betweenButtons)
        }
        replyLabel.snp.makeConstraints{
            $0.centerY.equalTo(replyButton)
            $0.left.equalTo(replyButton.snp.right).offset(betweenButtonAndLabel)
        }
    }
    
    func fillDataToView () {
        // 카테고리 종류
        categoryButton.setTitle(newsPost?.category, for: .normal)

        // 게시글 게시 시간 설정
        if newsPost?.createdAt == newsPost?.updatedAt {
            let originPostTime = newsPost?.createdAt ?? ""
            let postTimeDateFormat = originPostTime.getDateFormat(time: originPostTime)
            dateLabel.text = postTimeDateFormat?.timeAgoSince(postTimeDateFormat!)
        } else {
            let originPostTime = newsPost?.updatedAt ?? ""
            let postTimeDateFormat = originPostTime.getDateFormat(time: originPostTime)
            let updatePostTime = postTimeDateFormat?.timeAgoSince(postTimeDateFormat!)
            dateLabel.text = "수정 " + (updatePostTime ?? "")
        }

        // Posting 내용 설정
        titleLabel.text = newsPost?.title
        titleLabel.sizeToFit()
        contentTextView.text = newsPost?.content
        
        viewCountButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        viewCountLabel.text = String(newsPost?.hits ?? 0)
        
        imageButton.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        imageLabel.text = String(newsPost?.images?.count ?? 0)
        
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeLabel.text = String(newsPost?.likers?.count ?? 0)
        
        replyButton.setImage(UIImage(systemName: "message.fill"), for: .normal)
        replyLabel.text = String(newsPost?.commentNum ?? 0)
    }
    
    func hideSkeletonView() {
        categoryButton.hideSkeleton()
//        dateLabel.isHidden = false
        
        titleLabel.hideSkeleton()
        contentTextView.hideSkeleton()
        
        postCountInfoContainerView.hideSkeleton()
    }
    
    @objc func didTapMoreButton() {
        let nuteeAlertSheet = NuteeAlertSheet()
        nuteeAlertSheet.optionList = [["수정", UIColor.black, "editPost"],
                                      ["삭제", UIColor.red, "deletePost"],
                                      ["🚨신고하기", UIColor.red, "reportPost"]]
        
        nuteeAlertSheet.modalPresentationStyle = .custom
        
        homeVC?.present(nuteeAlertSheet, animated: true)
    }

//    @IBAction func btnMore(sender: AnyObject) {
//        let moreAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//        let editAction = UIAlertAction(title: "수정", style: .default){
//            (action: UIAlertAction) in
//            // Code to edit
//            // Posting 창으로 전환
//            let postSB = UIStoryboard(name: "Post", bundle: nil)
//            let editPostingVC = postSB.instantiateViewController(withIdentifier: "PostVC") as! PostVC
//
//            editPostingVC.loadViewIfNeeded()
//            editPostingVC.editNewsPost = self.newsPost
//            editPostingVC.setEditMode()
//
//            editPostingVC.modalPresentationStyle = .fullScreen
//            self.newsFeedVC?.present(editPostingVC, animated: true, completion: nil)
//        }
//        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {
//            (action: UIAlertAction) in
//            let deleteAlert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
//            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
//            let okAction = UIAlertAction(title: "삭제", style: .destructive) {
//                (action: UIAlertAction) in
//                // Code to 삭제
//                self.deletePost()
//            }
//            deleteAlert.addAction(cancelAction)
//            deleteAlert.addAction(okAction)
//            self.newsFeedVC?.present(deleteAlert, animated: true, completion: nil)
//        }
//        let userReportAction = UIAlertAction(title: "신고하기🚨", style: .destructive) {
//            (action: UIAlertAction) in
//            // Code to 신고 기능
//            let reportAlert = UIAlertController(title: "이 게시글을 신고하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
//            let cancelAction
//                = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//            let reportAction = UIAlertAction(title: "신고", style: .destructive) {
//                (action: UIAlertAction) in
//                let content = reportAlert.textFields?[0].text ?? "" // 신고 내용
//                self.reportPost(content: content)
//                //신고 여부 알림 <-- 서버연결 코드에서 구현됨
//            }
//            reportAlert.addTextField { (mytext) in
//                mytext.tintColor = .nuteeGreen
//                mytext.placeholder = "신고할 내용을 입력해주세요."
//            }
//            reportAlert.addAction(cancelAction)
//            reportAlert.addAction(reportAction)
//
//            self.newsFeedVC?.present(reportAlert, animated: true, completion: nil)
//        }
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//
//        let userId = KeychainWrapper.standard.integer(forKey: "id")
//
//        if (userId == newsPost?.userID) {
//            moreAlert.addAction(editAction)
//            moreAlert.addAction(deleteAction)
//            moreAlert.addAction(cancelAction)
//        } else {
//            moreAlert.addAction(userReportAction)
//            moreAlert.addAction(cancelAction)
//        }
//
//        newsFeedVC?.present(moreAlert, animated: true, completion: nil)
//    }
//
//
//    func showDetailNewsFeed() {
//        // DetailNewsFeed 창으로 전환
//        let detailNewsFeedSB = UIStoryboard(name: "DetailNewsFeed", bundle: nil)
//        let showDetailNewsFeedVC = detailNewsFeedSB.instantiateViewController(withIdentifier: "DetailNewsFeed") as! DetailNewsFeedVC
//
//        // 현재 게시물 id를 DetailNewsFeedVC로 넘겨줌
//        showDetailNewsFeedVC.postId = self.newsPost?.id
//        showDetailNewsFeedVC.getPostService(postId: showDetailNewsFeedVC.postId!, completionHandler: {(returnedData)-> Void in
//            showDetailNewsFeedVC.replyTV.reloadData()
//        })
//
//        newsFeedVC?.navigationController?.pushViewController(showDetailNewsFeedVC, animated: true)
//    }
//

//    func setButtonAttributed(btn: UIButton, num: Int, color: UIColor, state: UIControl.State) {
//        let stateAttributes = [NSAttributedString.Key.foregroundColor: color]
//        btn.setAttributedTitle(NSAttributedString(string: " " + String(num), attributes: stateAttributes), for: state)
//        btn.tintColor = color
//    }
//
//    func deletePost() {
//        self.postDeleteService(postId: self.newsPost?.id ?? 0, completionHandler: {() -> Void in
//            // delegate로 NewsFeedVC와 통신하기
//            self.delegate?.updateNewsTV()
//        })
//    }

}

// MARK: - NewsFeedVC와 통신하기 위한 프로토콜 정의

protocol NewsFeedTVCellDelegate: class {
    func updateNewsTV() // NewsFeedVC에 정의되어 있는 프로토콜 함수
}

// MARK: - Repost

//extension NewsFeedTVCell {
//    func reportPost( content: String) {
//        let userid = KeychainWrapper.standard.string(forKey: "id") ?? ""
//        ContentService.shared.reportPost(userid, content) { (responsedata) in
//
//            switch responsedata {
//            case .success(_):
//
//                let successfulAlert = UIAlertController(title: "신고가 완료되었습니다", message: nil, preferredStyle: UIAlertController.Style.alert)
//                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//
//                successfulAlert.addAction(okAction)
//
//                self.newsFeedVC?.present(successfulAlert, animated: true, completion: nil)
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
//
//
//    // MARK: - Post
//    func postDeleteService(postId: Int, completionHandler: @escaping () -> Void ) {
//        ContentService.shared.postDelete(postId) { (responsedata) in
//
//            switch responsedata {
//            case .success(let res):
//
//                print("postPost succussful", res)
//                completionHandler()
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
