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
    
    let activityIndicator = UIActivityIndicatorView()
    
    let refreshControl = SmallRefreshControl()
    
    let detailNewsFeedTableView = UITableView(frame: CGRect(), style: .grouped)
    
    let commentView = UIView()
    let commentTextView = PlaceholderTextView()
    let submitButton = UIButton()
    
    //MARK: - Variables and Properties
    
    let commentTextViewFontSize: CGFloat = 14
    let commentTextViewHeight: CGFloat = 100
    
    var postId: Int?
    var post: PostContent?
    var replyList: [ReplyList]?
    
    var commentViewBottomConstraint: Constraint?
    
    var isEditCommentMode = false
    var commentId: Int?
    
    var feedContainerCVCell: FeedContainerCVCell?
    
    //MARK: - Dummy data
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        makeConstraints()
        
        setRefresh()
        
        addKeyboardNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        showActivityIndicator(activityIndicator: activityIndicator)
        getPostService(postId: postId ?? 0, completionHandler: { [self] (returnedData)-> Void in
            detailNewsFeedTableView.reloadData()
            
            hideActivityIndicator(activityIndicator: activityIndicator)
            detailNewsFeedTableView.isHidden = false
            commentView.isHidden = false
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = view.then {
            $0.backgroundColor = .white
            $0.tintColor = .nuteeGreen
        }
        
        _ = detailNewsFeedTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(DetailNewsFeedHeaderView.self, forHeaderFooterViewReuseIdentifier: Identify.DetailNewsFeedHeaderView)
            $0.register(ReplyTVCell.self, forCellReuseIdentifier: Identify.ReplyTVCell)
            $0.register(ReReplyTVCell.self, forCellReuseIdentifier: Identify.ReReplyTVCell)
            $0.register(NoReplyFooterView.self, forHeaderFooterViewReuseIdentifier: Identify.NoReplyFooterView)
            
            $0.backgroundColor = .white
            $0.separatorInset.left = 0
            $0.separatorStyle = .singleLine
            
            $0.keyboardDismissMode = .onDrag
            
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutsideOfCommentView(sender:))))
            
            $0.isHidden = true
        }
        
        _ = commentView.then {
            $0.backgroundColor = .white
            $0.addBorder(.top, color: .veryLightPink, thickness: 0.3)
            
            $0.isHidden = true
        }
        _ = commentTextView.then {
            $0.delegate = self
            
            $0.placeholderLabel.text = "댓글을 입력하세요"
            $0.placeholderLabel.font = .systemFont(ofSize: commentTextViewFontSize)
            
            $0.font = .systemFont(ofSize: commentTextViewFontSize)
            $0.tintColor = .nuteeGreen
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isScrollEnabled = false
        }
        _ = submitButton.then {
            $0.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            $0.tintColor = .nuteeGreen
            
            $0.imageView?.contentMode = .scaleAspectFit
            $0.contentHorizontalAlignment = .fill
            $0.contentVerticalAlignment = .fill
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 5)
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        }
    }
    
    func makeConstraints() {
        view.addSubview(detailNewsFeedTableView)

        view.addSubview(commentView)
        commentView.addSubview(commentTextView)
        commentView.addSubview(submitButton)
        
        
        detailNewsFeedTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }
        
        commentView.snp.makeConstraints {
            $0.top.equalTo(detailNewsFeedTableView.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            commentViewBottomConstraint =
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
        }
        commentTextView.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(commentTextViewHeight)
            
            $0.top.equalTo(commentView.snp.top).offset(20)
            $0.left.equalTo(commentView.snp.left).offset(10)
            $0.bottom.equalTo(commentView.snp.bottom).inset(20)
        }
        submitButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(submitButton.snp.width)

            $0.left.equalTo(commentTextView.snp.right)
            $0.right.equalTo(commentView.snp.right)
            $0.bottom.equalTo(commentView.snp.bottom).inset(3)
        }
    }
    
    func setRefresh() {
        detailNewsFeedTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updatePost), for: UIControl.Event.valueChanged)
    }
    
    func makeReplyList() {
        // 댓글과 대댓글을 하나의 CommentBody 배열 형태로 구성 및 정렬
        var replyList: [ReplyList] = []
        var reply: ReplyList = ReplyList.init()
        let comments = post?.body.comments ?? []
        for comment in comments {
            reply.type = .comment
            reply.body = comment
            
            replyList.append(reply)
            if comment.reComment?.isEmpty == false {
                let recomments = comment.reComment ?? []
                for recomment in recomments {
                    reply.type = .reComment
                    reply.body = recomment
                    
                    replyList.append(reply)
                }
            }
        }
        self.replyList = replyList
    }
    
    @objc func updatePost() {
        self.getPostService(postId: self.postId ?? 0, completionHandler: { [self] (returnedData)-> Void in
            self.detailNewsFeedTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    @objc func didTapSubmitButton(_ sender: UIButton) {
        if isEditCommentMode {
            // 댓글 수정 모드일 때 실행될 문장
            self.editCommentService(postId: postId ?? 0, commentId: commentId ?? 0, content: commentTextView.text, completionHandler: { [self] () -> Void in
                commentTextView.text = ""
                commentTextView.endEditing(true)
                
                // 수정모드 종료
                isEditCommentMode = false
                textViewDidChange(commentTextView)
                
                getPostService(postId: postId ?? 0, completionHandler: {(returnedData)-> Void in
                    detailNewsFeedTableView.reloadData()
                })
            })
        } else {
            // 댓글 수정x, 새로 작성할 때
            self.postCommentService(postId: postId ?? 0, comment: commentTextView.text) { [self] in
                commentTextView.text = ""
                commentTextView.endEditing(true)
                textViewDidChange(commentTextView)
                
                getPostService(postId: postId ?? 0, completionHandler: {(returnedData)-> Void in
                    detailNewsFeedTableView.reloadData()
                    
                    let lastRow = IndexPath(row: (post?.body.comments?.count ?? 1) - 1, section: 0)
                    detailNewsFeedTableView.scrollToRow(at: lastRow, at: .bottom, animated: true)
                })
            }
        }
    }

    @objc func didTapOutsideOfCommentView(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    func setEditCommentMode(editCommentId: Int, content: String) {
        isEditCommentMode = true
        
        commentId = editCommentId
        commentTextView.text = content
        commentTextView.placeholderLabel.text = ""
        
        commentTextView.becomeFirstResponder()
    }
    
    func deleteComment(deleteCommentId: Int) {
        deleteCommentService(postId: postId ?? 0, commentId: deleteCommentId) { [self] in
            getPostService(postId: postId ?? 0, completionHandler: {(returnedData)-> Void in
                detailNewsFeedTableView.reloadData()
            })
        }
    }
    
    func setFetchDetailNewsFeedFail(failMessage: String?) {
        activityIndicator.stopAnimating()
        self.detailNewsFeedTableView.isHidden = false
        
        self.detailNewsFeedTableView.setEmptyView(title: "게시글 조회 실패", message: failMessage ?? "")
    }
}

//MARK: - Build TableView
extension DetailNewsFeedVC : UITableViewDelegate, UITableViewDataSource {

    // HeaderView
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        // 임의 값이 있어야 작동함
        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identify.DetailNewsFeedHeaderView) as? DetailNewsFeedHeaderView
        headerView?.detailNewsFeedVC = self
        headerView?.feedContainerCVCell = self.feedContainerCVCell
        
        // HeaderView로 NewsFeedVC에서 받아온 게시글 정보룰 넘김
        headerView?.post = self.post
        if headerView?.post != nil {
            headerView?.initPosting()
        }
        
        return headerView
    }

    // Cell
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: String
        
        switch replyList?[indexPath.row].type {
        case .comment:
            cellId = Identify.ReplyTVCell
        case .reComment:
            cellId = Identify.ReReplyTVCell
        default:
            cellId = Identify.ReplyTVCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReplyTVCell
        cell.selectionStyle = .none
        
        cell.detailNewsFeedVC = self
        
        cell.postId = postId
        cell.comment = replyList?[indexPath.row].body
        cell.fillDataToView()

        return cell
    }

    // FooterView
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        // 임의 값이 있어야 작동함
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if post?.body.comments?.count == 0 {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }

    // 댓글이 없을 때 표시 할 정보
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identify.NoReplyFooterView) as? NoReplyFooterView
        
        return footerView
    }
}

