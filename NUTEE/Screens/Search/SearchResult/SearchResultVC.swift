//
//  SearchCVCell.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper

class SearchResultVC: UIViewController {

    // MARK: - UI components
    
    let searchResultTableView = UITableView()

    // MARK: - Variables and Properties
    
    var searchResult = ""

//    var responseStudyInfo: StudyList?
//    var studyInfoList: [StudyListData] = []
//    let token = KeychainWrapper.standard.string(forKey: "token")

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getStudyInfoSearchService(token ?? "", searchResult.stringByAddingPercentEncodingForFormData() ?? "")
        
        setTableView()
    }

    // MARK: - Helper
    
    func setTableView() {
        _ = searchResultTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(NewsFeedTVCell.self, forCellReuseIdentifier: "NewsFeedTVCell")
            
            $0.separatorStyle = .none
        }
        
        
        self.view.addSubview(searchResultTableView)
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }

}

// MARK: - TableView Delegate

extension SearchResultVC: UITableViewDelegate { }
extension SearchResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let studyInfoNum = responseStudyInfo?.data.count ?? 0
//
//        if studyInfoNum == 0 {
//            searchTV.setEmptyView(title: searchResult, message: "에 해당하는 검색 결과가 없습니다.")
//        } else {
//            searchTV.restore()
//        }
//
//        return studyInfoNum
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeueReusableCell(withIdentifier: "NewsFeedTVCell", for: indexPath) as! NewsFeedTVCell
        cell.selectionStyle = .none
        
        cell.fillDataToView()

//        let studyInfo = responseStudyInfo
//        cell.addContentView()
//        cell.selectionStyle = .none
//
//        switch studyInfo?.status {
//        case 200:
//            if studyInfo?.data.count == 0 {
//                cell.studyImageView.isHidden = true
//                cell.studyTitleLabel.isHidden = true
//                cell.studyInfoTextView.isHidden = true
//                cell.isPenaltyLabel.isHidden = true
//                cell.memberButton.isHidden = true
//                cell.placeButton.isHidden = true
//
//                let emptyLabel = UILabel()
//                emptyLabel.text = "참여중인 스터디가 없습니다😳"
//                cell.addSubview(emptyLabel)
//                emptyLabel.snp.makeConstraints{ (make) in
//                    make.centerX.equalToSuperview()
//                    make.top.equalToSuperview().offset(100)
//                    make.bottom.equalToSuperview().offset(-100)
//                }
//            } else {
//                cell.studyImageView.isHidden = false
//                cell.studyTitleLabel.isHidden = false
//                cell.studyInfoTextView.isHidden = false
//                cell.isPenaltyLabel.isHidden = false
//                cell.memberButton.isHidden = false
//                cell.placeButton.isHidden = false
//
//                cell.studyInfo = studyInfo?.data[indexPath.row]
//                cell.initCell()
//                cell.addContentView()
//            }
//
//        case 400, 406, 411, 500, 420, 421, 422, 423:
//            cell.studyImageView.isHidden = true
//            cell.studyTitleLabel.isHidden = true
//            cell.studyInfoTextView.isHidden = true
//            cell.isPenaltyLabel.isHidden = true
//            cell.memberButton.isHidden = true
//            cell.placeButton.isHidden = true
//
//            let emptyLabel = UILabel()
//            emptyLabel.text = "참여중인 스터디가 없습니다😢"
//            cell.addSubview(emptyLabel)
//            emptyLabel.snp.makeConstraints{ (make) in
//                make.centerX.equalToSuperview()
//                make.centerY.equalToSuperview()
//            }
//
//        default:
//            cell.studyImageView.isHidden = true
//            cell.studyTitleLabel.isHidden = true
//            cell.studyInfoTextView.isHidden = true
//            cell.isPenaltyLabel.isHidden = true
//            cell.memberButton.isHidden = true
//            cell.placeButton.isHidden = true
//        }


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailNewsFeedVC = DetailNewsFeedVC()
        
        self.navigationController?.pushViewController(detailNewsFeedVC, animated: true)
    }

}

//extension SearchResultVC {
//    func getStudyInfoSearchService(_ token: String, _ name: String) {
//        StudyService.shared.getSearchList(token, name) { result in
//            switch result {
//            case .success(let res):
//                let responseStudyList = res as! StudyList
//
//                switch responseStudyList.status {
//                case 200:
//                    self.responseStudyInfo = responseStudyList
//
//                    self.searchTV.reloadData()
//
//                case 400, 406, 411, 500, 420, 421, 422, 423:
//                    self.simpleAlert(title: responseStudyList.message, message: "")
//                    self.searchTV.setEmptyView(title: "스터디 목록을 불러오는데 실패하였습니다😢", message: "")
//
//                default:
//                    self.simpleAlert(title: "오류가 발생하였습니다", message: "")
//                }
//            case .requestErr(_):
//                print(".requestErr")
//            case .pathErr:
//                print(".pathErr")
//            case .serverErr:
//                print(".serverErr")
//            case .networkFail:
//                print(".networkFail")
//            }
//
//        }
//    }
//
//}
