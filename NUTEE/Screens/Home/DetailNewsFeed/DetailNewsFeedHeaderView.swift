//
//  DetailNewsFeedHeaderView.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/24.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

import SwiftKeychainWrapper

class DetailNewsFeedHeaderView: UITableViewHeaderFooterView, UITextViewDelegate {
    
    static let identifier = Identify.DetailNewsFeedHeaderView
    
    //MARK: - UI components
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    
    let moreButton = UIButton()
    
    let contentTextView = UITextView()
    let imageWrapperView = UIView()
    
    // 이미지 하나일 때
    let imageViewWhenOne = UIImageView()
    
    // 이미지 세 개일 때
    let firstImageViewWhenThree = UIImageView()
    let secondImageViewWhenThree = UIImageView()
    let thirdImageViewWhenThree = UIImageView()
    
    // 이미지 네 개일 때
    let firstImageViewWhenFour = UIImageView()
    let secondImageViewWhenFour = UIImageView()
    let thirdImageViewWhenFour = UIImageView()
    let fourthImageViewWhenFour = UIImageView()
    
    // 이미지 더보기 Label
    var imageViewOneMoreLabel = UILabel()
    var imageViewMoreLabel = UILabel()
    
    let likeButton = UIButton()
    
    // MARK: - Variables and Properties
   
    var detailNewsFeedVC: UIViewController?
    
    var post: PostContent?
    var likeCount: Int?
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        setImageView()
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
        
        _ = imageViewWhenOne.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
            
            //$0.isHidden = true
        }
        
        _ = firstImageViewWhenThree.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
            
            $0.isHidden = true
        }
        
        _ = secondImageViewWhenThree.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
            
            $0.isHidden = true
        }
        
        _ = thirdImageViewWhenThree.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
            
            $0.isHidden = true
        }
        
        _ = firstImageViewWhenFour.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
            
            $0.isHidden = true
        }
        
        _ = secondImageViewWhenFour.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
            
            $0.isHidden = true
        }
        
        _ = thirdImageViewWhenFour.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
            
            $0.isHidden = true
        }
        
        _ = fourthImageViewWhenFour.then {
            $0.imageFromUrl("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png", defaultImgPath: "")
            
            $0.isHidden = true
        }
        
        _ = imageViewOneMoreLabel.then {
            $0.text = "+1"
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 21)
            
            $0.isHidden = true
        }
        
        _ = imageViewMoreLabel.then {
            $0.text = "+N"
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 21)
            
            $0.isHidden = true
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
            
            //$0.isSelected = true
            $0.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        }
    }
    
    func addContentView() {
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(moreButton)
        
        contentView.addSubview(contentTextView)
        contentView.addSubview(imageWrapperView)
        
        imageWrapperView.addSubview(imageViewWhenOne)
        imageViewWhenOne.addSubview(imageViewOneMoreLabel)
        
        imageWrapperView.addSubview(firstImageViewWhenThree)
        imageWrapperView.addSubview(secondImageViewWhenThree)
        imageWrapperView.addSubview(thirdImageViewWhenThree)
        thirdImageViewWhenThree.addSubview(imageViewMoreLabel)
        
        imageWrapperView.addSubview(firstImageViewWhenFour)
        imageWrapperView.addSubview(secondImageViewWhenFour)
        imageWrapperView.addSubview(thirdImageViewWhenFour)
        imageWrapperView.addSubview(fourthImageViewWhenFour)
        
        contentView.addSubview(likeButton)

        let TopAndBottomSpace = 10
        let leftAndRightSpace = 15
        
//        profileImageView.snp.makeConstraints {
//            $0.width.equalTo(50)
//            $0.height.equalTo(profileImageView.snp.width)
//            $0.top.equalTo(contentView.snp.top).offset(TopAndBottomSpace)
//            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
//        }
//        nicknameLabel.snp.makeConstraints {
//            $0.top.equalTo(profileImageView.snp.top)
//            $0.left.equalTo(profileImageView.snp.right).offset(15)
//        }
//        dateLabel.snp.makeConstraints {
//            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
//            $0.left.equalTo(nicknameLabel.snp.left)
//        }
//
//        moreButton.snp.makeConstraints {
//            $0.width.equalTo(40)
//            $0.height.equalTo(40)
//            $0.centerY.equalTo(profileImageView)
//            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
//        }
//
//        contentTextView.snp.makeConstraints {
//            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
//            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
//            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
//        }
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
        
//        imageWrapperView.snp.makeConstraints{
//            $0.height.equalTo(234)
//
//            $0.top.equalTo(contentTextView.snp.bottom).offset(15)
//            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
//            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
//        }
//
//        imageViewWhenOne.snp.makeConstraints{
//            $0.top.equalTo(imageWrapperView.snp.top)
//            $0.left.equalTo(imageWrapperView.snp.left)
//            $0.right.equalTo(imageWrapperView.snp.right)
//            $0.bottom.equalTo(imageWrapperView.snp.bottom)
//        }
//
//        imageViewOneMoreLabel.snp.makeConstraints{
//            $0.centerX.equalTo(imageViewWhenOne)
//            $0.centerY.equalTo(imageViewWhenOne)
//        }
//
//        firstImageViewWhenThree.snp.makeConstraints{
//            $0.width.equalTo(175)
//
//            $0.top.equalTo(imageWrapperView.snp.top)
//            $0.left.equalTo(imageWrapperView.snp.left)
//            $0.bottom.equalTo(imageWrapperView.snp.bottom)
//        }
//
//        secondImageViewWhenThree.snp.makeConstraints{
//            $0.height.equalTo(117)
//
//            $0.top.equalTo(imageWrapperView.snp.top)
//            $0.left.equalTo(firstImageViewWhenThree.snp.right)
//            $0.right.equalTo(imageWrapperView.snp.right)
//        }
//
//        thirdImageViewWhenThree.snp.makeConstraints{
//            $0.top.equalTo(secondImageViewWhenThree.snp.bottom)
//            $0.left.equalTo(firstImageViewWhenThree.snp.right)
//            $0.right.equalTo(imageWrapperView.snp.right)
//            $0.bottom.equalTo(imageWrapperView.snp.bottom)
//        }
//
//        imageViewMoreLabel.snp.makeConstraints{
//            $0.centerX.equalTo(thirdImageViewWhenThree)
//            $0.centerY.equalTo(thirdImageViewWhenThree)
//        }
//
//        firstImageViewWhenFour.snp.makeConstraints{
//            $0.height.equalTo(117)
//            $0.width.equalTo(206)
//
//            $0.top.equalTo(imageWrapperView.snp.top)
//            $0.left.equalTo(imageWrapperView.snp.left)
//        }
//
//        secondImageViewWhenFour.snp.makeConstraints{
//            $0.height.equalTo(117)
//
//            $0.top.equalTo(imageWrapperView.snp.top)
//            $0.left.equalTo(firstImageViewWhenFour.snp.right)
//            $0.right.equalTo(imageWrapperView.snp.right)
//        }
//
//        thirdImageViewWhenFour.snp.makeConstraints{
//            $0.width.equalTo(140)
//
//            $0.top.equalTo(firstImageViewWhenFour.snp.bottom)
//            $0.left.equalTo(imageWrapperView.snp.left)
//            $0.bottom.equalTo(imageWrapperView.snp.bottom)
//        }
//
//        fourthImageViewWhenFour.snp.makeConstraints{
//            $0.top.equalTo(secondImageViewWhenFour.snp.bottom)
//            $0.left.equalTo(thirdImageViewWhenFour.snp.right)
//            $0.right.equalTo(imageWrapperView.snp.right)
//            $0.bottom.equalTo(imageWrapperView.snp.bottom)
//        }
        
        likeButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(20)
            $0.top.equalTo(contentTextView.snp.bottom).offset(10)
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
            $0.bottom.equalTo(contentView.snp.bottom).inset(TopAndBottomSpace)
        }
        
    }
    
