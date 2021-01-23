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
    
    // MARK: - UI components
    
    let activityIndicator = UIActivityIndicatorView()
    
    let noticeFeedTableView = UITableView()
    
    // MARK: - Variables and Properties
    
    var noticeVC: NoticeVC?
    
    var notices: Notice?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        makeConstraints()
        
        fetchNoticeFeed()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper

    func initView() {
        _ = noticeFeedTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(NoticeFeedTVCell.self, forCellReuseIdentifier: Identify.NoticeFeedTVCell)
            
            $0.separatorInset.left = 0
            
            $0.isHidden = true
        }
        _ = activityIndicator.then {
            $0.style = .medium
            $0.startAnimating()
        }
    }
    
    func makeConstraints() {
        contentView.addSubview(noticeFeedTableView)
        contentView.addSubview(activityIndicator)
        
        
        noticeFeedTableView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(noticeFeedTableView.snp.top)
            $0.left.equalTo(noticeFeedTableView.snp.left)
            $0.right.equalTo(noticeFeedTableView.snp.right)
            $0.bottom.equalTo(noticeFeedTableView.snp.bottom)
        }
    }
    
    func fetchNoticeFeed() {
        // default status
        setFetchNoticeFeedFail()
        
        // <-- will override by subclass
    }
    
    func setFetchNoticeFeedFail() {
        activityIndicator.stopAnimating()
        noticeFeedTableView.isHidden = false
        
        noticeFeedTableView.setEmptyView(title: "오류발생😢", message: "공지사항을 조회하지 못했습니다")
    }
    
    func afterFetchNotice() {
        noticeFeedTableView.reloadData()
        
        activityIndicator.stopAnimating()
        noticeFeedTableView.isHidden = false
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
        cell.selectionStyle = .none
        
        if notices != nil {
            cell.setFetchedData(noticeContent: notices?[indexPath.row], completionHandler: { ()-> Void in
                cell.fillDataToView()
            })
        }
        
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
    
    func getNoticeService(url: String, completionHandler: @escaping () -> Void) {
        NoticeService.shared.getNoticeFromUrl(url: url, completion: { [self] (returnedData) -> Void in
            switch returnedData {
            case .success(let res):
                
                let response = res as! Notice
                notices = response
                completionHandler()
                
            case .requestErr(let message):
                noticeVC?.simpleNuteeAlertDialogue(title: "공지사항 조회 실패", message: "\(message)")
                setFetchNoticeFeedFail()
                completionHandler()
                
            case .pathErr:
                noticeVC?.simpleNuteeAlertDialogue(title: "공지사항 조회 실패", message: "서버연결에 오류가 있습니다")
                setFetchNoticeFeedFail()
                completionHandler()
                
            case .serverErr:
                noticeVC?.simpleNuteeAlertDialogue(title: "공지사항 조회 실패", message: "서버에 오류가 있습니다")
                setFetchNoticeFeedFail()
                completionHandler()
                
            case .networkFail :
                noticeVC?.simpleNuteeAlertDialogue(title: "공지사항 조회 실패", message: "네트워크 상태를 확인해주세요")
                setFetchNoticeFeedFail()
                completionHandler()
            }
        })
    }
    
}
