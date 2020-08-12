//
//  NoticeFeedContainerCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/12.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SafariServices
import SkeletonView

class NoticeFeedContainerCVCell : UICollectionViewCell {
    
    // MARK: - UI components
    
    let noticeFeedTableView = UITableView()
    
    // MARK: - Variables and Properties
    
    var noticeVC: UIViewController?
    
    var notices: Notice?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        return notices?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.NoticeFeedTVCell, for: indexPath) as! NoticeFeedTVCell
        cell.noticeContent = notices?[indexPath.row]
        
        cell.addContentView()
        cell.initCell()
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: notices?[indexPath.row].href ?? "")
        let safariViewController = SFSafariViewController(url: url!)
        safariViewController.preferredControlTintColor = .nuteeGreen
        
        noticeVC?.present(safariViewController, animated: true, completion: nil)
    }
    
}

// MARK: - Notice Service

extension NoticeFeedContainerCVCell {
    
    func getNoticeService(responseData: NetworkResult<Any>, completionHandler: @escaping (_ returnedData: Notice) -> Void) {
        
        switch responseData {
        case .success(let res):
            
            let response = res as! Notice
            self.notices = response
            
            completionHandler(self.notices!)

        case .requestErr(let message):
            self.noticeVC?.simpleAlert(title: "공지사항 조회 실패", message: "\(message)")
            
        case .pathErr:
            print(".pathErr")
            
        case .serverErr:
            print(".serverErr")
            
        case .networkFail :
            self.noticeVC?.simpleAlert(title: "카테고리 조회 실패", message: "네트워크 상태를 확인해주세요.")
        }
        
    }
    
    func doAfterLoadData(responseData: NetworkResult<Any>) {
        self.getNoticeService(responseData: responseData, completionHandler: {(returnedData)-> Void in
            self.noticeFeedTableView.reloadData()
        })
    }
    
    func getBachelorNoticeService(completionHandler: @escaping (_ returnedData: Notice) -> Void) {
        NoticeService.shared.getBachelorNotice() { responseData in
            self.doAfterLoadData(responseData: responseData)
        }
    }
    
    func getClassNoticeService(completionHandler: @escaping (_ returnedData: Notice) -> Void) {
        NoticeService.shared.getClassNotice() { responseData in
            self.doAfterLoadData(responseData: responseData)
        }
    }
    
    func getExchangeNoticeService(completionHandler: @escaping (_ returnedData: Notice) -> Void) {
        NoticeService.shared.getExchangeNotice() { responseData in
            self.doAfterLoadData(responseData: responseData)
        }
    }
    
    func getScholarshipNoticeService(completionHandler: @escaping (_ returnedData: Notice) -> Void) {
        NoticeService.shared.getScholarshipNotice() { responseData in
            self.doAfterLoadData(responseData: responseData)
        }
    }
    
    func getGeneralNoticeService(completionHandler: @escaping (_ returnedData: Notice) -> Void) {
        NoticeService.shared.getGeneralNotice() { responseData in
            self.doAfterLoadData(responseData: responseData)
        }
    }
    
    func getEventNoticeService(completionHandler: @escaping (_ returnedData: Notice) -> Void) {
        NoticeService.shared.getEventNotice() { responseData in
            self.doAfterLoadData(responseData: responseData)
        }
    }
    
}
