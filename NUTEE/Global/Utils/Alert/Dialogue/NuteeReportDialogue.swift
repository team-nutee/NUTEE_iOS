//
//  NuteeReportDialogue.swift
//  NUTEE
//
//  Created by eunwoo on 2021/02/03.
//  Copyright © 2021 Nutee. All rights reserved.
//
import UIKit
import SnapKit

class NuteeReportDialogue: NuteeAlertDialogue {
    
    // MARK: - UI components
    
    let reasonView = UIView()
    let reasonTextField = UITextField()
    let reasonLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    var windowViewBottomConstraint: Constraint?
    
    var windowViewBottomOriginalPos: CGFloat = 0
    var minimumSpace: CGFloat = 20
    
    var feedContainerCVCell: FeedContainerCVCell?

    var postId: Int?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        makeConstraints()
        
        addKeyboardNotification()
        
        reasonTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let deviceHeight = UIScreen.main.bounds.height
        let windowViewHeight = windowView.bounds.height
        
        windowViewBottomOriginalPos = deviceHeight / 2 - windowViewHeight / 2
    }
    
    // MARK: - Helper
    
    override func initView() {
        super.initView()
        
        _ = okButton.then {
            $0.removeTarget(self, action: #selector(dismissAction), for: .touchUpInside)
            $0.addTarget(self, action: #selector(didTapReportPost), for: .touchUpInside)
        }
        
        _ = reasonView.then {
            $0.backgroundColor = .white
            $0.setBorder(borderColor: .veryLightPink, borderWidth: 0.3)
        }
        
        _ = reasonTextField.then {
            $0.placeholder = "내용을 입력해주세요"
            $0.font = .systemFont(ofSize: 14)
            $0.tintColor = .nuteeGreen
        }
        _ = reasonLabel.then {
            $0.text = "신고 사유를 입력해주세요"
            $0.font = .systemFont(ofSize: 10)
            $0.textColor = .red
            
            $0.alpha = 0
        }
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        // Add SubViews
        windowView.addSubview(reasonView)
        reasonView.addSubview(reasonTextField)
        windowView.addSubview(reasonLabel)
        
        // Make Constraints
        windowView.snp.remakeConstraints {
            $0.width.equalTo(windowWidth)
            
            $0.centerX.equalTo(view)
            windowViewBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
        }
        
        reasonView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(10)
            $0.left.equalTo(contentTextView.snp.left)
            $0.right.equalTo(contentTextView.snp.right)
        }
        reasonTextField.snp.makeConstraints {
            $0.top.equalTo(reasonView.snp.top).offset(5)
            $0.left.equalTo(reasonView.snp.left).offset(5)
            $0.right.equalTo(reasonView.snp.right).inset(5)
            $0.bottom.equalTo(reasonView.snp.bottom).inset(5)
        }
        reasonLabel.snp.makeConstraints {
            $0.top.equalTo(reasonView.snp.bottom).offset(1)
            $0.left.equalTo(contentTextView.snp.left)
            $0.right.equalTo(contentTextView.snp.right)
        }
        
        okButton.snp.remakeConstraints {
            $0.width.greaterThanOrEqualTo(45)

            $0.top.equalTo(reasonView.snp.bottom).offset(20).priority(999)
            $0.left.equalTo(cancelButton.snp.right).offset(15)
            $0.right.equalTo(contentTextView.snp.right)
            $0.bottom.equalTo(windowView.snp.bottom).inset(20)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func didTapReportPost() {
        let reportReason = reasonTextField.text ?? ""
        if reportReason != "" {
            nuteeAlertActionDelegate?.nuteeAlertDialogueAction(text: reportReason)
        } else {
            UIView.animate(withDuration: 0.2) { [self] in
                reasonLabel.alpha = 1.0
            }
        }
    }
}

    // MARK: - KeyBoard
extension NuteeReportDialogue {

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
            
            
            let targetContraints = abs(windowViewBottomConstraint?.layoutConstraints[0].constant ?? 0)
            let baseBottomConstraints = keyboardHeight + minimumSpace
            
            if targetContraints < baseBottomConstraints {
                windowViewBottomConstraint?.layoutConstraints[0].constant = -baseBottomConstraints
                
                self.view.setNeedsLayout()
                UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: { [self] in
                    if targetContraints != 0 {
                        view.layoutIfNeeded()
                    }
                })
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let info = notification.userInfo {
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
            
            windowViewBottomConstraint?.layoutConstraints[0].constant = -windowViewBottomOriginalPos
            
            self.view.setNeedsLayout()
            UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: { [self] in
                view.layoutIfNeeded()
            })
        }
    }
}
