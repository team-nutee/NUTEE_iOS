//
//  LoginCVCell.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class PasswordVC: UIViewController {
    
    // MARK: - UI components
    
    // 로그인 화면
    let closeButton = HighlightedButton()
    
    let progressView = UIProgressView()
    
    let guideLabel = UILabel()
    
    let passwordTitleLabel = UILabel()
    let passwordTextField = UITextField()
    let passwordIndicatorLabel = UILabel()
    
    let passwordCheckTitleLabel = UILabel()
    let passwordCheckTextField = UITextField()
    let passwordCheckLabel = UILabel()
    
    let agreeTermsAndConditionsButton = HighlightedButton()
    let showTermsAndConditionsButton = HighlightedButton()
    
    let previousButton = HighlightedButton()
    let doneButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var userId: String = ""
    var nickname: String = ""
    var email: String = ""
    var otp: String = ""
    
    var animationDuration: TimeInterval = 1.4
    let xPosAnimationRange: CGFloat = 50
    let yPosAnimationRange: CGFloat = 50
    
    var isAgree = false
    
    var previousButtonBottomConstraint: Constraint?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
        addKeyboardNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        enterPasswordVCAnimate()
    }
    
    // MARK: - Helper
    
    func initView() {
        
        _ = view.then {
            $0.backgroundColor = .white
            $0.tintColor = .nuteeGreen
        }
        
        _ = closeButton.then {
            $0.setTitle("닫기", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            $0.alpha = 0
        }
        
        _ = progressView.then {
            $0.progressViewStyle = .bar
            $0.tintColor = .nuteeGreen
            $0.progress = 3/4
        }
        
        _ = guideLabel.then {
            $0.text = "다 왔어요!! 😄 비밀번호를 입력해주세요!!"
            $0.font = .boldSystemFont(ofSize: 20)
            
            $0.alpha = 0
        }
        
        _ = passwordTitleLabel.then {
            $0.text = "비밀번호"
            $0.font = .systemFont(ofSize: 17)
            
            $0.alpha = 0
        }
        _ = passwordTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "대소문자 및 숫자 포함 최소 8자 이상"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        }
        _ = passwordIndicatorLabel.then {
            $0.text = "errorConditionArea"
            $0.font = .systemFont(ofSize: 11)
            
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
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.keyboardType = .numberPad
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        }
        _ = passwordCheckLabel.then {
            $0.text = "passwordAvailableLabel"
            $0.font = .systemFont(ofSize: 11)
            
            $0.alpha = 0
        }
        
        _ = agreeTermsAndConditionsButton.then {
            $0.setTitle("[필수] 이용약관 및 개인정보 수집 및 이용에 동의", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 11)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            didTapAgreeTermsAndConditionsButton()
            
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
        
        _ = previousButton.then {
            $0.setTitle("이전", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        }
        _ = doneButton.then {
            $0.setTitle("완료", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.isEnabled = false
            $0.setTitleColor(.veryLightPink, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        }
        
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(closeButton)
        
        view.addSubview(progressView)
        
        view.addSubview(guideLabel)
        
        view.addSubview(passwordTitleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordIndicatorLabel)
        
        view.addSubview(passwordCheckTitleLabel)
        view.addSubview(passwordCheckTextField)
        view.addSubview(passwordCheckLabel)
        
        view.addSubview(agreeTermsAndConditionsButton)
        view.addSubview(showTermsAndConditionsButton)
        
        view.addSubview(previousButton)
        view.addSubview(doneButton)
        
        
        // Make Constraints
        closeButton.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(closeButton.snp.width)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(20)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(35 - yPosAnimationRange)
            $0.left.equalTo(closeButton.snp.left)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
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
        passwordCheckLabel.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(3)
            $0.left.equalTo(passwordCheckTextField.snp.left)
            $0.right.equalTo(passwordCheckTextField.snp.right)
        }
        
        agreeTermsAndConditionsButton.snp.makeConstraints {
            $0.top.equalTo(passwordCheckLabel).offset(40)
            $0.left.equalTo(passwordCheckTextField.snp.left)
        }
        showTermsAndConditionsButton.snp.makeConstraints {
            $0.centerY.equalTo(agreeTermsAndConditionsButton)
            $0.left.equalTo(agreeTermsAndConditionsButton.snp.right).offset(10)
            $0.right.equalTo(passwordCheckTextField.snp.right)
        }
        
        previousButton.snp.makeConstraints {
            $0.width.equalTo(view.frame.size.width / 2.0)
            $0.height.equalTo(50)
            
            $0.left.equalTo(view.snp.left)
            previousButtonBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
        }
        doneButton.snp.makeConstraints {
            $0.width.equalTo(previousButton.snp.width)
            $0.height.equalTo(previousButton.snp.height)
            
            $0.centerY.equalTo(previousButton)
            $0.left.equalTo(previousButton.snp.right)
        }
        
    }
    
    @objc func didTapCloseButton() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAgreeTermsAndConditionsButton() {
        if isAgree == true {
            agreeTermsAndConditionsButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        } else {
            agreeTermsAndConditionsButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        isAgree = !isAgree
    }
    
    @objc func didTapPreviousButton() {
        self.modalTransitionStyle = .crossDissolve
        
        dismiss(animated: true)
    }
    
    @objc func didTapShowTermsAndConditionsButton(){
        let termsAndConditionsSB = UIStoryboard(name: "TermsAndConditions", bundle: nil)
        let termsAndConditionsVC = termsAndConditionsSB.instantiateViewController(withIdentifier: "TermsAndConditions") as! TermsAndConditionsVC
        
        
        
        let navigationController = UINavigationController(rootViewController: termsAndConditionsVC)
        
//        navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "동의", style: .plain, target: self, action: #selector(didTapAgreeButton))
//        navigationController.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: 18, NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
        
//        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
    
    @objc func didTapDoneButton() {
        //signUpService(<#T##userId: String##String#>, <#T##nickname: String##String#>, <#T##email: String##String#>, <#T##password: String##String#>, otp: <#T##String#>, interests: <#T##[String]#>, majors: <#T##[String]#>)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - TextField Delegate

extension PasswordVC : UITextFieldDelegate {
  
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        
        if passwordTextField.text == "" || passwordTextField.text != "" && passwordTextField.text?.validatePassword() == true {
            successAnimate(targetTextField: passwordTextField, successMessage: "")
            
        } else if passwordTextField.text != "" && passwordTextField.text?.validatePassword() == false {
            errorAnimate(targetTextField: passwordTextField, errorMessage: "8자 이상의 영어 대문자, 소문자, 숫자가 포함된 비밀번호를 입력해주세요")
        }
        
        
        if passwordCheckTextField.text != passwordTextField.text && passwordCheckTextField.text != ""  {
            errorAnimate(targetTextField: passwordCheckTextField, errorMessage: "비밀번호를 확인해주세요")
            
        } else if passwordCheckTextField.text != "" && passwordCheckTextField.text?.validatePassword() == true {
            successAnimate(targetTextField: passwordCheckTextField, successMessage: "비밀번호가 확인되었습니다")
            if isAgree {
                doneButton.isEnabled = true
                doneButton.setTitleColor(.nuteeGreen, for: .normal)
            } else {
                doneButton.isEnabled = false
                doneButton.setTitleColor(.veryLightPink, for: .normal)
            }
        }
        
    }
    
}

// MARK: - passwordVC Animation

extension PasswordVC {
    
    private func enterPasswordVCAnimate() {
        
        // guide title
        UIView.animate(withDuration: animationDuration,
                       delay: 1,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.guideLabel.alpha = 1
                        self.guideLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
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
                        
                        self.passwordCheckTitleLabel.alpha = 1
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
                        self.passwordIndicatorLabel.alpha = 0
                        self.passwordIndicatorLabel.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.passwordCheckTextField.alpha = 1
                        self.passwordCheckTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        self.passwordCheckLabel.alpha = 0
                        self.passwordCheckLabel.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.agreeTermsAndConditionsButton.alpha = 1
                        self.agreeTermsAndConditionsButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.showTermsAndConditionsButton.alpha = 1
                        self.showTermsAndConditionsButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
        })
        
        // progressView
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.progressView.setProgress(4/4, animated: true)

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
            _ = passwordCheckLabel.then {
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
                            self.passwordCheckLabel.alpha = 1
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
            _ = passwordCheckLabel.then {
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
                            self.passwordCheckLabel.transform = CGAffineTransform.init(translationX: 5 - self.xPosAnimationRange, y: 0)
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
                            self.passwordCheckLabel.transform = CGAffineTransform.init(translationX: -5 - self.xPosAnimationRange, y: 0)
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
                            self.passwordCheckLabel.transform = CGAffineTransform.init(translationX: 0 - self.xPosAnimationRange, y: 0)
                        }
        })
    }
    
}

// MARK: - Keyboard

extension PasswordVC {
    
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
            let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
            let bottomPadding = keyWindow?.safeAreaInsets.bottom
            
            previousButtonBottomConstraint?.layoutConstraints[0].constant = -(keyboardHeight - (bottomPadding ?? 0))
            
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
            
            previousButtonBottomConstraint?.layoutConstraints[0].constant = 0
            self.view.setNeedsLayout()
            UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
    
// MARK: - Server connect

extension PasswordVC {
    
    func error() {
        self.errorAnimate(targetTextField: passwordTextField, errorMessage: "에러로 인해 회원가입이 진행되지 않았습니다")
        self.errorAnimate(targetTextField: passwordCheckTextField, errorMessage: "에러로 인해 회원가입이 진행되지 않았습니다.")
    }
    
    func signUpService(_ userId: String, _ nickname: String, _ email: String, _ password: String) {
        UserService.shared.signUp(userId, nickname, email, password, otp) { responsedata in
            
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
