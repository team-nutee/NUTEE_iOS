//
//  SearchTVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/08.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SearchTVC: UITableViewCell {

    // MARK: - UI components
    
    let keywordHistoryLabel = UILabel()
    let deleteButton = UIButton()
    let underBarView = UIView()
    
    // MARK: - Variables and Properties
    
    var recode: String?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initCell()
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = keywordHistoryLabel.then {
            $0.font = .systemFont(ofSize: 17)
        }
        
        _ = deleteButton.then {
            $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            $0.tintColor = .lightGray
        }
    }
    
    func addContentView() {
        
        contentView.addSubview(keywordHistoryLabel)
        contentView.addSubview(deleteButton)
        
        
        keywordHistoryLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(5)
            $0.centerY.equalTo(contentView)
        }
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(deleteButton.snp.width)
            
            $0.right.equalTo(contentView.snp.right).inset(5)
            $0.centerY.equalTo(contentView)
        }
        
    }
    
    @objc func didTapDeleteButton() {
        
    }
    
}
