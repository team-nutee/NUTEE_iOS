//
//  LoginCVCell.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class EmailVC: UIViewController {
    
    // MARK: - UI components
    
    // 로그인 화면
    let closeButton = HighlightedButton()
    
    let progressView = UIProgressView()
    
    let guideLabel = UILabel()
    
    let emailTitleLabel = UILabel()
    let emailTextField = UITextField()
    let certificationButton = HighlightedButton()
    let certificationResultLabel = UILabel()
    
    let certificationNumberTextField = UITextField()
    let confirmButton = HighlightedButton()
    let comfirmResultLabel = UILabel()
    
    let nextButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var animationDuration: TimeInterval = 1.4
    let xPosAnimationRange: CGFloat = 50
    let yPosAnimationRange: CGFloat = 50
    
    var nextButtonBottomConstraint: Constraint?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
        addKeyboardNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        enterEmailVCAnimate()
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
            
            $0.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        }
        
        _ = progressView.then {
            $0.progressViewStyle = .bar
            $0.tintColor = .nuteeGreen
            $0.progress = 0/4
        }
        
        _ = guideLabel.then {
            $0.text = "인증을 위해 학교 이메일이 필요해요! 😄"
            $0.font = .boldSystemFont(ofSize: 20)
            
            $0.alpha = 0
        }
        
        _ = emailTitleLabel.then {
            $0.text = "이메일"
            $0.font = .systemFont(ofSize: 17)
            
            $0.alpha = 0
        }
        _ = emailTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "email@office.skhu.ac.kr"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(emailemailTextFieldDidChange(_:)), for: .editingChanged)
        }
        _ = certificationButton.then {
            $0.setTitle("인증하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.alpha = 0
            $0.isEnabled = false
            $0.setTitleColor(.veryLightPink, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapCertificationButton), for: .touchUpInside)
        }
        _ = certificationResultLabel.then {
            $0.text = "errorStatusArea"
            $0.font = .systemFont(ofSize: 11)
            
            $0.alpha = 0
        }
        
        _ = certificationNumberTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "인증번호"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.keyboardType = .numberPad
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(certificationNumberTextFieldDidChange(_:)), for: .editingChanged)
        }
        _ = confirmButton.then {
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.alpha = 0
            $0.isEnabled = false
            $0.setTitleColor(.veryLightPink, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        }
        _ = comfirmResultLabel.then {
            $0.text = "otpCheckLabel"
            $0.font = .systemFont(ofSize: 11)
            
            $0.alpha = 0
        }
        
        _ = nextButton.then {
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.isEnabled = false
            $0.setTitleColor(.veryLightPink, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        }
        
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(closeButton)
        
        view.addSubview(progressView)
        
        view.addSubview(guideLabel)
        
        view.addSubview(emailTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(certificationButton)
        view.addSubview(certificationResultLabel)
        
        view.addSubview(certificationNumberTextField)
        view.addSubview(confirmButton)
        view.addSubview(comfirmResultLabel)
        
        view.addSubview(nextButton)
        
        
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
        
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(40)
            $0.left.equalTo(guideLabel.snp.left)
        }
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(5 + yPosAnimationRange)
            $0.left.equalTo(emailTitleLabel.snp.left).offset(xPosAnimationRange)
        }
        certificationButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(emailTextField)
            $0.left.equalTo(emailTextField.snp.right).offset(10)
            $0.right.equalTo(view.snp.right).inset(15 - xPosAnimationRange)
        }
        certificationResultLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(3)
            $0.left.equalTo(emailTextField.snp.left)
            $0.right.equalTo(emailTextField.snp.right)
        }
        
        certificationNumberTextField.snp.makeConstraints {
            $0.width.equalTo(emailTextField.snp.width)
            $0.height.equalTo(40)
            
            $0.top.equalTo(certificationResultLabel.snp.bottom).offset(10)
            $0.left.equalTo(emailTextField.snp.left)
        }
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(certificationButton.snp.width)
            $0.height.equalTo(certificationButton.snp.height)
            
            $0.centerY.equalTo(certificationNumberTextField)
            $0.left.equalTo(certificationNumberTextField.snp.right).offset(10)
        }
        comfirmResultLabel.snp.makeConstraints {
            $0.top.equalTo(certificationNumberTextField.snp.bottom).offset(3)
            $0.left.equalTo(certificationNumberTextField.snp.left)
            $0.right.equalTo(certificationNumberTextField.snp.right)
        }
        
        nextButton.snp.makeConstraints {
            $0.width.equalTo(view.frame.size.width / 2.0)
            $0.height.equalTo(50)
            
            $0.right.equalTo(view.snp.right)
            nextButtonBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
        }
        
    }
    
    @objc func didTapCloseButton() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapCertificationButton() {
        sendOTP(emailTextField.text ?? "")
    }
    
    @objc func didTapConfirmButton() {
        errorAnimate(targetTextField: certificationNumberTextField, errorMessage: "인증번호가 틀렸습니다")
        errorAnimate(targetTextField: emailTextField, errorMessage: "이미 인증된 이메일입니다")
    }
    
    @objc func didTapNextButton() {
        emailTextField.resignFirstResponder()
        certificationNumberTextField.resignFirstResponder()
        
        let idVC = IDVC()
        idVC.modalPresentationStyle = .fullScreen
        
        present(idVC, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - TextField Delegate

extension EmailVC : UITextFieldDelegate {
  
    @objc func emailemailTextFieldDidChange(_ textField: UITextField) {
        
        if emailTextField.text != "" {
            certificationButton.isEnabled = true
            certificationButton.setTitleColor(.nuteeGreen, for: .normal)
            
        } else if emailTextField.text == "" {
            certificationButton.isEnabled = false
            certificationButton.setTitleColor(.veryLightPink, for: .normal)

        }
        
    }
    
    @objc func certificationNumberTextFieldDidChange(_ textField: UITextField) {
        
        if certificationNumberTextField.text != "" {
            confirmButton.isEnabled = true
            confirmButton.setTitleColor(.nuteeGreen, for: .normal)
            
        } else if certificationNumberTextField.text == "" {
            confirmButton.isEnabled = false
            confirmButton.setTitleColor(.veryLightPink, for: .normal)
        }
    }
    
}


// MARK: - EmailVC Animation

extension EmailVC {
    
    private func enterEmailVCAnimate() {
        
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
        
        // email title
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.emailTitleLabel.alpha = 1
                        self.emailTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
        })
        // insert email address area
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4 + 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        
                        self.emailTextField.alpha = 1
                        self.emailTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.certificationButton.alpha = 1
                        self.certificationButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.certificationResultLabel.transform = CGAffineTransform.init(translationX: -50, y: 0)
        })
        
        // progressView
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.progressView.setProgress(1/4, animated: true)

        })
    }
    
    private func certificationAnimate() {
   
        // insert certificate code area
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.successAnimate(targetTextField: self.emailTextField, successMessage: "해당 이메일에서 인증번호를 확인해주세요")
                        
                        self.certificationNumberTextField.alpha = 1
                        self.certificationNumberTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.confirmButton.alpha = 1
                        self.confirmButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.comfirmResultLabel.transform = CGAffineTransform.init(translationX: -50, y: 0)

        })
    }
    
    private func successAnimate(targetTextField: UITextField, successMessage: String) {
        
        targetTextField.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
        
        if targetTextField == self.emailTextField {
            _ = certificationResultLabel.then {
                $0.text = successMessage
                $0.textColor = .nuteeGreen
                $0.alpha = 0
            }
        } else {
            _ = comfirmResultLabel.then {
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
                        if targetTextField == self.emailTextField {
                            self.certificationResultLabel.alpha = 1
                        } else {
                            self.comfirmResultLabel.alpha = 1
                        }
        })
    }
    
    private func errorAnimate(targetTextField: UITextField, errorMessage: String) {
        
        let errorColor = UIColor(red: 255, green: 67, blue: 57)
        
        targetTextField.addBorder(.bottom, color: errorColor, thickness: 1)
        
        if targetTextField == self.emailTextField {
            _ = certificationResultLabel.then {
                $0.text = errorMessage
                $0.textColor = errorColor
                $0.alpha = 1
            }
        } else {
            _ = comfirmResultLabel.then {
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
                        if targetTextField == self.emailTextField {
                            self.certificationResultLabel.transform = CGAffineTransform.init(translationX: 5 - self.xPosAnimationRange, y: 0)
                        } else {
                            self.comfirmResultLabel.transform = CGAffineTransform.init(translationX: 5 - self.xPosAnimationRange, y: 0)
                        }
        })
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        if targetTextField == self.emailTextField {
                            self.certificationResultLabel.transform = CGAffineTransform.init(translationX: -5 - self.xPosAnimationRange, y: 0)
                        } else {
                            self.comfirmResultLabel.transform = CGAffineTransform.init(translationX: -5 - self.xPosAnimationRange, y: 0)
                        }
        })
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        if targetTextField == self.emailTextField {
                            self.certificationResultLabel.transform = CGAffineTransform.init(translationX: 0 - self.xPosAnimationRange, y: 0)
                        } else {
                            self.comfirmResultLabel.transform = CGAffineTransform.init(translationX: 0 - self.xPosAnimationRange, y: 0)
                        }
        })
    }
    
}

