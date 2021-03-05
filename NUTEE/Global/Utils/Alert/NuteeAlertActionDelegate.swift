//
//  NuteeAlertActionDelegate.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/02/19.
//  Copyright © 2021 Nutee. All rights reserved.
//

// MARK: - NuteeAlert Sheet/Dialogue와 통신하기 위한 프로토콜 정의

import Foundation

protocol NuteeAlertActionDelegate: class {
    
    func nuteeAlertSheetAction(indexPath: Int)
    
    func nuteeSelectSheetAction(selectedOptionItem: String, sheetMode: SelectMode)
    
    func nuteeAlertDialogueAction(text: String)
    
}

// To make function 'optional' (make default implementation)
extension NuteeAlertActionDelegate {
    
    func nuteeAlertSheetAction(indexPath: Int) { }
    
    func nuteeSelectSheetAction(selectedOptionItem: String, sheetMode: SelectMode) { }
    
    func nuteeAlertDialogueAction(text: String) { }
    
}