// MARK: - UITextView Delegate
extension DetailNewsFeedVC: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        
        commentTextView.handlePlaceholder()
        
        
        // 전송 버튼 활성화(빈칸이나 줄바꿈으로만 입력된 경우 비활성화) 조건
        var str = commentTextView.text.replacingOccurrences(of: " ", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        if str.isEmpty == true {
            UIView.animate(withDuration: 0.1) {
                self.submitButton.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.submitButton.alpha = 1.0
            }
        }

        
        // 댓글 입력창의 높이가 100 이상 넘을 시 스크롤 가능 활성화
        if commentTextView.contentSize.height > commentTextViewHeight - commentTextViewFontSize {
            if commentTextView.text.isEmpty == false {
                commentTextView.translatesAutoresizingMaskIntoConstraints = true
                commentTextView.isScrollEnabled = true
            }
        } else {
            commentTextView.translatesAutoresizingMaskIntoConstraints = false
            commentTextView.isScrollEnabled = false
            
            commentTextView.frame.size.height = commentTextView.contentSize.height
        }
        
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - KeyBoard
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
        
            let tabbarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
            _ = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

            commentViewBottomConstraint?.layoutConstraints[0].constant = -(keyboardHeight - tabbarHeight)
            
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
            
            commentViewBottomConstraint?.layoutConstraints[0].constant = 0
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
        ContentService.shared.getPost(postId) { [self] responsedata in
            
            switch responsedata {
            case .success(let res):
                let response = res as! PostContent
                post = response
                makeReplyList()
                
                completionHandler(self.post!)
                
            case .requestErr(_):
                setFetchDetailNewsFeedFail(failMessage: "요청에 실패했습니다")
                
            case .pathErr:
                setFetchDetailNewsFeedFail(failMessage: "서버 연결에 오류가 있습니다")
                
            case .serverErr:
                setFetchDetailNewsFeedFail(failMessage: "서버 연결에 오류가 있습니다")

            case .networkFail :
                setFetchDetailNewsFeedFail(failMessage: "네트워크에 오류가 있습니다")
            }
        }
    }
    
    // 댓글 작성
    func postCommentService(postId: Int, comment: String, completionHandler: @escaping () -> Void ) {
        ContentService.shared.createComment(postId, comment: comment) { (responsedata) in
            
            switch responsedata {
            case .success(let res):
                completionHandler()
                
                print("Create comment successful", res)
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
    
    // 댓글 수정
    func editCommentService(postId: Int, commentId: Int, content: String, completionHandler: @escaping () -> Void ) {
        ContentService.shared.editComment(postId, commentId, content) { (responsedata) in
            
            switch responsedata {
            case .success(let res):
                print("commentEdit succussful", res)
                completionHandler()
                print(res)
                
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
    
    // 댓글 삭제
    func deleteCommentService(postId: Int, commentId: Int, completionHandler: @escaping () -> Void ) {
        ContentService.shared.deleteComment(postId, commentId: commentId) { (responsedata) in
            
            switch responsedata {
            case .success(let res):
                print(res)
                completionHandler()
                
            case .requestErr(_):
                let errorAlert = UIAlertController(title: "오류발생😵", message: "오류가 발생하여 댓글을 삭제하지 못했습니다", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                
                errorAlert.addAction(okAction)
                
                self.present(errorAlert, animated: true, completion: nil)
                
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
