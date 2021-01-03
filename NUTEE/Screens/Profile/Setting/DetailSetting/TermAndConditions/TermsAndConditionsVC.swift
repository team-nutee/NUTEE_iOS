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

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let termsAndConditionsTitle = UILabel()
    @IBOutlet var contentsTextView: UITextView!
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        initView()
        makeConstraints()
    }
    
    // MARK: - Helper
    
    func initView() {
        _ = scrollView.then {
            $0.scrollIndicatorInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        }
        
        _ = termsAndConditionsTitle.then {
            $0.text = "NUTEE 서비스 이용약관"
            $0.font = .systemFont(ofSize: 22, weight: .heavy)
        }
        _ = contentsTextView.then {
            $0.tintColor = .nuteeGreen
        }
    }
    
    func makeConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(termsAndConditionsTitle)
        containerView.addSubview(contentsTextView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.left.equalTo(view.safeAreaInsets.left)
            $0.right.equalTo(view.safeAreaInsets.right)
            $0.bottom.equalTo(view.safeAreaInsets.bottom)
        }
        containerView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.height.greaterThanOrEqualTo(scrollView.snp.height)
            
            $0.top.equalTo(scrollView.snp.top)
            $0.left.equalTo(scrollView.snp.left)
            $0.right.equalTo(scrollView.snp.right)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        termsAndConditionsTitle.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(10)
            $0.left.equalTo(containerView.snp.left).offset(10)
            $0.right.equalTo(containerView.snp.right).inset(10)
        }
        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(termsAndConditionsTitle.snp.bottom).offset(13)
            $0.left.equalTo(termsAndConditionsTitle.snp.left)
            $0.right.equalTo(termsAndConditionsTitle.snp.right)
            $0.bottom.equalTo(containerView.snp.bottom)
        }
    }
}
