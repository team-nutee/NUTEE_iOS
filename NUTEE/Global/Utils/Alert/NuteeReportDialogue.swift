//
//  ReportDialogue.swift
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
    
    
    // MARK: - Helper
    override func initView() {
        _ = backgroundView.then {
            $0.backgroundColor = .black
            $0.alpha = 0.3
        }
        
        _ = windowView.then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            $0.backgroundColor = .white
        }
        
        _ = titleLabel.then {
            $0.text = dialogueData[0]
            $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18.0)
        }
        _ = contentTextView.then {
            $0.text = dialogueData[1]
            $0.font = .systemFont(ofSize: 14)
            $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
            $0.isScrollEnabled = false
            $0.isSelectable = false
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
            $0.font = .systemFont(ofSize: 11)
            $0.textColor = .red
            
            $0.alpha = 0
        }
        
        _ = okButton.then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 11
            
            $0.setTitle(okButtonData[0] as? String, for: .normal)
            $0.setTitleColor(okButtonData[1] as? UIColor, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
            
            $0.backgroundColor = okButtonData[2] as? UIColor
            
            $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        }
        _ = cancelButton.then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 11
            
            $0.setTitle(cancelButtonData[0] as? String, for: .normal)
            $0.setTitleColor(cancelButtonData[1] as? UIColor , for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            
            $0.backgroundColor = cancelButtonData[2] as? UIColor
            
            $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        }
    }
    
    override func makeConstraints() {
        // Add SubViews
        view.addSubview(backgroundView)
        view.addSubview(windowView)
        
        windowView.addSubview(titleLabel)
        windowView.addSubview(contentTextView)
        windowView.addSubview(reasonView)
        reasonView.addSubview(reasonTextField)
        windowView.addSubview(reasonLabel)
        
        windowView.addSubview(cancelButton)
        windowView.addSubview(okButton)
        
        
        // Make Constraints
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        windowView.snp.makeConstraints {
            $0.width.equalTo(windowWidth)
            
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(view)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(windowView.snp.top).offset(25)
            $0.left.equalTo(windowView.snp.left).offset(20)
            $0.right.equalTo(windowView.snp.right).inset(20)
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
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
            $0.top.equalTo(reasonView.snp.bottom)
            $0.left.equalTo(contentTextView.snp.left)
            $0.right.equalTo(contentTextView.snp.right)
        }
        
        okButton.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(45)
            
            $0.top.equalTo(reasonView.snp.bottom).offset(20)
            $0.left.equalTo(cancelButton.snp.right).offset(15)
            $0.right.equalTo(contentTextView.snp.right)
            $0.bottom.equalTo(windowView.snp.bottom).inset(20)
        }
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(okButton)
        }
        
    }
    
    func addReportPostAction() {
        okButton.addTarget(self, action: #selector(didTapReportPost), for: .touchUpInside)
    }
    
    @objc func didTapReportPost() {
        if reasonTextField.text == "" {
            reasonLabel.alpha = 1.0
        } else {
            detailNewsFeedHeaderView?.reportPost(postId: postId ?? 0, content: reasonTextField.text ?? "")
        }
    }
}
