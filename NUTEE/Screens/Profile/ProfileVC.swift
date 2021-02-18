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
    
    let scrollView = UIScrollView()
    
    let refreshControl = SmallRefreshControl()
    
    let userInfoView = UserInformationView()
    
    let userMenuBar = UserMenuBarCV()
    let separatorView = UIView()
    
    let userFeedContainerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Variables and Properties
    
    var user: User?
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        initView()
        makeConstraints()
        
        getMyProfileService { [self] (user) in
            fillDataToView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        userFeedContainerCollectionView.snp.updateConstraints {
            let height = scrollView.frame.size.height - userInfoView.frame.size.height - userMenuBar.frame.size.height
            $0.height.equalTo(height)
        }
        userFeedContainerCollectionView.reloadData()
    }

    // MARK: - Helper
    
    func setNavigationBar() {
        _ = navigationItem.then {
            $0.title = "프로필"
            
            $0.rightBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(didTapSetting))
            $0.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.nuteeGreen], for: .normal)
        }
    }
    
    func initView() {
        _ = view.then {
            $0.backgroundColor = .white
        }
        
        _ = refreshControl.then {
            scrollView.addSubview($0)
            $0.addTarget(self, action: #selector(updateUserInfo), for: UIControl.Event.valueChanged)
        }
        
        _ = scrollView.then {
            $0.showsVerticalScrollIndicator = false
            
            $0.delegate = self
        }
        
        _ = userMenuBar.then {
            $0.menuList = ["게시물", "댓글", "추천 게시글"]
            
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
        // Add Subviews
        view.addSubview(scrollView)
        
        scrollView.addSubview(userInfoView)
        
        scrollView.addSubview(userMenuBar)
        scrollView.addSubview(separatorView)
        
        scrollView.addSubview(userFeedContainerCollectionView)
        
        
        // Make Constraints
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        userInfoView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            
            $0.top.equalTo(scrollView.snp.top)
            $0.left.equalTo(scrollView.snp.left)
            $0.right.equalTo(scrollView.snp.right)
        }
        
        userMenuBar.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.left.equalTo(scrollView.snp.left)
            $0.right.equalTo(scrollView.snp.right)
        }
        separatorView.snp.makeConstraints {
            $0.height.equalTo(0.3).priority(999)
            
            $0.top.equalTo(userMenuBar.snp.bottom)
            $0.left.equalTo(scrollView.snp.left)
            $0.right.equalTo(scrollView.snp.right)
        }
        
        userFeedContainerCollectionView.snp.makeConstraints {
            $0.height.equalTo(0) // 업데이트 전 임의 값 0인 height 생성
            
            $0.top.equalTo(separatorView.snp.bottom)
            $0.left.equalTo(scrollView.snp.left)
            $0.right.equalTo(scrollView.snp.right)
            $0.bottom.greaterThanOrEqualTo(scrollView.snp.bottom)
        }
    
    }
    
    func fillDataToView() {
        userInfoView.userProfileImageImageView.setImageNutee(user?.body.image?.src)
        userInfoView.userNickNameButton.setTitle(user?.body.nickname, for: .normal)
        
        userMenuBar.userInfomationList[0] = user?.body.postNum ?? 0
        userMenuBar.userInfomationList[1] = user?.body.commentNum ?? 0
        userMenuBar.userInfomationList[2] = user?.body.likeNum ?? 0
        userMenuBar.menuBarCollectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        userMenuBar.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    @objc func updateUserInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        userFeedContainerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func didTapSetting() {
        let settingVC = SettingVC()
        settingVC.userProfileImageSrc = user?.body.image?.src
        
        settingVC.originalNickname = user?.body.nickname
        
        settingVC.originalCategoryList = user?.body.interests ?? []
        
        settingVC.originalFirstMajor = user?.body.majors[0]
        settingVC.originalSecondMajor = user?.body.majors[1]
        
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
        switch scrollView {
            case self.scrollView :
                // forbid bounce drag 'up' direction
                if scrollView.contentOffset.y > 0 {
                    scrollView.contentOffset.y = 0
                }
                
            case userFeedContainerCollectionView :
                // move 'Menu positionBar' to correct Feed index
                var adjustStartPoint: CGFloat = userMenuBar.adjustItemLength / 2

                let fullWidth = scrollView.bounds.size.width
                let currentWidth = scrollView.contentOffset.x
                let currentPositionRatio = currentWidth / fullWidth

                let boundaryItemIndex = CGFloat(1)

                if currentPositionRatio < boundaryItemIndex {
                    adjustStartPoint *= currentPositionRatio
                }
                
                userMenuBar.positionBarView.frame.origin.x = scrollView.contentOffset.x / CGFloat(userMenuBar.menuList.count) + 10 - adjustStartPoint
                
            default :
                break
        }
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
