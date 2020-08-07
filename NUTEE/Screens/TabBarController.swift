//
//  TabBarController.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/01.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - UI components
    
    let toPostButton = UIButton()
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        setTabBarStyle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Helper
    
    func setTabBarStyle() {
        UITabBar.clearShadow()
        self.tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
    @objc func didTapToPostButton() {
        let postVC = PostVC()
        
        let navigationController = UINavigationController(rootViewController: postVC)
        navigationController.modalPresentationStyle = .currentContext
        
        present(navigationController, animated: true, completion: nil)
    }
    
}

// MARK: - TabBarController Delegate

extension TabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) { }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[1] {
            // present 형식으로 PostVC 화면 띄우기
            didTapToPostButton()

            // 해당 탭 화면('+' 버튼에 해당하는)으로 VC 전환 금지
            return false
        } else {
            return true
        }
    }
}
