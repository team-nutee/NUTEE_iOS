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
    
    let saveButton = HighlightedButton()
    
    let currentPasswordTitleLabel = UILabel()
    let currentPasswordTextField = UITextField()
    let currentPasswordIndicatorLabel = UILabel()
    
    let newPasswordTitleLabel = UILabel()
    let newPasswordTextField = UITextField()
    let newPasswordIndicatorLabel = UILabel()
    
    let newPasswordCheckTitleLabel = UILabel()
    let newPasswordCheckTextField = UITextField()
    let newPasswordCheckIndicatorLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    let titleLabelFontSize: CGFloat = 17
    let textFieldFontSize: CGFloat = 14
    let indicatorLabelFontSize: CGFloat = 11
    
    let checkPasswordStatusLabelSize: CGFloat = 11.0
    
    let animationDuration: TimeInterval = 1.4
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
        view.backgroundColor = .white
        view.tintColor = .nuteeGreen
        
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
        
        _ = currentPasswordTitleLabel.then {
            commonLabelSetting(targetLabel: $0, title: "현재 비밀번호", fontSize: titleLabelFontSize, alpha: 1)
        }
        _ = currentPasswordTextField.then {
            commonTextFieldSetting(targetTextField: $0, fontSize: textFieldFontSize, placeholder: "현재 비밀번호")
        }
        _ = currentPasswordIndicatorLabel.then {
            commonLabelSetting(targetLabel: $0, title: "errorConditionArea", fontSize: indicatorLabelFontSize, alpha: 0)
        }
        
        _ = newPasswordTitleLabel.then {
            commonLabelSetting(targetLabel: $0, title: "새 비밀번호", fontSize: titleLabelFontSize, alpha: 1)
        }
        _ = newPasswordTextField.then {
            commonTextFieldSetting(targetTextField: $0, fontSize: textFieldFontSize, placeholder: "대소문자 및 숫자 포함 최소 8자 이상")
        }
        _ = newPasswordIndicatorLabel.then {
            commonLabelSetting(targetLabel: $0, title: "errorConditionArea", fontSize: indicatorLabelFontSize, alpha: 0)
        }
        
        _ = newPasswordCheckTitleLabel.then {
            commonLabelSetting(targetLabel: $0, title: "새 비밀번호 확인", fontSize: titleLabelFontSize, alpha: 1)
        }
        _ = newPasswordCheckTextField.then {
            commonTextFieldSetting(targetTextField: $0, fontSize: textFieldFontSize, placeholder: "비밀번호 확인")
            
            $0.isEnabled = false
            textFieldDidChange($0)
        }
        _ = newPasswordCheckIndicatorLabel.then {
            commonLabelSetting(targetLabel: $0, title: "passwordAvailableLabel", fontSize: indicatorLabelFontSize, alpha: 0)
        }
    }
    
    func addSubView() {
        view.addSubview(saveButton)
        
        view.addSubview(currentPasswordTitleLabel)
        view.addSubview(currentPasswordTextField)
        view.addSubview(currentPasswordIndicatorLabel)
        
        view.addSubview(newPasswordTitleLabel)
        view.addSubview(newPasswordTextField)
        view.addSubview(newPasswordIndicatorLabel)
        
        view.addSubview(newPasswordCheckTitleLabel)
        view.addSubview(newPasswordCheckTextField)
        view.addSubview(newPasswordCheckIndicatorLabel)
        
        
        saveButton.snp.makeConstraints {
            $0.width.equalTo(saveButton.intrinsicContentSize.width)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(currentPasswordTitleLabel)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        currentPasswordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(45)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        currentPasswordTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(currentPasswordTitleLabel.snp.bottom)
            $0.left.equalTo(currentPasswordTitleLabel.snp.left)
            $0.right.equalTo(saveButton.snp.left).inset(-10)
        }
        currentPasswordIndicatorLabel.snp.makeConstraints {
            $0.height.equalTo(checkPasswordStatusLabelSize)
            
            $0.top.equalTo(currentPasswordTextField.snp.bottom).offset(3)
            $0.left.equalTo(currentPasswordTextField.snp.left)
            $0.right.equalTo(currentPasswordTextField.snp.right)
        }
        
        newPasswordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(currentPasswordTextField.snp.bottom).offset(30)
            $0.left.equalTo(currentPasswordTitleLabel.snp.left)
        }
        newPasswordTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(newPasswordTitleLabel.snp.bottom)
            $0.left.equalTo(newPasswordTitleLabel.snp.left)
            $0.right.equalTo(saveButton.snp.left).inset(-10)
        }
        newPasswordIndicatorLabel.snp.makeConstraints {
            $0.height.equalTo(checkPasswordStatusLabelSize)
            
            $0.top.equalTo(newPasswordTextField.snp.bottom).offset(3)
            $0.left.equalTo(newPasswordTextField.snp.left)
//            $0.right.equalTo(newPasswordTextField.snp.right)
            $0.right.equalTo(saveButton.snp.right)
        }
        
        newPasswordCheckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(newPasswordTextField.snp.bottom).offset(30)
            $0.left.equalTo(newPasswordTitleLabel.snp.left)
        }
        newPasswordCheckTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(newPasswordCheckTitleLabel.snp.bottom)
            $0.left.equalTo(newPasswordTextField.snp.left)
            $0.right.equalTo(newPasswordTextField.snp.right)
        }
        newPasswordCheckIndicatorLabel.snp.makeConstraints {
            $0.top.equalTo(newPasswordCheckTextField.snp.bottom).offset(3)
            $0.left.equalTo(newPasswordCheckTextField.snp.left)
            $0.right.equalTo(newPasswordCheckTextField.snp.right)
        }
    }
    
    func commonLabelSetting(targetLabel: UILabel, title: String, fontSize: CGFloat, alpha: CGFloat) {
        _ = targetLabel.then {
            $0.text = title
            $0.font = .systemFont(ofSize: fontSize)
            
            $0.alpha = alpha
        }
    }
    
    func commonTextFieldSetting(targetTextField: UITextField, fontSize: CGFloat, placeholder: String) {
        _ = targetTextField.then {
            $0.text = title
            $0.font = .systemFont(ofSize: fontSize)
            
            $0.isSecureTextEntry = true
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            $0.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        }
    }
    
    @objc func didTapKeyboardOutSide() {
        view.endEditing(true)
    }
    
    @objc func didTapSaveButton() {
        changePwService(currentPw: currentPasswordTextField.text ?? "", changePw: newPasswordTextField.text ?? "")
        simpleNuteeAlertDialogue(title: "비밀번호 변경", message: "성공적으로 변경되었습니다")
        saveButton.isEnabled = false
    }
    
}

