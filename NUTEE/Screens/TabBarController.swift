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
        if viewController == tabBarController.viewControllers?[2] {
            // present 형식으로 PostVC 화면 띄우기
            didTapToPostButton()

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
        var navigationController: UINavigationController
        
        // HomeTab
        let homeVC = HomeVC()
        navigationController = UINavigationController(rootViewController: homeVC)
        
//        navigationController.tabBarItem.image = UIImage(systemName: "house")
//        navigationController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")

        navigationController.tabBarItem.image = UIImage(named: "home")
        navigationController.tabBarItem.selectedImage = UIImage(named: "home_fill")
        
        let HomeTab = navigationController
        
        // SearchTab
//        let searchVC = SearchVC()
//        navigationController = UINavigationController(rootViewController: searchVC)
//
//        navigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
//        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
//        navigationController.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
//
//        let SearchTab = navigationController
        
        // NotificationTab
        let notificationVC = NotificationVC()
        navigationController = UINavigationController(rootViewController: notificationVC)
        
        navigationController.tabBarItem.image = UIImage(systemName: "bell")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")

        let NotificationTab = navigationController
        
        // PostTab
        let postVC = UIViewController()
        postVC.view.backgroundColor = .white
        navigationController = UINavigationController(rootViewController: postVC)
//        navigationController.tabBarItem.image = UIImage(systemName: "plus")
        navigationController.tabBarItem.image = UIImage(named: "post")
        
        let PostTab = navigationController
        
        // NoticeTab
        let noticeVC = NoticeVC()
        navigationController = UINavigationController(rootViewController: noticeVC)
        
//        navigationController.tabBarItem.image = UIImage(systemName: "pin")
//        navigationController.tabBarItem.selectedImage = UIImage(systemName: "pin.fill")
        navigationController.tabBarItem.image = UIImage(named: "alarm")
        navigationController.tabBarItem.selectedImage = UIImage(named: "alarm_fill")

        let NoticeTab = navigationController
        
        // ProfileTab
        let profileVC = ProfileVC()
        navigationController = UINavigationController(rootViewController: profileVC)
//        navigationController.tabBarItem.image = UIImage(systemName: "person")
//        navigationController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        navigationController.tabBarItem.image = UIImage(named: "profile")
        navigationController.tabBarItem.selectedImage = UIImage(named: "profile_fill")

        let ProfileTab = navigationController
        
        // TabBarController Settings
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [HomeTab, NotificationTab, PostTab, NoticeTab, ProfileTab]

        tabBarController.tabBar.tintColor = .nuteeGreen
        
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        
        return tabBarController
    }
    
}
