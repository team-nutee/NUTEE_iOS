//
//  ProfileVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // MARK: - UI components
    
    let userProfileImageImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let userNickNameButton = UIButton()
    
    let userMenuBar = UserMenuBarCV()
    
    let separatorView = UIView()
    
    let userFeedContainerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Variables and Properties
    var user: User?
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "프로필"
        view.backgroundColor = .white
        
        setNavigationBarItem()
        
        initView()
        makeConstraints()
        
        getMyProfileService { (user) in
            self.fillDataToView()
        }
    }
    
    // MARK: - Helper
    
    func setNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(didTapSetting))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
    }
    
    func initView() {
        _ = userProfileImageImageView.then {
            $0.contentMode = .scaleAspectFit
            $0.cornerRadius = 0.5 * $0.frame.size.width
            $0.clipsToBounds = true
            }
        _ = userNickNameButton.then {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
            $0.setTitleColor(UIColor(red: 112, green: 112, blue: 112), for: .normal)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.contentHorizontalAlignment = .left
            }
        
        _ = userMenuBar.then {
//            $0.menuList = ["내가 쓴 글", "내가 쓴 댓글", "내가 추천한 글"]
            $0.menuList = ["게시물", "댓글", "추천 게시글"]
            $0.userInfomationList = [1314, 2218, 2199]
            
            $0.profileVC = self
        }
        
        _ = separatorView.then {
            $0.backgroundColor = .lightGray
        }
        
        _ = userFeedContainerCollectionView.then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
            
            $0.register(FeedContainerCVCell.self, forCellWithReuseIdentifier: Identify.FeedContainerCVCell)
            
            $0.register(UserPostFeedCVCell.self, forCellWithReuseIdentifier: Identify.UserPostFeedCVCell)
            $0.register(UserCommentFeedCVCell.self, forCellWithReuseIdentifier: Identify.UserCommentFeedCVCell)
            $0.register(UserRecommendFeedCVCell.self, forCellWithReuseIdentifier: Identify.UserRecommendFeedCVCell)
            
            $0.delegate = self
            $0.dataSource = self
            
            $0.backgroundColor = .white
            
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    func makeConstraints() {
        // Add SubViews
        view.addSubview(userProfileImageImageView)
        view.addSubview(userNickNameButton)
        
        view.addSubview(userMenuBar)
        
        view.addSubview(separatorView)
        
        view.addSubview(userFeedContainerCollectionView)
        
        
        // Make Constraints
        userProfileImageImageView.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(userProfileImageImageView.snp.width)
            
            $0.top.equalTo(view.snp.top).offset(5)
            $0.left.equalTo(view.snp.left).offset(15)
        }
        userNickNameButton.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageImageView)
            $0.left.equalTo(userProfileImageImageView.snp.right).offset(10)
            $0.right.equalTo(view.snp.right).inset(15)
        }
        
        userMenuBar.snp.makeConstraints {
            $0.height.equalTo(50)
            
            $0.top.equalTo(userProfileImageImageView.snp.bottom).offset(20)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)//.inset(10)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(0.3).priority(999)
            
            $0.top.equalTo(userMenuBar.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }
        
        userFeedContainerCollectionView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func fillDataToView() {
        userProfileImageImageView.setImageNutee(user?.body.image?.src, userProfileImageImageView)
        
        userNickNameButton.setTitle(user?.body.nickname, for: .normal)
        
        userMenuBar.userInfomationList[0] = user?.body.postNum ?? 0
        userMenuBar.userInfomationList[1] = user?.body.commentNum ?? 0
        userMenuBar.userInfomationList[2] = user?.body.likeNum ?? 0

        userMenuBar.menuBarCollectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        userMenuBar.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
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
        var adjustStartPoint: CGFloat = userMenuBar.adjustItemLength / 2
        
        let fullWidth = scrollView.bounds.size.width
        let currentWidth = scrollView.contentOffset.x
        let currentPositionRatio = currentWidth / fullWidth
        
        let boundaryItemIndex = CGFloat(1)
        
        if currentPositionRatio < boundaryItemIndex {
            adjustStartPoint *= currentPositionRatio
        }
        
        userMenuBar.positionBarView.frame.origin.x = scrollView.contentOffset.x / CGFloat(userMenuBar.menuList.count) + 10 - adjustStartPoint
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userMenuBar.menuList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId: String
        
        switch indexPath.row {
        case 0:
            cellId = Identify.UserPostFeedCVCell
        case 1:
            cellId = Identify.UserCommentFeedCVCell
        case 2:
            cellId = Identify.UserRecommendFeedCVCell
        default:
            cellId = Identify.FeedContainerCVCell
        }
        
        let cell = userFeedContainerCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedContainerCVCell
        cell.homeVC = self
        
        return cell
    }
}

// MARK: - Server connect

extension ProfileVC {
    
    func getMyProfileService(completionHandler: @escaping (_ returnedData: User) -> Void ) {
        UserService.shared.getMyProfile() { responsedata in
            
            switch responsedata {
            case .success(let res):
                let response = res as! User
                self.user = response
                completionHandler(self.user!)
                
            case .requestErr(_):
                self.simpleNuteeAlertDialogue(title: "프로필 조회 실패", message: "요청에 오류가 있습니다")
                
            case .pathErr:
                self.simpleNuteeAlertDialogue(title: "프로필 조회 실패", message: "서버에 오류가 있습니다")
                
            case .serverErr:
                self.simpleNuteeAlertDialogue(title: "프로필 조회 실패", message: "서버 연결에 오류가 있습니다")

            case .networkFail :
                self.simpleNuteeAlertDialogue(title: "프로필 조회 실패", message: "네트워크에 오류가 있습니다")
            }
        }
    }
}
