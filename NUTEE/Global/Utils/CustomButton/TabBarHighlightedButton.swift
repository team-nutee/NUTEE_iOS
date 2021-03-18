//
//  TabBarHighlightedButton.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/02/04.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class TabBarHighlightedButton: UIButton {

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .gray
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 7, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Function
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted == true {
                    tintColor = .nuteeGreen
                } else {
                    tintColor = .gray
                }
        }
    }
    
}
