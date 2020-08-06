//
//  MenuBar.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/07/31.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class MenuBarCV : UIView {
    
    // MARK: - UI components
    
    lazy var menuBarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let positionBarView = UIView()
    
    // MARK: - Variables and Properties
    
    var menuList = [""]
    
    var homeVC: HomeVC?
    var profileVC: ProfileVC?
    var noticeVC: NoticeVC?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _ = menuBarCollectionView.then {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = layout
            
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(MenuBarCVCell.self, forCellWithReuseIdentifier: "MenuBarCVCell")
            
            addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    // 레이아웃이 형성된 뒤에 불려지는 함수
    override func layoutSubviews() {
         super.layoutSubviews()
        
        _ = menuBarCollectionView.then {
            $0.backgroundColor = .white
            
            // 최초 실행 시 선택되어 있는 위치 지정
            let indexPath = IndexPath(item: 0, section: 0)
            $0.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        
        _ = positionBarView.then {
            $0.backgroundColor = .nuteeGreen
            
            addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(4)
                let width = menuBarCollectionView.frame.size.width / CGFloat(menuList.count) - 20
                $0.width.equalTo(width)
                $0.left.equalToSuperview().offset(10)
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
}
    

// MARK: - Menu Bar CollectionView

extension MenuBarCV : UICollectionViewDelegate { }
extension MenuBarCV : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuCount = CGFloat(menuList.count)
        
        return CGSize(width: self.frame.width/menuCount, height: collectionView.frame.height)
    }
    
}

extension MenuBarCV : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuBarCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuBarCVCell", for: indexPath) as! MenuBarCVCell
        
        cell.initCell()
        cell.addContentView()
        
        cell.menuTitle.text = menuList[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.homeVC?.scrollToMenuIndex(menuIndex: indexPath.item)
        self.profileVC?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
}


// MARK: - Menu Bar CollectionView Cell Definition

class MenuBarCVCell : UICollectionViewCell {
    
    // MARK: - UI components
    
    var menuTitle = UILabel()
    
    // MARK: - Helper
    
    func initCell() {
        _ = menuTitle.then {
            $0.font = .systemFont(ofSize: 15)
            $0.textColor = .gray
        }
    }
    
    func addContentView() {
        contentView.addSubview(menuTitle)
        
        menuTitle.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .boldSystemFont(ofSize: 18)
                    $0.textColor = .nuteeGreen
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 15)
                    $0.textColor = .gray
                }
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                _ = menuTitle.then {
                    $0.font = .boldSystemFont(ofSize: 18)
                    $0.textColor = .nuteeGreen
                }
            } else {
                _ = menuTitle.then {
                    $0.font = .systemFont(ofSize: 15)
                    $0.textColor = .gray
                }
            }
        }
    }
    
}
