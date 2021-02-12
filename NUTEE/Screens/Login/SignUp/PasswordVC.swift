//
//  LoginCVCell.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class PasswordVC: SignUpViewController {
    
    // MARK: - UI components
    
    let passwordTitleLabel = UILabel()
    let passwordTextField = UITextField()
    let passwordIndicatorLabel = UILabel()
    
    let passwordCheckTitleLabel = UILabel()
    let passwordCheckTextField = UITextField()
    let passwordCheckIndicatorLabel = UILabel()
    
    let agreeTermsAndConditionsButton = HighlightedButton()
    let showTermsAndConditionsButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var userId: String = ""
    var nickname: String = ""
    var email: String = ""
    var otp: String = ""
    var interests: [String] = []
    var majors: [String] = []
    
    var checkPasswordStatusLabelSize: CGFloat = 11.0
    
    var isAgree = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
        addKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        enterPasswordVCAnimate()
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = guideLabel.then {
            $0.text = "다 왔어요!! 😄 비밀번호를 입력해주세요!!"
        }
        
        _ = passwordTitleLabel.then {
            $0.text = "비밀번호"
            $0.font = .systemFont(ofSize: 17)
            
            $0.alpha = 0
        }
        _ = passwordTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "대소문자 및 숫자 포함 최소 8자 이상"
            $0.isSecureTextEntry = true
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
            $0.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        }
        _ = passwordIndicatorLabel.then {
            $0.text = "errorConditionArea"
            $0.font = .systemFont(ofSize: checkPasswordStatusLabelSize)
            
            $0.alpha = 0
        }
        
        _ = passwordCheckTitleLabel.then {
            $0.text = "비밀번호 확인"
            $0.font = .systemFont(ofSize: 17)
            
            $0.alpha = 0
        }
        _ = passwordCheckTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "비밀번호"
            $0.isSecureTextEntry = true
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.isEnabled = false
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
            $0.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        }
        _ = passwordCheckIndicatorLabel.then {
            $0.text = "passwordAvailableLabel"
            $0.font = .systemFont(ofSize: checkPasswordStatusLabelSize)
            
            $0.alpha = 0
        }
        
        _ = agreeTermsAndConditionsButton.then {
            $0.setTitle("[필수] 이용약관 및 개인정보 수집 및 이용에 동의", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 11)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            isAgree = true
            didTapAgreeTermsAndConditionsButton() // 약관 동의 상태를 false로 만들어주기 위한 작업
            
            $0.contentHorizontalAlignment = .left
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(didTapAgreeTermsAndConditionsButton), for: .touchUpInside)
        }
        _ = showTermsAndConditionsButton.then {
            $0.setTitle("약관보기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 11)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(didTapShowTermsAndConditionsButton), for: .touchUpInside)
        }
        
        _ = nextButton.then {
            $0.setTitle("완료", for: .normal)
            
            $0.alpha = 0
        }
        
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(passwordTitleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordIndicatorLabel)
        
        view.addSubview(passwordCheckTitleLabel)
        view.addSubview(passwordCheckTextField)
        view.addSubview(passwordCheckIndicatorLabel)
        
        view.addSubview(agreeTermsAndConditionsButton)
        view.addSubview(showTermsAndConditionsButton)
        
        // Make Constraints
        passwordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(40)
            $0.left.equalTo(guideLabel.snp.left)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(passwordTitleLabel.snp.bottom).offset(yPosAnimationRange)
            $0.left.equalTo(passwordTitleLabel.snp.left).offset(xPosAnimationRange)
            $0.right.equalTo(view.snp.right).inset(20 - xPosAnimationRange)
        }
        passwordIndicatorLabel.snp.makeConstraints {
            $0.height.equalTo(checkPasswordStatusLabelSize)
            
            $0.top.equalTo(passwordTextField.snp.bottom).offset(3)
            $0.left.equalTo(passwordTextField.snp.left)
            $0.right.equalTo(passwordTextField.snp.right)
        }
        
        passwordCheckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(passwordIndicatorLabel.snp.bottom).offset(20 - yPosAnimationRange)
            $0.left.equalTo(passwordTitleLabel.snp.left)
        }
        passwordCheckTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(passwordCheckTitleLabel.snp.bottom).offset(yPosAnimationRange)
            $0.left.equalTo(passwordTextField.snp.left)
            $0.right.equalTo(passwordTextField.snp.right)
        }
        passwordCheckIndicatorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(3)
            $0.left.equalTo(passwordCheckTextField.snp.left)
            $0.right.equalTo(passwordCheckTextField.snp.right)
        }
        
        agreeTermsAndConditionsButton.snp.makeConstraints {
            $0.top.equalTo(passwordCheckIndicatorLabel).offset(40)
            $0.left.equalTo(passwordCheckTextField.snp.left)
        }
        showTermsAndConditionsButton.snp.makeConstraints {
            $0.centerY.equalTo(agreeTermsAndConditionsButton)
            $0.left.equalTo(agreeTermsAndConditionsButton.snp.right).offset(10)
            $0.right.equalTo(passwordCheckTextField.snp.right)
        }
    }
    
    @objc func didTapAgreeTermsAndConditionsButton() {
        isAgree = !isAgree
        
        if isAgree == true {
            agreeTermsAndConditionsButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            
            if passwordCheckTextField.text?.validatePassword() == true && passwordCheckTextField.text == passwordTextField.text {
                nextButton.isEnabled = true
                nextButton.setTitleColor(.nuteeGreen, for: .normal)
            }
        } else {
            agreeTermsAndConditionsButton.setImage(UIImage(systemName: "circle"), for: .normal)
            
            nextButton.isEnabled = false
            nextButton.setTitleColor(.veryLightPink, for: .normal)
        }
    }
    
    @objc func didTapConfirmButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapShowTermsAndConditionsButton(){
        let termsAndConditionsSB = UIStoryboard(name: "TermsAndConditions", bundle: nil)
        let termsAndConditionsVC = termsAndConditionsSB.instantiateViewController(withIdentifier: "TermsAndConditions") as! TermsAndConditionsVC
        termsAndConditionsVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(didTapConfirmButton))
        termsAndConditionsVC.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
        
        let navigationController = UINavigationController(rootViewController: termsAndConditionsVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
    
    @objc override func didTapNextButton() {
        let rootVC = view.window?.rootViewController
        self.view.window!.rootViewController?.dismiss(animated: true, completion: {
            rootVC?.simpleNuteeAlertDialogue(title: "회원가입 성공", message: "회원가입이 완료되었습니다😁")
        })
        
        //signUpService(<#T##userId: String##String#>, <#T##nickname: String##String#>, <#T##email: String##String#>, <#T##password: String##String#>, otp: <#T##String#>, interests: <#T##[String]#>, majors: <#T##[String]#>)
    }
    
}

