//
//  LoginVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//
import UIKit
import Alamofire
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    // MARK: - UI components
    
    // 로그인 화면
    let loadingIndicator = UIActivityIndicatorView()
    
    let titleLogoLabel = UILabel()
    
    let idTextField = UITextField()
    let idErrorLabel = UILabel()
    
    let pwTextField = UITextField()
    let pwErrorLabel = UILabel()
    
    let autoLoginButton = HighlightedButton()
    
    let findAccountButton = HighlightedButton()
    
    let loginButton = HighlightedButton()
    
    // 회원가입 화면
    let signUpLabel = UILabel()
    let leftLineView = UIView()
    let rightLineView = UIView()
    
    let signUpButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var signin : SignIn?
    var autoLogin = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.alpha = 0.0
        
        initView()
        makeConstraints()
        
//        enterLoginVCAnimate()
    }
    
    
    // MARK: - Helper
   
    func initView() {
        
        _ = view.then {
            $0.backgroundColor = .white
            $0.tintColor = .nuteeGreen
        }
        
        // 로그인 화면
        _ = titleLogoLabel.then {
            $0.text = "NUTEE"
            $0.font = UIFont(name: "NotoSansKannada-Bold", size: 30)
            $0.textColor = .nuteeGreen
        }
        
        _ = idTextField.then {
            $0.borderStyle = .none
            $0.placeholder = "아이디"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1.0)
            $0.addTarget(self, action: #selector(LoginVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            $0.keyboardType = .emailAddress
        }
        _ = idErrorLabel.then {
            $0.text = "ErrorMessageArea"
            $0.textColor = UIColor(red: 255, green: 67, blue: 57)
            $0.font = .systemFont(ofSize: 11)
            $0.alpha = 0.0
        }
        
        _ = pwTextField.then {
            $0.borderStyle = .none
            $0.placeholder = "비밀번호"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1.0)
            $0.isSecureTextEntry = true
            $0.addTarget(self, action: #selector(LoginVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
        _ = pwErrorLabel.then {
            $0.text = "ErrorMessageArea"
            $0.textColor = UIColor(red: 255, green: 67, blue: 57)
            $0.font = .systemFont(ofSize: 11)
            $0.alpha = 0.0
        }
        
        _ = autoLoginButton.then {
            $0.setTitle("로그인 유지", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            $0.tintColor = .nuteeGreen
            
            autoLogin = true
            didTapAutoLoginButton()
            
            $0.contentHorizontalAlignment = .left
            
            $0.addTarget(self, action: #selector(didTapAutoLoginButton), for: .touchUpInside)
        }
        
        _ = findAccountButton.then {
            $0.setTitle("아이디 혹은 비밀번호를 잊으셨나요?", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 11)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            $0.addTarget(self, action: #selector(didTapFindAccountButton), for: .touchUpInside)
        }
        
        _ = loginButton.then {
            $0.setTitle("로그인", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 20)
            $0.setTitleColor(.white, for: .normal)
            $0.contentVerticalAlignment = .bottom
            
            $0.layer.cornerRadius = 17
            $0.backgroundColor = .veryLightPink
            $0.alpha = 0.5
            
            $0.isEnabled = false
            
            $0.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        }
        
        // 회원가입 화면
        _ = signUpLabel.then {
            $0.text = "처음이신가요?"
            $0.font = UIFont(name: "NotoSansKannada-SemiBold", size: 17)
            $0.textColor = .gray
        }
        _ = leftLineView.then {
            $0.backgroundColor = .gray
        }
        _ = rightLineView.then {
            $0.backgroundColor = .gray
        }
        
        _ = signUpButton.then {
            $0.setTitle("회원가입", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKannada-Bold", size: 17)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        }
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(loadingIndicator)
        
        view.addSubview(titleLogoLabel)
        
        view.addSubview(idTextField)
        view.addSubview(idErrorLabel)
        
        view.addSubview(pwTextField)
        view.addSubview(pwErrorLabel)
        
        view.addSubview(autoLoginButton)
        
        view.addSubview(findAccountButton)
        
        view.addSubview(loginButton)
        
        view.addSubview(signUpLabel)
        view.addSubview(leftLineView)
        view.addSubview(rightLineView)
        
        view.addSubview(signUpButton)
        
        
        // Make Constraints
        loadingIndicator.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        titleLogoLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        idTextField.snp.makeConstraints{
            $0.height.equalTo(35)
            
            $0.left.equalTo(view.snp.left).offset(25)
            $0.right.equalTo(view.snp.right).inset(25)
        }
        idErrorLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(8)
            $0.right.equalTo(idTextField.snp.right)
        }
        
        pwTextField.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(idTextField.snp.bottom).offset(30)
            $0.left.equalTo(idTextField.snp.left)
            $0.right.equalTo(idTextField.snp.right)
        }
        pwErrorLabel.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(8)
            $0.right.equalTo(pwTextField.snp.right)
        }
        
        autoLoginButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(20)
            
            $0.top.equalTo(pwErrorLabel.snp.bottom).offset(5)
            $0.left.equalTo(pwTextField.snp.left)
        }
        
        findAccountButton.snp.makeConstraints {
            $0.height.equalTo(50)
            
            $0.centerX.equalTo(titleLogoLabel)
            $0.top.equalTo(autoLoginButton.snp.bottom).offset(15)
            $0.width.equalTo(200)
        }
        
        loginButton.snp.makeConstraints {
            let screenHeight = UIScreen.main.bounds.size.height
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(screenHeight * 0.51)
            
            $0.height.equalTo(50)
            
            $0.top.equalTo(findAccountButton.snp.bottom).offset(15)
            $0.left.equalTo(pwTextField.snp.left)
            $0.right.equalTo(pwTextField.snp.right)
        }
        
        signUpLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(loginButton.snp.bottom).offset(75)
        }
        leftLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.centerY.equalTo(signUpLabel)
            $0.left.equalTo(view.snp.left).offset(30)
            $0.right.equalTo(signUpLabel.snp.left).inset(-30)
        }
        rightLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.centerY.equalTo(signUpLabel)
            $0.left.equalTo(signUpLabel.snp.right).offset(30)
            $0.right.equalTo(view.snp.right).inset(30)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerX.equalTo(signUpLabel)
            $0.top.equalTo(signUpLabel.snp.bottom).offset(60)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func didTapFindAccountButton() {
        let findVC = FindVC()
        findVC.modalPresentationStyle = .fullScreen
        
        present(findVC, animated: false)
    }
    
    @objc func didTapLoginButton() {
        loadingIndicatorSwitcher()
        
        let id = idTextField.text ?? ""
        let pw = pwTextField.text ?? ""
        
        if autoLogin == true {
            KeychainWrapper.standard.set(id, forKey: "userId")
            KeychainWrapper.standard.set(pw, forKey: "pw")
        }
        
        signInService(id, pw)
    }
    
    @objc func didTapSignUpButton() {
        let emailVC = EmailVC()
        emailVC.totalSignUpViews = 6.0
        emailVC.progressStatusCount = 0.0

        emailVC.modalPresentationStyle = .fullScreen
        
        present(emailVC, animated: false)
    }
    
    @objc func didTapAutoLoginButton() {
        autoLogin = !autoLogin
        
        if autoLogin == true {
            autoLoginButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        } else {
            autoLoginButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    func loadingIndicatorSwitcher() {
        if loadingIndicator.isAnimating == false {
            loadingIndicator.startAnimating()
            view.alpha = 0.7
        } else {
            loadingIndicator.stopAnimating()
            view.alpha = 1.0
        }
    }
    
}

// MARK: - LoginVC Animation

extension LoginVC {
    
    private func enterLoginVCAnimate() {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.view.alpha = 1.0
        })
    }
    
    private func errorAnimate(message: String) {
        idErrorLabel.text = message
        pwErrorLabel.text = message
        idErrorLabel.sizeToFit()
        pwErrorLabel.sizeToFit()
        
        idTextField.addBorder(.bottom, color: .red, thickness: 1)
        pwTextField.addBorder(.bottom, color: .red, thickness: 1)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        self.idErrorLabel.transform = CGAffineTransform.init(translationX: -5, y: 0)
                        self.pwErrorLabel.transform = CGAffineTransform.init(translationX: -5, y: 0)
                        
                        self.idErrorLabel.alpha = 1
                        self.pwErrorLabel.alpha = 1
        })
        UIView.animate(withDuration: 0.2,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        self.idErrorLabel.transform = CGAffineTransform.init(translationX: 5, y: 0)
                        self.pwErrorLabel.transform = CGAffineTransform.init(translationX: 5, y: 0)
        })
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        self.idErrorLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
                        self.pwErrorLabel.transform = CGAffineTransform.init(translationX: 0, y: 0)
        })
    }
    
}

