//
//  FindVC.swift
//  NUTEE
//
//  Created by eunwoo on 2020/11/18.
//  Copyright © 2020 Nutee. All rights reserved.
//
import UIKit

class FindVC: UIViewController {
    
    // MARK: - UI components
    let closeButton = HighlightedButton()
    
    let idForgetLabel = UILabel()
    
    let findIdByEmailTitleLabel = UILabel()
    let findIdByEmailTextField = UITextField()
    let idFindButton = HighlightedButton()
    let idCheckLabel = UILabel()
    
    let lineView = UIView()
    
    let passwordForgetLabel = UILabel()
    
    let findPasswordByIdTitleLabel = UILabel()
    let findPasswordByIdTextField = UITextField()
    
    let findPasswordByEmailTitleLabel = UILabel()
    let findPasswordByEmailTextField = UITextField()
    let passwordFindButton = HighlightedButton()
    let passwordCheckLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    var animationDuration: TimeInterval = 1.3
    let xPosAnimationRange: CGFloat = 50
    let yPosAnimationRange: CGFloat = 50
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        enterFindVCAnimate()
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
        
        _ = idForgetLabel.then {
            $0.text = "아이디를 잊으셨나요? 😥"
            $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            
            $0.alpha = 0
        }
        
        _ = findIdByEmailTitleLabel.then {
            $0.text = "이메일을 입력해주세요!"
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
            $0.alpha = 0
        }
        
