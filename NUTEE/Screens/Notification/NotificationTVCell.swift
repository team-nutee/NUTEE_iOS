//
//  NotificationTVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/10/22.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class NotificationTVCell: UITableViewCell {
    
    static let identifier = Identify.NotificationTVCell
    
    // MARK: - UI components
    
    let categoryButton = UIButton().then {
        $0.layer.cornerRadius = 9
        $0.backgroundColor = UIColor(red: 180, green: 180, blue: 180)

        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.titleLabel?.font = .systemFont(ofSize: 11)
        $0.setTitleColor(.white, for: .normal)
        
        $0.isUserInteractionEnabled = false
    }
    var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = UIColor(red: 178, green: 178, blue: 178)
    }
    
    var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = UIColor(red: 115, green: 115, blue: 115)
    }
    var contentTextView = UITextView().then {
        $0.textContainer.maximumNumberOfLines = 3
        $0.textContainer.lineBreakMode = .byTruncatingTail
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
        $0.isUserInteractionEnabled = false
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5) // 기본 설정 값인 0이 좌우 여백이 있기 때문에 조정 필요
    }
    
    var cellSeperatorView = UIView().then {
        $0.backgroundColor = UIColor(red: 235, green: 235, blue: 235)
    }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func makeConstraints() {
        
        // Add SubViews
        contentView.addSubview(categoryButton)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentTextView)
        
        contentView.addSubview(cellSeperatorView)
        
        // Make Constraints
        let TopAndBottomSpace = 10
        let leftAndRightSpace = 26
        categoryButton.snp.makeConstraints {
            $0.width.equalTo(63)
            $0.height.equalTo(26)
            
            $0.top.equalTo(contentView.snp.top).offset(TopAndBottomSpace)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
        }
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryButton)
            $0.left.equalTo(categoryButton.snp.right).offset(14)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryButton.snp.bottom).offset(10)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
        }
        contentTextView.snp.makeConstraints {
            
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(contentView.snp.left).offset(leftAndRightSpace)
            $0.right.equalTo(contentView.snp.right).inset(leftAndRightSpace)
        }
        
        cellSeperatorView.snp.makeConstraints {
            $0.height.equalTo(3)
            
            $0.top.equalTo(contentTextView.snp.bottom).offset(TopAndBottomSpace)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func fillDataToView () {
        categoryButton.setTitle("글", for: .normal)
        dateLabel.text = "5일 전"
        
        titleLabel.text = "마진쿡님이 지구온난화 카테고리에 글을 작성하였습니다"
        titleLabel.sizeToFit()
        contentTextView.text = "\"환경을 위해 충전기는 별매입니다\""
    }
    
}
