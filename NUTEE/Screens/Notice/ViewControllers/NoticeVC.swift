//
//  NoticeVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SnapKit
import SwiftKeychainWrapper
import Then

class NoticeVC: UIViewController {
    // MARK: - UI components
    
    let navigationBar = UINavigationBar()
    
    let menuBar = MenuBarCV()
    
    let noticeCollectionView = UICollectionView(frame: .zero,
                                    collectionViewLayout: UICollectionViewFlowLayout()).then
        {
            $0.register(NoticeTabCVCell.self,
                        forCellWithReuseIdentifier: Identify.noticeTabCVCell)
            $0.register(NoticePageCVCell.self,
                        forCellWithReuseIdentifier: Identify.noticePageCVCell)
            
            
            $0.scrollIndicatorInsets = .zero
            $0.backgroundColor = .white
            $0.translatesAutoresizingMaskIntoConstraints = false
            let layout = UICollectionViewFlowLayout().then {
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0
                $0.minimumInteritemSpacing = 0
            }
            
            $0.collectionViewLayout = layout
            $0.isPagingEnabled = true
            $0.allowsMultipleSelection = true
            $0.allowsSelection = true
    }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(noticeCollectionView)
        noticeCollectionView.pinEdgesToSuperView()
        noticeCollectionView.delegate = self
        noticeCollectionView.dataSource = self
//        view.backgroundColor = .yellow
//        navigationController?.navigationBar.tintColor = .teal
        navigationController?.navigationBar.barTintColor = .systemPink
        navigationController?.navigationBar.backgroundColor = .systemPurple
        navigationController?.navigationBar.topItem?.title = "123"
        setMenuBar()
        
        
    }
    
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
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        noticeCollectionView.scrollToItem(at: indexPath,
                                          at: .centeredHorizontally,
                                          animated: true)
    }

}

extension NoticeVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.positionBarView.frame.origin.x = scrollView.contentOffset.x / CGFloat(menuBar.menuList.count) + 10
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let menuIndex = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: menuIndex, section: 0)
        menuBar.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

}
extension NoticeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView:UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.numberOfSections {
        case 0:
            return CGSize(width: self.view.frame.width, height: 50)
            
        case 1:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height - 50)
            
        default:
            return CGSize(width: 0, height: 0)
            
        }
    }
}

extension NoticeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 6
            
        case 1:
            return 6
            
        default:
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.numberOfSections {
            
        case 0:
            guard let tabCell =
                collectionView.dequeueReusableCell(withReuseIdentifier: Identify.noticeTabCVCell,
                                                   for: indexPath)
                    as? NoticeTabCVCell else { return UICollectionViewCell() }
            
            tabCell.backgroundColor = .red
            
            return tabCell
            
        case 1:
            guard let pageCell =
                collectionView.dequeueReusableCell(withReuseIdentifier: Identify.noticePageCVCell,
                                                   for: indexPath)
                    as? NoticePageCVCell else { return UICollectionViewCell() }
            
            if indexPath.row % 2 == 0 {
                pageCell.backgroundColor = .blue
            } else {
                pageCell.backgroundColor = .red
            }
            pageCell.awakeFromNib()
            
            return pageCell
            
        default:
            return UICollectionViewCell()
            
        }
    }
}

