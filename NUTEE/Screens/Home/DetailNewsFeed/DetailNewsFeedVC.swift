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
    
    var isEditCommentMode = false
    
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
            $0.register(ReplyCell.self, forCellReuseIdentifier: Identify.ReplyCell)
            $0.register(NoReplyFooterView.self, forHeaderFooterViewReuseIdentifier: Identify.NoReplyFooterView)
            
            $0.backgroundColor = .white
            $0.separatorInset.left = 0
            $0.separatorStyle = .singleLine
            
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapScreen(sender:))))
        }
        
        _ = commentView.then {
            $0.backgroundColor = .white
            $0.addBorder(.top, color: .veryLightPink, thickness: 0.3)
        }
        
        _ = commentTextView.then {
            $0.delegate = self
            
            $0.font = .systemFont(ofSize: 13)
            $0.tintColor = .veryLightPink
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        _ = placeholderLabel.then {
            $0.text = "댓글을 입력하세요"
            $0.sizeToFit()
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .gray
        }
        
        _ = submitButton.then {
            //$0.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            $0.tintColor = .nuteeGreen
            $0.backgroundColor = .gray
            $0.setTitle("등록", for: .normal)
            
            $0.alpha = 1
            
            $0.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        }
    }
    
    func makeConstraints() {
        
        view.addSubview(detailNewsFeedTableView)

        view.addSubview(commentView)
        
        commentView.addSubview(commentTextView)
        commentTextView.addSubview(placeholderLabel)
        
        //commentView.addSubview(submitButton)
        
        detailNewsFeedTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }
        
        commentView.backgroundColor = .yellow
        commentView.snp.makeConstraints {
            //$0.height.greaterThanOrEqualTo(50)
            //$0.height.lessThanOrEqualTo(130)
            //$0.height.lessThanOrEqualTo(100)
            
            $0.top.equalTo(detailNewsFeedTableView.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            commentViewBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
        }
        
        commentTextView.snp.makeConstraints {
            //$0.height.greaterThanOrEqualTo(40)
            $0.height.lessThanOrEqualTo(90)
            
            $0.top.equalTo(commentView.snp.top).offset(10)
            $0.left.equalTo(commentView.snp.left).offset(10)
            $0.right.equalTo(commentView.snp.right).inset(10)
            $0.bottom.equalTo(commentView.snp.bottom).inset(10)
        }

        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.top).offset(10)
            
            $0.centerY.equalTo(commentTextView)
        }

//        submitButton.snp.makeConstraints {
//            $0.width.equalTo(40)
//            $0.height.equalTo(submitButton.snp.width)
//
//            $0.left.equalTo(commentTextView.snp.right).offset(5)
//            $0.right.equalTo(commentView.snp.right)
//            $0.bottom.equalTo(commentTextView.snp.bottom)
//        }
    }
    
    func setRefresh() {
        detailNewsFeedTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updatePost), for: UIControl.Event.valueChanged)
    }
    
    @objc func updatePost() {
        self.getPostService(postId: self.postId ?? 0, completionHandler: {(returnedData)-> Void in
            self.detailNewsFeedTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    @objc func didTapSubmitButton(_ sender: UIButton) {
        if isEditCommentMode {
            // 댓글 수정 모드일 때 실행될 문장
        } else {
            // 댓글 수정x, 새로 작성할 때
            self.postCommentService(postId: postId ?? 0, comment: commentTextView.text) {
                self.commentTextView.text = ""
                self.commentTextView.endEditing(true)
                
                self.getPostService(postId: self.postId ?? 0, completionHandler: {(returnedData)-> Void in
                    self.detailNewsFeedTableView.reloadData()
                    
                    let lastRow = IndexPath(row: (self.post?.body.comments?.count ?? 1) - 1, section: 0)
                    self.detailNewsFeedTableView.scrollToRow(at: lastRow, at: .bottom, animated: true)
                })
            }
        }
    }

    @objc func didTapScreen(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
}

//MARK: - Build TableView
extension DetailNewsFeedVC : UITableViewDelegate, UITableViewDataSource {

    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue with the reuse identifier
        let detailNewsFeedHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identify.DetailNewsFeedHeaderView) as? DetailNewsFeedHeaderView
        detailNewsFeedHeaderView?.detailNewsFeedVC = self

        detailNewsFeedHeaderView?.initHeaderView()
        detailNewsFeedHeaderView?.addContentView()

        // HeaderView로 NewsFeedVC에서 받아온 게시글 정보룰 넘김
        detailNewsFeedHeaderView?.post = self.post
        //detailNewsFeedHeaderView?.initPosting()

        return detailNewsFeedHeaderView
    }

    // Cell
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.body.comments?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.ReplyCell, for: indexPath) as! ReplyCell
        cell.selectionStyle = .none
        cell.detailNewsFeedVC = self
        cell.delegate = self
        
        cell.comment = post?.body.comments?[indexPath.row]
        
        cell.initCell()
        cell.addContentView()
        cell.fillDataToView()

        return cell
    }

    // FooterView
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if post?.body.comments?.count == 0 {
            return 200.0
        } else {
            return .leastNormalMagnitude
        }
    }

    // 댓글이 없을 때 띄우는 footer view
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let noReplyFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identify.NoReplyFooterView) as? NoReplyFooterView
        
        noReplyFooterView?.initFooterView()
        noReplyFooterView?.addContentView()

        return noReplyFooterView
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
        
        let lineCounter = commentTextView.text.components(separatedBy: "\n").count - 1
        if lineCounter <= 4 {
            self.commentTextView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            self.commentTextView.translatesAutoresizingMaskIntoConstraints = true
        }
        
        // 댓글 입력창의 높이가 100 이상일 시 스크롤 기능 활성화
        if commentTextView.contentSize.height >= 90 {
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

// MARK: - ReplyCell과 통신하여 게시글 삭제 후 테이블뷰 정보 다시 로드하기
extension DetailNewsFeedVC: ReplyCellDelegate {
    func updateReplyTV() {
        self.getPostService(postId: self.postId ?? 0, completionHandler: {(returnedData)-> Void in
            self.detailNewsFeedTableView.reloadData()
        })
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
}
