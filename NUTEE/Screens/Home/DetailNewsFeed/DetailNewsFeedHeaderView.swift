//
//  DetailNewsFeedHeaderView.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/24.
//  Copyright © 2020 Nutee. All rights reserved.
//
import UIKit

import SwiftKeychainWrapper

import SafariServices

class DetailNewsFeedHeaderView: UITableViewHeaderFooterView, UITextViewDelegate {
    
    static let identifier = Identify.DetailNewsFeedHeaderView
    
    // MARK: - UI components
    
    let testView = UIView()
    
    let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    
    let moreButton = UIButton()
    
    let contentTextView = HashtagTextView()
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
        super.layoutSubviews()
        
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
            $0.clipsToBounds = true
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
            
            $0.isUserInteractionEnabled = true
            $0.isScrollEnabled = false
            $0.isEditable = false
            $0.dataDetectorTypes = .link
            
            $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 기본 설정 값이 좌우 여백이 있기 때문에 조정 필요
            
            $0.delegate = self
        }
        
        _ = firstImageViewWhenOne.then {
            setClickActions(imageView: $0, tag: 0)
            
            $0.isHidden = true
        }
        
        _ = firstImageViewWhenThree.then {
            setClickActions(imageView: $0, tag: 0)
            
            $0.isHidden = true
        }
        
        _ = secondImageViewWhenThree.then {
            setClickActions(imageView: $0, tag: 1)
            
            $0.isHidden = true
        }
        
        _ = thirdImageViewWhenThree.then {
            setClickActions(imageView: $0, tag: 2)
            
            $0.isHidden = true
        }
        
        _ = firstImageViewWhenFour.then {
            setClickActions(imageView: $0, tag: 0)
            
            $0.isHidden = true
        }
        
        _ = secondImageViewWhenFour.then {
            setClickActions(imageView: $0, tag: 1)
            
            $0.isHidden = true
        }
        
        _ = thirdImageViewWhenFour.then {
            setClickActions(imageView: $0, tag: 2)
            
            $0.isHidden = true
        }
        
        _ = fourthImageViewWhenFour.then {
            setClickActions(imageView: $0, tag: 3)
            
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
        imageFrameView.addSubview(oneMoreLabel)

        imageFrameView.addSubview(firstImageViewWhenThree)
        imageFrameView.addSubview(secondImageViewWhenThree)
        imageFrameView.addSubview(thirdImageViewWhenThree)
        imageFrameView.addSubview(moreLabel)
        
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
//            let deviceHeight = UIScreen.main.bounds.height
//            $0.height.equalTo(deviceHeight / 2).priority(999)
            $0.height.greaterThanOrEqualTo(0).priority(999)
            
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
        showNuteeAlertSheet()
    }
    
    @objc func didTapLikeButton(_ sender: UIButton) {
        if likeButton.isSelected {
            likeCount! -= 1
            likeButton.setTitle(String(likeCount ?? 0), for: .normal)
            setNormalLikeButton()

            postUnlikeService(postId: post?.body.id ?? 0, completionHandler: { (PostContent) -> Void in
                self.detailNewsFeedVC?.post = PostContent
            })
        } else {
            likeCount! += 1
            likeButton.setTitle(String(likeCount ?? 0), for: .normal)
            setSelectedLikeButton()

            postLikeService(postId: post?.body.id ?? 0, completionHandler: { (PostContent) -> Void in
                self.detailNewsFeedVC?.post = PostContent
            })
        }
    }
    
    func setNormalLikeButton() {
        likeButton.isSelected = false
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setTitleColor(UIColor(red: 134, green: 134, blue: 134), for: .normal)
    }
    
    func setSelectedLikeButton() {
        likeButton.isSelected = true
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.setTitleColor(.systemPink, for: .selected)
    }
    
    func initPosting() {
        // 사용자 프로필 이미지 설정
        profileImageView.setImageNutee(post?.body.user?.image?.src)
        
        // 사용자 이름 설정
        nicknameLabel.text = post?.body.user?.nickname
        
        // 게시글 게시 시간 설정
        if post?.body.createdAt == post?.body.updatedAt {
            let originPostTime = post?.body.createdAt ?? ""
            let postTimeDateFormat = originPostTime.getDateFormat(time: originPostTime)
            dateLabel.text = postTimeDateFormat?.timeAgoSince(postTimeDateFormat!)
        } else {
            let originPostTime = post?.body.updatedAt ?? ""
            let postTimeDateFormat = originPostTime.getDateFormat(time: originPostTime)
            let updatePostTime = postTimeDateFormat?.timeAgoSince(postTimeDateFormat!)
            dateLabel.text = "수정 " + (updatePostTime ?? "")
        }
        
        // Posting 내용 설정
        contentTextView.text = post?.body.content
        contentView.sizeToFit()
        contentTextView.snp.updateConstraints {
//            $0.height.equalTo(contentTextView.frame.size.height).priority(999)
            $0.height.greaterThanOrEqualTo(contentTextView.frame.size.height).priority(999)
        }
        
        // 게시글 이미지 설정
        setImageFrame(imageCnt: post?.body.images?.count ?? 0)
        postImageList = post?.body.images ?? []
        
        // Like 버튼
        likeCount = post?.body.likers?.count
        likeButton.setTitle(String(likeCount ?? 0), for: .normal)
        
        var loginUser = false
    
        for liker in post?.body.likers ?? [] {
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
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.isHidden = false
            }
            break
        case 2:
            _ = firstImageViewWhenOne.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.alpha = 0.5
                $0.isHidden = false
            }
            
            oneMoreLabel.isHidden = false
            break
        case 3:
            _ = firstImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.isHidden = false
            }
            _ = secondImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[1].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.isHidden = false
            }
            _ = thirdImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[2].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.isHidden = false
            }
            break
        case 4:
            _ = firstImageViewWhenFour.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.isHidden = false
            }
            _ = secondImageViewWhenFour.then {
                $0.imageFromUrl(post?.body.images?[1].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.isHidden = false
            }
            _ = thirdImageViewWhenFour.then {
                $0.imageFromUrl(post?.body.images?[2].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.isHidden = false
            }
            _ = fourthImageViewWhenFour.then {
                $0.imageFromUrl(post?.body.images?[3].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                
                $0.isHidden = false
            }
            break
        default:
            _ = firstImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[0].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true

                $0.isHidden = false
            }
            _ = secondImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[1].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true

                $0.isHidden = false
            }
            _ = thirdImageViewWhenThree.then {
                $0.imageFromUrl(post?.body.images?[2].src ?? "", defaultImgPath: "")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true

                $0.alpha = 0.5
                $0.isHidden = false
            }

            moreLabel.text = "+\(imageCnt - 3)"
            moreLabel.isHidden = false
        }
    }
    
    func setClickActions(imageView: UIImageView, tag: Int) {
        imageView.tag = tag
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer1.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer1)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let nuteeImageViewer = NuteeImageViewer()
        nuteeImageViewer.modalPresentationStyle = .overFullScreen
        
        let imgView = tapGestureRecognizer.view as? UIImageView
        nuteeImageViewer.setImageSource(imageList: postImageList, tag: imgView?.tag ?? 0)
        
        detailNewsFeedVC?.present(nuteeImageViewer, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        guard let hashTagTextView = textView as? HashtagTextView  else { return false }
        
        if url.scheme == "http" {
            // 링크 연결
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.preferredControlTintColor = .nuteeGreen
            
            self.detailNewsFeedVC?.present(safariViewController, animated: true, completion: nil)
        } else {
            // 해시 태그 검색
            let urlString = String(describing: url)
            if let index = Int(urlString) {
                let hashtagFeedVC = HashtagFeedVC()
                
                hashtagFeedVC.afterSetKeyword(keyword: hashTagTextView.hashtagArr?[index] ?? "")
                    
                self.detailNewsFeedVC?.navigationController?.pushViewController(hashtagFeedVC, animated: true)
            }
        }
        
        return false
    }
    
}

