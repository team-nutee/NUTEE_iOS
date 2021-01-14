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

class ReplyCell: UITableViewCell, UITextViewDelegate{
    
    static let identifier = Identify.ReplyCell
    
    //MARK: - UI components
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    
    let dateLabel = UILabel()
    let moreButton = UIButton()
    
    let replyTextView = UITextView()

    //MARK: - Variables and Properties

    // NewsFeedVC와 통신하기 위한 델리게이트 변수 선언
    var delegate: ReplyCellDelegate?
//    weak var RootVC: UIViewController?

    var comment: CommentBody?

    //MARK: - Life Cycle



    // MARK: - Variables and Properties
    
    var detailNewsFeedVC: UIViewController?
    
    //MARK: - Helper
    
    func initCell () {
        
        _ = profileImageView.then {
            $0.layer.cornerRadius = 0.5 * profileImageView.frame.size.width
            $0.image = UIImage(named: "nutee_zigi_white")
            $0.contentMode = .scaleAspectFit
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
            $0.text = "대대대댇글"
            $0.textContainer.maximumNumberOfLines = 3
            $0.textContainer.lineBreakMode = .byTruncatingTail
            $0.font = .systemFont(ofSize: 14)
            $0.isUserInteractionEnabled = false
            $0.isScrollEnabled = false
            $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 기본 설정 값인 0이 좌우 여백이 있기 때문에 조정 필요
        }
        
    }
    
    func addContentView() {
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(moreButton)
        
        contentView.addSubview(replyTextView)
        
        
        let TopAndBottomSpace = 10
        let leftAndRightSpace = 20
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(profileImageView.snp.width)
            $0.top.equalToSuperview().offset(TopAndBottomSpace)
            $0.left.equalToSuperview().offset(leftAndRightSpace)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(15)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel)
            $0.right.equalToSuperview().inset(leftAndRightSpace)
        }
        moreButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(12)
            $0.top.equalTo(replyTextView.snp.top)
            $0.right.equalToSuperview().inset(leftAndRightSpace)
        }
        
        replyTextView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.left.equalTo(nicknameLabel.snp.left)
            $0.right.equalTo(moreButton.snp.left).inset(-10)
            $0.bottom.equalToSuperview().inset(TopAndBottomSpace)
        }
        
    }
    
    @objc func didTapMoreButton() {
        let nuteeAlertSheet = NuteeAlertSheet()
        nuteeAlertSheet.optionList = [["수정", UIColor.black, "editPost"],
                                      ["삭제", UIColor.red, "deletePost"],
                                      ["🚨신고하기", UIColor.red, "reportPost"]]
        
        nuteeAlertSheet.modalPresentationStyle = .custom
        
        detailNewsFeedVC?.present(nuteeAlertSheet, animated: true)
    }
    
    func fillDataToView() {
        // 사용자 프로필 설정
        if comment?.user.image?.src != nil {
            profileImageView.setImageNutee(comment?.user.image?.src)
        } else {
            profileImageView.image = UIImage(named: "nutee_zigi_white")
        }

        nicknameLabel.text = comment?.user.nickname

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
    }

//    func showProfile() {
//        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
//
//        // 선택된 사용자 아이디를 넘거줌
//        vc?.userId = comment?.user.id  ?? KeychainWrapper.standard.integer(forKey: "id")
//
//        RootVC?.navigationController?.pushViewController(vc!, animated: true)
//    }
//
//    // 프로필 이미지에 탭 인식하게 만들기
//    func setClickActions() {
//        imgCommentUser.tag = 1
//        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        tapGestureRecognizer1.numberOfTapsRequired = 1
//        imgCommentUser.isUserInteractionEnabled = true
//        imgCommentUser.addGestureRecognizer(tapGestureRecognizer1)
//    }
//
//    // 프로필 이미지 클릭시 실행 함수
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        let imgView = tapGestureRecognizer.view as! UIImageView
//
//        //Give your image View tag
//        if (imgView.tag == 1) {
//            showProfile()
//        }
//    }
}

// MARK: - DetailNewsFeedVC와 통신하기 위한 프로토콜 정의

protocol ReplyCellDelegate: class {
    func updateReplyTV()
}
//
//extension ReplyCell : UITableViewDelegate { }
//
//// MARK: - 서버 연결 코드 구간
//
//extension ReplyCell {
//    // 뎃글 신고 <-- 확인 필요
//    func reportCommentService(reportReason: String) {
//        let userid = KeychainWrapper.standard.string(forKey: "id") ?? "" // <-- 수정 必
//        ContentService.shared.reportPost(userid, reportReason) { (responsedata) in // <-- 현재 작성된 API는 게시글(post)에 대한 신고기능
//
//            switch responsedata {
//            case .success(let res):
//
//                print(res)
//
//                let successfulAlert = UIAlertController(title: "신고가 완료되었습니다", message: nil, preferredStyle: UIAlertController.Style.alert)
//                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//
//                successfulAlert.addAction(okAction)
//
//                self.RootVC?.present(successfulAlert, animated: true, completion: nil)
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
//                }
//        }
//    }
//
//    // 댓글 삭제
//    func deleteCommentService(postId: Int, commentId: Int, completionHandler: @escaping () -> Void ) {
//        ContentService.shared.commentDelete(postId, commentId: commentId) { (responsedata) in
//
//            switch responsedata {
//            case .success(let res):
//
//                print("commentDelete succussful", res)
//                completionHandler()
//
//            case .requestErr(_):
//                let errorAlert = UIAlertController(title: "오류발생😵", message: "오류가 발생하여 댓글을 삭제하지 못했습니다", preferredStyle: UIAlertController.Style.alert)
//                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//
//                errorAlert.addAction(okAction)
//
//                self.RootVC?.present(errorAlert, animated: true, completion: nil)
//
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
//                }
//        }
//    }
//}
