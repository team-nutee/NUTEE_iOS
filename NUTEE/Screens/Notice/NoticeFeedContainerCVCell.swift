//
//  NoticeFeedContainerCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/12.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SafariServices

class NoticeFeedContainerCVCell : UICollectionViewCell {
    
    static let identifier = Identify.NoticeFeedContainerCVCell
    
    // MARK: - UI components
    
    let noticeFeedTableView = UITableView()
    
    // MARK: - Variables and Properties
    
    var noticeVC: UIViewController?
    
    // MARK: - Helper

    func setTableView() {
            _ = noticeFeedTableView.then {
                $0.delegate = self
                $0.dataSource = self
                
                $0.register(NoticeFeedTVCell.self, forCellReuseIdentifier: Identify.NoticeFeedTVCell)
                
                contentView.addSubview($0)
                
                $0.snp.makeConstraints {
                    $0.top.equalTo(contentView.snp.top)
                    $0.left.equalTo(contentView.snp.left)
                    $0.right.equalTo(contentView.snp.right)
                    $0.bottom.equalTo(contentView.snp.bottom)
                }
                
                $0.separatorInset.left = 0
            }
        }
    
}

// MARK: - NoticeFeed TableView

extension NoticeFeedContainerCVCell : UITableViewDelegate { }

extension NoticeFeedContainerCVCell : UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.NoticeFeedTVCell, for: indexPath) as! NoticeFeedTVCell

        if indexPath.row < 5 {
            cell.fixedNoticeImageView.isHidden = false
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: "http://www.skhu.ac.kr/board/boardread.aspx?idx=35548&curpage=1&bsid=10004&searchBun=51")
        let safariViewController = SFSafariViewController(url: url!)
        safariViewController.preferredControlTintColor = .nuteeGreen
        
        noticeVC?.present(safariViewController, animated: true, completion: nil)
    }

}
