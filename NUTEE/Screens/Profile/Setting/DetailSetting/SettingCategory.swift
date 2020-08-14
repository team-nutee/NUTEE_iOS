//
//  SettingCategory.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/11.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingCategoryVC : UIViewController {
    
    // MARK: - UI components
    
    let categoryTitleLabel = UILabel()
    let saveButton = UIButton()
    
    let categoryTextField = UITextField()
    let plusButton = UIButton()
    
    let categoryButton = UIButton()
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
        view.backgroundColor = .white
        
        initView()
        addSubView()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapKeyboardOutSide)))
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = categoryTitleLabel.then {
            $0.text = "선호하는 카테고리를 설정해주세요!!"
            $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18.0)
        }
        _ = saveButton.then {
            $0.setTitle("저장하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
            $0.setTitleColor(.black, for: .normal)
        }
        
        _ = categoryTextField.then {
            $0.text = "카테고리를 설정하러 가볼까요?"
            $0.font = .boldSystemFont(ofSize: 14)
            $0.isEnabled = false
            
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
        }
        _ = plusButton.then {
            let configuration = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)
            $0.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
            $0.tintColor = .nuteeGreen
        }
        
        _ = categoryButton.then {
            let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]
            $0.setAttributedTitle(NSAttributedString(string: "블라블라", attributes: attributes), for: .normal)
            
            $0.backgroundColor = UIColor(red: 196, green: 196, blue: 196)
        }
    }
    
    func addSubView() {
        
        view.addSubview(categoryTitleLabel)
        view.addSubview(saveButton)
        
        view.addSubview(categoryTextField)
        view.addSubview(plusButton)
        
        view.addSubview(categoryButton)
        
        
        categoryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(45)
            $0.left.equalTo(view.snp.left).offset(20)
        }
        saveButton.snp.makeConstraints {
            $0.width.equalTo(saveButton.intrinsicContentSize.width)
            $0.height.equalTo(40)
            
            $0.centerY.equalTo(categoryTitleLabel)
            $0.right.equalTo(view.snp.right).inset(20)
        }
        
        categoryTextField.snp.makeConstraints {
            $0.height.equalTo(35)
            
            $0.top.equalTo(categoryTitleLabel.snp.bottom).offset(40)
            $0.left.equalTo(categoryTitleLabel.snp.left)
            $0.right.equalTo(saveButton.snp.right)
        }
        plusButton.snp.makeConstraints {
            $0.centerY.equalTo(categoryTextField)
            $0.right.equalTo(categoryTextField.snp.right)
        }
        
        categoryButton.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(30)
            
            $0.top.equalTo(categoryTextField.snp.bottom).offset(50)
            $0.left.equalTo(categoryTextField.snp.left)
        }
        
    }
    
    @objc func didTapKeyboardOutSide() {
        categoryTextField.resignFirstResponder()
    }
    
}