// MARK: - TextField Delegate

extension LoginVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        // 로그인 입력 조건 확인
        let id = idTextField.text
        if id?.validateID() == true && pwTextField.text?.isEmpty == false {
            loginButton.isEnabled = true
            
            loginButton.backgroundColor = .nuteeGreen
            loginButton.alpha = 1.0
        } else {
            loginButton.isEnabled = false
            
            loginButton.backgroundColor = .veryLightPink
            loginButton.alpha = 0.5
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == idTextField {
            pwTextField.becomeFirstResponder()
        } else {
            pwTextField.resignFirstResponder()
        }
        return true
    }
    
}

// MARK: - server service

extension LoginVC {
    
    func signInService(_ userId: String, _ password: String) {
        UserService.shared.signIn(userId, password) { [self] result in
            
            switch result {
                
            // NetworkResult 의 요소들
            case .success(_):
                Splash.hide()
                LoadingHUD.hide()
                
                loadingIndicatorSwitcher()
                
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                
                let nuteeApp = BuildTabBarController.shared.nuteeApp()
                sceneDelegate.window?.rootViewController = nuteeApp
                
            case .requestErr(let res):
                let responseData = res as! SignIn
                
                let errorMessage = responseData.message
                simpleNuteeAlertDialogue(title: "로그인 오류", message: errorMessage)
                
                LoadingHUD.hide()
                
                loadingIndicatorSwitcher()
                
                self.errorAnimate(message: errorMessage)
                print("request error")
                
            case .pathErr:
                LoadingHUD.hide()
                
                loadingIndicatorSwitcher()
                errorAnimate(message: "경로오류")
                simpleNuteeAlertDialogue(title: "로그인 경로 오류", message: "개발사로 문의 바랍니다")
                
                print(".pathErr")
                
            case .serverErr:
                LoadingHUD.hide()
                
                loadingIndicatorSwitcher()
                errorAnimate(message: "서버 에러입니다")
                
                print(".serverErr")
                
            case .networkFail :
                LoadingHUD.hide()
                
                loadingIndicatorSwitcher()
                errorAnimate(message: "서버 에러입니다")
                
                print("failure")
            }
            
        }
    }
    
}
