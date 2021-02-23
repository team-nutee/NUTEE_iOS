//
//  UIViewController+Extension.swift
//  NUTEE
//
//  Created by 오준현 on 2020/07/29.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

extension UIViewController {

    func simpleNuteeAlertDialogue(title: String, message: String) {
        let nuteeAlertDialogue = NuteeAlertDialogue()
        nuteeAlertDialogue.dialogueData = [title, message]
        nuteeAlertDialogue.cancelButton.isHidden = true
        
        nuteeAlertDialogue.modalPresentationStyle = .overFullScreen
        nuteeAlertDialogue.modalTransitionStyle = .crossDissolve
        
        present(nuteeAlertDialogue, animated: true)
    }
    
    func showActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            
            activityIndicator.style = .large
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2 - 40)
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
