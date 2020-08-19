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
   
//
//    // User Information
//    @IBOutlet var userIMG: UIImageView!
//    @IBOutlet var userName: UIButton!
//    @IBOutlet var dateLabel: UILabel!
//
//    @IBOutlet var btnMore: UIButton!
//
//    // Posting
//    @IBOutlet weak var contentTextView: LinkTextView!
//    //앨범 이미지 1, 3, 4개수 프레임
//    @IBOutlet weak var imageWrapperView: UIView!
//    //앨범 이미지 높이
//    @IBOutlet var imageWrapperViewHeight: NSLayoutConstraint!
//    // Images 개수
//    @IBOutlet var oneImageView : UIImageView!
//    @IBOutlet var threeImageViewArr: [UIImageView]!
//    @IBOutlet var fourImageViewArr : [UIImageView]!
//    // 더보기 Label
//    @IBOutlet var moreLabel1: UILabel!
//    @IBOutlet var moreLabel4: UILabel!
//
//    // 좋아요 Button
//    @IBOutlet var btnLike: UIButton!
//
//    //MARK: - Variables and Properties
//
//    // FeedTVC와 통신하기 위한 델리게이트 변수 선언
//    weak var delegate: DetailHeaderViewDelegate?
//    weak var RootVC: UIViewController?
//
//    var detailNewsPost: NewsPostsContentElement?
//
//    var imageCnt: Int?
//
//    var numLike: Int?
//    var numComment: Int?
//
//    var isClickedLike: Bool?
//    var isClickedRepost: Bool?
//    var isClickedComment: Bool?
//
//    // .normal 상태에서의 버튼 AttributedStringTitle의 색깔 지정
//    let normalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
//    // .selected 상태에서의 Repost버튼 AttributedStringTitle의 색깔 지정
//    let selectedRepostAttributes = [NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen]
//    // .selected 상태에서의 Like버튼 AttributedStringTitle의 색깔 지정
//    let selectedLikeAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
//
//    //MARK: - Life Cycle
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        setImageView()
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        btnLike.isEnabled = true
//        btnMore.isEnabled = true
//    }
//
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
            $0.width.equalTo(24)
            $0.height.equalTo(12)
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
    
