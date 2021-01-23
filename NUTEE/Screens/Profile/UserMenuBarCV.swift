//
//  UserMenuBarCV.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class UserMenuBarCVCell : MenuBarCVCell {
    
    // MARK: - UI components
    
    let userInfomationLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    var userInfomationList = ["13", "21", "21"]
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
}
