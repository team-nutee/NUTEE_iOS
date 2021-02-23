//
//  SettingCategoryVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/11.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingCategoryVC: SignUpCategoryVC {
    
    // MARK: - UI components
    
    let saveButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var originalCategoryList: [String] = []
    var originalCategoryCheckList: [Bool] = []
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.navigationItem.title = "설정"
        view.backgroundColor = .white
        
        xPosAnimationRange = 0.0
        yPosAnimationRange = 0.0
        
        super.viewDidLoad()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        saveButton.snp.updateConstraints {
            $0.width.equalTo(saveButton.intrinsicContentSize.width)
        }
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
            $0.font = .boldSystemFont(ofSize: 18)
            $0.alpha = 1
        }
        
        _ = selectCategoryButton.then {
            $0.alpha = 1
        }
        _ = selectCategoryUnderLineView.then {
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
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(45)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        
        previousButton.snp.updateConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }
    }

    override func fetchCategoryList() {
        getCategoriesService(completionHandler: { [self] fetchedCategoryList in
            var checkList: [Bool] = []
            for categoryList in fetchedCategoryList {
                if originalCategoryList.contains(categoryList) == true {
                    checkList.append(true)
                } else {
                    checkList.append(false)
                }
            }
            originalCategoryCheckList = checkList
            categoryCheckList = checkList
            
            updateSelectedCategoryStatus()
        })
    }
    
    override func updateSelectedCategoryStatus() {
        super.updateSelectedCategoryStatus()
        
        if categoryCheckList.contains(true) == true && categoryCheckList != originalCategoryCheckList {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @objc func didTapSaveButton() {
        let selectedCategoryList = getUserSelectedCategoryList()
        
        changeInterestsService(interests: selectedCategoryList, completionHandler: { [self] in
            simpleNuteeAlertDialogue(title: "관심사 변경", message: "성공적으로 변경되었습니다")
            saveButton.isEnabled = false
        })
    }
    
    func failToChangeCategory(_ message: String) {
        self.simpleNuteeAlertDialogue(title: "관심사 변경 실패", message: message)
    }
    
    // MARK: - Remove SignUpCategoryVC Animation
    
    override func enterCommonViewsAnimate() {
        // <---- make do nothing
    }
    
    override func enterSignUpCategoryVCAnimate() {
        // <---- make do nothing
    }
    
}

// MARK: - Server connect

extension SettingCategoryVC {
    func changeInterestsService(interests: [String], completionHandler: @escaping () -> Void) {
        UserService.shared.changeInterests(interests, completion: { (returnedData) -> Void in
            
            switch returnedData {
            case .success(_ ):
                completionHandler()

            case .requestErr(let message):
                self.failToChangeCategory("\(message)")

            case .pathErr:
                self.failToChangeCategory("서버 에러입니다")

            case .serverErr:
                self.failToChangeCategory("서버 에러입니다")

            case .networkFail:
                self.failToChangeCategory("네트워크 에러입니다")

            }
        })
    }
}
