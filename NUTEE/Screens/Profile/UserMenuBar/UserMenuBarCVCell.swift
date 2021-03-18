//
//  UserMenuBarCV.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class UserMenuBarCVCell: MenuBarCVCell {
    
    // MARK: - UI components
    
    let containerView = UIView()
    let userInfomationButton = UIButton()
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Helper
    
    override func initCell() {
        super.initCell()
        
        _ = userInfomationButton.then {
            $0.layer.cornerRadius = 7
            $0.backgroundColor = .lightGray

            $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
            $0.titleLabel?.font = .systemFont(ofSize: 11)
            $0.setTitleColor(.white, for: .normal)
            
            $0.isUserInteractionEnabled = false
        }
    }
    
    override func makeConstraints() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(menuTitle)
        containerView.addSubview(userInfomationButton)
        
        
        containerView.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }
        
        menuTitle.snp.makeConstraints {
            $0.centerY.equalTo(containerView)
            
            $0.left.equalTo(containerView.snp.left)
        }
        userInfomationButton.snp.makeConstraints {
            $0.centerY.equalTo(menuTitle)
            
            $0.left.equalTo(menuTitle.snp.right).offset(4)
            $0.right.equalTo(containerView.snp.right)
        }
    }
    
    // MARK: - Override Function
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected == true {
                _ = userInfomationButton.then {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
                    $0.backgroundColor = .nuteeGreen
                }
            } else {
                _ = userInfomationButton.then {
                    $0.titleLabel?.font = .systemFont(ofSize: 11)
                    $0.backgroundColor = .gray
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                _ = userInfomationButton.then {
                    $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
                    $0.backgroundColor = .nuteeGreen
                }
            } else {
                _ = userInfomationButton.then {
                    $0.titleLabel?.font = .systemFont(ofSize: 11)
                    $0.backgroundColor = .gray
                }
            }
        }
    }
}
