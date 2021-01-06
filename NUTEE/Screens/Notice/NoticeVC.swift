//
//  NoticeVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

import SnapKit
import Then

class NoticeVC: UIViewController {
    
    // MARK: - UI components
    
    let menuBar = MenuBarCV()
    
    let noticeFeedContainerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "공지사항"
        view.backgroundColor = .white
        
        setMenuBar()
        setNoticeFeedContainerCollectionView()
    }
    
    // MARK: - Helper
    
    func setMenuBar() {
        _ = menuBar.then {
            view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.top.equalTo(view.snp.top)
                $0.left.equalTo(view.snp.left)
                $0.right.equalTo(view.snp.right)
                $0.height.equalTo(50)
            }
            
            $0.menuList = ["학사", "수업", "학점", "장학", "일반", "행사"]
            $0.noticeVC = self
        }
    }
    
    func setNoticeFeedContainerCollectionView() {
        _ = noticeFeedContainerCollectionView.then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
            
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(NoticeFeedContainerCVCell.self, forCellWithReuseIdentifier: Identify.NoticeFeedContainerCVCell)
            
            $0.register(BachelorFeedCVCell.self, forCellWithReuseIdentifier: Identify.BachelorFeedCVCell)
            $0.register(ClassFeedCVCell.self, forCellWithReuseIdentifier: Identify.ClassFeedCVCell)
            $0.register(ExchangeFeedCVCell.self, forCellWithReuseIdentifier: Identify.ExchangeFeedCVCell)
            $0.register(ScholarshipFeedCVCell.self, forCellWithReuseIdentifier: Identify.ScholarshipFeedCVCell)
            $0.register(GeneralFeedCVCell.self, forCellWithReuseIdentifier: Identify.GeneralFeedCVCell)
            $0.register(EventFeedCVCell.self, forCellWithReuseIdentifier: Identify.EventFeedCVCell)
            
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(menuBar.snp.bottom)
                $0.left.equalTo(view.snp.left)
                $0.right.equalTo(view.snp.right)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            
            $0.backgroundColor = .white
            
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        noticeFeedContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

}

// MARK: - NoticeFeed CollectionView Container

extension NoticeVC : UICollectionViewDelegate { }
extension NoticeVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }

}

extension NoticeVC : UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.positionBarView.frame.origin.x = scrollView.contentOffset.x / CGFloat(menuBar.menuList.count) + 10
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let menuIndex = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: menuIndex, section: 0)
        menuBar.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBar.menuList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId: String
        
        switch indexPath.row {
        case 0:
            cellId = Identify.BachelorFeedCVCell
        case 1:
            cellId = Identify.ClassFeedCVCell
        case 2:
            cellId = Identify.ExchangeFeedCVCell
        case 3:
            cellId = Identify.ScholarshipFeedCVCell
        case 4:
            cellId = Identify.GeneralFeedCVCell
        case 5:
            cellId = Identify.EventFeedCVCell
        default:
            cellId = Identify.NoticeFeedContainerCVCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NoticeFeedContainerCVCell
        cell.noticeVC = self
        
        return cell
    }
    
}
