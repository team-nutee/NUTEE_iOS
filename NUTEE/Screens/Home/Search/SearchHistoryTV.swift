//
//  SearchTV.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2020/08/09.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit

import CoreData

// MARK: - Search TableView

class SearchHistoryTV : UITableView {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    var searchVC: SearchVC?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        
        delegate = self
        dataSource = self
        
        register(SearchHistoryTVHeaderView.self, forHeaderFooterViewReuseIdentifier: Identify.SearchHistoryTVHeaderView)
        register(SearchHistoryTVCell.self, forCellReuseIdentifier: Identify.SearchHistoryTVCell)
        tableFooterView = nil
        
        backgroundColor = .white
        separatorInset.left = 0
        separatorStyle = .singleLine
        
        keyboardDismissMode = .onDrag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Helper
}


// MARK: - TableView Delegate

extension SearchHistoryTV : UITableViewDelegate, UITableViewDataSource {
    
    // HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identify.SearchHistoryTVHeaderView) as? SearchHistoryTVHeaderView
        headerView?.searchHistoryTV = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let postItems = searchVC?.searchHistoryList.count ?? 0
        
        if postItems == 0 {
            setEmptyView(title: "", message: "검색 기록이 없습니다")
        } else {
            restore()
        }
        
        return postItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.SearchHistoryTVCell, for: indexPath) as! SearchHistoryTVCell
        cell.selectionStyle = .none
        cell.searchHistoryTV = self
        
        cell.keywordHistoryLabel.text = searchVC?.searchHistoryList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKeyword = searchVC?.searchHistoryList[indexPath.row] ?? ""
        
        if selectedKeyword != "" {
            searchVC?.didTapSearchButton(keyword: selectedKeyword)
        }
    }
    
}

// MARK: - Search TableViewHeaderView

class SearchHistoryTVHeaderView : UITableViewHeaderFooterView {
    
    static let identifier = Identify.SearchHistoryTVHeaderView
    
    // MARK: - UI components
    
    let previousSearchlabel = UIButton()
    let deleteAllButton = UIButton()
    
    // MARK: - Variables and Properties
    
    var searchHistoryTV: SearchHistoryTV?
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initHeaderView()
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func initHeaderView() {
        contentView.backgroundColor = .white
        
        _ = previousSearchlabel.then {
            $0.setTitle("이전 검색", for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 11)
        }
        
        _ = deleteAllButton.then {
            $0.setTitle("전체 삭제", for: .normal)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 11)
            $0.addTarget(self, action: #selector(deleteAllRecords), for: .touchUpInside)
        }
    }
    
    func addContentView() {
        contentView.addSubview(previousSearchlabel)
        contentView.addSubview(deleteAllButton)
        
        
        previousSearchlabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        deleteAllButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.right.equalTo(contentView.snp.right)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    @objc func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Recode")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            
            try context.execute(deleteRequest)
            try context.save()
            
        } catch {
            
            print ("There was an error")
            
        }
        
//        searchTV?.recodeMemory = []
        
//        searchHistoryTV?.searchTableView.reloadData()
    }
}

// MARK: - Search TableViewCell

class SearchHistoryTVCell : UITableViewCell {
    
    static let identifier = Identify.SearchHistoryTVCell
    
    // MARK: - UI components
    
    let keywordHistoryLabel = UILabel()
    let deleteButton = UIButton()
    let underBarView = UIView()
    
    // MARK: - Variables and Properties
    
    var searchHistoryTV: SearchHistoryTV?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initCell()
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if isHighlighted == true {
            // light gray
            contentView.backgroundColor = UIColor(red: 211 / 255.0, green: 211 / 255.0, blue: 211 / 255.0 , alpha: 1.0)
        } else {
            contentView.backgroundColor = .white
        }
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = keywordHistoryLabel.then {
            $0.font = .systemFont(ofSize: 15)
        }
        
        _ = deleteButton.then {
            $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            $0.tintColor = .lightGray
            $0.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        }
    }
    
    func addContentView() {
        
        contentView.addSubview(keywordHistoryLabel)
        contentView.addSubview(deleteButton)
        
        
        keywordHistoryLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(5)
            $0.centerY.equalTo(contentView)
        }
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(deleteButton.snp.width)
            
            $0.right.equalTo(contentView.snp.right).inset(5)
            $0.centerY.equalTo(contentView)
        }
        
    }
    
    @objc func didTapDeleteButton() {
        
    }
    
}
