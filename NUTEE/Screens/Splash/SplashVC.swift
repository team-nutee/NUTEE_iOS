//
//  SplashVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    // MARK: - UI components
    
    let nuteeImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "Nutee_Image_white")
    }
    
    // MARK: - Variables and Properties
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addSplashView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        Thread.sleep(forTimeInterval: 0.5)
        startNuteeApp()
    }
    
    // MARK: - Helper
    
    func addSplashView() {
        view.backgroundColor = .white
        
        view.addSubview(nuteeImageView)
        
        nuteeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(nuteeImageView.snp.width)
        }
    }
    
    func startNuteeApp() {
        var navigationController: UINavigationController
        
        // HomeTab
        let homeVC = HomeVC()
        navigationController = UINavigationController(rootViewController: homeVC)
        
        navigationController.tabBarItem.image = UIImage(systemName: "house")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")

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
        navigationController.tabBarItem.image = UIImage(systemName: "plus")
        
        let PostTab = navigationController
        
        // NoticeTab
        let noticeVC = NoticeVC()
        navigationController = UINavigationController(rootViewController: noticeVC)
        
        navigationController.tabBarItem.image = UIImage(systemName: "pin")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "pin.fill")

        let NoticeTab = navigationController
        
        // ProfileTab
        let profileVC = ProfileVC()
        navigationController = UINavigationController(rootViewController: profileVC)
        navigationController.tabBarItem.image = UIImage(systemName: "person")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

        let ProfileTab = navigationController
        
        // TabBarController Settings
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [HomeTab, NotificationTab, PostTab, NoticeTab, ProfileTab]

        tabBarController.tabBar.tintColor = .nuteeGreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
//        sceneDelegate.window?.rootViewController = tabBarController
        sceneDelegate.window?.rootViewController = LoginVC()
    }
    
}
