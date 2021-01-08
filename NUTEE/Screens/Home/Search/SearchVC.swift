//
//  SearchVC.swift
//  NUTEE
//
//  Created by Junhyeon on 2020/07/21.
//  Copyright © 2020 Nutee. All rights reserved.
//

import UIKit
import CoreData

class SearchVC: UIViewController {
    
    // MARK: - UI components
    
    let searchTextField = UITextField()
    let searchButton = UIButton()
    
    let searchHistoryTableView = SearchHistoryTV()
    
    // MARK: - Variables and Properties
    
    var searchHistoryObject: [NSManagedObject] = []
    var seearchHistoryList: [String] = []
    
    // MARK: - Dummy data
     
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchVC()
        setSearchBar()
        
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getSearchHistory(completion: {
            searchHistoryTableView.searchTableView.reloadData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _ = searchTextField.then {
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: searchButton.frame.size.width, height: 0))
            $0.rightViewMode = .always
        }
    }
    
    // MARK: - Helper
    
    func initSearchVC() {
        self.navigationItem.title = "검색"
        view.backgroundColor = .white
    }
    
    func setSearchBar(){
        _ = searchTextField.then {
            $0.delegate = self
            
            $0.font = .systemFont(ofSize: 12)
            $0.placeholder = "검색어를 입력해주세요"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
        }
        
        _ = searchButton.then {
            $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            $0.tintColor = .nuteeGreen
            
            $0.isHidden = true
            
            $0.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        }
        
        _ = searchHistoryTableView.then {
            $0.searchVC = self
        }
    }
    
    func makeConstraints() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        
        view.addSubview(searchHistoryTableView.searchTableView)
        
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(30)
            
            $0.top.equalTo(view.snp.top).offset(10)
            $0.left.equalTo(view.snp.left).offset(15)
            $0.right.equalTo(view.snp.right).inset(15)
        }
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.right.equalTo(searchTextField.snp.right)
        }
        
        searchHistoryTableView.searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.left.equalTo(searchTextField.snp.left)
            $0.right.equalTo(searchTextField.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    @objc func didTapSearchButton(keyword: String) {
        let searchResultVC = SearchResultVC()
        
        searchResultVC.navigationItem.title = keyword
        saveSearchKeyword(toSaveKeyword: keyword)
        
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
    
    func getSearchHistory(completion: () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "keyword")
        do {
            let searchHistory = try managedObjectContext.fetch(SearchHistory.fetchRequest()) as! [SearchHistory]
            searchHistory.forEach {
                seearchHistoryList.append($0.keyword ?? "")
            }
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveSearchKeyword(toSaveKeyword: String) {
        // 1. Get NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        // 2. Get Entity by NSManagedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "SearchHistory", in: managedObjectContext) else {
            return
        }

        // 3. Create NSManagedObject
        let managedObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)

        // 4. Set the Search Keyword
        managedObject.setValue(toSaveKeyword, forKeyPath: "keyword")
        
        // 5. Save NSManagedObjectContext which modified
        do {
          try managedObjectContext.save()
          searchHistoryObject.append(managedObject) // 가져온 검색기록에 생성된 새로운 기록 바로 반영하기
        } catch {
            print("could not save search keyword")
            print(error.localizedDescription)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}

// MARK: - TextField Delegate

extension SearchVC : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // 입력된 빈칸 감지하기
        var str = textField.text
        str = str?.replacingOccurrences(of: " ", with: "")
        
        if str?.count == 0 {
            searchButton.isHidden = true
        } else {
            searchButton.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 입력된 빈칸 감지하기
        var str = textField.text ?? ""
        str = str.replacingOccurrences(of: " ", with: "")
        
        if str.count != 0 {
            didTapSearchButton(keyword: str)
        }
        return true
    }
    
}
