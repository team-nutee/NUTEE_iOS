//
//  NoReplyFooterView.swift
//  NUTEE
//
//  Created by eunwoo on 2021/01/12.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

import SnapKit

class NoReplyFooterView: UITableViewHeaderFooterView {
    
    static let identifier = Identify.NoReplyFooterView
    
    //MARK: - UI components
    
    let lineView = UIView()
        
    let noReplyView = UIView()
    let noReplyTitleLabel = UILabel()
    let noReplyMessageLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    
    //MARK: - Helper
    
    func initFooterView() {
        
        _ = lineView.then {
            $0.backgroundColor = UIColor(red: 93, green: 93, blue: 93)
            $0.alpha = 0.3
        }
    
        _ = noReplyView.then {
            $0.backgroundColor = .clear
        }
        
        _ = noReplyTitleLabel.then {
            $0.text = "댓글이 없습니다"
            $0.textColor = .black
            $0.font = Font.emptyTableBoldLabel
            $0.textAlignment = .center
        }
        
        _ = noReplyMessageLabel.then {
            $0.text = "댓글을 작성해주세요"
            $0.textColor = .lightGray
            $0.numberOfLines = 0
            $0.font = Font.emptyTableLabel
            $0.textAlignment = .center
        }
    }
    
    func addContentView() {
        contentView.addSubview(lineView)
        contentView.addSubview(noReplyView)
        
        noReplyView.addSubview(noReplyTitleLabel)
        noReplyView.addSubview(noReplyMessageLabel)
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(0.3)
            
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
        }
        
        noReplyView.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
                        
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
        }
        
        noReplyTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(noReplyView.snp.centerX)
                        
            $0.top.equalTo(noReplyView.snp.top)
        }
        
        noReplyMessageLabel.snp.makeConstraints {
            $0.centerX.equalTo(noReplyTitleLabel)
            
            $0.top.equalTo(noReplyTitleLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(noReplyView.snp.bottom)
        }
    }
}
