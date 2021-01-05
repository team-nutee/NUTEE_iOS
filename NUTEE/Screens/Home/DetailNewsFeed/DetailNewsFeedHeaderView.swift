//
//  DetailNewsFeedHeaderView.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/24.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SafariServices

import SwiftKeychainWrapper

class DetailNewsFeedHeaderView: UITableViewHeaderFooterView, UITextViewDelegate {
    
    //MARK: - UI components
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    
    let moreButton = UIButton()
    
    let contentTextView = UITextView()
    let contentImageView = UIImageView()
    
    let likeButton = UIButton()
    
    // MARK: - Variables and Properties
   
    var detailNewsFeedVC: UIViewController?
    
    var post: PostContent?
    var numLike: Int?

    //MARK: - Helper
    
    func initHeaderView () {

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
            $0.text = "시간"
            $0.font = .systemFont(ofSize: 11)
            $0.textColor = UIColor(red: 112, green: 112, blue: 112)
            $0.sizeToFit()
        }
        
        _ = moreButton.then {
            $0.contentHorizontalAlignment = .left
            $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            $0.tintColor = UIColor(red: 134, green: 134, blue: 134)
            
            $0.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        }
        
        _ = contentTextView.then {
            $0.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            $0.textAlignment = .justified
            $0.font = .systemFont(ofSize: 14)
            $0.isUserInteractionEnabled = false
            $0.isScrollEnabled = false
            $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 기본 설정 값인 0이 좌우 여백이 있기 때문에 조정 필요
        }
        _ = contentImageView.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
        }
        
        _ = likeButton.then {
            $0.contentHorizontalAlignment = .left

            $0.tintColor = .systemPink
            $0.setTitleColor(UIColor(red: 134, green: 134, blue: 134), for: .normal)
            
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
            $0.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        }
    }
    
    func addContentView() {
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(moreButton)
        
        contentView.addSubview(contentTextView)
        contentView.addSubview(contentImageView)

        contentView.addSubview(likeButton)

        
        let TopAndBottomSpace = 10
        let leftAndRightSpace = 15
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(profileImageView.snp.width)
            $0.top.equalToSuperview().offset(TopAndBottomSpace)
            $0.left.equalToSuperview().offset(leftAndRightSpace)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(15)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.left.equalTo(nicknameLabel.snp.left)
        }
        
        moreButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.centerY.equalTo(profileImageView)
            $0.right.equalToSuperview().inset(leftAndRightSpace)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(leftAndRightSpace)
            $0.right.equalToSuperview().inset(leftAndRightSpace)
        }
        contentImageView.snp.makeConstraints{
            $0.height.equalTo(300)
            $0.top.equalTo(contentTextView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(leftAndRightSpace)
            $0.right.equalToSuperview().inset(leftAndRightSpace)
        }

        likeButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(20)
            $0.top.equalTo(contentImageView.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(leftAndRightSpace)
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
    
    @objc func didTapLikeButton(_ sender: UIButton) {
        if !likeButton.isSelected {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            numLike! -= 1
            likeButton.setTitle(String(numLike ?? 0), for: .normal)
            likeButton.setTitleColor(UIColor(red: 134, green: 134, blue: 134), for: .normal)
            
            deleteLikeService(postId: post?.body.id ?? 0)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            numLike! += 1
            likeButton.setTitle(String(numLike ?? 0), for: .normal)
            likeButton.setTitle("1", for: .selected)
            likeButton.setTitleColor(.systemPink, for: .selected)
            
            PostLikeService(postId: post?.body.id ?? 0)
        }
    }
    
    func initPosting() {
        
        // 사용자 프로필 이미지 설정
        profileImageView.setImageNutee(post?.body.user.image?.src)
        
        // 사용자 이름 설정
        nicknameLabel.text = post?.body.user.nickname
        
        // 게시글 게시 시간 설정
        let originPostTime = post?.body.createdAt
        let postTimeDateFormat = originPostTime?.getDateFormat(time: originPostTime!)
        dateLabel.text = postTimeDateFormat?.timeAgoSince(postTimeDateFormat!)
        
        // Posting 내용 설정
        contentTextView.text = post?.body.content
        contentTextView.postingInit()
        
        // 게시글 이미지 설정
        //showImgFrame()
        
        // Like 버튼
        numLike = post?.body.likers?.count
        likeButton.setTitle(String(numLike ?? 0), for: .normal)
    }

//    // 사진 개수에 따른 이미지 표시 유형 선택
//    func showImgFrame() {
//        moreLabel1.isHidden = true
//        moreLabel4.isHidden = true
//
//        var num = 0
//        switch post?.body.images?.count {
//        case 0:
//            // 보여줄 사진이 없는 경우(글만 표시)
//            imageWrapperViewHeight.constant = 0
//
//            break
//        case 1:
//            // ver. only OneImage
//            oneImageView.imageFromUrl((APIConstants.BaseURL) + "/" + (detailNewsPost?.images[0].src ?? ""), defaultImgPath: (APIConstants.BaseURL) + "/settings/nutee_profile.png")
//            break
//        case 2:
//            oneImageView.imageFromUrl((APIConstants.BaseURL) + "/" + (detailNewsPost?.images[0].src ?? ""), defaultImgPath: (APIConstants.BaseURL) + "/settings/nutee_profile.png")
//            moreLabel1.isHidden = false
//            oneImageView.alpha = 0.7
//            moreLabel1.text = "+1"
//            moreLabel1.textColor = .black
//
//            break
//        case 3:
//            for imgvw in threeImageViewArr {
//                imgvw.imageFromUrl((APIConstants.BaseURL) + "/" + (detailNewsPost?.images[num].src ?? ""), defaultImgPath: (APIConstants.BaseURL) + "/settings/nutee_profile.png")
//                num += 1
//            }
//            break
//        default:
//            // ver. FourFrame
//            for imgvw in fourImageViewArr {
//                if num <= 3 {
//                    imgvw.imageFromUrl((APIConstants.BaseURL) + "/" + (detailNewsPost?.images[num].src ?? ""), defaultImgPath: (APIConstants.BaseURL) + "/settings/nutee_profile.png")
//                }
//
//                if num == 3 {
//                    let leftImg = (imageCnt ?? 3) - 4
//                    if leftImg > 0 {
//                        imgvw.alpha = 0.7
//                        moreLabel4.isHidden = false
//                        moreLabel4.text = "+" + String(leftImg)
//                        moreLabel4.textColor = .black
//                    }
//                }
//                num += 1
//            }
//        } // End of case statement
//    } // Finish ShowImageFrame

//    // 프로필 이미지에 탭 인식하게 만들기
//    func setClickActions() {
//        userIMG.tag = 1
//        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        tapGestureRecognizer1.numberOfTapsRequired = 1
//        userIMG.isUserInteractionEnabled = true
//        userIMG.addGestureRecognizer(tapGestureRecognizer1)
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
//
//    func setImageView(){
//        oneImageView.isUserInteractionEnabled = true
//        oneImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(tapGestureRecognizer:))))
//
//
//        for imageView in threeImageViewArr {
//            imageView.isUserInteractionEnabled = true
//            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(tapGestureRecognizer:))))
//
//        }
//        for imageView in fourImageViewArr {
//            imageView.isUserInteractionEnabled = true
//            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(tapGestureRecognizer:))))
//
//        }
//    }
//
//    @objc func imageTap(tapGestureRecognizer: UITapGestureRecognizer){
//        let vc =
//            UIStoryboard.init(name: "PopUp",
//                                   bundle: Bundle.main).instantiateViewController(
//                                    withIdentifier: "PictureVC") as? PictureVC
//        vc?.modalPresentationStyle = .overFullScreen
//        vc?.imageArr = self.detailNewsPost?.images
//
//        self.RootVC?.present(vc!, animated: false)
//    }
//
//
//    func showProfile() {
//        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
//
//        // 해당 글이 공유글인지 아닌지 판단
//        if detailNewsPost?.retweet == nil {
//            vc?.userId = detailNewsPost?.user.id ?? KeychainWrapper.standard.integer(forKey: "id")
//        } else {
//            vc?.userId = detailNewsPost?.retweet?.user.id ?? KeychainWrapper.standard.integer(forKey: "id")
//        }
//
//        RootVC?.navigationController?.pushViewController(vc!, animated: true)
//    }
//
//    func setButtonAttributed(btn: UIButton, num: Int, color: UIColor, state: UIControl.State) {
//        let stateAttributes = [NSAttributedString.Key.foregroundColor: color]
//        btn.setAttributedTitle(NSAttributedString(string: " " + String(num), attributes: stateAttributes), for: state)
//        btn.tintColor = color
//    }
//
//    func deletePost() {
//        self.postDeleteService(postId: self.detailNewsPost?.id ?? 0, completionHandler: {() -> Void in
//            // delegate로 NewsFeedVC와 통신하기
//            self.delegate?.backToUpdateNewsTV()
//        })
//    }
}

// MARK: - NewsFeedVC와 통신하기 위한 프로토콜 정의

protocol DetailHeaderViewDelegate: class {
    func backToUpdateNewsTV() // NewsFeedVC에 정의되어 있는 프로토콜 함수
}
//
//extension DetailHeaderView : UITableViewDelegate { }
//
// MARK: - Server connect

extension DetailNewsFeedHeaderView {

    // MARK: - Like

    func PostLikeService(postId: Int) {
        ContentService.shared.postLike(postId) { (responsedata) in

            switch responsedata {
            case .success(let res):
                print("post like success", res)
                
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

    func deleteLikeService(postId: Int) {
        ContentService.shared.deleteLike(postId) { (responsedata) in

            switch responsedata {
            case .success(let res):
                print("post like delete success", res)
                
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
    
    // MARK: - Delete post
    
    func postDeleteService(postId: Int, completionHandler: @escaping () -> Void) {
        ContentService.shared.deletePost(postId) { (responsedata) in

            switch responsedata {
            case .success(let res):
                print("post delete succuss", res)
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
    
    func reportPost(postId: Int, content: String) {
        ContentService.shared.reportPost(postId, content) { (responsedata) in

            switch responsedata {
            case .success(let res):
                print("post report success", res)
//                let successfulAlert = UIAlertController(title: "신고가 완료되었습니다", message: nil, preferredStyle: UIAlertController.Style.alert)
//                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//
//                successfulAlert.addAction(okAction)
//
//                self.RootVC?.present(successfulAlert, animated: true, completion: nil)


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
