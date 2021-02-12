//
//  HighlightedButton.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/03.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

// MARK: - Custom Button
// highlight 상황 시 tinColor나 alpha 값을 일반적인 방법으로는 변경 할 수 없어서 커스텀으로 버튼 설정
class HighlightedButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
}