// MARK: - TextField Delegate

extension PasswordVC : UITextFieldDelegate {
  
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        // 비밀번호 확인 TextField 입력 조건 확인
        if passwordTextField.text?.validatePassword() == true {
            passwordCheckTextField.isEnabled = true
            
            passwordCheckTitleLabel.alpha = 1.0
            passwordCheckTextField.alpha = 1.0
        } else {
            passwordCheckTextField.isEnabled = false
            passwordCheckTextField.text = ""
            
            passwordCheckTitleLabel.alpha = 0.5
            passwordCheckTextField.alpha = 0.5
            
            successAnimate(targetTextField: passwordCheckTextField, successMessage: "")
            
            nextButton.isEnabled = false
            nextButton.setTitleColor(.veryLightPink, for: .normal)
        }
        
        // 비밀번호 입력창 모드
        if textField == self.passwordTextField {
            // 빈칸일 시 일반 초록 창 표시
            if passwordTextField.text == "" {
                successAnimate(targetTextField: passwordTextField, successMessage: "")
            }
        }
        
        // 비밀번호 확인 입력창 모드
        if textField == self.passwordCheckTextField {
            if passwordCheckTextField.text?.validatePassword() == true && passwordCheckTextField.text == passwordTextField.text {
                successAnimate(targetTextField: passwordCheckTextField, successMessage: "비밀번호가 확인되었습니다")
                
                if isAgree == true {
                    nextButton.isEnabled = true
                    nextButton.setTitleColor(.nuteeGreen, for: .normal)
                }
            } else {
                successAnimate(targetTextField: passwordCheckTextField, successMessage: "")
                
                nextButton.isEnabled = false
                nextButton.setTitleColor(.veryLightPink, for: .normal)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 비밀번호 입력창 모드
        if textField == self.passwordTextField {
            if passwordTextField.text != "" && passwordTextField.text?.validatePassword() == false {
                errorAnimate(targetTextField: textField, errorMessage: "8자 이상의 영어 대문자, 소문자, 숫자가 포함된 비밀번호를 입력해주세요")
            }
            if passwordCheckTextField.text != "" {
                if passwordTextField.text?.validatePassword() == false || passwordCheckTextField.text != passwordTextField.text {
                    errorAnimate(targetTextField: passwordCheckTextField, errorMessage: "비밀번호를 확인해주세요")
                }
            }
        }
        
        // 비밀번호 확인 입력창 모드
        if textField == self.passwordCheckTextField {
            if passwordCheckTextField.text != "" {
                if passwordTextField.text?.validatePassword() == false || passwordCheckTextField.text != passwordTextField.text {
                    errorAnimate(targetTextField: passwordCheckTextField, errorMessage: "비밀번호를 확인해주세요")
                }
            }
        }
    }
    
}

// MARK: - PasswordVC Animation

extension PasswordVC {
    
