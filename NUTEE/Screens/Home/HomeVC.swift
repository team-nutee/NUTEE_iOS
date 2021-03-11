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
    
    let loadMorePostButton = ResizableButton()
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NUTEE"
        view.backgroundColor = .white
        
        initViews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        if newsFeedContainerCollectionView.visibleCells.isEmpty == false {
            let currentCell = newsFeedContainerCollectionView.visibleCells[0] as? FeedContainerCVCell
            checkLastestPost(cell: currentCell)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    // MARK: - Helper
    
    func initViews() {
        _ = rightNavigationBarButton.then {
            $0.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.setImage(UIImage(named: "search_fill")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            
            $0.tintColor = .black
            
            $0.addTarget(self, action: #selector(didTapSearchBarItem), for: .touchUpInside)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNavigationBarButton)
        
        _ = menuBar.then {
            $0.menuList = ["카테고리", "내 전공", "전체 게시글"]
            $0.homeVC = self
        }
        
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
            
            $0.backgroundColor = .white
            
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
        
        _ = loadMorePostButton.then {
            $0.setTitle("새 게시물", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            
            $0.cornerRadius = 13
            $0.borderColor = .nuteeGreen
            $0.borderWidth = 1
            
            $0.backgroundColor = .white
            
            $0.addTarget(self, action: #selector(didTapLoadMorePostButton), for: .touchUpInside)
            
            $0.alpha = 0
        }
    }
    
    func makeConstraints() {
        view.addSubview(newsFeedContainerCollectionView)
        view.addSubview(menuBar)
        view.addSubview(loadMorePostButton) // 제일 마지막에 추가해야 보임
        
        
        menuBar.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(50)
        }
        
        newsFeedContainerCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuBar.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        loadMorePostButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(menuBar.snp.top)
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
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func didTapLoadMorePostButton() {
        guard let cell = newsFeedContainerCollectionView.visibleCells[0] as? FeedContainerCVCell else {
            return
        }
        cell.fetchNewsFeed()
        
        if cell.postContent?.count ?? 0 > 0 {
            cell.newsFeedTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
        controlLoadMorePostButton(show: false)
    }
    
    func checkLastestPost(cell: FeedContainerCVCell?) {
        var currentLastestPostId = 0
        if cell?.postContent?.isEmpty == false {
            currentLastestPostId = cell?.postContent?[0].id ?? 0
        }
        
        cell?.getPostsService(lastId: 0, limit: 1) { [self] (Post) in
            if Post.body.isEmpty == false {
                let updatedLaestPostId = Post.body[0].id
                if updatedLaestPostId > currentLastestPostId && currentLastestPostId != 0 {
                    controlLoadMorePostButton(show: true)
                } else {
                    controlLoadMorePostButton(show: false)
                }
            }
        }
    }
    
    func controlLoadMorePostButton(show: Bool) {
        let yPos: CGFloat
        let alphaValue: CGFloat
        
        if show == true {
            yPos = menuBar.frame.size.height + 10
            alphaValue = 1
        } else {
            yPos = 10
            alphaValue = 0
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [self] in
            loadMorePostButton.alpha = alphaValue
            loadMorePostButton.transform = CGAffineTransform.init(translationX: 0, y: yPos)
        })
    }
    
    func findCurrentFeedContainer(targetIndex: Int) -> String {
        let cellId: String
        
        switch targetIndex {
        case 0:
            cellId = Identify.FavoriteFeedCVCell
        case 1:
            cellId = Identify.MajorFeedCVCell
        case 2:
            cellId = Identify.AllFeedCVCell
        default:
            cellId = Identify.FeedContainerCVCell
        }
        
        return cellId
    }
    
    func findCurrentCVCell(targetScrollView: UIScrollView) -> UICollectionViewCell? {
        let currentIndex = targetScrollView.contentOffset.x / newsFeedContainerCollectionView.frame.size.width
        let cellId = findCurrentFeedContainer(targetIndex: Int(currentIndex))
        
        var currentCell: UICollectionViewCell?
        let cells = newsFeedContainerCollectionView.visibleCells
        for index in 0..<cells.count {
            let searchCell = NSStringFromClass(type(of: cells[index])).components(separatedBy: ".").last ?? ""
            if searchCell == cellId {
                currentCell = cells[index]
                break
            }
        }
        
        return currentCell
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentCell = findCurrentCVCell(targetScrollView: scrollView)
        checkLastestPost(cell: currentCell as? FeedContainerCVCell)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let currentCell = findCurrentCVCell(targetScrollView: scrollView)
        checkLastestPost(cell: currentCell as? FeedContainerCVCell)
    }
    
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
        let cellId = findCurrentFeedContainer(targetIndex: indexPath.row)
        
        let cell = newsFeedContainerCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedContainerCVCell
        cell.homeVC = self
        
        return cell
    }
    
}
