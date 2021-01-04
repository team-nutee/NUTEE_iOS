//
//  SettingVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/10.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

class SettingVC : UIViewController {
    
    // MARK: - UI components
    
    let settingListTableView = UITableView(frame: CGRect(), style: .grouped)
    
    // MARK: - Variables and Properties
    
    let settingList = [
        ["프로필 이미지를 설정하고 싶으신가요?", "닉네임을 변경하고 싶으신가요?", "비밀번호를 변경하고 싶으신가요?", "카테고리를 변경하고 싶으신가요?", "전공을 변경하고 싶으신가요?"],
        ["NUTEE 서비스 이용약관", "개발자 정보"],
        ["로그아웃"]
    ]
    
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
            
            $0.register(SettingTVCell.self, forCellReuseIdentifier: Identify.SettingTVCell)
            
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.contentInset = UIEdgeInsets(top: view.frame.size.height / 8, left: 0, bottom: 0, right: 0)
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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fakeView = UIView()
        fakeView.backgroundColor = .clear
        
        return fakeView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fakeView = UIView()
        fakeView.backgroundColor = .clear
        
        return fakeView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.SettingTVCell, for: indexPath) as! SettingTVCell
        cell.selectionStyle = .none
        
        cell.settingItemName = settingList[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
            
        case IndexPath(row: 0, section: 0):
            let settingProfileImageVC = SettingProfileImageVC()
            self.navigationController?.pushViewController(settingProfileImageVC, animated: true)
            
        case IndexPath(row: 1, section: 0):
            let settingNicknameVC = SettingNicknameVC()
            self.navigationController?.pushViewController(settingNicknameVC, animated: true)
            
        case IndexPath(row: 2, section: 0):
            let settingPasswordVC = SettingPasswordVC()
            self.navigationController?.pushViewController(settingPasswordVC, animated: true)
            
        case IndexPath(row: 3, section: 0):
            let settingCategoryVC = SettingCategoryVC()
            self.navigationController?.pushViewController(settingCategoryVC, animated: true)
            
        case IndexPath(row: 4, section: 0):
            let settingMajorVC = SettingMajorVC()
            self.navigationController?.pushViewController(settingMajorVC, animated: true)
            
        case IndexPath(row: 0, section: 1):
            let termsAndConditionsSB = UIStoryboard(name: "TermsAndConditions", bundle: nil)
            let termsAndConditionsVC = termsAndConditionsSB.instantiateViewController(withIdentifier: "TermsAndConditions") as! TermsAndConditionsVC
            
            self.navigationController?.pushViewController(termsAndConditionsVC, animated: true)
            
        case IndexPath(row: 1, section: 1):
            let developerInfoVC = DeveloperInfoVC()
            self.navigationController?.pushViewController(developerInfoVC, animated: true)
        
        case IndexPath(row: 0, section: 2):
            KeychainWrapper.standard.remove(forKey: "userId")
            KeychainWrapper.standard.remove(forKey: "pw")
            
            let rootVC = view.window?.rootViewController
            self.view.window!.rootViewController?.dismiss(animated: true, completion: {
                rootVC?.simpleNuteeAlertDialogue(title: "로그아웃", message: "로그아웃 되었습니다")
            })
            
        default:
            simpleNuteeAlertDialogue(title: "오류발생😢", message: "해당 설정을 찾을 수 없습니다")
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
        
        if settingItemLabel.text == "로그아웃" {
            settingItemLabel.textColor = .red
            arrowImageView.isHidden = true
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
