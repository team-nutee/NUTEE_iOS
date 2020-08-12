//
//  NoticeTVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/12.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

class NoticeFeedTVCell: UITableViewCell {
    
    static let identifier = Identify.NoticeFeedTVCell
    
    // MARK: - UI components
    
    let fixedNoticeImageView = UIImageView()
    
    let titleLabel = UILabel()
    
    let dateLabel = UILabel()
    let authorLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    var noticeContent: NoticeElement?
    
    // MARK: - Life Cycle
    
    // MARK: - Helper
    
    func initCell () {
        _ = fixedNoticeImageView.then {
            $0.image = UIImage(systemName: "pin")
            $0.tintColor = .red
            
            if noticeContent?.no == "공지" {
                $0.isHidden = false
            } else {
                $0.isHidden = true
            }
        }
        
        _ = titleLabel.then {
            $0.text = noticeContent?.title
            $0.font = .boldSystemFont(ofSize: 17)
        }
        
        _ = dateLabel.then {
            $0.text = noticeContent?.date
            $0.font = .systemFont(ofSize: 11)
            $0.textColor = .gray
        }
        _ = authorLabel.then {
            $0.text = noticeContent?.author
            $0.font = .systemFont(ofSize: 11)
            $0.textColor = .gray
            $0.sizeToFit()
        }
    }
    
    func addContentView() {
        
        contentView.addSubview(fixedNoticeImageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(authorLabel)
        
        
        fixedNoticeImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(fixedNoticeImageView.snp.width)

            $0.centerY.equalTo(titleLabel)
            $0.left.equalTo(contentView.snp.left).offset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.left.equalTo(fixedNoticeImageView.snp.right).offset(10)
            $0.right.equalTo(contentView.snp.right).inset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(65)
            
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalTo(titleLabel.snp.left)
            $0.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
        authorLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.left.equalTo(dateLabel.snp.right).offset(20)
        }
        
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if isHighlighted == true {
            contentView.backgroundColor = UIColor(red: 227 / 255.0, green: 241 / 255.0, blue: 223 / 255.0 , alpha: 1.0)
        } else {
            contentView.backgroundColor = .white
        }
    }
    
}

