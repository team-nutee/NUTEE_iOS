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
    
    static let identifier = Identify.DetailNewsFeedHeaderView
    
    //MARK: - UI components
    
    let testView = UIView()
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    
    let moreButton = UIButton()
    
    let contentTextView = UITextView()
    let contentImageView = UIImageView()
    
    let likeButton = UIButton()
    
    // MARK: - Variables and Properties
   
    var detailNewsFeedVC: DetailNewsFeedVC?
   
    var post: PostContent?
    var likeCount: Int?
        
    //MARK: - Dummy data
    
    var testImageList: [UIImage?] = [UIImage(named: "TestImage01"), UIImage(named: "TestImage02"), UIImage(named: "TestImage03")]
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: Identify.DetailNewsFeedHeaderView)
        
        contentView.autoresizingMask = .flexibleHeight // console 창에 뜨는 headerView Height 경고 창을 방지하기 위한 코드. 가장 마지막 contraints가 적용되어서 height의 혼동(ambiguous)을 없앤다
        
        initHeaderView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            
            setClickActions()
        }
        
        _ = likeButton.then {
            $0.contentHorizontalAlignment = .left
            
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            
            $0.tintColor = .systemPink
            
            $0.setTitle("0", for: .normal)
            $0.setTitle("1", for: .selected)
            $0.setTitleColor(UIColor(red: 134, green: 134, blue: 134), for: .normal)
            $0.setTitleColor(.systemPink, for: .selected)
            
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
            $0.isSelected = true
        }
    }
    
    func makeConstraints() {
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
            
            $0.top.equalTo(contentView.snp.top).offset(TopAndBottomSpace)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
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
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
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
        nuteeAlertSheet.titleHeight = 0
        nuteeAlertSheet.optionList = [["수정", UIColor.black, "editPost"],
                                      ["삭제", UIColor.red, "deletePost"],
                                      ["🚨신고하기", UIColor.red, "reportPost"]]
        
        nuteeAlertSheet.modalPresentationStyle = .custom
        
        detailNewsFeedVC?.present(nuteeAlertSheet, animated: true)
    }
    
    @objc func didTapLikeButton(_ sender: UIButton) {
        if likeButton.isSelected {
            likeButton.isSelected = false
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeCount! -= 1
            likeButton.setTitle(String(likeCount ?? 0), for: .normal)
            likeButton.setTitleColor(UIColor(red: 134, green: 134, blue: 134), for: .normal)
            
            deleteLikeService(postId: post?.body.id ?? 0)
        } else {
            likeButton.isSelected = true
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            likeCount! += 1
            likeButton.setTitle(String(likeCount ?? 0), for: .normal)
            likeButton.setTitleColor(.systemPink, for: .selected)
            
            PostLikeService(postId: post?.body.id ?? 0)
        }
    }
    
    func initPosting() {
        // 사용자 프로필 이미지 설정
        if post?.body.user.image?.src != nil {
            profileImageView.setImageNutee(post?.body.user.image?.src)
        } else {
            profileImageView.image = UIImage(named: "nutee_zigi_white")
        }
        
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
        //showImageFrame(imageCount: post?.body.images?.count ?? 0)
        
        // Like 버튼
        likeCount = post?.body.likers?.count
        likeButton.setTitle(String(likeCount ?? 0), for: .normal)
    }
    
    func setClickActions() {
        contentImageView.tag = 1
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer1.numberOfTapsRequired = 1
        contentImageView.isUserInteractionEnabled = true
        contentImageView.addGestureRecognizer(tapGestureRecognizer1)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imgView = tapGestureRecognizer.view as! UIImageView
        print("your taped image view tag is : \(imgView.tag)")

        //Give your image View tag
        if (imgView.tag == 1) {
            let nuteeImageViewer = NuteeImageViewer()
            nuteeImageViewer.imageList = testImageList
            
            nuteeImageViewer.modalPresentationStyle = .fullScreen
            
            detailNewsFeedVC?.present(nuteeImageViewer, animated: true)
        }
    }
    
}

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
