//
//  DetailNewsFeedTVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/24.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

class ReplyTVCell: UITableViewCell, UITextViewDelegate{
    
    static let identifier = Identify.ReplyTVCell
    
    //MARK: - UI components
    
    let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let nicknameLabel = UILabel()
    
    let dateLabel = UILabel()
    let moreButton = UIButton()
    
    let replyTextView = UITextView()
    
    let likeButton = UIButton()
    let likeLabel = UILabel()

    //MARK: - Variables and Properties

    var detailNewsFeedVC: DetailNewsFeedVC?
    var comment: CommentBody?
    
    var postId: Int?
    
    var loginUser = false
    
    var likeCount: Int? = 5
    
    //MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Identify.ReplyTVCell)
        
        initCell()
        makeConstraints()
        
        setClickActionsInImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    
    func initCell () {
        
        _ = profileImageView.then {
            $0.layer.cornerRadius = 0.4 * profileImageView.frame.size.width
            $0.image = UIImage(named: "nutee_zigi_white")
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        _ = nicknameLabel.then {
            $0.text = "닉네임"
            $0.font = .systemFont(ofSize: 15)
            $0.sizeToFit()
        }
        _ = dateLabel.then {
            $0.text = "date"
            $0.font = .systemFont(ofSize: 11)
            $0.textColor = UIColor(red: 112, green: 112, blue: 112)
            $0.sizeToFit()
        }
        
        _ = moreButton.then {
            $0.contentHorizontalAlignment = .left
            $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            $0.contentHorizontalAlignment = .center
            $0.tintColor = UIColor(red: 134, green: 134, blue: 134)
            
            $0.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        }
        
        _ = replyTextView.then {
            $0.text = "대대대댇글대대대댇글대대대댇글대대대댇글대대대댇글"
            $0.textContainer.maximumNumberOfLines = 3
            $0.textContainer.lineBreakMode = .byTruncatingTail
            $0.font = .systemFont(ofSize: 14)
            $0.isUserInteractionEnabled = false
            $0.isScrollEnabled = false
            $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 기본 설정 값인 0이 좌우 여백이 있기 때문에 조정 필요
        }
        
        _ = likeButton.then {
            $0.contentHorizontalAlignment = .left
            
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            
            $0.tintColor = .systemPink
            
            $0.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
        }
        
        _ = likeLabel.then {
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = UIColor(red: 134, green: 134, blue: 134)
            $0.sizeToFit()
        }
        
    }
    
    func makeConstraints() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(moreButton)
        
        contentView.addSubview(replyTextView)
        
        contentView.addSubview(likeButton)
        contentView.addSubview(likeLabel)
        
        let TopAndBottomSpace = 10
        let leftAndRightSpace = 20
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(profileImageView.snp.width)
            
            $0.top.equalTo(contentView.snp.top).offset(TopAndBottomSpace)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(15)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(TopAndBottomSpace)
            $0.centerX.equalTo(profileImageView)
        }
        moreButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(12)
            
