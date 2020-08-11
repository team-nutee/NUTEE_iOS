//
//  SettingNicknameVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/11.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingNicknameVC : UIViewController {
    
    // MARK: - UI components
    
    let nicknameLabel = UILabel()
    let saveButton = UIButton()
    
    let nicknameTextField = UITextField()
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
        view.backgroundColor = .white
        
        initView()
        addSubView()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapKeyboardOutSide)))
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = nicknameLabel.then {
            $0.text = "닉네임"
            $0.font = .systemFont(ofSize: 17)
            $0.sizeToFit()
        }
        _ = saveButton.then {
            $0.setTitle("저장하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
            $0.setTitleColor(.black, for: .normal)
        }
        
        _ = nicknameTextField.then {
            $0.placeholder = "닉네임"
            $0.font = .systemFont(ofSize: 14)
            
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
        }
    }
    
    func addSubView() {
        
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        
        view.addSubview(saveButton)
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(20)
            $0.left.equalTo(view.snp.left).offset(15)
        }
        saveButton.snp.makeConstraints {
            $0.width.equalTo(saveButton.intrinsicContentSize.width)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(nicknameLabel)
            $0.right.equalTo(view.snp.right).inset(15)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(15)
            $0.left.equalTo(nicknameLabel.snp.left)
            $0.right.equalTo(saveButton.snp.right)
        }
    }
    
    @objc func didTapKeyboardOutSide() {
        nicknameTextField.resignFirstResponder()
    }
    
}
