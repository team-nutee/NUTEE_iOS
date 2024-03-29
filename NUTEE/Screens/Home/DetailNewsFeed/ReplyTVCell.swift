//
//  DetailNewsFeedTVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/24.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit
import SafariServices
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

    var indextPathRow: Int?
    
    var detailNewsFeedVC: DetailNewsFeedVC?
    var comment: CommentBody?
    
    var postId: Int?
        
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
            $0.textContainer.lineBreakMode = .byTruncatingTail
            $0.font = .systemFont(ofSize: 14)
            
            $0.isUserInteractionEnabled = true
            $0.isEditable = false
            $0.dataDetectorTypes = .link
            $0.isScrollEnabled = false
            
            $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 기본 설정 값인 0이 좌우 여백이 있기 때문에 조정 필요
            
            $0.delegate = self
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
            $0.left.equalTo(profileImageView.snp.right).offset(leftAndRightSpace)
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
        showNuteeAlertSheet()
    }
    
    func fillDataToView() {
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
        
        var loginUser = false

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

            commentUnlikeService(postId: postId ?? 0, commentId: comment?.id ?? 0, completionHandler: {
                self.detailNewsFeedVC?.getPostService(postId: self.postId ?? 0, completionHandler: { (PostContent) in
                    self.detailNewsFeedVC?.post = PostContent
                })
            })
        } else {
            likeCount! += 1
            likeLabel.text = "좋아요 \(likeCount ?? 0)"
            setSelectedLikeButton()

            commentLikeService(postId: postId ?? 0, commentId: comment?.id ?? 0, completionHandler: {
                self.detailNewsFeedVC?.getPostService(postId: self.postId ?? 0, completionHandler: { (PostContent) in
                    self.detailNewsFeedVC?.post = PostContent
                })
            })
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
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        // 링크 연결 코드
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .nuteeGreen
        
        self.detailNewsFeedVC?.present(safariViewController, animated: true, completion: nil)
        
        return false
    }
}

// MARK: - NuteeAlert Action Definition

extension ReplyTVCell: NuteeAlertActionDelegate {
    
    @objc func showNuteeAlertSheet() {
        let nuteeAlertSheet = NuteeAlertSheet()
        nuteeAlertSheet.nuteeAlertActionDelegate = self
        
        if comment?.user?.id == KeychainWrapper.standard.integer(forKey: "id") {
            nuteeAlertSheet.optionList = [["답글 작성하기", UIColor.black],
                                          ["수정", UIColor.black],
                                          ["삭제", UIColor.red]]
            
        } else {
            nuteeAlertSheet.optionList = [["답글 작성하기", UIColor.black],
                                          ["🚨신고하기", UIColor.red]]
        }
        
        nuteeAlertSheet.modalPresentationStyle = .custom
        
        detailNewsFeedVC?.present(nuteeAlertSheet, animated: true)
    }
    
    @objc func nuteeAlertSheetAction(indexPath: Int) {
        detailNewsFeedVC?.dismiss(animated: true, completion: nil)
        
        if comment?.user?.id == KeychainWrapper.standard.integer(forKey: "id") {
            switch indexPath {
            case 0:
                createRecomment()
            case 1:
                editComment()
            case 2:
                deleteComment()
            default:
                break
            }
            
        } else {
            switch indexPath {
            case 0:
                createRecomment()
            case 1:
                reportComment()
            default:
                break
            }
        }
    }
    
    func editComment() {
        detailNewsFeedVC?.setEditCommentMode(editCommentId: comment?.id ?? 0, content: comment?.content ?? "", currentCellRow: indextPathRow)
    }
    
    func reportComment() {
        let nuteeReportDialogue = NuteeReportDialogue()
        nuteeReportDialogue.nuteeAlertActionDelegate = self
        
        nuteeReportDialogue.dialogueData = ["댓글 신고하기", "신고 사유를 입력해주세요."]
        nuteeReportDialogue.okButtonData = ["신고", UIColor.white, UIColor.red]
        
        nuteeReportDialogue.modalPresentationStyle = .overCurrentContext
        nuteeReportDialogue.modalTransitionStyle = .crossDissolve
        
        detailNewsFeedVC?.tabBarController?.present(nuteeReportDialogue, animated: true)
    }
    
