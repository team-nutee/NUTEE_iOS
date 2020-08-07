//
//  PostCVCell.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class PostImageCVCell : UICollectionViewCell {
    
    // MARK: - UI components
    
    let postImageImageView = UIImageView()
    let cancelButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initCell()
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = postImageImageView.then {
            $0.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        _ = cancelButton.then {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .lightGray
        }
    }
    
    func addContentView() {
        
        contentView.addSubview(postImageImageView)
        contentView.addSubview(cancelButton)
        
        
        postImageImageView.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(postImageImageView.snp.width)

            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(cancelButton.snp.width)
            
            $0.top.equalTo(postImageImageView).offset(5)
            $0.right.equalTo(postImageImageView).inset(5)
        }
        
    }
}
