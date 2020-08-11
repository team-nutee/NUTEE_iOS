//
//  SettingMajorVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/11.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingMajorVC : UIViewController {
    
    // MARK: - UI components
    
    let majorTitleLabel = UILabel()
    
    let firstMajorLabel = UILabel()
    let saveButton = UIButton()
    
    let firstMajorTextField = UITextField()
    
    let secondMajorLabel = UILabel()
    let secondMajorTextField = UITextField()
    
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
        _ = majorTitleLabel.then {
            $0.text = "전공을 설정해주세요!!"
            $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18.0)
        }
        _ = saveButton.then {
            $0.setTitle("저장하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
            $0.setTitleColor(.black, for: .normal)
        }
        
        _ = firstMajorLabel.then {
            $0.text = "전공"
            $0.font = .systemFont(ofSize: 17)
            $0.sizeToFit()
        }
        _ = firstMajorTextField.then {
            $0.placeholder = "첫 번쨰 전공"
            $0.font = .systemFont(ofSize: 14)
            
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
        }
        
        _ = secondMajorLabel.then {
            $0.text = "두 번째 전공이 있다면!!"
            $0.font = .systemFont(ofSize: 17)
            $0.sizeToFit()
        }
        _ = secondMajorTextField.then {
            $0.placeholder = "두 번쨰 전공"
            $0.font = .systemFont(ofSize: 14)
            
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
        }
    }
    
    func addSubView() {
        
        view.addSubview(majorTitleLabel)
        
        view.addSubview(firstMajorLabel)
        view.addSubview(firstMajorTextField)
        
        view.addSubview(saveButton)
        
        view.addSubview(secondMajorLabel)
        view.addSubview(secondMajorTextField)
        
        
        majorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(45)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        saveButton.snp.makeConstraints {
            $0.width.equalTo(saveButton.intrinsicContentSize.width)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(majorTitleLabel)
            $0.left.equalTo(firstMajorTextField.snp.right).offset(5)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        firstMajorLabel.snp.makeConstraints {
            $0.top.equalTo(majorTitleLabel.snp.bottom).offset(25)
            $0.left.equalTo(majorTitleLabel.snp.left)
        }
        firstMajorTextField.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(firstMajorLabel.snp.bottom).offset(15)
            $0.left.equalTo(firstMajorLabel.snp.left)
        }
        
        secondMajorLabel.snp.makeConstraints {
            $0.top.equalTo(firstMajorTextField.snp.bottom).offset(30)
            $0.left.equalTo(firstMajorTextField.snp.left)
        }
        secondMajorTextField.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(secondMajorLabel.snp.bottom).offset(15)
            $0.left.equalTo(secondMajorLabel.snp.left)
            $0.right.equalTo(firstMajorTextField.snp.right)
        }
        
    }
    
    @objc func didTapKeyboardOutSide() {
        firstMajorTextField.resignFirstResponder()
        secondMajorTextField.resignFirstResponder()
    }
    
}
