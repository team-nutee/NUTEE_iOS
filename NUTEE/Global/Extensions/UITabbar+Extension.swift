//
//  UITabbar+Extension.swift
//  NUTEE
//
//  Created by 오준현 on 2020/07/29.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().layer.borderWidth = 0.0

    }
}