//
//    func initTextView() {
//        contentTextView.delegate = self
//        contentTextView.isEditable = false
//        contentTextView.isSelectable = true
//        contentTextView.isUserInteractionEnabled = true
//        contentTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
//        contentTextView.dataDetectorTypes = .link
//        contentTextView.resolveHashTags()
//    }
//
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        var sub:String = (NSString(string: textView.text)).substring(with: characterRange)
//        if (sub.first) == "#" {
//            let vc = UIStoryboard.init(name: "Hash", bundle: Bundle.main).instantiateViewController(withIdentifier: "HashVC") as? HashVC
//
//            vc?.hashTag = sub
//            RootVC?.navigationController?.pushViewController(vc!, animated: true)
//
//        } else {
//            if (sub.hasPrefix("https://") || sub.hasPrefix("http://")) == false {
//                sub = "http://" + sub
//            }
//            let beforeURL = sub
//            let url: URL = Foundation.URL(string: beforeURL)!
//            let safariViewController = SFSafariViewController(url: url)
//            safariViewController.preferredControlTintColor = .nuteeGreen
//
//            self.RootVC?.present(safariViewController, animated: true, completion: nil)
//        }
//
//        return false
//    }
//
//    @IBAction func showDetailProfile(_ sender: UIButton) {
//        showProfile()
//    }
//
//    @IBAction func btnLike(_ sender: UIButton) {
//        // .selected State를 활성화 하기 위한 코드
//        //        btnLike.isSelected = !btnLike.isSelected
//        if isClickedLike! {
//            setNormalLikeBtn()
//            likeDeleteService(postId: detailNewsPost?.id ?? 0)
//        } else {
//            setSelectedLikeBtn()
//            likePostService(postId: detailNewsPost?.id ?? 0)
//        }
//    }
//
//    @IBAction func btnMore(_ sender: Any) {
//        let moreAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//        let editAction = UIAlertAction(title: "수정", style: .default){
//            (action: UIAlertAction) in
//            // Code to edit
//            // Posting 창으로 전환
//            let postSB = UIStoryboard(name: "Post", bundle: nil)
//            let editPostingVC = postSB.instantiateViewController(withIdentifier: "PostVC") as! PostVC
//
//            editPostingVC.loadViewIfNeeded()
//            editPostingVC.editNewsPost = self.detailNewsPost
//            editPostingVC.setEditMode()
//
//            editPostingVC.modalPresentationStyle = .fullScreen
//            self.RootVC?.present(editPostingVC, animated: true, completion: nil)
//        }
//        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {
//            (action: UIAlertAction) in
//            let deleteAlert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
//            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
//            let okAction = UIAlertAction(title: "삭제", style: .destructive) {
//                (action: UIAlertAction) in
//                // Code to delete
//                self.deletePost()
//                self.RootVC?.navigationController?.popViewController(animated: true)
//            }
//            deleteAlert.addAction(cancelAction)
//            deleteAlert.addAction(okAction)
//            self.RootVC?.present(deleteAlert, animated: true, completion: nil)
//        }
//        let userReportAction = UIAlertAction(title: "신고하기🚨", style: .destructive) {
//            (action: UIAlertAction) in
//            // Code to 신고 기능
//            let reportAlert = UIAlertController(title: "이 게시글을 신고하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
//            let cancelAction
//                = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//            let reportAction = UIAlertAction(title: "신고", style: .destructive) {
//                (action: UIAlertAction) in
//                // <---- 신고 기능 구현
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
//            self.RootVC?.present(reportAlert, animated: true, completion: nil)
//        }
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//
//        let userid = KeychainWrapper.standard.integer(forKey: "id")
//
//        if (userid == detailNewsPost?.userID) {
//            moreAlert.addAction(editAction)
//            moreAlert.addAction(deleteAction)
//            moreAlert.addAction(cancelAction)
//        } else {
//            moreAlert.addAction(userReportAction)
//            moreAlert.addAction(cancelAction)
//        }
//        RootVC?.present(moreAlert, animated: true, completion: nil)
//    }
//
//    func initPosting() {
//        if detailNewsPost?.retweetID == nil {
//            // 사용자 프로필 이미지 설정
//            userIMG.setRounded(radius: nil)
//
//            userIMG.setImageNutee(detailNewsPost?.user.image?.src)
//            userIMG.setImageContentMode(detailNewsPost?.user.image?.src, imgvw: userIMG)
//
//            // 사용자 이름 설정
//            userName.setTitle(detailNewsPost?.user.nickname, for: .normal)
//            userName.sizeToFit()
//            // 게시글 게시 시간 설정
//            let originPostTime = detailNewsPost?.createdAt
//            let postTimeDateFormat = originPostTime?.getDateFormat(time: originPostTime!)
//            dateLabel.text = postTimeDateFormat?.timeAgoSince(postTimeDateFormat!)
//
//            // Posting 내용 설정
//            contentTextView.text = detailNewsPost?.content
//            contentTextView.postingInit()
//
//            // 게시글 이미지 설정
//            imageCnt = detailNewsPost?.images.count
//            showImgFrame()
//
//            // Like 버튼
//            var containLoginUser = false
//            for arrSearch in detailNewsPost?.likers ?? [] {
//                if arrSearch.like.userID == KeychainWrapper.standard.integer(forKey: "id") {
//                    containLoginUser = true
//                }
//            }
//            if containLoginUser {
//                // 로그인 한 사용자가 좋아요를 누른 상태일 경우
//                btnLike.isSelected = true
//                numLike = detailNewsPost?.likers.count ?? 0
//                btnLike.setTitle(" " + String(numLike!), for: .selected)
//                btnLike.tintColor = .systemPink
//                btnLike.setTitleColor(.systemPink, for: .selected)
//                isClickedLike = true
//            } else {
//                // 로그인 한 사용자가 좋아요를 누르지 않은 상태일 경우
//                btnLike.isSelected = false
//                numLike = detailNewsPost?.likers.count ?? 0
//                btnLike.setTitle(" " + String(numLike!), for: .normal)
//                btnLike.tintColor = .gray
//                btnLike.setTitleColor(.gray, for: .normal)
//                isClickedLike = false
//            }
//        }
//    }
//
//    func setNormalLikeBtn() {
//        btnLike.isSelected = false
//        numLike! -= 1
//        btnLike.setTitle(" " + String(numLike ?? 0), for: .normal)
//        btnLike.tintColor = .gray
//        btnLike.setTitleColor(.gray, for: .normal)
//        isClickedLike = false
//    }
//
//    func setSelectedLikeBtn() {
//        btnLike.isSelected = true
//        numLike! += 1
//        btnLike.setTitle(" " + String(numLike ?? 0), for: .selected)
//        btnLike.tintColor = .systemPink
//        btnLike.setTitleColor(.systemPink, for: .selected)
//        isClickedLike = true
//    }
//
//    func setButtonPlain(btn: UIButton, num: Int, color: UIColor, state: UIControl.State) {
//        btn.setTitle(" " + String(num), for: state)
//        btn.setTitleColor(color, for: state)
//        btn.tintColor = color
//    }
//
//    // 사진 개수에 따른 이미지 표시 유형 선택
//    func showImgFrame() {
//        moreLabel1.isHidden = true
//        moreLabel4.isHidden = true
//
//        var num = 0
//        switch imageCnt {
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
//
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
//// MARK: - 서버 연결 코드 구간
//
//extension DetailHeaderView {
//
//    func reportPost( content: String) {
//        let userid = KeychainWrapper.standard.string(forKey: "id") ?? ""
//        ContentService.shared.reportPost(userid, content) { (responsedata) in
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
//    // MARK: - like
//
//    func likePostService(postId: Int) {
//        ContentService.shared.likePost(postId) { (responsedata) in
//
//            switch responsedata {
//            case .success(let res):
//
//                print("likePost succussful", res)
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
//    func likeDeleteService(postId: Int) {
//        ContentService.shared.likeDelete(postId) { (responsedata) in
//
//            switch responsedata {
//            case .success(let res):
//
//                print("likePost succussful", res)
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
