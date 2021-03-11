//
//  DeveloperInfoVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/15.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SafariServices

class DeveloperInfoVC : UIViewController {
    
    // MARK: - UI components
    
    let developerInfoTableView = UITableView()
    
    // MARK: - Variables and Properties
    
    let developerList = [
        ["이문혁", "BackEnd", "2019 ~", "MoonHKLee"],
        ["윤석노", "BackEnd", "2021 ~", "sny1032"],
        ["오준현", "PM, Design", "2019 ~ ", "5anniversary"],
        ["김희재", "iOS", "2019 ~ ", "iowa329"],
        ["김은우", "iOS", "2019 ~ ", "foreunwoo"],
        ["임윤휘", "Android", "2020 ~", "88yhtserof"],
        ["김지원", "FrontEnd", "2020 ~ ", "gwonkim"],
        ["김산호", "FrontEnd", "2020 ~ ", "san9901"],
        ["박세연", "QA", "2020 ~ ", "SEYEON-PARK"],

        ["임우찬", "BackEnd", "2019 ~ 2020", "dladncks1217"],
        ["박진수", "Android, TI", "2020 ~ 2021", "jinsu4755"],
        ["배은서", "Android", "2020 ~ 2021", "eunseo5355"],
        ["정우경", "QA", "2020", ""],
        ["고병우", "QA", "2020", "kohbwoo"],
    ]
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "개발자 정보"
        view.backgroundColor = .white
        
        setTableView()
    }
    
    // MARK: - Helper
    
    func setTableView() {
        _ = developerInfoTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(DeveloperInfoTVCell.self, forCellReuseIdentifier: Identify.DeveloperInfoTVCell)
            
            view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.top.equalTo(view.snp.top)
                $0.left.equalTo(view.snp.left)
                $0.right.equalTo(view.snp.right)
                $0.bottom.equalTo(view.snp.bottom)
            }

            $0.separatorStyle = .none
            $0.backgroundColor = .white
        }
    }
}

// MARK: - NoticeFeed TableView

extension DeveloperInfoVC : UITableViewDelegate { }
extension DeveloperInfoVC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return developerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.DeveloperInfoTVCell, for: indexPath) as! DeveloperInfoTVCell
        cell.selectionStyle = .none
        
        cell.developerInfoVC = self
        
        cell.developer = developerList[indexPath.row]
        cell.fillDataToView()
        
        return cell
    }

}
