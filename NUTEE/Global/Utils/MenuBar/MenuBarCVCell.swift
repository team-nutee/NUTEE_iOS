//
//  MenuBarCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class MenuBarCVCell: UICollectionViewCell {
    
    // MARK: - UI components
    
    let menuTitle = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCell()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = menuTitle.then {
            $0.font = .systemFont(ofSize: 15)
            $0.textColor = .gray
        }
    }
    
    func makeConstraints() {
        contentView.addSubview(menuTitle)
        
        menuTitle.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }
    }
    
    // MARK: - Override Function
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .boldSystemFont(ofSize: 18)
                    $0.textColor = .nuteeGreen
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 15)
                    $0.textColor = .gray
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .boldSystemFont(ofSize: 18)
                    $0.textColor = .nuteeGreen
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 15)
                    $0.textColor = .gray
                }
            }
        }
    }
    
}
