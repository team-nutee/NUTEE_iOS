//
//  UserMenuBarCV.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/23.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class UserMenuBarCV: MenuBarCV {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    var userInfomationList = [0]
    
    // MARK: - Life Cycle
    
    // MARK: - Helper
    
    override func registerCVCell() {
        menuBarCollectionView.register(UserMenuBarCVCell.self, forCellWithReuseIdentifier: Identify.UserMenuBarCVCell)
    }
    
    // MARK: - Menu Bar CollectionView Delegate
    
    override func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuCount = CGFloat(menuList.count)
        let standardItemWidth = self.frame.width / menuCount
        
        let itemWidth: CGFloat
        let adjustLength: CGFloat = 30
        switch indexPath.row {
        case 1:
            itemWidth = standardItemWidth - adjustLength
        case 2:
            itemWidth = standardItemWidth + adjustLength
        default:
            itemWidth = standardItemWidth
        }
        
        return CGSize(width: itemWidth, height: collectionView.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: Identify.UserMenuBarCVCell, for: indexPath) as! UserMenuBarCVCell
        
        cell.menuTitle.text = menuList[indexPath.item]
        cell.userInfomationButton.setTitle(String(userInfomationList[indexPath.row]), for: .normal)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

