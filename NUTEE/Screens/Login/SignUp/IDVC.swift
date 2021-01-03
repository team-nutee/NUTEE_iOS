//
//  LoginCVCell.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class IDVC: SignUpViewController {
    
    // MARK: - UI components
    
    let idTitleLabel = UILabel()
    let idTextField = UITextField()
    let idCheckLabel = UILabel()
    let idCheckButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var email: String = ""
    var otp: String = ""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
        addKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        enterIDVCAnimate()
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = guideLabel.then {
            $0.text = "아이디를 입력해주세요!!"
        }
        
        _ = idTitleLabel.then {
            $0.text = "아이디"
            $0.font = .systemFont(ofSize: 17)
            
            $0.alpha = 0
        }
        _ = idTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "아이디"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            
            $0.alpha = 0
            
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        _ = idCheckButton.then {
            $0.setTitle("중복확인", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.alpha = 0
            $0.isEnabled = false
            $0.setTitleColor(.veryLightPink, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        }
        
        _ = idCheckLabel.then {
            $0.text = "checkIDArea"
            $0.font = .systemFont(ofSize: 11)
            
            $0.alpha = 0
        }
        
        _ = previousButton.then {
            $0.alpha = 0
        }
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(idTitleLabel)
        view.addSubview(idTextField)
        view.addSubview(idCheckButton)
        view.addSubview(idCheckLabel)
        
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        // Make Constraints
        idTitleLabel.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(40)
            $0.left.equalTo(guideLabel.snp.left)
        }
        idTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(idTitleLabel.snp.bottom).offset(5 + yPosAnimationRange)
            $0.left.equalTo(idTitleLabel.snp.left).offset(xPosAnimationRange)
        }
        
        idCheckButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(idTextField)
            $0.left.equalTo(idTextField.snp.right).offset(10)
            $0.right.equalTo(view.snp.right).inset(15 - xPosAnimationRange)
        }
        
        idCheckLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(3)
            $0.left.equalTo(idTextField.snp.left)
            $0.right.equalTo(idTextField.snp.right)
        }
    }
    
    @objc func didTapCheckButton() {
        checkID(idTextField.text ?? "")
    }
    
    @objc override func didTapNextButton() {
        idTextField.resignFirstResponder()

        let nicknameVC = NicknameVC()
        nicknameVC.totalSignUpViews = totalSignUpViews
        nicknameVC.progressStatusCount = progressStatusCount
        
        nicknameVC.userId = idTextField.text ?? ""
        nicknameVC.email = self.email
        nicknameVC.otp = self.otp
        
        present(nicknameVC, animated: false)
    }
    
}

// MARK: - TextField Delegate

extension IDVC : UITextFieldDelegate {
  
    @objc func textFieldDidChange(_ textField: UITextField) {
        if idTextField.text != "" && idTextField.text?.validateID() == true {
            successAnimate()
            
            idCheckButton.isEnabled = true
            idCheckButton.setTitleColor(.nuteeGreen, for: .normal)
            
        } else if idTextField.text == "" || idTextField.text?.validateID() == false {
            
            successAnimate()
            
            idCheckButton.isEnabled = false
            idCheckButton.setTitleColor(.veryLightPink, for: .normal)
            
        } else {
            
            errorAnimate(errorMessage: "영문 혹은 숫자만 입력이 가능합니다")
            
            idCheckButton.isEnabled = false
            idCheckButton.setTitleColor(.veryLightPink, for: .normal)
        }
    }
    
}

// MARK: - IDVC Animation

extension IDVC {
    
    private func enterIDVCAnimate() {
        // provious button appear
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: { [self] in
                        self.previousButton.alpha = 1
        })
        
        // id title
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.idTitleLabel.alpha = 1
                        self.idTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
        })
        // insert id area
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4 + 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        
                        self.idTextField.alpha = 1
                        self.idTextField.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.idCheckButton.alpha = 1
                        self.idCheckButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.idCheckLabel.transform = CGAffineTransform.init(translationX: -50, y: 0)
        })
    }

    private func successAnimate() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.idTextField.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
                        self.idCheckLabel.alpha = 0
        })
    }
    
    private func errorAnimate(errorMessage: String) {
        let errorColor = UIColor(red: 255, green: 67, blue: 57)
        
        idTextField.addBorder(.bottom, color: errorColor, thickness: 1)
        
        _ = idCheckLabel.then {
            $0.text = errorMessage
            $0.textColor = errorColor
            $0.alpha = 1
        }
    
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        self.idCheckLabel.transform = CGAffineTransform.init(translationX: 5 - self.xPosAnimationRange, y: 0)
        })
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        self.idCheckLabel.transform = CGAffineTransform.init(translationX: -5 - self.xPosAnimationRange, y: 0)
        })
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        self.idCheckLabel.transform = CGAffineTransform.init(translationX: 0 - self.xPosAnimationRange, y: 0)
        })
    }
    
}

// MARK: - Server connect

extension IDVC {
    
    @objc func checkID(_ userId : String){
        UserService.shared.checkID(userId) { (responsedata) in
            switch responsedata {
                
            case .success(_):
                self.successAnimate()
                
                self.idCheckLabel.alpha = 1
                self.idCheckLabel.textColor = .nuteeGreen
                self.idCheckLabel.text = "아이디 중복 체크 완료"
                self.nextButton.isEnabled = true
                self.nextButton.setTitleColor(.nuteeGreen, for: .normal)
                
            case .requestErr(_):
                self.errorAnimate(errorMessage: "이미 사용 중인 아이디입니다.")
                
            case .pathErr:
                self.errorAnimate(errorMessage: "에러가 발생했습니다.")

            case .serverErr:
                self.errorAnimate(errorMessage: "서버 에러가 발생했습니다.")

            case .networkFail:
                self.errorAnimate(errorMessage: "네트워크 에러가 발생했습니다.")
            }
        }
    }

}