//    func setImageView(){
//        oneImageView.isUserInteractionEnabled = true
//        oneImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage(tapGestureRecognizer:))))
//
//        for imageView in threeImageViews {
//            imageView.isUserInteractionEnabled = true
//            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage(tapGestureRecognizer:))))
//
//        }
//        for imageView in fourImageViews {
//            imageView.isUserInteractionEnabled = true
//            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage(tapGestureRecognizer:))))
//
//        }
//    }
    
    @objc func didTapImage(tapGestureRecognizer: UITapGestureRecognizer){
//        let vc =
//            UIStoryboard.init(name: "PopUp",
//                              bundle: Bundle.main).instantiateViewController(
//                                withIdentifier: "PictureVC") as? PictureVC
//        vc?.modalPresentationStyle = .overFullScreen
//        vc?.imageArr = self.post?.body.images
//
//        self.RootVC?.present(vc!, animated: false)
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
        showImageFrame(imageCount: post?.body.images?.count ?? 0)
        
        // Like 버튼
        likeCount = post?.body.likers?.count
        likeButton.setTitle(String(likeCount ?? 0), for: .normal)
    }

    // 사진 개수에 따른 이미지 표시 유형 선택
    func showImageFrame(imageCount: Int) {
        var imageNum: Int? = imageCount
        
        switch imageCount {
        case 0:
            imageWrapperView.snp.makeConstraints{
                $0.height.equalTo(0)
            }
            break
        case 1:
            imageViewWhenOne.isHidden = false
            break
        case 2:
            imageViewWhenOne.isHidden = false
            imageViewWhenOne.alpha = 0.7
            imageViewOneMoreLabel.isHidden = false
            break
        case 3:
            firstImageViewWhenThree.isHidden = false
            secondImageViewWhenThree.isHidden = false
            thirdImageViewWhenThree.isHidden = false
            break
        case 4:
            firstImageViewWhenFour.isHidden = false
            secondImageViewWhenFour.isHidden = false
            thirdImageViewWhenFour.isHidden = false
            fourthImageViewWhenFour.isHidden = false
            break
        default:
            firstImageViewWhenThree.isHidden = false
            secondImageViewWhenThree.isHidden = false
            thirdImageViewWhenThree.isHidden = false
            thirdImageViewWhenThree.alpha = 0.7
            imageViewMoreLabel.isHidden = false
            imageNum = imageCount - 3
            imageViewMoreLabel.text = "+\(imageNum ?? 0)"
        }
        
    }
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
