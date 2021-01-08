//
//  DetailNewsFeedVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/24.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit
import SnapKit
import SwiftKeychainWrapper

class DetailNewsFeedVC: UIViewController {
    
    //MARK: - UI components
    
    let detailNewsFeedTableView = UITableView(frame: CGRect(), style: .grouped)
    let refreshControl = UIRefreshControl()
    
    let commentView = UIView()
    let commentTextView = UITextView()
    let placeholderLabel = UILabel()
    let submitButton = UIButton()
    
    //MARK: - Variables and Properties
    
    // FeedTVC와 DetailHeadderView가 통신하기 위해 중간(DetailNewsFeed) 연결 델리게이트 변수 선언
    var delegate: DetailHeaderViewDelegate?

    var post: PostContent?
    var postBody: PostContentBody?
    var postId: Int?
    
    var commentViewBottomConstraint: Constraint?
    
    //MARK: - Dummy data
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setCommentView()
        makeConstraints()
        
        addKeyboardNotification()
//
//        txtvwComment.delegate = self
//
//        initCommentWindow()
//
//        setRefresh()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        // ---> NewsFeedVC에서 getPostService 실행 후 reloadData 실행 <--- //
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//
//        addKeyboardNotification()
//    }

//MARK: - Helper
    
    func setTableView() {
        _ = detailNewsFeedTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(DetailNewsFeedHeaderView.self, forHeaderFooterViewReuseIdentifier: "DetailNewsFeedHeaderView")
            $0.register(ReplyCell.self, forCellReuseIdentifier: "ReplyCell")
            
            view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
            }
            
            $0.backgroundColor = .white
            $0.separatorInset.left = 0
            $0.separatorStyle = .singleLine
            
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapScreen(sender:))))
        }
    }
    
    func setCommentView() {
        _ = commentView.then {
            $0.backgroundColor = .white
            $0.addBorder(.top, color: .veryLightPink, thickness: 0.3)
        }
        
        _ = commentTextView.then {
            $0.delegate = self
            
            $0.font = .systemFont(ofSize: 13)
            $0.tintColor = .veryLightPink
        }
        
        _ = placeholderLabel.then {
            $0.text = "댓글을 입력하세요"
            $0.sizeToFit()
            $0.font = .systemFont(ofSize: 13)
            $0.textColor = .gray
        }
        
        _ = submitButton.then {
            $0.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            $0.tintColor = .nuteeGreen
            
            $0.alpha = 0
            
//            $0.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        }
    }
    
    func makeConstraints() {
        view.addSubview(commentView)
        
        commentView.addSubview(commentTextView)
        commentTextView.addSubview(placeholderLabel)
        commentView.addSubview(submitButton)
        
        commentView.snp.makeConstraints {
            $0.top.equalTo(detailNewsFeedTableView.snp.bottom).inset(10)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            commentViewBottomConstraint =
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
        }
        
        commentTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(40)
            
            $0.top.equalTo(commentView.snp.top).offset(10)
            $0.left.equalTo(commentView.snp.left).offset(10)
            $0.bottom.equalTo(commentView.snp.bottom).inset(10)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.top).offset(10)
            $0.left.equalTo(commentTextView.snp.left)
            $0.right.equalTo(commentTextView.snp.right)
            $0.bottom.equalTo(commentTextView.snp.bottom).inset(10)
        }

        submitButton.snp.makeConstraints {
            $0.height.equalTo(commentTextView)
            
            $0.left.equalTo(commentTextView.snp.right).offset(10)
            $0.right.equalTo(commentView.snp.right).inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

//    func setRefresh() {
//        refreshControl = UIRefreshControl()
//        replyTV.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(updatePost), for: UIControl.Event.valueChanged)
//    }
//
//    @objc func updatePost() {
//        self.getPostService(postId: self.postId ?? 0, completionHandler: {(returnedData)-> Void in
//            self.replyTV.reloadData()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.refreshControl.endRefreshing()
//            }
//        })
//    }

    @objc func didTapScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
}

//MARK: - Build TableView

extension DetailNewsFeedVC : UITableViewDelegate { }

extension DetailNewsFeedVC : UITableViewDataSource {

