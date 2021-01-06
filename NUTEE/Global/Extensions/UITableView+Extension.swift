//
//  UITableView+Extension.swift
//  NUTEE
//
//  Created by 오준현 on 2020/07/29.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import Then
import SnapKit

extension UITableView {
    
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        // MARK: - UI components
        
        let alertView = UIView()
        
        let titleLabel = UILabel().then {
            $0.textColor = .black
            $0.text = title
            $0.font = Font.emptyTableBoldLabel
        }
        let messageLabel = UILabel().then {
            $0.text = message
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .lightGray
            $0.font = Font.emptyTableLabel
        }

        // MARK: - Make Constraints
        
        emptyView.addSubview(alertView)
        
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        
        alertView.snp.makeConstraints {
            $0.centerY.equalTo(emptyView)
            
            $0.left.equalTo(emptyView.snp.left)
            $0.right.equalTo(emptyView.snp.right)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(alertView.snp.centerX)
            
            $0.top.equalTo(alertView.snp.top)
        }
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel)
            
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(alertView.snp.bottom)
        }

        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
