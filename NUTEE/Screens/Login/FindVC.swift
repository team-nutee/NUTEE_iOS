//
//  LoginVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
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
    
    let lineView = UIView()
    
    let passwordForgetLabel = UILabel()
    let findPasswordByIdTitleLabel = UILabel()
    let findPasswordByIdTextField = UITextField()
    let findPasswordByEmailTitleLabel = UILabel()
    let findPasswordByEmailTextField = UITextField()
    let passwordFindButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
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
        }
        
        _ = findIdByEmailTitleLabel.then {
            $0.text = "이메일을 입력해주세요!"
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
        }
        
        _ = findIdByEmailTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "email@office.skhu.ac.kr"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
        }
        
        _ = idFindButton.then {
            $0.setTitle("찾으러가기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapFindButton), for: .touchUpInside)
        }
        
        _ = lineView.then {
            $0.backgroundColor = UIColor(red: 93, green: 93, blue: 93)
            $0.alpha = 0.5
        }
        
        _ = passwordForgetLabel.then {
            $0.text = "비밀번호를 잊어버리셨다면!! 😥"
            $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        }
        
        _ = findPasswordByIdTitleLabel.then {
            $0.text = "아이디를 입력해주세요!"
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
        }
        
        _ = findPasswordByIdTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "ID"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
        }
        
        _ = findPasswordByEmailTitleLabel.then {
            $0.text = "이메일을 입력해주세요!"
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
        }
        
        _ = findPasswordByEmailTextField.then {
            $0.font = .systemFont(ofSize: 14)
            $0.placeholder = "email@office.skhu.ac.kr"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
        }
        
        _ = passwordFindButton.then {
            $0.setTitle("찾으러가기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15)
            $0.setTitleColor(.nuteeGreen, for: .normal)
            
            $0.addTarget(self, action: #selector(didTapFindButton), for: .touchUpInside)
        }
        
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(closeButton)
        
        view.addSubview(idForgetLabel)
        view.addSubview(findIdByEmailTitleLabel)
        view.addSubview(findIdByEmailTextField)
        view.addSubview(idFindButton)
        
        view.addSubview(lineView)
        
        view.addSubview(passwordForgetLabel)
        view.addSubview(findPasswordByIdTitleLabel)
        view.addSubview(findPasswordByIdTextField)
        view.addSubview(findPasswordByEmailTitleLabel)
        view.addSubview(findPasswordByEmailTextField)
        view.addSubview(passwordFindButton)
        
        // Make Constraints
        closeButton.snp.makeConstraints {
            $0.width.equalTo(26)
            $0.height.equalTo(closeButton.snp.width)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(19)
            $0.left.equalTo(view.snp.left).offset(15)
        }
        
        idForgetLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(71)
            $0.left.equalTo(closeButton.snp.left)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        findIdByEmailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(idForgetLabel.snp.bottom).offset(24)
            $0.left.equalTo(idForgetLabel.snp.left)
        }

        findIdByEmailTextField.snp.makeConstraints {
            $0.height.equalTo(40)

            $0.top.equalTo(findIdByEmailTitleLabel.snp.bottom).offset(9)
            $0.left.equalTo(findIdByEmailTitleLabel.snp.left)
        }
        
        idFindButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(16)
            
            $0.centerY.equalTo(findIdByEmailTextField)
            $0.left.equalTo(findIdByEmailTextField.snp.right).offset(8)
            $0.right.equalTo(view.snp.right).inset(17)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.top.equalTo(findIdByEmailTextField.snp.bottom).offset(60)
            $0.left.equalTo(findIdByEmailTextField.snp.left)
            $0.right.equalTo(idFindButton.snp.right).inset(10)
        }
        
        passwordForgetLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(58)
            $0.left.equalTo(lineView.snp.left)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        findPasswordByIdTitleLabel.snp.makeConstraints {
            $0.top.equalTo(passwordForgetLabel.snp.bottom).offset(24)
            $0.left.equalTo(passwordForgetLabel.snp.left)
        }

        findPasswordByIdTextField.snp.makeConstraints {
            $0.height.equalTo(40)

            $0.top.equalTo(findPasswordByIdTitleLabel.snp.bottom).offset(9)
            $0.left.equalTo(findPasswordByIdTitleLabel.snp.left)
            $0.right.equalTo(findIdByEmailTextField.snp.right)
        }
        
        findPasswordByEmailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(findPasswordByIdTextField.snp.bottom).offset(24)
            $0.left.equalTo(findPasswordByIdTextField.snp.left)
        }

        findPasswordByEmailTextField.snp.makeConstraints {
            $0.height.equalTo(40)

            $0.top.equalTo(findPasswordByEmailTitleLabel.snp.bottom).offset(9)
            $0.left.equalTo(findPasswordByEmailTitleLabel.snp.left)
        }
        
        passwordFindButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(16)
            
            $0.centerY.equalTo(findPasswordByEmailTextField)
            $0.left.equalTo(findPasswordByEmailTextField.snp.right).offset(8)
            $0.right.equalTo(view.snp.right).inset(17)
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
    