    // HeaderView settings
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue with the reuse identifier
        let detailNewsFeedHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailNewsFeedHeaderView") as? DetailNewsFeedHeaderView
        detailNewsFeedHeaderView?.detailNewsFeedVC = self
        
        detailNewsFeedHeaderView?.initHeaderView()
        detailNewsFeedHeaderView?.addContentView()
        
        // HeaderView로 NewsFeedVC에서 받아온 게시글 정보룰 넘김
        detailNewsFeedHeaderView?.post = self.post
        detailNewsFeedHeaderView?.initPosting()

//
//        // VC 컨트롤 권한을 HeaderView로 넘겨주기
//        headerNewsFeed?.RootVC = self
//        // 중간 매개 델리게이트(DetailNewsFeed)와 DetailHeaderView 사이를 통신하기 위한 변수 연결작업
//        headerNewsFeed?.delegate = self.delegate
//        // 사용자 프로필 이미지 탭 인식 설정
//        headerNewsFeed?.setClickActions()
//        headerNewsFeed?.setImageView()
//        headerNewsFeed?.awakeFromNib()
//        headerNewsFeed?.initTextView()

        return detailNewsFeedHeaderView
    }

    // TableView cell settings
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // 생성한 댓글 cell 개수 파악
//        var replyCnt = content?.comments.count ?? 0
//
//        if replyCnt == 0 {
//            // 보여줄 댓글이 없을 때
//            replyCnt += 2
//        } /*else {
//            // 추가로 파악해야 할 대댓글의 개수
//            for i in 0...(replyCnt - 1) {
//                let reReply = content?.comments[i]
//                replyCnt += reReply?.reComment?.count ?? 0
//            }
//        }*/
//
//        return replyCnt
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Custom셀인 'ReplyCell' 형식으로 변환
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
        cell.selectionStyle = .none

        cell.detailNewsFeedVC = self
        
        cell.initCell()
        cell.addContentView()

//        cell.initTextView()
//        if content?.comments.count == 0 {
//            replyTV.allowsSelection = false
//            if indexPath.row == 0 {
//                cell.backgroundColor = .lightGray
//            } else {
//                replyTV.setStatusNoReplyView(cell, emptyView: statusNoReply)
//                statusNoReply.isHidden = false
//                cell.contentsCell.isHidden = true
//                tableView.separatorStyle = .none
//            }
//        } else {
//            // 불러올 댓글이 있는 경우 cell 초기화 진행
//            cell.backgroundColor = .white
//            tableView.separatorStyle = .singleLine
//            cell.contentsCell.isHidden = false
//            statusNoReply.isHidden = true
//
//            // 생성된 Cell클래스로 comment 정보 넘겨주기
//            cell.comment = content?.comments[indexPath.row]
//            cell.initComments()
//
//            // VC 컨트롤 권한을 Cell클래스로 넘겨주기
//            cell.RootVC = self
//            // DetailNewsFeedVC와 ReplyCell 사이를 통신하기 위한 변수 연결작업
//            cell.delegate = self
//
//            // 댓글 사용자 이미지 탭 인식 설정
//            cell.setClickActions()

            // 대댓글 관련 replyCell 설정
//            if cell.comment?.reComment?.count != 0 {
//                replyTV.beginUpdates()
//                print("insertRow 함수 실행")
////                let indextPath = IndexPath(row: indexPath.row, section: 0)
//                replyTV.insertRows(at: [indexPath], with: .automatic)
//                replyTV.endUpdates()
//            }
//        }

        return cell
    }

    // tableView의 마지막 cell 밑의 여백 발생 문제(footerView의 기본 높이 값) 제거 코드
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fakeView = UIView()
        fakeView.backgroundColor = .clear
        
        return fakeView
    }
}

// MARK: - UITextView Delegate

extension DetailNewsFeedVC: UITextViewDelegate {
    
