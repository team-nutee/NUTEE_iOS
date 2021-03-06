//
//  SignUpMajorVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/12/31.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class SignUpMajorVC: SignUpViewController {
    
    // MARK: - UI components
    
    let firstMajorTitleLabel = UILabel()
    let firstMajorButton = HighlightedButton()
    let firstMajorUnderLineView = UIView()
    
    let secondMajorTitleLabel = UILabel()
    let secondMajorButton = HighlightedButton()
    let secondMajorUnderLineView = UIView()
    
    // MARK: - Variables and Properties
    
    var email: String = ""
    var otp: String = ""
    var userId: String = ""
    var nickname: String = ""
    var interests: [String] = []
    var majors: [String] = []
    
    let majorButtonPlaceHolder = "전공을 선택해주세요"
    
    var majorList: [String] = []
    var firstMajor = ""
    var secondMajor = ""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        makeConstraints()
        
        getMajorsService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        enterMajorVCAnimate()
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = guideLabel.then {
            $0.text = "전공을 설정해주세요!!"
        }
        
        _ = firstMajorTitleLabel.then {
            $0.text = "전공"
            $0.font = .systemFont(ofSize: 17)
            $0.sizeToFit()
            
            $0.alpha = 0
        }
        _ = firstMajorButton.then {
            $0.setTitle(majorButtonPlaceHolder, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.setTitleColor(.gray, for: .normal)
            
            $0.contentHorizontalAlignment = .left
            
            $0.addTarget(self, action: #selector(didTapFirstMajorButton), for: .touchUpInside)
            
            $0.alpha = 0
        }
        _ = firstMajorUnderLineView.then {
            $0.backgroundColor = .nuteeGreen
            
            $0.alpha = 0
        }
        
        _ = secondMajorTitleLabel.then {
            $0.text = "두 번째 전공이 있다면!!"
            $0.font = .systemFont(ofSize: 17)
            $0.sizeToFit()
            
            $0.alpha = 0
        }
        _ = secondMajorButton.then {
            $0.setTitle(majorButtonPlaceHolder, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.setTitleColor(.gray, for: .normal)
            
            $0.contentHorizontalAlignment = .left
            
            $0.addTarget(self, action: #selector(didTapSecondMajorButton), for: .touchUpInside)
            
            $0.alpha = 0
        }
        _ = secondMajorUnderLineView.then {
            $0.backgroundColor = .nuteeGreen
            
            $0.alpha = 0
        }
    }
    
    func makeConstraints() {
        // Add SubView
        view.addSubview(firstMajorTitleLabel)
        view.addSubview(firstMajorButton)
        view.addSubview(firstMajorUnderLineView)
        
        view.addSubview(secondMajorTitleLabel)
        view.addSubview(secondMajorButton)
        view.addSubview(secondMajorUnderLineView)
        
        // Make Constraints
        firstMajorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(25)
            $0.left.equalTo(guideLabel.snp.left)
        }
        firstMajorButton.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(firstMajorTitleLabel.snp.bottom).offset(15 + yPosAnimationRange)
            $0.left.equalTo(firstMajorTitleLabel.snp.left).offset(xPosAnimationRange)
            $0.right.equalTo(guideLabel.snp.right).inset(-xPosAnimationRange)
        }
        firstMajorUnderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(firstMajorButton.snp.width)
            
            $0.top.equalTo(firstMajorButton.snp.bottom)
            $0.left.equalTo(firstMajorButton.snp.left)
            $0.right.equalTo(firstMajorButton.snp.right)
        }
        
        secondMajorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstMajorUnderLineView.snp.bottom).offset(30 - yPosAnimationRange)
            $0.left.equalTo(firstMajorTitleLabel.snp.left)
        }
        secondMajorButton.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(secondMajorTitleLabel.snp.bottom).offset(15 + yPosAnimationRange)
            $0.left.equalTo(firstMajorButton.snp.left)
            $0.right.equalTo(firstMajorButton.snp.right)
        }
        secondMajorUnderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(secondMajorButton.snp.width)
            
            $0.top.equalTo(secondMajorButton.snp.bottom)
            $0.left.equalTo(secondMajorButton.snp.left)
            $0.right.equalTo(secondMajorButton.snp.right)
        }
    }
    
    func updateFirstMajorButtonStatus() {
        _ = firstMajorButton.then {
            $0.setTitle(firstMajor, for: .normal)
            $0.titleLabel?.sizeToFit()
            $0.setTitleColor(.black, for: .normal)
        }
        if firstMajor == secondMajor {
            updateSecondMajorButtonStatus()
        }
        
        nextButton.isEnabled = true
        nextButton.setTitleColor(.nuteeGreen, for: .normal)
    }
    
    func updateSecondMajorButtonStatus() {
        if secondMajor == "" || secondMajor == "없음" || secondMajor == firstMajor {
            secondMajor = ""
            _ = secondMajorButton.then {
                $0.setTitle(majorButtonPlaceHolder, for: .normal)
                $0.titleLabel?.sizeToFit()
                $0.setTitleColor(.gray, for: .normal)
            }
        } else {
            _ = secondMajorButton.then {
                $0.setTitle(secondMajor, for: .normal)
                $0.titleLabel?.sizeToFit()
                $0.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @objc func didTapFirstMajorButton() {
        showSelectFirstMajorSheet()
    }
    
    @objc func didTapSecondMajorButton() {
        showSelectSecondMajorSheet()
    }
    
    @objc override func didTapNextButton() {
        let passwordVC = PasswordVC()
        passwordVC.totalSignUpViews = totalSignUpViews
        passwordVC.progressStatusCount = progressStatusCount

        passwordVC.userId = self.userId
        passwordVC.email = self.email
        passwordVC.otp = self.otp
        passwordVC.nickname = self.nickname
        passwordVC.interests = self.interests
        
        var userSelectedMajors: [String] = []
        userSelectedMajors.append(firstMajor)
        if secondMajor != "" {
            userSelectedMajors.append(secondMajor)
        }
        passwordVC.majors = userSelectedMajors
        
        present(passwordVC, animated: false)
    }
    
    // MARK: - MajorVC Animation
    
    func enterMajorVCAnimate() {
        // major guide & first major title
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.firstMajorTitleLabel.alpha = 1
                        self.firstMajorTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
        })
        // first major button
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4 + 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        
                        self.firstMajorButton.alpha = 1
                        self.firstMajorButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.firstMajorUnderLineView.alpha = 1
                        self.firstMajorUnderLineView.transform = CGAffineTransform.init(translationX: -50, y: 0)
        })
        // second major title
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4 + 0.5 + 0.4,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.secondMajorTitleLabel.alpha = 1
                        self.secondMajorTitleLabel.transform = CGAffineTransform.init(translationX: 0, y: 50)
        })
        // second major button
        UIView.animate(withDuration: animationDuration,
                       delay: 1 + 0.4 + 0.5 + 0.4 + 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        
                        self.secondMajorButton.alpha = 1
                        self.secondMajorButton.transform = CGAffineTransform.init(translationX: -50, y: 0)
                        
                        self.secondMajorUnderLineView.alpha = 1
                        self.secondMajorUnderLineView.transform = CGAffineTransform.init(translationX: -50, y: 0)
        })
    }
    
}