// MARK: - TextField Delegate

extension SettingPasswordVC : UITextFieldDelegate {
  
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 현재 비밀번호 입력 조건 충족
        if currentPasswordTextField.text?.validatePassword() == true {
            successAnimate(targetTextField: currentPasswordTextField, successMessage: "")
        }
        
        // 비밀번호 확인 TextField 입력 조건 확인
        if newPasswordTextField.text?.validatePassword() == true {
            newPasswordCheckTextField.isEnabled = true
            
            newPasswordCheckTitleLabel.alpha = 1.0
            newPasswordCheckTextField.alpha = 1.0
        } else {
            newPasswordCheckTextField.isEnabled = false
            newPasswordCheckTextField.text = ""
            
            newPasswordCheckTitleLabel.alpha = 0.5
            newPasswordCheckTextField.alpha = 0.5
            
            successAnimate(targetTextField: newPasswordCheckTextField, successMessage: "")
            
            saveButton.isEnabled = false
        }
        
        // 비밀번호 입력창 모드
        if textField == self.newPasswordTextField {
            // 빈칸일 시 일반 초록 창 표시
            if newPasswordTextField.text == "" {
                successAnimate(targetTextField: newPasswordTextField, successMessage: "")
            }
        }
        
        // 비밀번호 확인 입력창 모드
        if textField == self.newPasswordCheckTextField {
            if newPasswordCheckTextField.text?.validatePassword() == true && newPasswordCheckTextField.text == newPasswordTextField.text {
                successAnimate(targetTextField: newPasswordCheckTextField, successMessage: "비밀번호가 확인되었습니다")
                
            } else {
                successAnimate(targetTextField: newPasswordCheckTextField, successMessage: "")
                
                saveButton.isEnabled = false
            }
        }
        
