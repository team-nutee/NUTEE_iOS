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
        separatorColor = .clear
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        keyboardDismissMode = .onDrag
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTableView(sender:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Helper
    
    @objc func didTapTableView(sender: UITapGestureRecognizer) {
        // when tap tableView, keyboard is dismissed by this code
        if sender.state == .ended {
            searchVC?.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
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
            self.isScrollEnabled = false
        } else {
            restore()
            self.isScrollEnabled = true
        }
        
        return postItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.SearchHistoryTVCell, for: indexPath) as! SearchHistoryTVCell
        cell.selectionStyle = .none
        cell.searchHistoryTV = self
        
        cell.indexPath = indexPath.row
        cell.keywordHistoryLabel.text = searchVC?.searchHistoryList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKeyword = searchVC?.searchHistoryList[indexPath.row] ?? ""
//        searchVC?.searchTextField.text = selectedKeyword
//        searchVC?.didTapSearchButton()
//        searchVC?.searchTextField.text = ""
        let searchResultVC = SearchResultVC()
        searchResultVC.navigationItem.title = selectedKeyword
        searchVC?.saveSearchKeyword(toSaveKeyword: selectedKeyword)
        
        searchVC?.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    // FooterView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fakeView = UIView()
        fakeView.backgroundColor = .clear
        
        return fakeView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
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
            $0.addTarget(self, action: #selector(didTapDeleteAllButton), for: .touchUpInside)
        }
    }
    
    func addContentView() {
        contentView.addSubview(previousSearchlabel)
        contentView.addSubview(deleteAllButton)
        
        
        previousSearchlabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        deleteAllButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.right.equalTo(contentView.snp.right).inset(20)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    @objc func didTapDeleteAllButton() {
        // get NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
         
            searchHistoryTV?.searchVC?.searchHistoryList = []
            searchHistoryTV?.reloadData()
        } catch {
            print ("delete all 'SearchHistory' error")
        }
    }
}

// MARK: - Search TableViewCell

class SearchHistoryTVCell : UITableViewCell {
    
    static let identifier = Identify.SearchHistoryTVCell
    
    // MARK: - UI components
    
    let keywordHistoryLabel = UILabel()
    let deleteButton = UIButton()
    let seperatorView = UIView()
    
    // MARK: - Variables and Properties
    
    var indexPath: Int = 0
    var searchHistoryTV: SearchHistoryTV?
    
    var recodeObject: NSManagedObject?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initCell()
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        indexPath = 0
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
        
        _ = seperatorView.then {
            $0.backgroundColor = UIColor(red: 199 / 255.0, green: 199 / 255.0, blue: 199 / 255.0 , alpha: 1.0)
        }
    }
    
    func addContentView() {
        contentView.addSubview(keywordHistoryLabel)
        contentView.addSubview(deleteButton)
        
        contentView.addSubview(seperatorView)
        
        
        keywordHistoryLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(5+20)
            $0.right.equalTo(deleteButton.snp.left).inset(-5)
            $0.centerY.equalTo(contentView)
        }
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(deleteButton.snp.width)
            
            $0.right.equalTo(contentView.snp.right).inset(5+20)
            $0.centerY.equalTo(contentView)
        }
        
        seperatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.right.equalTo(contentView.snp.right).inset(20)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    @objc func didTapDeleteButton() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        do {
            let toRemoveObject = (searchHistoryTV?.searchVC?.searchHistoryObjectList[indexPath])!
            managedObjectContext.delete(toRemoveObject)
            try managedObjectContext.save()
            
            searchHistoryTV?.searchVC?.getSearchHistory(completion: {
                searchHistoryTV?.reloadData()
            })
            
        } catch {
            print("delete \(keywordHistoryLabel.text ?? "") failed")
            print(error.localizedDescription)
        }
        
    }
    
}
