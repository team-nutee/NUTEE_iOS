//
//  ReReplyTVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/03/08.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class ReReplyTVCell: ReplyTVCell {
    
    //MARK: - UI components
    
    //MARK: - Variables and Properties

    //MARK: - Life Cycle
    
    //MARK: - Helper
    
    override func makeConstraints() {
        super.makeConstraints()
        
        profileImageView.snp.updateConstraints {
            $0.left.equalTo(contentView.snp.left).offset(65)
        }
    }
}
