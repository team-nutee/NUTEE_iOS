//
//  NuteeAlertDialogue.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/18.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit
import SnapKit

class NuteeAlertDialogue: UIViewController {
    
    // MARK: - UI components

    let backgroundView = UIView()
    
    let windowView = UIView()
    
    let titleLabel = UILabel()
    let contentTextView = UITextView()
    
    let okButton = UIButton()
    let cancelButton = UIButton()
    
    // MARK: - Variables and Properties
    
    var dialogueData = ["", ""]
    var okButtonData = ["확인", UIColor.white, UIColor.nuteeGreen] as [Any] // title: 0, textColor: 1, backgroundColor: 2
    var cancelButtonData = ["취소", UIColor.lightGray, UIColor.white] as [Any] // title: 0, textColor: 1, backgroundColor: 2, isHidden: 3
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeConstraints()
        initView()
    }

    // MARK: - Helper
    
    func initView() {
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
    
    func makeConstraints() {
        // Add SubViews
        view.addSubview(backgroundView)
        view.addSubview(windowView)
        
        windowView.addSubview(titleLabel)
        windowView.addSubview(contentTextView)
        
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
            $0.width.equalTo(245)
            
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
        
        okButton.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(45)
            
            $0.top.equalTo(contentTextView.snp.bottom).offset(20)
            $0.left.equalTo(cancelButton.snp.right).offset(15)
            $0.right.equalTo(contentTextView.snp.right)
            $0.bottom.equalTo(windowView.snp.bottom).inset(20)
        }
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(okButton)
        }
        
    }
    
    func addCancelPostAction() {
        okButton.addTarget(self, action: #selector(didTapCancelPost), for: .touchUpInside)
    }
    
    func addDeletePostAction() {
        okButton.addTarget(self, action: #selector(didTapEditOkButton), for: .touchUpInside)
    }
    
    @objc func didTapEditOkButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapCancelPost() {
        let beforeVC = self.presentingViewController
        dismiss(animated: true, completion: {
            beforeVC?.dismiss(animated: true)
        })
    }
    
}
