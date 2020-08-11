//
//  SettingPasswordVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/11.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingPasswordVC : UIViewController {
    
    // MARK: - UI components
    
    let passwordLabel = UILabel()
    let saveButton = UIButton()
    
    let passwordTextField = UITextField()
    
    let checkPasswordLabel = UILabel()
    let checkPasswordTextField = UITextField()
    
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
        _ = passwordLabel.then {
            $0.text = "비밀번호"
            $0.font = .systemFont(ofSize: 17)
            $0.sizeToFit()
        }
        _ = saveButton.then {
            $0.setTitle("저장하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
            $0.setTitleColor(.black, for: .normal)
        }
        
        _ = passwordTextField.then {
            $0.placeholder = "비밀번호"
            $0.font = .systemFont(ofSize: 14)
            
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
            
            $0.isSecureTextEntry = true
        }
        
        _ = checkPasswordLabel.then {
            $0.text = "비밀번호 확인"
            $0.font = .systemFont(ofSize: 17)
            $0.sizeToFit()
        }
        _ = checkPasswordTextField.then {
            $0.placeholder = "비밀번호"
            $0.font = .systemFont(ofSize: 14)
            
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
            
            $0.isSecureTextEntry = true
        }
    }
    
    func addSubView() {
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        view.addSubview(saveButton)
        
        view.addSubview(checkPasswordLabel)
        view.addSubview(checkPasswordTextField)
        
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(20)
            $0.left.equalTo(view.snp.left).offset(15)
        }
        saveButton.snp.makeConstraints {
            $0.width.equalTo(saveButton.intrinsicContentSize.width)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(passwordLabel)
            $0.left.equalTo(passwordTextField.snp.right).offset(5)
            $0.right.equalTo(view.snp.right).inset(15)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(passwordLabel.snp.bottom).offset(15)
            $0.left.equalTo(passwordLabel.snp.left)
        }
        
        checkPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.left.equalTo(passwordTextField.snp.left)
        }
        checkPasswordTextField.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(checkPasswordLabel.snp.bottom).offset(15)
            $0.left.equalTo(checkPasswordLabel.snp.left)
            $0.right.equalTo(passwordTextField.snp.right)
        }
        
    }
    
    @objc func didTapKeyboardOutSide() {
        passwordTextField.resignFirstResponder()
        checkPasswordTextField.resignFirstResponder()
    }
    
}