    private func enterPasswordVCAnimate() {
        // next button title changed
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: { [self] in
                        self.nextButton.alpha = 1
        })
        
        // password title
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.passwordTitleLabel.alpha = 1
                        self.passwordTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
                        
                        self.passwordCheckTitleLabel.alpha = 0.5
                        self.passwordCheckTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
        })
        // insert password area
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4 + 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        
                        self.passwordTextField.alpha = 1
                        self.passwordTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
//                        self.passwordIndicatorLabel.alpha = 0
                        self.passwordIndicatorLabel.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.passwordCheckTextField.alpha = 0.5
                        self.passwordCheckTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
//                        self.passwordCheckIndicatorLabel.alpha = 0
                        self.passwordCheckIndicatorLabel.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.agreeTermsAndConditionsButton.alpha = 1
                        self.agreeTermsAndConditionsButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.showTermsAndConditionsButton.alpha = 1
                        self.showTermsAndConditionsButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
        })
    }
    
    private func successAnimate(targetTextField: UITextField, successMessage: String) {
        targetTextField.addBorder(.bottom, color: .nuteeGreen, thickness: 1)

        if targetTextField == self.passwordTextField {
            _ = passwordIndicatorLabel.then {
                $0.text = successMessage
                $0.textColor = .nuteeGreen
                $0.alpha = 0
            }
        } else {
            _ = passwordCheckIndicatorLabel.then {
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
                        if targetTextField == self.passwordTextField {
                            self.passwordIndicatorLabel.alpha = 0
                        } else {
                            self.passwordCheckIndicatorLabel.alpha = 1
                        }
        })
    }

    private func errorAnimate(targetTextField: UITextField, errorMessage: String) {
        let errorColor = UIColor(red: 255, green: 67, blue: 57)

        targetTextField.addBorder(.bottom, color: errorColor, thickness: 1)

        if targetTextField == self.passwordTextField {
            _ = passwordIndicatorLabel.then {
                $0.text = errorMessage
                $0.textColor = errorColor
                $0.alpha = 1
            }
        } else {
            _ = passwordCheckIndicatorLabel.then {
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
                        if targetTextField == self.passwordTextField {
                            self.passwordIndicatorLabel.transform = CGAffineTransform.init(translationX: 5 - self.xPosAnimationRange, y: 0)
                        } else {
                            self.passwordCheckIndicatorLabel.transform = CGAffineTransform.init(translationX: 5 - self.xPosAnimationRange, y: 0)
                        }
        })
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        if targetTextField == self.passwordTextField {
                            self.passwordIndicatorLabel.transform = CGAffineTransform.init(translationX: -5 - self.xPosAnimationRange, y: 0)
                        } else {
                            self.passwordCheckIndicatorLabel.transform = CGAffineTransform.init(translationX: -5 - self.xPosAnimationRange, y: 0)
                        }
        })
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        if targetTextField == self.passwordTextField {
                            self.passwordIndicatorLabel.transform = CGAffineTransform.init(translationX: 0 - self.xPosAnimationRange, y: 0)
                        } else {
                            self.passwordCheckIndicatorLabel.transform = CGAffineTransform.init(translationX: 0 - self.xPosAnimationRange, y: 0)
                        }
        })
    }
    
}

// MARK: - Server connect

extension PasswordVC {
    
    func error() {
        self.errorAnimate(targetTextField: passwordTextField, errorMessage: "에러로 인해 회원가입이 진행되지 않았습니다")
        self.errorAnimate(targetTextField: passwordCheckTextField, errorMessage: "에러로 인해 회원가입이 진행되지 않았습니다.")
    }
    
    func signUpService(_ userId: String, _ nickname: String, _ email: String, _ password: String, _ otp: String) {
        UserService.shared.signUp(userId, nickname, email, password, otp, interests, majors) { responsedata in
            
            switch responsedata {
            
            // NetworkResult 의 요소들
            case .success(_):
                let rootVC = self.view.window?.rootViewController
                self.view.window!.rootViewController?.dismiss(animated: true, completion: {
                    rootVC?.simpleNuteeAlertDialogue(title: "회원가입", message: "회원가입이 완료되었습니다😃")
                })
                
            case .requestErr(_):
                self.error()
                
            case .pathErr:
                self.error()
                print(".pathErr")
                
            case .serverErr:
                self.error()
                print(".serverErr")
                
            case .networkFail :
                self.error()
                print("failure")
            }
        }
    }
    
}
