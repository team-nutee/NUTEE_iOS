//
//  ResizableButton.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/03/03.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

// MARK: - Custom Button
// collectionView 내의 카테고리 버튼 표시(SearchVC 내의 CategoryCV)를 위해 작성한 커스텀 버튼

class ResizableButton: UIButton {
    
    // MARK: - Variables and Properties
    
    let minimumWidth: CGFloat = 67
    let height: CGFloat = 30
    
    let insetLeftRight: CGFloat = 10
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = .systemFont(ofSize: 13)
        setTitleColor(.black, for: .normal)
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetLeftRight, bottom: 0, right: insetLeftRight)
        titleLabel?.sizeToFit()
        
        self.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(minimumWidth)
            $0.height.equalTo(height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Function
    
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)

        return desiredButtonSize
    }
}
