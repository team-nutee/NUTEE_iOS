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
    
    let searchTableView = UITableView(frame: CGRect(), style: .grouped)
    
    // MARK: - Variables and Properties
    
    var recodeMemory : [String] = []
    var recodeObject: [NSManagedObject] = []
    let con = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchText: String = ""
    
    var searchVC: SearchVC?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
//        let context = self.getRecode()
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recode")
//
//        let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        do {
//            recodeObject = try context.fetch(fetchRequest)
//        } catch let error as NSError {
//            print(error)
//        }
//
//        for i in 0..<recodeObject.count {
//            recodeMemory.append(recodeObject[i].value(forKey: "recode") as! String)
//        }
        
        initTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Helper
    
    func initTableView() {
        _ = searchTableView.then {
            $0.delegate = self
            $0.dataSource = self
            
            $0.register(SearchHistoryTVHeaderView.self, forHeaderFooterViewReuseIdentifier: "SearchHistoryTVHeaderView")
            $0.register(SearchHistoryTVCell.self, forCellReuseIdentifier: "SearchHistoryTVCell")
            $0.tableFooterView = nil
            
            $0.backgroundColor = .white
            $0.separatorInset.left = 0
            $0.separatorStyle = .singleLine
            
            $0.keyboardDismissMode = .onDrag
        }
        
    }
    
    func getRecode() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func save(_ inputRecode: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Recode", in: managedContext)!
        
        let recode = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        recode.setValue(inputRecode, forKeyPath: "recode")
        recode.setValue(Date(), forKey: "time")
        
        // 4
        do {
            try managedContext.save()
            recodeObject.append(recode)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc func search() {
        let searchResultVC = SearchResultVC()
        
        let text = searchVC?.searchTextField.text ?? ""
        save(text)
        searchResultVC.searchResult = text
        
        recodeMemory.insert(text, at: 0)
        searchTableView.reloadData()
        
        searchVC?.searchTextField.text = ""
        
        searchVC?.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    @objc func searchInList() {
        let searchResultVC = SearchResultVC()
        let text: String = searchText
        
        searchResultVC.searchResult = text
        searchVC?.navigationController?.pushViewController(searchResultVC, animated: true)
    }
}


// MARK: - TableView Delegate

extension SearchHistoryTV : UITableViewDelegate { }
extension SearchHistoryTV : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchHistoryTVHeaderView") as? SearchHistoryTVHeaderView
        
        headerView?.searchTV = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let postItems = 10//recodeMemory.count
        
        if postItems == 0 {
            searchTableView.setEmptyView(tabBarHeight: 0, title: "", message: "검색 기록이 없습니다.")
        } else {
            searchTableView.restore()
        }
        
        return postItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTVCell", for: indexPath) as! SearchHistoryTVCell
//        let recoding = recodeMemory[indexPath.row]
        
        cell.selectionStyle = .none
//        cell.keywordHistoryLabel.text = recoding
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTVCell", for: indexPath) as! SearchHistoryTVCell
        
        searchText = recodeMemory[indexPath.row]
        self.searchInList()
        self.searchTableView.reloadData()
    }
    
}

// MARK: - Search TableViewHeaderView

class SearchHistoryTVHeaderView : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    let previousSearchlabel = UIButton()
    let deleteAllButton = UIButton()
    
    // MARK: - Variables and Properties
    
    var searchTV: SearchHistoryTV?
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initHeaderView()
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        searchTV?.recodeMemory = []
        
        searchTV?.searchTableView.reloadData()
    }
}

// MARK: - Search TableViewCell

class SearchHistoryTVCell : UITableViewCell {
    
    // MARK: - UI components
    
    let keywordHistoryLabel = UILabel()
    let deleteButton = UIButton()
    let underBarView = UIView()
    
    // MARK: - Variables and Properties
    
    var recode: String?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initCell()
        addContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Helper
    
    func initCell() {
        _ = keywordHistoryLabel.then {
            $0.text = "누티"
            $0.font = .systemFont(ofSize: 15)
        }
        
        _ = deleteButton.then {
            $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            $0.tintColor = .lightGray
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