// MARK: - Keyboard

extension EmailVC {
    
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
            
            nextButtonBottomConstraint?.layoutConstraints[0].constant = -(keyboardHeight - (bottomPadding ?? 0))
            
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
            
            nextButtonBottomConstraint?.layoutConstraints[0].constant = 0
            self.view.setNeedsLayout()
            UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
}

// MARK: - Server connect

extension EmailVC {
    func sendOTP(_ email : String){
        UserService.shared.sendOTP(email) { (responsedata) in
            switch responsedata {
            
            case .success(_):
                self.certificationAnimate()
                self.nextButton.isEnabled = true
                self.nextButton.setTitleColor(.nuteeGreen, for: .normal)
                
            case .requestErr(_):
                self.errorAnimate(targetTextField: self.emailTextField, errorMessage: "이미 인증된 이메일입니다.")
                
            case .pathErr:
                self.errorAnimate(targetTextField: self.emailTextField, errorMessage: "에러가 발생했습니다.")
                
            case .serverErr:
                self.errorAnimate(targetTextField: self.emailTextField, errorMessage: "서버 에러가 발생했습니다.")
                
            case .networkFail:
                self.errorAnimate(targetTextField: self.emailTextField, errorMessage: "네트워크 에러가 발생했습니다.")
            }
        }
    }
    
}

