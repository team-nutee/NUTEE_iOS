//
//  SettingVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/10.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class SettingVC : UIViewController {
    
    // MARK: - UI components
    
    let settingListTableView = UITableView()
    
    // MARK: - Variables and Properties
    
    let settingList = ["프로필 이미지를 설정하고 싶으신가요?",
                       "닉네임을 변경하고 싶으신가요?",
                       "비밀번호를 변경하고 싶으신가요?",
                       "카테고리를 변경하고 싶으신가요?",
                       "전공을 변경하고 싶으신가요?"]
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
        view.backgroundColor = .white
        
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
    }
    
    // MARK: - Helper
    
    func setTableView() {
        _ = settingListTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.tableHeaderView = nil
            $0.register(SettingTVCell.self, forCellReuseIdentifier: Identify.SettingTVCell)
            $0.tableFooterView = nil
            
            $0.separatorStyle = .none
            $0.contentInset = UIEdgeInsets(top: view.frame.size.height / 3, left: 0, bottom: 0, right: 0)
        }
        
        view.addSubview(settingListTableView)
        
        settingListTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
}

// MARK: - TableView

extension SettingVC : UITableViewDelegate { }

extension SettingVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.SettingTVCell, for: indexPath) as! SettingTVCell
        cell.settingItemName = settingList[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let settingProfileImageVC = SettingProfileImageVC()
            self.navigationController?.pushViewController(settingProfileImageVC, animated: true)
        case 1:
            let settingNicknameVC = SettingNicknameVC()
            self.navigationController?.pushViewController(settingNicknameVC, animated: true)
        case 2:
            let settingPasswordVC = SettingPasswordVC()
            self.navigationController?.pushViewController(settingPasswordVC, animated: true)
        case 3:
            let settingCategoryVC = SettingCategoryVC()
            self.navigationController?.pushViewController(settingCategoryVC, animated: true)
        case 4:
            let settingMajorVC = SettingMajorVC()
            self.navigationController?.pushViewController(settingMajorVC, animated: true)
        default:
            simpleAlert(title: "오류발생😢", message: "해당 설정을 찾을 수 없습니다")
        }
    }

}

// MARK: - Setting TableViewCell

class SettingTVCell : UITableViewCell {
    
    static let identifier = Identify.SettingTVCell
    
    // MARK: - UI components
    
    let settingItemLabel = UILabel()
    let arrowImageView = UIImageView()
    
    // MARK: - Variables and Properties
    
    var settingItemName: String?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initCell()
        addContentView()
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = settingItemLabel.then {
            $0.text = settingItemName
            $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15.0)
        }
        
        _ = arrowImageView.then {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .black
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func addContentView() {
        
        contentView.addSubview(settingItemLabel)
        contentView.addSubview(arrowImageView)
        
        
        settingItemLabel.snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(contentView.snp.left).offset(30)
            $0.centerY.equalTo(contentView)
        }
        arrowImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(arrowImageView.snp.width)

            $0.right.greaterThanOrEqualTo(contentView.snp.right).inset(85)
            $0.centerY.equalTo(contentView)
        }
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if isHighlighted == true {
            contentView.backgroundColor = .lightGray
        } else {
            contentView.backgroundColor = .white
        }
    }
    
}