        _ = findIdByEmailTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "email@office.skhu.ac.kr"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.alpha = 0
        }
        
        _ = idFindButton.then {
            $0.setTitle("찾으러가기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.alpha = 0
            $0.addTarget(self, action: #selector(didTapFindButton), for: .touchUpInside)
        }
        
        _ = idCheckLabel.then {
            $0.text = "errorConditionArea"
            $0.font = .systemFont(ofSize: 11)
            
            $0.alpha = 1
        }
        
        _ = lineView.then {
            $0.backgroundColor = UIColor(red: 93, green: 93, blue: 93)
            $0.alpha = 0.5
        }
        
        _ = passwordForgetLabel.then {
            $0.text = "비밀번호를 잊어버리셨다면!! 😥"
            $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
            
            $0.alpha = 0
        }
        
        _ = findPasswordByIdTitleLabel.then {
            $0.text = "아이디를 입력해주세요!"
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
            $0.alpha = 0
        }
        
        _ = findPasswordByIdTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "ID"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.alpha = 0
        }
        
        _ = findPasswordByEmailTitleLabel.then {
            $0.text = "이메일을 입력해주세요!"
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
            $0.alpha = 0
        }
        
        _ = findPasswordByEmailTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "email@office.skhu.ac.kr"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.alpha = 0
        }
        
        _ = passwordFindButton.then {
            $0.setTitle("찾으러가기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.alpha = 0
            $0.addTarget(self, action: #selector(didTapFindButton), for: .touchUpInside)
        }
        
        _ = passwordCheckLabel.then {
            $0.text = "errorConditionArea"
            $0.font = .systemFont(ofSize: 11)
            
            $0.alpha = 1
        }
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(closeButton)
        
        view.addSubview(idForgetLabel)
        view.addSubview(findIdByEmailTitleLabel)
        view.addSubview(findIdByEmailTextField)
        view.addSubview(idFindButton)
        view.addSubview(idCheckLabel)
        
        view.addSubview(lineView)
        
        view.addSubview(passwordForgetLabel)
        view.addSubview(findPasswordByIdTitleLabel)
        view.addSubview(findPasswordByIdTextField)
        view.addSubview(findPasswordByEmailTitleLabel)
        view.addSubview(findPasswordByEmailTextField)
        view.addSubview(passwordFindButton)
        view.addSubview(passwordCheckLabel)
        
        // Make Constraints
        closeButton.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(closeButton.snp.width)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        
        idForgetLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(35 - yPosAnimationRange)
            $0.left.equalTo(closeButton.snp.left)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        findIdByEmailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(idForgetLabel.snp.bottom).offset(24)
            $0.left.equalTo(idForgetLabel.snp.left)
        }

        findIdByEmailTextField.snp.makeConstraints {
            $0.height.equalTo(40)

            $0.top.equalTo(findIdByEmailTitleLabel.snp.bottom).offset(9 + yPosAnimationRange)
            $0.left.equalTo(findIdByEmailTitleLabel.snp.left).offset(xPosAnimationRange)
        }
        
        idFindButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(16)
            
            $0.centerY.equalTo(findIdByEmailTextField)
            $0.left.equalTo(findIdByEmailTextField.snp.right).offset(8)
            $0.right.equalTo(view.snp.right).inset(17 - xPosAnimationRange)
        }
        
        idCheckLabel.snp.makeConstraints {
            $0.top.equalTo(findIdByEmailTextField.snp.bottom).offset(3)
            $0.left.equalTo(findIdByEmailTextField.snp.left).offset(-xPosAnimationRange)
            $0.right.equalTo(findIdByEmailTextField.snp.right)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.top.equalTo(findIdByEmailTextField.snp.bottom).offset(60)
            $0.left.equalTo(findIdByEmailTextField.snp.left).offset(-xPosAnimationRange)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        passwordForgetLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(58 - yPosAnimationRange)
            $0.left.equalTo(lineView.snp.left)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        findPasswordByIdTitleLabel.snp.makeConstraints {
            $0.top.equalTo(passwordForgetLabel.snp.bottom).offset(24)
            $0.left.equalTo(passwordForgetLabel.snp.left)
        }

        findPasswordByIdTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(findPasswordByIdTitleLabel.snp.bottom).offset(9 + yPosAnimationRange)
            $0.left.equalTo(findPasswordByIdTitleLabel.snp.left).offset(xPosAnimationRange)
            $0.right.equalTo(findIdByEmailTextField.snp.right)
        }
        
        findPasswordByEmailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(findPasswordByIdTextField.snp.bottom).offset(24 - yPosAnimationRange)
            $0.left.equalTo(findPasswordByIdTextField.snp.left).offset(-xPosAnimationRange)
        }

        findPasswordByEmailTextField.snp.makeConstraints {
            $0.height.equalTo(40)

            $0.top.equalTo(findPasswordByEmailTitleLabel.snp.bottom).offset(9 + yPosAnimationRange)
            $0.left.equalTo(findPasswordByEmailTitleLabel.snp.left).offset(xPosAnimationRange)
        }
        
        passwordFindButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(16)
            
            $0.centerY.equalTo(findPasswordByEmailTextField)
            $0.left.equalTo(findPasswordByEmailTextField.snp.right).offset(8)
            $0.right.equalTo(view.snp.right).inset(17 - xPosAnimationRange)
        }
        
        passwordCheckLabel.snp.makeConstraints {
            $0.top.equalTo(findPasswordByEmailTextField.snp.bottom).offset(3)
            $0.left.equalTo(findPasswordByEmailTextField.snp.left).offset(-xPosAnimationRange)
            $0.right.equalTo(findPasswordByEmailTextField.snp.right)
        }
        
    }
    
    @objc func didTapCloseButton() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapFindButton() {
        let emailVC = EmailVC()
        emailVC.modalPresentationStyle = .fullScreen
        
        present(emailVC, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

//extension FindVC : UITextFieldDelegate {
//
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if idTextField.text?.validateSkhuKrEmail() ?? false || idTextField.text?.validateSkhuCoKrEmail() ?? false || idTextField.text?.validateOfficeEmail() ?? false{
//            idCertificateBtn.isEnabled = true
//            idCertificateBtn.tintColor = .nuteeGreen
//        } else {
//            idCertificateBtn.tintColor = nil
//            idCertificateBtn.isEnabled = false
//        }
//
//        if (pwTextField.text?.validateSkhuKrEmail() ?? false || pwTextField.text?.validateSkhuCoKrEmail() ?? false || pwTextField.text?.validateOfficeEmail() ?? false) && pwIDTextField.text != ""  {
//            pwCertificateBtn.isEnabled = true
//            pwCertificateBtn.tintColor = .nuteeGreen
//        } else {
//            pwCertificateBtn.tintColor = nil
//            pwCertificateBtn.isEnabled = false
//        }
//    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        if textField == pwTextField || textField == pwIDTextField {
//            pwAnimate()
//        }
//
//        idErrorLabel.alpha = 0
//        pwErrorLabel.alpha = 0
//        pwError2Label.alpha = 0
//
//        return true
//    }
//
//
//}
    
// MARK: - animate

extension FindVC {
    private func enterFindVCAnimate(){
        UIView.animate(withDuration: animationDuration,
                       delay: 1,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        // self를 항상 붙여줘야함 (클로저 안에서)
                        self.idForgetLabel.alpha = 1
                        self.idForgetLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
                       })
        
        UIView.animate(withDuration: animationDuration,
                       delay: animationDuration,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        // self를 항상 붙여줘야함 (클로저 안에서)
                        self.findIdByEmailTitleLabel.alpha = 1
                        self.findIdByEmailTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
                       })
        
        UIView.animate(withDuration: animationDuration,
                       delay: animationDuration*2,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        // self를 항상 붙여줘야함 (클로저 안에서)
                        self.passwordForgetLabel.alpha = 1
                        self.passwordForgetLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
                       })
        
        UIView.animate(withDuration: animationDuration,
                       delay: animationDuration*2.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        // self를 항상 붙여줘야함 (클로저 안에서)
                        self.findPasswordByIdTitleLabel.alpha = 1
                        self.findPasswordByIdTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
                        self.findPasswordByEmailTitleLabel.alpha = 1
                        self.findPasswordByEmailTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
                       })
        
        UIView.animate(withDuration: animationDuration,
                       delay: animationDuration * 1.5,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        // self를 항상 붙여줘야함 (클로저 안에서)
                        self.findIdByEmailTextField.alpha = 1
                        self.findIdByEmailTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        self.idFindButton.alpha = 1
                        self.idFindButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                       })
        
        UIView.animate(withDuration: animationDuration,
                       delay: animationDuration * 2 * 1.5,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        // self를 항상 붙여줘야함 (클로저 안에서)
                        self.findPasswordByIdTextField.alpha = 1
                        self.findPasswordByIdTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        self.findPasswordByEmailTextField.alpha = 1
                        self.findPasswordByEmailTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        self.passwordFindButton.alpha = 1
                        self.passwordFindButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                       })
        
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
}