// MARK: - NuteeAlert Action Definition

extension SignUpMajorVC: NuteeAlertActionDelegate {
    
    func showSelectFirstMajorSheet() {
        let selectFirstMajorSheet = NuteeSelectSheet()
        selectFirstMajorSheet.nuteeAlertActionDelegate = self
        selectFirstMajorSheet.selectMode = .firstMajor
        
        selectFirstMajorSheet.titleContent = majorButtonPlaceHolder
        
        selectFirstMajorSheet.itemList = majorList
        
        present(selectFirstMajorSheet, animated: true)
    }
    
    func showSelectSecondMajorSheet() {
        if firstMajor != "" {
            let selectSecondMajorSheet = NuteeSelectSheet()
            selectSecondMajorSheet.nuteeAlertActionDelegate = self
            selectSecondMajorSheet.selectMode = .secondMajor
            
            selectSecondMajorSheet.titleContent = "두 번째 " + majorButtonPlaceHolder
            
            var itemList: [String] = []
            itemList.append("없음")
            for major in majorList {
                if major != firstMajor {
                    itemList.append(major)
                }
            }
            selectSecondMajorSheet.itemList = itemList
            
            present(selectSecondMajorSheet, animated: true)
        }
    }
    
    func nuteeSelectSheetAction(selectedOptionItem: String, sheetMode: SelectMode) {
        switch sheetMode {
        case .firstMajor:
            firstMajor = selectedOptionItem
            updateFirstMajorButtonStatus()
        case .secondMajor:
            secondMajor = selectedOptionItem
            updateSecondMajorButtonStatus()
        default:
            break
        }
    }
    
}

// MARK: - Server connect

extension SignUpMajorVC {
    func getMajorsService() {
        ContentService.shared.getMajors() {
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                self.majorList = res as! [String]
                
            case .requestErr(let message):
                self.failToGetList("전공 목록 조회 실패", "\(message)")

            case .pathErr:
                self.failToGetList("전공 목록 조회 실패", "서버 에러입니다")
                
            case .serverErr:
                self.failToGetList("전공 목록 조회 실패", "서버 에러입니다")
                
            case .networkFail:
                self.failToGetList("전공 목록 조회 실패", "네트워크 에러입니다")
            }
        }
    }
}
