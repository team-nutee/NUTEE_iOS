//
//  FeedContainerVC.swift
//  NUTEE
//
//  Created by eunwoo on 2021/03/04.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class FeedContainerVC: UIViewController {

    // MARK: - UI components
    
    let activityIndicator = UIActivityIndicatorView()
        
    let refreshControl = UIRefreshControl()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Variables and Properties
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        makeConstraint()
        
        setRefresh()
    }

    // MARK: - Helper
    
    func initView() {
        _ = collectionView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(FeedContainerCVCell.self, forCellWithReuseIdentifier: Identify.FeedContainerCVCell)
            
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(view.snp.top)
                $0.left.equalTo(view.snp.left)
                $0.right.equalTo(view.snp.right)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            
            $0.backgroundColor = .white
            
            $0.alwaysBounceVertical = true
        }
        
        _ = activityIndicator.then {
            $0.style = .medium
            $0.startAnimating()
        }
    }
    
    func makeConstraint() {
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top)
            $0.left.equalTo(collectionView.snp.left)
            $0.right.equalTo(collectionView.snp.right)
            $0.bottom.equalTo(collectionView.snp.bottom)
        }
    }
    
    func setRefresh() {
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(updatePosts), for: UIControl.Event.valueChanged)
    }

    @objc func updatePosts() {
        // 글 업데이트 되는 코드 구현
    }

}

// MARK: - CollectionView Delegate
extension FeedContainerVC : UICollectionViewDelegate { }
extension FeedContainerVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }

}
extension FeedContainerVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identify.FeedContainerCVCell, for: indexPath) as! FeedContainerCVCell
        
        cell.homeVC = self
        
        return cell
    }
}