            $0.centerY.equalTo(profileImageView)
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
        }
        
        replyTextView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.left.equalTo(nicknameLabel.snp.left)
            $0.right.equalTo(moreButton.snp.left).inset(-10)
        }
        
        likeButton.snp.makeConstraints {
            $0.width.equalTo(17)
            $0.height.equalTo(14)
            
            $0.top.equalTo(replyTextView.snp.bottom).offset(15)
            $0.left.equalTo(replyTextView.snp.left)
            $0.bottom.equalTo(contentView.snp.bottom).inset(TopAndBottomSpace)
        }
        
        likeLabel.snp.makeConstraints {
            $0.left.equalTo(likeButton.snp.right).offset(5)
            $0.centerY.equalTo(likeButton)
        }
    }
    
    @objc func didTapMoreButton() {
        let nuteeAlertSheet = NuteeAlertSheet()
        
        if comment?.user?.id == KeychainWrapper.standard.integer(forKey: "id") {
            nuteeAlertSheet.optionList = [["수정", UIColor.black, "editComment"],
                                          ["삭제", UIColor.red, "deleteComment"]]
        } else {
            nuteeAlertSheet.optionList = [["🚨신고하기", UIColor.red, "reportPost"]]
        }
        
        nuteeAlertSheet.detailNewsFeedVC = self.detailNewsFeedVC
        nuteeAlertSheet.commentId = comment?.id
        nuteeAlertSheet.editCommentContent = comment?.content
        
        nuteeAlertSheet.modalPresentationStyle = .custom
        
        detailNewsFeedVC?.present(nuteeAlertSheet, animated: true)
    }
    
    func initComment() {
        // 사용자 프로필 설정
        profileImageView.setImageNutee(comment?.user?.image?.src)

        nicknameLabel.text = comment?.user?.nickname

        // 댓글 작성 시간 설정
        if comment?.createdAt == comment?.updatedAt {
            let originPostTime = comment?.createdAt ?? "1970-01-01T00:00:00.000Z" // 기본값 지정 안했을 경우 getDateFormat함수에서 nil값 에러 발생. 시간 임의 지정
            let postTimeDateFormat = originPostTime.getDateFormat(time: originPostTime)
            dateLabel.text = postTimeDateFormat?.timeAgoSince(postTimeDateFormat!)
        } else {
            let originPostTime = comment?.updatedAt ?? ""
            let postTimeDateFormat = originPostTime.getDateFormat(time: originPostTime)
            let updatePostTime = postTimeDateFormat?.timeAgoSince(postTimeDateFormat!)
            dateLabel.text = "수정 " + (updatePostTime ?? "")
        }

        replyTextView.text = comment?.content
        
        likeCount = comment?.likers?.count
        likeLabel.text = "좋아요 \(likeCount ?? 0)"

        for liker in comment?.likers ?? [] {
            if liker.id == KeychainWrapper.standard.integer(forKey: "id") {
                loginUser = true
            }
        }
        
        if loginUser {
            // 로그인 한 사용자가 좋아요를 누른 상태일 경우
            setSelectedLikeButton()
        } else {
            // 로그인 한 사용자가 좋아요를 누르지 않은 상태일 경우
            setNormalLikeButton()
        }
    }

    // 프로필 이미지에 탭 인식하게 만들기
    func setClickActionsInImage() {
        profileImageView.tag = 1
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer1.numberOfTapsRequired = 1
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer1)
    }

    // 프로필 이미지 클릭시 실행 함수
    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("profile image tapped")
        
        let imgView = tapGestureRecognizer.view as! UIImageView

        //Give your image View tag
        if (imgView.tag == 1) {
            showUserProfile()
        }
    }
    
    func showUserProfile() {
        // when user profile image clicked, it will show user info with bottom sheet
    }
    
    @objc func didTapLikeButton(_ sender: UIButton) {
        if likeButton.isSelected {
            likeCount! -= 1
            likeLabel.text = "좋아요 \(likeCount ?? 0)"
            setNormalLikeButton()

            commentUnlikeService(postId: postId ?? 0, commentId: comment?.id ?? 0)
        } else {
            likeCount! += 1
            likeLabel.text = "좋아요 \(likeCount ?? 0)"
            setSelectedLikeButton()

            commentLikeService(postId: postId ?? 0, commentId: comment?.id ?? 0)
        }
    }
    
    func setNormalLikeButton() {
        likeButton.isSelected = false
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func setSelectedLikeButton() {
        likeButton.isSelected = true
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }

}

// MARK: - Server connect

extension ReplyTVCell {
    
    // MARK: - Like
    func commentLikeService(postId: Int, commentId: Int) {
        ContentService.shared.commentLike(postId, commentId) { (responsedata) in

            switch responsedata {
            case .success(_):
                print("post like success")
                
            case .requestErr(let message):
                print("request error: \(message)")

            case .pathErr:
                print(".pathErr")

            case .serverErr:
                print(".serverErr")

            case .networkFail :
                print("failure")
            }
        }
    }

    func commentUnlikeService(postId: Int, commentId: Int) {
        ContentService.shared.commentUnlike(postId, commentId) { (responsedata) in

            switch responsedata {
            case .success(_):
                print("post unlike success")
                
            case .requestErr(let message):
                print("request error: \(message)")

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
