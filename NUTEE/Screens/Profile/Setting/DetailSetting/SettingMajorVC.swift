//
//  SettingMajorVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/11.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingMajorVC: SignUpMajorVC {
    
    // MARK: - UI components
    
    let saveButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var originalFirstMajor = ""
    var originalSecondMajor = ""
    var newMajors: [String] = []
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.navigationItem.title = "설정"
        view.backgroundColor = .white
        
        xPosAnimationRange = 0.0
        yPosAnimationRange = 0.0
        
        super.viewDidLoad()
        
        fetchUserMajorInfo()
    }
    
    // MARK: - Helper
    
    override func initView() {
        super.initView()
        
        _ = saveButton.then {
            $0.setTitle("저장하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
            $0.setTitleColor(.black, for: .normal)
            
            $0.isEnabled = false
            
            $0.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        }
        
        _ = guideLabel.then {
            $0.alpha = 1
        }
        
        _ = firstMajorTitleLabel.then {
            $0.alpha = 1
        }
        _ = firstMajorButton.then {
            $0.alpha = 1
        }
        _ = firstMajorUnderLineView.then {
            $0.alpha = 1
        }
        
        _ = secondMajorTitleLabel.then {
            $0.alpha = 1
        }
        _ = secondMajorButton.then {
            $0.alpha = 1
        }
        _ = secondMajorUnderLineView.then {
            $0.alpha = 1
        }
    }

    override func makeConstraints() {
        // add Subview
        view.addSubview(saveButton)
        
        // make Constraints
        saveButton.snp.makeConstraints {
            $0.width.equalTo(saveButton.intrinsicContentSize.width)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(guideLabel)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        super.makeConstraints()
        
        // remove SignUp style UI components
        closeButton.removeFromSuperview()
        progressView.removeFromSuperview()
        
        // add replacement SignUp style UI components constraints
        guideLabel.snp.remakeConstraints {
            $0.top.equalTo(view.snp.top).offset(45)
            $0.left.equalTo(view.snp.left).offset(20)
            $0.right.equalTo(saveButton.snp.left).inset(-10)
        }
        
        previousButton.snp.updateConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }
    }
    
    func fetchUserMajorInfo() {
        _ = firstMajorButton.then {
            $0.setTitle(originalFirstMajor, for: .normal)
            $0.titleLabel?.sizeToFit()
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    override func updateFirstMajorButtonStatus() {
        super.updateFirstMajorButtonStatus()

        checkSaveButtonEnableCondition()
    }
    
    override func updateSecondMajorButtonStatus() {
        super.updateSecondMajorButtonStatus()
        
        checkSaveButtonEnableCondition()
    }
    
    func checkSaveButtonEnableCondition() {
        if originalFirstMajor != firstMajor || originalSecondMajor != secondMajor {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc func didTapSaveButton() {
        newMajors.append(firstMajor)
        newMajors.append(secondMajor)
        self.changeMajorsService(majors: newMajors, completionHandler: {
            self.simpleNuteeAlertDialogue(title: "전공 변경", message: "성공적으로 변경되었습니다")
            self.saveButton.isEnabled = false
        })
    }
    
    func failToChangeMajor(_ message: String) {
        self.simpleNuteeAlertDialogue(title: "전공 변경 실패", message: message)
    }
    
    // MARK: - Remove SignUpMajorVC Animation
    
    override func enterCommonViewsAnimate() {
        // <---- make do nothing
    }
    
    override func enterMajorVCAnimate() {
        // <---- make do nothing
    }
    
}

// MARK: - Server connect

extension SettingMajorVC {
    func changeMajorsService(majors: [String], completionHandler: @escaping () -> Void) {
        UserService.shared.changeMajors(majors, completion: { (returnedData) -> Void in

            switch returnedData {
            case .success(_ ):
                completionHandler()

            case .requestErr(let message):
                self.failToChangeMajor("\(message)")

            case .pathErr:
                self.failToChangeMajor("서버 에러입니다")

            case .serverErr:
                self.failToChangeMajor("서버 에러입니다")

            case .networkFail:
                self.failToChangeMajor("네트워크 에러입니다")

            }
        })
    }
}
