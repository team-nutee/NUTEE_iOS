//
//  UserVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // MARK: - UI components
    
    let userInfoView = UIView()
    
    let userProfileImageImageView = UIImageView()
    let userNickNameButton = UIButton()
    
    let containerTextViewsView = UIView()
    let postsTextView = UITextView()
    let replysTextView = UITextView()
    let recommandsTextView = UITextView()
    
    let menuBar = MenuBarCV()
    
    let userFeedContainerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Variables and Properties
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NUTEE"
        view.backgroundColor = .white
        
        setUserInfoView()
        setMenuBar()
        setUserFeedContainerCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
    }
    
    // MARK: - Helper
    
    func setUserInfoView() {
        _ = userProfileImageImageView.then {
            $0.image = UIImage(named: "nutee_zigi_white")
            $0.contentMode = .scaleAspectFit
            $0.cornerRadius = 0.5 * $0.frame.width
        }
        _ = userNickNameButton.then {
            $0.setTitle("닉네임", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
            $0.setTitleColor(UIColor(red: 112, green: 112, blue: 112), for: .normal)
        }
        
        let spaceBetweenTwoLines = CGFloat(10)
        let font = UIFont.boldSystemFont(ofSize: 16)
        let foregroundColor = UIColor(red: 141, green: 141, blue: 141)
        _ = postsTextView.then {
            // 줄 간격 조정을 위해 AttributedText 사용
            let style = NSMutableParagraphStyle()
            style.lineSpacing = spaceBetweenTwoLines
            style.alignment = .center
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: foregroundColor]
            
            $0.attributedText = NSAttributedString(string: "글\n100", attributes: attributes)
            
            $0.isScrollEnabled = false
        }
        _ = replysTextView.then {
            // 줄 간격 조정을 위해 AttributedText 사용
            let style = NSMutableParagraphStyle()
            style.lineSpacing = spaceBetweenTwoLines
            style.alignment = .center
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: foregroundColor]
            
            $0.attributedText = NSAttributedString(string: "댓글\n200", attributes: attributes)
            
            $0.isScrollEnabled = false
        }
        _ = recommandsTextView.then {
            // 줄 간격 조정을 위해 AttributedText 사용
            let style = NSMutableParagraphStyle()
            style.lineSpacing = spaceBetweenTwoLines
            style.alignment = .center
            let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: foregroundColor]
            
            $0.attributedText = NSAttributedString(string: "추천\n300", attributes: attributes)
            
            $0.isScrollEnabled = false
        }
        
        // addSubViews and makeContraints
        view.addSubview(userInfoView)
        
        userInfoView.addSubview(userProfileImageImageView)
        userInfoView.addSubview(userNickNameButton)
        
        userInfoView.addSubview(containerTextViewsView)
        containerTextViewsView.addSubview(postsTextView)
        containerTextViewsView.addSubview(replysTextView)
        containerTextViewsView.addSubview(recommandsTextView)
        
        
        userInfoView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(100)
        }
        
        userProfileImageImageView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(50)
            $0.centerY.equalTo(userInfoView)
            $0.left.equalTo(userInfoView.snp.left).offset(15)
        }
        userNickNameButton.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageImageView)
            $0.left.equalTo(userProfileImageImageView.snp.right).offset(5)
        }
        
        containerTextViewsView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.top)
            $0.left.equalTo(userNickNameButton.snp.right).offset(15)
            $0.right.equalTo(userInfoView.snp.right).inset(15)
            $0.bottom.equalTo(userInfoView.snp.bottom)
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
    }
    
    func setMenuBar() {
        _ = menuBar.then {
            view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.top.equalTo(userInfoView.snp.bottom)
                $0.left.equalTo(view.snp.left)
                $0.right.equalTo(view.snp.right)
                $0.height.equalTo(50)
            }
            
            $0.menuList = ["내가 쓴 글", "내가 쓴 댓글", "내가 추천한 글"]
            $0.profileVC = self
        }
    }
    
    func setUserFeedContainerCollectionView() {
        _ = userFeedContainerCollectionView.then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
            
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(FeedContainerCVCell.self, forCellWithReuseIdentifier: "FeedContainerCVCell")
            
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(menuBar.snp.bottom)
                $0.left.equalTo(view.snp.left)
                $0.right.equalTo(view.snp.right)
                $0.bottom.equalTo(view.snp.bottom)
            }
            
            $0.backgroundColor = .white
            
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        userFeedContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        cell.setTableView()

        return cell
    }
}
