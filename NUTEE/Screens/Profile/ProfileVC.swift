//
//  UserVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SkeletonView

class ProfileVC: UIViewController {

    // MARK: - UI components
    
    let userInfoView = UIView()
    
    let userProfileImageImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)).then {
        $0.contentMode = .scaleAspectFit
        $0.cornerRadius = 0.5 * $0.frame.size.width
        $0.clipsToBounds = true
        
        $0.isSkeletonable = true
//        $0.showAnimatedGradientSkeleton()
        }
    let userNickNameButton = UIButton().then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.setTitleColor(UIColor(red: 112, green: 112, blue: 112), for: .normal)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        $0.isSkeletonable = true
//        $0.showAnimatedGradientSkeleton()
    }
    
    let containerTextViewsView = UIView().then {
        $0.isSkeletonable = true
//        $0.showAnimatedGradientSkeleton()
    }
    
    let postsTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.isEditable = false
    }
    let replysTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.isEditable = false
    }
    let recommandsTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.isEditable = false
    }
    
    let menuBar = MenuBarCV().then {
        $0.menuList = ["내가 쓴 글", "내가 쓴 댓글", "내가 추천한 글"]
    }
    
    let userFeedContainerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        $0.collectionViewLayout = layout
        
        $0.register(FeedContainerCVCell.self, forCellWithReuseIdentifier: "FeedContainerCVCell")
        
        $0.backgroundColor = .white
        
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NUTEE"
        view.backgroundColor = .white
        
        setNavigationBarItem()
        makeConstraints()
        fillDataToView()
    }
    
    // MARK: - Helper
    
    func setNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(didTapSetting))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
    }
    
    func makeConstraints() {
        // Add SubViews
        view.addSubview(userInfoView)
        
        userInfoView.addSubview(userProfileImageImageView)
        userInfoView.addSubview(userNickNameButton)
        
        userInfoView.addSubview(containerTextViewsView)
        containerTextViewsView.addSubview(postsTextView)
        containerTextViewsView.addSubview(replysTextView)
        containerTextViewsView.addSubview(recommandsTextView)
        
        view.addSubview(menuBar)
        
        view.addSubview(userFeedContainerCollectionView)
        
        // Make Constraints
        userInfoView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(100)
        }
        
        userProfileImageImageView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(userProfileImageImageView.snp.width)
            
            $0.centerY.equalTo(userInfoView)
            $0.left.equalTo(userInfoView.snp.left).offset(15)
        }
        userNickNameButton.snp.makeConstraints {
            $0.width.equalTo(60)
            
            $0.centerY.equalTo(userProfileImageImageView)
            $0.left.equalTo(userProfileImageImageView.snp.right).offset(5)
        }
        
        containerTextViewsView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.top).offset(15)
            $0.left.equalTo(userNickNameButton.snp.right).offset(15)
            $0.right.equalTo(userInfoView.snp.right).inset(15)
            $0.bottom.equalTo(userInfoView.snp.bottom).inset(15)
        }
        postsTextView.snp.makeConstraints {
            $0.centerY.equalTo(containerTextViewsView)
            $0.left.equalTo(containerTextViewsView.snp.left).offset(10)
        }
        replysTextView.snp.makeConstraints {
            $0.centerX.equalTo(containerTextViewsView)
            $0.centerY.equalTo(containerTextViewsView)
        }
        recommandsTextView.snp.makeConstraints {
            $0.centerY.equalTo(containerTextViewsView)
            $0.right.equalTo(containerTextViewsView.snp.right).inset(10)
        }
        
        menuBar.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(50)
        }
        
        userFeedContainerCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuBar.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        _ = userFeedContainerCollectionView.then {
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func fillDataToView() {
        userProfileImageImageView.image = UIImage(named: "nutee_zigi_white")
        userNickNameButton.setTitle("닉네임", for: .normal)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.alignment = .center
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 141, green: 141, blue: 141)]
        
        postsTextView.attributedText = NSAttributedString(string: "글\n100", attributes: attributes)
        replysTextView.attributedText = NSAttributedString(string: "댓글\n200", attributes: attributes)
        recommandsTextView.attributedText = NSAttributedString(string: "추천\n300", attributes: attributes)
        
        menuBar.profileVC = self
    }
    
    func showSkeletonView() {
        userProfileImageImageView.showAnimatedGradientSkeleton()
        userNickNameButton.showAnimatedGradientSkeleton()
        containerTextViewsView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView() {
        userProfileImageImageView.hideSkeleton()
        userNickNameButton.hideSkeleton()
        containerTextViewsView.hideSkeleton()
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        userFeedContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func didTapSetting() {
        let settingVC = SettingVC()
        
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
}

// MARK: - NewsFeed CollectionView Container

extension ProfileVC : UICollectionViewDelegate { }
extension ProfileVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: collectionView.frame.height)
    }

}

extension ProfileVC : UICollectionViewDataSource {
    
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
        let cell = userFeedContainerCollectionView.dequeueReusableCell(withReuseIdentifier: "FeedContainerCVCell", for: indexPath) as! FeedContainerCVCell

        cell.homeVC = self
        
        cell.newsFeedTableView.reloadData()

        return cell
    }
}