// MARK: - NuteeAlert Action Definition

extension DetailNewsFeedHeaderView: NuteeAlertActionDelegate {
    
    func editPost() {
        let postVC = PostVC()
    
        postVC.editPostContent = post
        postVC.isEditMode = true
        
        let navigationController = UINavigationController(rootViewController: postVC)
        navigationController.modalPresentationStyle = .currentContext
        
        detailNewsFeedVC?.tabBarController?.present(navigationController, animated: true)
    }
    
    func deletePost() {
        let nuteeAlertDialogue = NuteeAlertDialogue()
        nuteeAlertDialogue.dialogueData = ["게시글 삭제", "해당 게시글을 삭제하시겠습니까?"]
        nuteeAlertDialogue.okButtonData = ["삭제", UIColor.white, UIColor.red]
        nuteeAlertDialogue.okButton.addTarget(self, action: #selector(didTapDeletePost), for: .touchUpInside)
        
        nuteeAlertDialogue.modalPresentationStyle = .overCurrentContext
        nuteeAlertDialogue.modalTransitionStyle = .crossDissolve
    
        detailNewsFeedVC?.tabBarController?.present(nuteeAlertDialogue, animated: true)
    }
    
    func reportPost() {
        let nuteeReportDialogue = NuteeReportDialogue()
        nuteeReportDialogue.nuteeAlertActionDelegate = self
        
        nuteeReportDialogue.dialogueData = ["게시물 신고하기", "신고 사유를 입력해주세요."]
        nuteeReportDialogue.okButtonData = ["신고", UIColor.white, UIColor.red]
        
        nuteeReportDialogue.modalPresentationStyle = .overCurrentContext
        nuteeReportDialogue.modalTransitionStyle = .crossDissolve
        
        detailNewsFeedVC?.tabBarController?.present(nuteeReportDialogue, animated: true)
    }
    
    @objc func didTapDeletePost() {
        detailNewsFeedVC?.feedContainerCVCell?.postDeleteService(postId: post?.body.id ?? 0, completionHandler: { [self] in
            detailNewsFeedVC?.feedContainerCVCell?.fetchNewsFeed()
            detailNewsFeedVC?.navigationController?.popViewController(animated: true)
        })
    }
    
    func showNuteeAlertSheet() {
        let nuteeAlertSheet = NuteeAlertSheet()
        nuteeAlertSheet.nuteeAlertActionDelegate = self
        
        if post?.body.user?.id == KeychainWrapper.standard.integer(forKey: "id") {
            nuteeAlertSheet.optionList = [["수정", UIColor.black],
                                          ["삭제", UIColor.red]]
            
        } else {
            nuteeAlertSheet.optionList = [["🚨신고하기", UIColor.red]]
            
        }
                
        nuteeAlertSheet.modalPresentationStyle = .custom
        
        detailNewsFeedVC?.present(nuteeAlertSheet, animated: true)
    }
    
    func nuteeAlertSheetAction(indexPath: Int) {
        detailNewsFeedVC?.dismiss(animated: true)
        
        if post?.body.user?.id == KeychainWrapper.standard.integer(forKey: "id") {
            switch indexPath {
            case 0:
                editPost()
            case 1:
                deletePost()
            default:
                break
            }
            
        } else {
            switch indexPath {
            case 0:
                reportPost()
            default:
                break
            }
        }
        
    }
    
    func nuteeAlertDialogueAction(text: String) {
        detailNewsFeedVC?.feedContainerCVCell?.reportPostService(postId: post?.body.id ?? 0, content: text, completionHandler: { [self] in
            detailNewsFeedVC?.simpleNuteeAlertDialogue(title: "신고완료", message: "해당 게시글이 신고되었습니다")
        })
    }
    
}

// MARK: - Server connect
extension DetailNewsFeedHeaderView {

    // MARK: - Like
    func postLikeService(postId: Int, completionHandler: @escaping (_ returnedData: PostContent) -> Void ){
        ContentService.shared.postLike(postId) { (responsedata) in

            switch responsedata {
            case .success(let res):
                let response = res as? PostContent
                completionHandler(response!)
                
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

    func postUnlikeService(postId: Int, completionHandler: @escaping (_ returnedData: PostContent) -> Void ){
        ContentService.shared.postUnlike(postId) { (responsedata) in

            switch responsedata {
            case .success(let res):
                let response = res as? PostContent
                completionHandler(response!)
                
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