        // 저장하기 버튼 활성화 조건
        if currentPasswordTextField.text?.validatePassword() == true && newPasswordCheckTextField.text?.validatePassword() == true && newPasswordCheckTextField.text == newPasswordTextField.text {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 현재 비밀번호 입력창
        if currentPasswordTextField.text?.validatePassword() == true {
            successAnimate(targetTextField: currentPasswordTextField, successMessage: "")
        } else {
            errorAnimate(targetTextField: currentPasswordTextField, errorMessage: "")
        }
        
        // 비밀번호 입력창 모드
        if textField == self.newPasswordTextField {
            if newPasswordTextField.text != "" && newPasswordTextField.text?.validatePassword() == false {
                errorAnimate(targetTextField: textField, errorMessage: "8자 이상의 영어 대문자, 소문자, 숫자가 포함된 비밀번호")
            }
            if newPasswordCheckTextField.text != "" {
                if newPasswordTextField.text?.validatePassword() == false || newPasswordCheckTextField.text != newPasswordTextField.text {
                    errorAnimate(targetTextField: newPasswordCheckTextField, errorMessage: "비밀번호를 확인해주세요")
                }
            }
        }
        
        // 비밀번호 확인 입력창 모드
        if textField == self.newPasswordCheckTextField {
            if newPasswordCheckTextField.text != "" {
                if newPasswordTextField.text?.validatePassword() == false || newPasswordCheckTextField.text != newPasswordTextField.text {
                    errorAnimate(targetTextField: newPasswordCheckTextField, errorMessage: "비밀번호를 확인해주세요")
                }
            }
        }
    }
    
}

// MARK: - SettingPasswordVC Animation

extension SettingPasswordVC {
    
    private func successAnimate(targetTextField: UITextField, successMessage: String) {
        targetTextField.addBorder(.bottom, color: .nuteeGreen, thickness: 1)

        if targetTextField == self.newPasswordTextField {
            _ = newPasswordIndicatorLabel.then {
                $0.text = successMessage
                $0.textColor = .nuteeGreen
                $0.alpha = 0
            }
        } else {
            _ = newPasswordCheckIndicatorLabel.then {
                $0.text = successMessage
                $0.textColor = .nuteeGreen
                $0.alpha = 0
            }
        }

        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        if targetTextField == self.newPasswordTextField {
                            self.newPasswordIndicatorLabel.alpha = 0
                        } else {
                            self.newPasswordCheckIndicatorLabel.alpha = 1
                        }
        })
    }

    private func errorAnimate(targetTextField: UITextField, errorMessage: String) {
        let errorColor = UIColor(red: 255, green: 67, blue: 57)

        targetTextField.addBorder(.bottom, color: errorColor, thickness: 1)

        if targetTextField == self.newPasswordTextField {
            _ = newPasswordIndicatorLabel.then {
                $0.text = errorMessage
                $0.textColor = errorColor
                $0.alpha = 1
            }
        } else {
            _ = newPasswordCheckIndicatorLabel.then {
                $0.text = errorMessage
                $0.textColor = errorColor
                $0.alpha = 1
            }
        }

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        if targetTextField == self.newPasswordTextField {
                            self.newPasswordIndicatorLabel.transform = CGAffineTransform.init(translationX: 5, y: 0)
                        } else {
                            self.newPasswordCheckIndicatorLabel.transform = CGAffineTransform.init(translationX: 5, y: 0)
                        }
        })
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        if targetTextField == self.newPasswordTextField {
                            self.newPasswordIndicatorLabel.transform = CGAffineTransform.init(translationX: -5, y: 0)
                        } else {
                            self.newPasswordCheckIndicatorLabel.transform = CGAffineTransform.init(translationX: -5, y: 0)
                        }
        })
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        if targetTextField == self.newPasswordTextField {
                            self.newPasswordIndicatorLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
                        } else {
                            self.newPasswordCheckIndicatorLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
                        }
        })
    }
    
}

// MARK: - Server connect

extension SettingPasswordVC {
    func changePwService(currentPw: String, changePw: String) {
        UserService.shared.changePassword(currentPw, changePw){
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
