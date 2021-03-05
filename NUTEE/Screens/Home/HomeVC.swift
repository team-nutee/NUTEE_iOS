//
//  HomeVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/31.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

import SnapKit
import Then

class HomeVC: UIViewController {
    
    // MARK: - UI components
    
    let rightNavigationBarButton = HighlightedButton()
    
    let menuBar = MenuBarCV()
    
    let newsFeedContainerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NUTEE"
        view.backgroundColor = .white
        
        setNavigationBarItem()
        setMenuBar()
        setNewsFeedContainerCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    // MARK: - Helper
    
    func setNavigationBarItem() {
        _ = rightNavigationBarButton.then {
            $0.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.setImage(UIImage(named: "search_fill")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            
            $0.tintColor = .black
            
            $0.addTarget(self, action: #selector(didTapSearchBarItem), for: .touchUpInside)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationBarButton)
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
            
            $0.menuList = ["카테고리", "내 전공", "전체 게시글"]
            $0.homeVC = self
        }
    }
    
    func setNewsFeedContainerCollectionView() {
        _ = newsFeedContainerCollectionView.then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
            
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(FeedContainerCVCell.self, forCellWithReuseIdentifier: Identify.FeedContainerCVCell)
            
            $0.register(FavoriteFeedCVCell.self, forCellWithReuseIdentifier: Identify.FavoriteFeedCVCell)
            $0.register(MajorFeedCVCell.self, forCellWithReuseIdentifier: Identify.MajorFeedCVCell)
            $0.register(AllFeedCVCell.self, forCellWithReuseIdentifier: Identify.AllFeedCVCell)
            
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
        newsFeedContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func didTapSearchBarItem() {
        let searchVC = SearchVC()
        searchVC.getCategoriesService(completionHandler: {
            searchVC.afterFetchCategoryView()
        })
        searchVC.homeVC = self
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

// MARK: - NewsFeed CollectionView Container

extension HomeVC : UICollectionViewDelegate { }
extension HomeVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }

}

extension HomeVC : UICollectionViewDataSource {
    
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
            cellId = Identify.FavoriteFeedCVCell
        case 1:
            cellId = Identify.MajorFeedCVCell
        case 2:
            cellId = Identify.AllFeedCVCell
        default:
            cellId = Identify.FeedContainerCVCell
        }
        
        let cell = newsFeedContainerCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedContainerCVCell
        cell.homeVC = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("")
    }
}
