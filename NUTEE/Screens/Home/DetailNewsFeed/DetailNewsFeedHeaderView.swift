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
    
    // MARK: - UI components
    
    let testView = UIView()
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    
    let moreButton = UIButton()
    
    let contentTextView = UITextView()
    let contentImageView = UIImageView()
    
    let imageFrameView = UIView()
    let firstImageViewWhenOne = UIImageView()
    let oneMoreLabel = UILabel()
    
    let firstImageViewWhenThree = UIImageView()
    let secondImageViewWhenThree = UIImageView()
    let thirdImageViewWhenThree = UIImageView()

    let firstImageViewWhenFour = UIImageView()
    let secondImageViewWhenFour = UIImageView()
    let thirdImageViewWhenFour = UIImageView()
    let fourthImageViewWhenFour = UIImageView()
    let moreLabel = UILabel()
    
    let likeButton = UIButton()
    
    // MARK: - Variables and Properties
   
    var detailNewsFeedVC: DetailNewsFeedVC?
    
    let TopAndBottomSpace = 10
    let leftAndRightSpace = 15
        
    var imageFrameViewWidth: CGFloat = 0
    var imageFrameViewHeight: CGFloat = 300
   
    var post: PostContent?
    var likeCount: Int?
        
    //MARK: - Dummy data
    
    //var testImageList: [UIImage?] = [UIImage(named: "TestImage01"), UIImage(named: "TestImage02"), UIImage(named: "TestImage03")]
    var postImageList: [PostImage?] = []
    
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
    
    override func layoutSubviews() {
        imageFrameViewWidth = imageFrameView.frame.size.width
        
        firstImageViewWhenThree.snp.updateConstraints {
            $0.width.equalTo(imageFrameViewWidth / 2)
        }
        
        firstImageViewWhenFour.snp.updateConstraints {
            $0.width.equalTo(imageFrameViewWidth * (3/5))
        }
        
        thirdImageViewWhenFour.snp.updateConstraints {
            $0.width.equalTo(imageFrameViewWidth * (2/5))
        }
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
            $0.contentHorizontalAlignment = .center
            $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            $0.tintColor = UIColor(red: 134, green: 134, blue: 134)
            
            $0.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        }
        
        _ = contentTextView.then {
            $0.textAlignment = .justified
            $0.font = .systemFont(ofSize: 14)
            
            $0.isUserInteractionEnabled = false
            $0.isScrollEnabled = false
            
            $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 기본 설정 값이 좌우 여백이 있기 때문에 조정 필요
        }
        
        _ = firstImageViewWhenOne.then {
            setClickActions(imageView: $0)
            
            $0.isHidden = true
        }
        
        _ = firstImageViewWhenThree.then {
            setClickActions(imageView: $0)
            
            $0.isHidden = true
        }
        
        _ = secondImageViewWhenThree.then {
            setClickActions(imageView: $0)
            
            $0.isHidden = true
        }
        
        _ = thirdImageViewWhenThree.then {
            setClickActions(imageView: $0)
            
            $0.isHidden = true
        }
        
        _ = firstImageViewWhenFour.then {
            setClickActions(imageView: $0)
            
            $0.isHidden = true
        }
        
        _ = secondImageViewWhenFour.then {
            setClickActions(imageView: $0)
            
            $0.isHidden = true
        }
        
        _ = thirdImageViewWhenFour.then {
            setClickActions(imageView: $0)
            
            $0.isHidden = true
        }
        
        _ = fourthImageViewWhenFour.then {
            setClickActions(imageView: $0)
            
            $0.isHidden = true
        }
        
        _ = oneMoreLabel.then {
            $0.text = "+1"
            $0.font = .boldSystemFont(ofSize: 21)
            $0.textColor = .black
            
            $0.isHidden = true
        }
        
        _ = moreLabel.then {
            $0.text = "+N"
            $0.font = .boldSystemFont(ofSize: 21)
            $0.textColor = .black
            
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
            
            $0.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
        }
    }
    
    func makeConstraints() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)

        contentView.addSubview(moreButton)

        contentView.addSubview(contentTextView)
        contentView.addSubview(imageFrameView)
        
        imageFrameView.addSubview(firstImageViewWhenOne)
        firstImageViewWhenOne.addSubview(oneMoreLabel)

        imageFrameView.addSubview(firstImageViewWhenThree)
        imageFrameView.addSubview(secondImageViewWhenThree)
        imageFrameView.addSubview(thirdImageViewWhenThree)
        thirdImageViewWhenThree.addSubview(moreLabel)
        
        imageFrameView.addSubview(firstImageViewWhenFour)
        imageFrameView.addSubview(secondImageViewWhenFour)
        imageFrameView.addSubview(thirdImageViewWhenFour)
        imageFrameView.addSubview(fourthImageViewWhenFour)

        contentView.addSubview(likeButton)
        
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(profileImageView.snp.width).priority(999)
            
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
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace - 10)
        }

        contentTextView.snp.makeConstraints {
            let deviceHeight = UIScreen.main.bounds.height
            $0.height.equalTo(deviceHeight / 2).priority(999)
            
            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
            $0.left.equalTo(contentView).offset(leftAndRightSpace)
            $0.right.equalTo(contentView).inset(leftAndRightSpace)
        }
        
        imageFrameView.snp.makeConstraints{
            $0.height.equalTo(300).priority(999)

            $0.top.equalTo(contentTextView.snp.bottom).offset(15)
            $0.left.equalTo(contentView).offset(leftAndRightSpace)
            $0.right.equalTo(contentView).inset(leftAndRightSpace)
        }
        
        firstImageViewWhenOne.snp.makeConstraints {
            $0.top.equalTo(imageFrameView.snp.top)
            $0.left.equalTo(imageFrameView.snp.left)
            $0.right.equalTo(imageFrameView.snp.right)
            $0.bottom.equalTo(imageFrameView.snp.bottom)
        }
        
        oneMoreLabel.snp.makeConstraints {
            $0.centerX.equalTo(firstImageViewWhenOne)
            $0.centerY.equalTo(firstImageViewWhenOne)
        }
        
        firstImageViewWhenThree.snp.makeConstraints {
            $0.width.equalTo(0)

            $0.top.equalTo(imageFrameView.snp.top)
            $0.left.equalTo(imageFrameView.snp.left)
            $0.bottom.equalTo(imageFrameView.snp.bottom)
        }

        secondImageViewWhenThree.snp.makeConstraints {
            $0.height.equalTo(imageFrameViewHeight / 2).priority(999)
            
            $0.top.equalTo(imageFrameView.snp.top)
            $0.left.equalTo(firstImageViewWhenThree.snp.right)
            $0.right.equalTo(imageFrameView.snp.right)
        }
        
        thirdImageViewWhenThree.snp.makeConstraints {
            $0.top.equalTo(secondImageViewWhenThree.snp.bottom)
            $0.left.equalTo(firstImageViewWhenThree.snp.right)
            $0.right.equalTo(imageFrameView.snp.right)
            $0.bottom.equalTo(imageFrameView.snp.bottom)
        }
        
        moreLabel.snp.makeConstraints {
            $0.centerX.equalTo(thirdImageViewWhenThree)
            $0.centerY.equalTo(thirdImageViewWhenThree)
        }
        
        firstImageViewWhenFour.snp.makeConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(imageFrameViewHeight / 2).priority(999)

            $0.top.equalTo(imageFrameView.snp.top)
            $0.left.equalTo(imageFrameView.snp.left)
        }
        
        secondImageViewWhenFour.snp.makeConstraints {
            $0.height.equalTo(imageFrameViewHeight / 2).priority(999)
            
            $0.top.equalTo(imageFrameView.snp.top)
            $0.left.equalTo(firstImageViewWhenFour.snp.right)
            $0.right.equalTo(imageFrameView.snp.right)
        }
        
        thirdImageViewWhenFour.snp.makeConstraints {
            $0.width.equalTo(0)
            
            $0.top.equalTo(firstImageViewWhenFour.snp.bottom)
            $0.left.equalTo(imageFrameView.snp.left)
            $0.bottom.equalTo(imageFrameView.snp.bottom)
        }
        
        fourthImageViewWhenFour.snp.makeConstraints {
            $0.top.equalTo(secondImageViewWhenFour.snp.bottom)
            $0.left.equalTo(thirdImageViewWhenFour.snp.right)
            $0.right.equalTo(imageFrameView.snp.right)
            $0.bottom.equalTo(imageFrameView.snp.bottom)
        }

        likeButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(20)
            
            $0.top.equalTo(imageFrameView.snp.bottom).offset(10)
            $0.right.equalTo(contentView).inset(leftAndRightSpace)
            $0.bottom.equalTo(contentView).inset(TopAndBottomSpace)
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
        contentTextView.snp.updateConstraints {
            $0.height.equalTo(contentTextView.frame.size.height).priority(999)
        }
        
        // 게시글 이미지 설정
        setImageFrame(imageCnt: post?.body.images?.count ?? 0)
        postImageList = post?.body.images ?? []
        
        // Like 버튼
        likeCount = post?.body.likers?.count
        likeButton.setTitle(String(likeCount ?? 0), for: .normal)
    }
    
    func setImageFrame(imageCnt: Int) {
        switch imageCnt {
        case 0:
            imageFrameView.snp.remakeConstraints { (remakeView) in
                remakeView.height.equalTo(0)

                remakeView.top.equalTo(contentTextView.snp.bottom).offset(15)
                remakeView.left.equalTo(contentView).offset(10)
                remakeView.right.equalTo(contentView).inset(10)
            }
            break
        case 1:
            _ = firstImageViewWhenOne.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")
                
                $0.isHidden = false
            }
            break
        case 2:
            _ = firstImageViewWhenOne.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")
                
                $0.alpha = 0.7
                $0.isHidden = false
            }
            
            oneMoreLabel.isHidden = false
            break
        case 3:
            _ = firstImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")
                
                $0.isHidden = false
            }
            _ = secondImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[1].src ?? "", defaultImgPath: "")
                
                $0.isHidden = false
            }
            _ = thirdImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[2].src ?? "", defaultImgPath: "")
                
                $0.isHidden = false
            }
            break
        case 4:
            _ = firstImageViewWhenFour.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")
                
                $0.isHidden = false
            }
            _ = secondImageViewWhenFour.then {
                $0.imageFromUrl(post?.body.images?[1].src ?? "", defaultImgPath: "")
                
                $0.isHidden = false
            }
            _ = thirdImageViewWhenFour.then {
                $0.imageFromUrl(post?.body.images?[2].src ?? "", defaultImgPath: "")
                
                $0.isHidden = false
            }
            _ = fourthImageViewWhenFour.then {
                $0.imageFromUrl(post?.body.images?[3].src ?? "", defaultImgPath: "")
                
                $0.isHidden = false
            }
            break
        default:
            _ = firstImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")

                $0.isHidden = false
            }
            _ = secondImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[1].src ?? "", defaultImgPath: "")

                $0.isHidden = false
            }
            _ = thirdImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[2].src ?? "", defaultImgPath: "")

                $0.alpha = 0.7
                $0.isHidden = false
            }

            moreLabel.text = "+\(imageCnt - 3)"
            moreLabel.isHidden = false
        }
    }
    
    func setClickActions(imageView: UIImageView) {
        imageView.tag = 1
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer1.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer1)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imgView = tapGestureRecognizer.view as! UIImageView
//        print("your tapped image view tag is : \(imgView.tag)")

        //Give your image View tag
        if (imgView.tag == 1) {
            let nuteeImageViewer = NuteeImageViewer()
            nuteeImageViewer.imageList = postImageList
            
            nuteeImageViewer.modalPresentationStyle = .overFullScreen
            
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
