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
        
        let newsFeedVC = NewsFeedVC()
        let navigationController = UINavigationController(rootViewController: newsFeedVC)
        
        navigationController.tabBarItem.image = UIImage(systemName: "house")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let newsFeedVC2 = NewsFeedVC()
        let navigationController2 = UINavigationController(rootViewController: newsFeedVC2)
        navigationController2.tabBarItem.image = UIImage(systemName: "person")
        navigationController2.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController, navigationController2]
        tabBarController.tabBar.tintColor = .nuteeGreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = tabBarController
    }

}
