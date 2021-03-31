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
    
    let toPostButton = TabBarHighlightedButton()
    
    // MARK: - Variables and Properties
    
    let toPostIndex = 2
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setModalStyle()
        
        setTabBarStyle()
        
        addToPostButton()
        delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        toPostButton.snp.updateConstraints {
            let tabsCount = CGFloat(viewControllers?.count ?? 0)
            let tabIconWidth = tabBar.frame.size.width / tabsCount
            
            $0.width.equalTo(tabIconWidth)
            $0.height.equalTo(tabBar.frame.size.height - view.safeAreaInsets.bottom)
            
            $0.left.equalTo(view.snp.left).offset(tabIconWidth * CGFloat(toPostIndex))
        }
    }
    
    // MARK: - Helper
    
    func setModalStyle() {
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    func setTabBarStyle() {
        UITabBar.clearShadow()
        
        _ = tabBar.then {
            $0.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
            $0.tintColor = .nuteeGreen
        }
    }
    
    func addToPostButton() {
        _ = toPostButton.then {
            $0.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.setImage(UIImage(named: "add_fill")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            
            $0.addTarget(self, action: #selector(didTapToPostButton), for: .touchUpInside)
        }
        
        view.addSubview(toPostButton)
        toPostButton.snp.makeConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(0)
            
            $0.left.equalTo(view.snp.left).offset(0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
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
  
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[toPostIndex] {
            // 해당 탭 화면('+' 버튼에 해당하는)으로 VC 전환 금지
            return false
        } else {
            return true
        }
    }
}

// MARK: - Build NuteeApp

struct BuildTabBarController {
    
    private init() {}
    
    static let shared = BuildTabBarController()
    
    func nuteeApp() -> TabBarController {
        let HomeTab = setTabBarViewController(viewcontroller: HomeVC(), image: "home", selectedImage: "home_fill")
//        let NotificationTab = setTabBarViewController(viewcontroller: NotificationVC(), image: "notice", selectedImage: "notice_fill")
        let PostTab = UINavigationController()
        let NoticeTab = setTabBarViewController(viewcontroller: NoticeVC(), image: "speaker", selectedImage: "speaker_fill")
        let ProfileTab = setTabBarViewController(viewcontroller: ProfileVC(), image: "user", selectedImage: "user_fill")
        
        // TabBarController Settings
        let tabBarController = TabBarController()
//        tabBarController.viewControllers = [HomeTab, NotificationTab, PostTab, NoticeTab, ProfileTab]
        tabBarController.viewControllers = [HomeTab, NoticeTab, PostTab, ProfileTab]
        
        return tabBarController
    }
    
    func setTabBarViewController(viewcontroller: UIViewController, image: String, selectedImage: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewcontroller)
        
        navigationController.tabBarItem.image = UIImage(named: image)
        navigationController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        
        return navigationController
    }
    
}
