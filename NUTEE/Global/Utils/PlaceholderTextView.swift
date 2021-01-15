//
//  PlaceHolderTextView.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/15.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
    
    //MARK: - UI components
    
    let placeholderLabel = UILabel()
    
    //MARK: - Variables and Properties
   
    //MARK: - Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addPlaceHolder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func addPlaceHolder() {
        _ = placeholderLabel.then {
            $0.text = "placehoder"
            $0.textColor = .lightGray
            $0.font = font
        }
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalTo(self)
            
            $0.left.equalTo(self.snp.left).offset(5)
            $0.right.equalTo(self.snp.right)
        }
    }
    
    func handlePlaceholder() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}
