//
//  SettingNicknameVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/11.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingNicknameVC: UIViewController {
    
    // MARK: - UI components
    
    let saveButton = HighlightedButton()
    
    let nicknameLabel = UILabel()
    let nicknameTextField = UITextField()
    let nicknameIndicatorLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    var originalNickname: String?
    
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
        _ = saveButton.then {
            $0.setTitle("저장하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
            $0.setTitleColor(.black, for: .normal)
            
            $0.isEnabled = false
            
            $0.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        }
        
        _ = nicknameLabel.then {
            $0.text = originalNickname
            $0.font = .systemFont(ofSize: 17)
            $0.sizeToFit()
        }
        _ = nicknameTextField.then {
            $0.placeholder = "변경할 닉네임을 입력해 주세요"
            $0.font = .systemFont(ofSize: 14)
            
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
            
            $0.addTarget(self, action: #selector(SettingNicknameVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
        _ = nicknameIndicatorLabel.then {
            $0.text = "nicknameErrorIndicatorArea"
            $0.font = .systemFont(ofSize: 11)
            
            $0.alpha = 0
        }
    }
    
    func addSubView() {
        
        view.addSubview(saveButton)
        
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameIndicatorLabel)
        
        saveButton.snp.makeConstraints {
            $0.width.equalTo(saveButton.intrinsicContentSize.width)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(nicknameLabel)
            $0.left.equalTo(nicknameTextField.snp.right).offset(5)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(45)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        nicknameTextField.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(15)
            $0.left.equalTo(nicknameLabel.snp.left)
        }
        nicknameIndicatorLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.left.equalTo(nicknameTextField.snp.left)
            $0.right.equalTo(nicknameTextField.snp.right)
        }
    }
    
    @objc func didTapKeyboardOutSide() {
        nicknameTextField.resignFirstResponder()
    }
    
    @objc func didTapSaveButton() {
        changeNicknameService(nickname: nicknameTextField.text ?? "")
        self.simpleNuteeAlertDialogue(title: "닉네임 변경", message: "성공적으로 변경되었습니다")
        self.nicknameLabel.text = self.nicknameTextField.text ?? ""
        self.saveButton.isEnabled = false
    }
    
    func checkSaveButtonEnableCondition() {
        if nicknameTextField.text?.nicknameLimitation() == true {
            successAnimate(targetTextField: nicknameTextField, errorMessage: "")
            saveButton.isEnabled = true
        } else {
            errorAnimate(targetTextField: nicknameTextField, errorMessage: "최대 12자 사용가능")
            saveButton.isEnabled = false
        }
    }
    
}

// MARK: - TextField Delegate

extension SettingNicknameVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkSaveButtonEnableCondition()
    }
    
}

// MARK: - SettingNicknameVC Animation

extension SettingNicknameVC {
    
    func errorAnimate(targetTextField: UITextField, errorMessage: String) {
        let errorColor = UIColor(red: 255, green: 67, blue: 57)

        targetTextField.addBorder(.bottom, color: errorColor, thickness: 1)
    
        _ = nicknameIndicatorLabel.then {
            $0.text = errorMessage
            $0.textColor = errorColor
            $0.alpha = 1
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: [.curveEaseIn], animations: {
            self.nicknameIndicatorLabel.transform = CGAffineTransform.init(translationX: 2, y: 0)
        })
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: [.curveEaseIn], animations: {
            self.nicknameIndicatorLabel.transform = CGAffineTransform.init(translationX: -2, y: 0)
        })
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: [.curveEaseIn], animations: {
            self.nicknameIndicatorLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
        })
    }
    
    func successAnimate(targetTextField: UITextField, errorMessage: String) {
        targetTextField.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
    
        _ = nicknameIndicatorLabel.then {
            $0.text = ""
            $0.alpha = 0
        }
    }
    
}

// MARK: - Server connect

extension SettingNicknameVC {
    func changeNicknameService(nickname: String) {
        UserService.shared.changeNickname(nickname){
            [weak self]
            data in
            
            guard let `self` = self else { return }

            switch data {
            case .success(_ ):
                self.dismiss(animated: true, completion: nil)

            case .requestErr:
                print("requestErr")

            case .pathErr:
                print(".pathErr")

            case .serverErr:
                print(".serverErr")

            case .networkFail:
                print(".networkFail")


            }
        }
    }
}
