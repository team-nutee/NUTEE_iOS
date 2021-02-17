//
//  UserInfomationView.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/02/17.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class UserInformationView: UIView {
    
    // MARK: - UI components
    
    let userProfileImageImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)).then {
        $0.contentMode = .scaleAspectFit
        $0.cornerRadius = 0.5 * $0.frame.size.width
        $0.clipsToBounds = true
    }
    
    let userNickNameButton = UIButton().then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.setTitleColor(UIColor(red: 112, green: 112, blue: 112), for: .normal)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.contentHorizontalAlignment = .left
    }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func makeConstraints() {
        // Add Subviews
        addSubview(userProfileImageImageView)
        addSubview(userNickNameButton)
        
        // Make Constraints
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        userProfileImageImageView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(userProfileImageImageView.snp.width)
            
            $0.centerY.equalTo(self)
            
            $0.left.equalTo(self.snp.left).offset(15)
        }
        userNickNameButton.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageImageView)
            
            $0.left.equalTo(userProfileImageImageView.snp.right).offset(10)
            $0.right.equalTo(self.snp.right).inset(15)
        }
    }
}
