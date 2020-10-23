//
//  NotificationVC.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/10/22.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    static let identifier = Identify.FeedContainerCVCell
    
    // MARK: - UI components
    
    let notificationTableView = UITableView()
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "알림"
        view.backgroundColor = .white
        
        setTableView()
    }
    
    // MARK: - Helper

    func setTableView() {
            _ = notificationTableView.then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(NotificationTVCell.self, forCellReuseIdentifier: Identify.NotificationTVCell)
                
                view.addSubview($0)
                
                $0.snp.makeConstraints {
                    $0.top.equalTo(view.snp.top)
                    $0.left.equalTo(view.snp.left)
                    $0.right.equalTo(view.snp.right)
                    $0.bottom.equalTo(view.snp.bottom)
                }
                
                $0.separatorInset.left = 0
                $0.separatorStyle = .none
            }
        }
    
}


// MARK: - Notification TableView

extension NotificationVC : UITableViewDelegate { }
extension NotificationVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.NotificationTVCell, for: indexPath) as! NotificationTVCell
        cell.selectionStyle = .none
        
        cell.fillDataToView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailNewsFeedVC = DetailNewsFeedVC()
        
        navigationController?.pushViewController(detailNewsFeedVC, animated: true)
    }
    
}
