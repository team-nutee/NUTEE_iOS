//
//  SmallRefreshControl.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/02/17.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class SmallRefreshControl: UIRefreshControl {
    
    // MARK: - Custom RefreshControl
    override init() {
        super.init()
        
        transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
