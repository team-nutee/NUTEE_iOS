//
//  TermsAndConditionsVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/14.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class TermsAndConditionsVC : UIViewController {
    
    // MARK: - UI components

    @IBOutlet var contentsTextView: UITextView!
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "서비스 이용약관"
        view.backgroundColor = .white
        
        contentsTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        contentsTextView.tintColor = .nuteeGreen
    }
    
    // MARK: - Helper
}