    func deleteComment() {
        let nuteeAlertDialogue = NuteeAlertDialogue()
        nuteeAlertDialogue.dialogueData = ["댓글 삭제", "해당 댓글을 삭제하시겠습니까?"]
        nuteeAlertDialogue.okButtonData = ["삭제", UIColor.white, UIColor.red]
        nuteeAlertDialogue.okButton.addTarget(self, action: #selector(didTapDeleteComment), for: .touchUpInside)
        
        nuteeAlertDialogue.modalPresentationStyle = .overCurrentContext
        nuteeAlertDialogue.modalTransitionStyle = .crossDissolve
        
        detailNewsFeedVC?.tabBarController?.present(nuteeAlertDialogue, animated: true)
    }
    
    @objc func didTapDeleteComment() {
        detailNewsFeedVC?.deleteComment(deleteCommentId: comment?.id ?? 0)
    }
    
    func createRecomment() {
        detailNewsFeedVC?.commentTextView.text = ""
        detailNewsFeedVC?.isEditCommentMode = false
        detailNewsFeedVC?.switchRecommentMode(recommentMode: true, currentCellRow: indextPathRow)
        detailNewsFeedVC?.commentId = comment?.id
    }
    
    func nuteeAlertDialogueAction(text: String) {
        reportCommentService(postId: postId ?? 0, commentId: comment?.id ?? 0, content: text, completionHandler: { [self] in
            detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "신고완료", message: "해당 댓글이 신고되었습니다")
        })
    }
}

// MARK: - Server connect

extension ReplyTVCell {
    
    // MARK: - Like
    func commentLikeService(postId: Int, commentId: Int, completionHandler: @escaping () -> Void ) {
        ContentService.shared.commentLike(postId, commentId) { (responsedata) in

            switch responsedata {
            case .success(_):
                completionHandler()
                
            case .requestErr(let message):
                self.detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 좋아요 실패", message: "\(message)")
                print("request error")
                
            case .pathErr:
                self.detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 좋아요 실패", message: "서버 연결에 오류가 있습니다")
                print(".pathErr")
                
            case .serverErr:
                self.detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 좋아요 실패", message: "서버에 오류가 있습니다")
                print(".serverErr")
                
            case .networkFail :
                self.detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 좋아요 실패", message: "네트워크에 오류가 있습니다")
                print("failure")
            }
        }
    }

    func commentUnlikeService(postId: Int, commentId: Int, completionHandler: @escaping () -> Void ) {
        ContentService.shared.commentUnlike(postId, commentId) { (responsedata) in

            switch responsedata {
            case .success(_):
                completionHandler()
                
            case .requestErr(let message):
                self.detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 좋아요 취소 실패", message: "\(message)")
                print("request error")
                
            case .pathErr:
                self.detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 좋아요 취소 실패", message: "서버 연결에 오류가 있습니다")
                print(".pathErr")
                
            case .serverErr:
                self.detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 좋아요 취소 실패", message: "서버에 오류가 있습니다")
                print(".serverErr")
                
            case .networkFail :
                self.detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 좋아요 취소 실패", message: "네트워크에 오류가 있습니다")
                print("failure")
            }
        }
    }
    
    func reportCommentService(postId: Int, commentId: Int, content: String, completionHandler: @escaping () -> Void) {
        ContentService.shared.reportComment(postId, commentId, content) { [self] (responsedata) in

            switch responsedata {
            case .success(_):
                detailNewsFeedVC?.dismiss(animated: true)
                completionHandler()

            case .requestErr(let message):
                detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 신고 실패", message: "\(message)")
                print("request error")
                
            case .pathErr:
                detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 신고 실패", message: "서버 연결에 오류가 있습니다")
                print(".pathErr")
                
            case .serverErr:
                detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 신고 실패", message: "서버에 오류가 있습니다")
                print(".serverErr")
                
            case .networkFail :
                detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "댓글 신고 실패", message: "네트워크에 오류가 있습니다")
                print("failure")
            }
        }
    }
}
