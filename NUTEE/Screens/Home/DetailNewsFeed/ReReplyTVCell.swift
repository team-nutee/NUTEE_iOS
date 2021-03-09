//
//  ReReplyTVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/03/08.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

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
    
    override func showNuteeAlertSheet() {
        let nuteeAlertSheet = NuteeAlertSheet()
        nuteeAlertSheet.nuteeAlertActionDelegate = self
        
        if comment?.user?.id == KeychainWrapper.standard.integer(forKey: "id") {
            nuteeAlertSheet.optionList = [["수정", UIColor.black],
                                          ["삭제", UIColor.red]]
            
        } else {
            nuteeAlertSheet.optionList = [["🚨신고하기", UIColor.red]]
        }
        
        nuteeAlertSheet.modalPresentationStyle = .custom

        detailNewsFeedVC?.present(nuteeAlertSheet, animated: true)
    }
    
    override func nuteeAlertSheetAction(indexPath: Int) {
        detailNewsFeedVC?.dismiss(animated: true, completion: nil)
        
        if comment?.user?.id == KeychainWrapper.standard.integer(forKey: "id") {
            switch indexPath {
            case 0:
                editComment()
            case 1:
                deleteComment()
            default:
                break
            }
            
        } else {
            switch indexPath {
            case 0:
                reportComment()
            default:
                break
            }
        }
    }
}