    // TextView의 동적인 크기 변화를 위한 function
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        // 빈칸이나 줄바꿈으로만 입력된 경우 버튼 비활성화
        var str = commentTextView.text.replacingOccurrences(of: " ", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
    
        if str.count != 0 || str != "" {
            self.placeholderLabel.isHidden = true
            
            UIView.animate(withDuration: 0.2) {
                self.submitButton.alpha = 1.0
                        }
            
        } else if str == "" {
            UIView.animate(withDuration: 0.1) {
                self.submitButton.alpha = 0.0
                        }
        }
        
        // 입력된 줄바꿈 개수 구하기
        let originalStr = commentTextView.text.count
        let removeEnterStr = commentTextView.text.replacingOccurrences(of: "\n", with: "").count
        // 엔터가 4개 이하 일시 댓글창 높이 자동조절 설정
        let enterNum = originalStr - removeEnterStr
        if enterNum <= 4 {
            self.commentTextView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            self.commentTextView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        // 댓글 입력창의 높이가 30 이상일 시 스크롤 기능 활성화
        if commentTextView.contentSize.height >= 30 {
            commentTextView.isScrollEnabled = true
        } else {
            commentTextView.frame.size.height = commentTextView.contentSize.height
            commentTextView.isScrollEnabled = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        placeholderLabel.isHidden = true
        
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text == "" {
            placeholderLabel.isHidden = false
        }
    }
}

// MARK: - Reply KeyBoard PopUp

extension DetailNewsFeedVC {

    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification)  {
        if let info = notification.userInfo {
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = keyboardFrame.height
            let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
            let bottomPadding = keyWindow?.safeAreaInsets.bottom
        
            let tabbarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
            _ = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

            commentViewBottomConstraint?.layoutConstraints[0].constant = -(keyboardHeight - (bottomPadding ?? 0))

//            commentView.snp.updateConstraints {
//                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardHeight - (bottomPadding ?? 0))
//            }
            
//            submitButton.snp.updateConstraints {
//                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardHeight - tabbarHeight + 12)
//            }

            self.view.setNeedsLayout()
            UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let info = notification.userInfo {
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
            
            commentView.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            submitButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            }
            detailNewsFeedTableView.contentInset = .zero
            
            self.view.setNeedsLayout()
            UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - Server connect

extension DetailNewsFeedVC {
    
    // 게시글 한 개 가져오기
    func getPostService(postId: Int, completionHandler: @escaping (_ returnedData: PostContent) -> Void ) {
        ContentService.shared.getPost(postId) { responsedata in
            
            switch responsedata {
            case .success(let res):
                let response = res as! PostContent
                self.post = response
                completionHandler(self.post!)
                
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
//
//    // 댓글 작성
//    func postCommentService(postId: Int, comment: String, completionHandler: @escaping () -> Void ) {
//        ContentService.shared.commentPost(postId, comment: comment) { (responsedata) in
//
//            switch responsedata {
//            case .success(let res):
//                completionHandler()
//
//                print("commentPost succussful", res)
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
//    // 댓글 수정
//    func editCommentService(postId: Int, commentId: Int, editComment: String, completionHandler: @escaping () -> Void ) {
//        ContentService.shared.commentEdit(postId, commentId, editComment) { (responsedata) in
//
//            switch responsedata {
//            case .success(let res):
//
//                print("commentEdit succussful", res)
//                completionHandler()
//                print(res)
//            case .requestErr(_):
//                self.alertNoticeEditCommentError()
//
//                print("request error")
//
//            case .pathErr:
//                self.alertNoticeEditCommentError()
//                print(".pathErr")
//
//            case .serverErr:
//                self.alertNoticeEditCommentError()
//                print(".serverErr")
//
//            case .networkFail :
//                self.alertNoticeEditCommentError()
//                print("failure")
//            }
//        }
//    }
}


//// MARK: - ReplyCell과 통신하여 게시글 삭제 후 테이블뷰 정보 다시 로드하기
//
//extension DetailNewsFeedVC: ReplyCellDelegate {
//    func updateReplyTV() {
//        self.getPostService(postId: self.postId ?? 0, completionHandler: {(returnedData)-> Void in
//            self.replyTV.reloadData()
//        })
//    }
//
//    func setEditCommentMode(commentId: Int, commentContent: String) {
//        self.isEditCommentMode = true
//        self.currentCommentId = commentId
//
//        self.btnCancel.isHidden = false
//        self.lblStatus.isHidden = false
//        self.lblStatus.text = "댓글수정"
//        self.statusViewHeight.constant = 40
//
//        self.txtvwComment.text = commentContent
//        self.txtvwComment.textColor = .black
//
//        self.view.setNeedsLayout()
//        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//
//        txtvwComment.becomeFirstResponder()
//    }
//}
//
