//
//  LoginCVCell.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class EmailVC: SignUpViewController {
    
    // MARK: - UI components
    
    // 로그인 화면
    let emailTitleLabel = UILabel()
    let emailTextField = UITextField()
    let certificationButton = HighlightedButton()
    let certificationResultLabel = UILabel()
    
    let certificationNumberTextField = UITextField()
    let confirmButton = HighlightedButton()
    let comfirmResultLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
        addKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        enterEmailVCAnimate()
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = closeButton.then {
            $0.removeTarget(self, action: #selector(didTapCloseButton), for: .allEvents)
            $0.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        }
        
        _ = guideLabel.then {
            $0.text = "인증을 위해 학교 이메일이 필요해요! 😄"
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
            
            $0.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
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
        
        _ = previousButton.then {
            $0.isEnabled = false
            $0.isHidden = true
        }
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(emailTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(certificationButton)
        view.addSubview(certificationResultLabel)
        
        view.addSubview(certificationNumberTextField)
        view.addSubview(confirmButton)
        view.addSubview(comfirmResultLabel)
        
        // Make Constraints
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
    }
    
    @objc func didTapCertificationButton() {
        sendOTP(emailTextField.text ?? "")
    }
    
    @objc func didTapConfirmButton() {
        checkOTP(certificationNumberTextField.text ?? "")
    }
    
    @objc override func didTapNextButton() {
        emailTextField.resignFirstResponder()
        certificationNumberTextField.resignFirstResponder()
        
        let idVC = IDVC()
        idVC.totalSignUpViews = totalSignUpViews
        idVC.progressStatusCount = progressStatusCount
        
        idVC.email = emailTextField.text ?? ""
        idVC.otp = certificationNumberTextField.text ?? ""
        
        present(idVC, animated: false)
    }
    
}

// MARK: - TextField Delegate

extension EmailVC : UITextFieldDelegate {
  
    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        if emailTextField.text != "" && emailTextField.text?.validateOfficeEmail() == true {
            certificationButton.isEnabled = true
            certificationButton.setTitleColor(.nuteeGreen, for: .normal)
            
        } else if emailTextField.text == "" || emailTextField.text?.validateOfficeEmail() == false {
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

// MARK: - Server connect

extension EmailVC {
    
    func sendOTP(_ email : String){
        UserService.shared.sendOTP(email) { (responsedata) in
            switch responsedata {
            
            case .success(_):
                self.certificationAnimate()
                
            case .requestErr(let res):
                self.errorAnimate(targetTextField: self.emailTextField, errorMessage: "\(res)")
                
            case .pathErr:
                self.errorAnimate(targetTextField: self.emailTextField, errorMessage: "에러가 발생했습니다.")
                
            case .serverErr:
                self.errorAnimate(targetTextField: self.emailTextField, errorMessage: "서버 에러가 발생했습니다.")
                
            case .networkFail:
                self.errorAnimate(targetTextField: self.emailTextField, errorMessage: "네트워크 에러가 발생했습니다.")
            }
        }
    }
    
    func checkOTP(_ otp : String){
        UserService.shared.checkOTP(otp) { (responsedata) in
            switch responsedata {
            
            case .success(_):
                self.successAnimate(targetTextField: self.certificationNumberTextField, successMessage: "인증번호가 확인되었습니다.")
                
                self.nextButton.isEnabled = true
                self.nextButton.setTitleColor(.nuteeGreen, for: .normal)
                
            case .requestErr(_):
                self.errorAnimate(targetTextField: self.certificationNumberTextField, errorMessage: "인증번호가 틀렸습니다.")
                
            case .pathErr:
                self.errorAnimate(targetTextField: self.certificationNumberTextField, errorMessage: "인증번호가 틀렸습니다.")
                
            case .serverErr:
                self.errorAnimate(targetTextField: self.certificationNumberTextField, errorMessage: "서버 에러가 발생했습니다.")
                
            case .networkFail:
                self.errorAnimate(targetTextField: self.certificationNumberTextField, errorMessage: "네트워크 에러가 발생했습니다.")
            }
        }
    }

}

