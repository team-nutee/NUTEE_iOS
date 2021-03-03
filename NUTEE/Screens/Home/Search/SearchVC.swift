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
    
    let activityIndicator = UIActivityIndicatorView()
    
    let searchTextField = UITextField()
    let deleteAllTextButton = UIButton()
    let searchButton = UIButton()
    
//    let searchHistoryTableView = SearchHistoryTV()
    
    let categoryView = UIView()
    let categoryLabel = UILabel()
    let categoryCollectionView = CategoryCV()
    
    // MARK: - Variables and Properties
    
    var searchHistoryObjectList: [NSManagedObject] = []
    var searchHistoryList: [String] = []
    
    // MARK: - Dummy data
     
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchVC()
        initView()
        
        makeConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        hideTabBarController(isHidden: true)
        
//        getSearchHistory(completion: {
//            searchHistoryTableView.reloadData()
//        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        hideTabBarController(isHidden: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _ = searchTextField.then {
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: searchButton.frame.size.width + deleteAllTextButton.frame.size.width - 10, height: 0))
            $0.rightViewMode = .always
        }
    }
    
    func hideTabBarController(isHidden: Bool) {
        tabBarController?.tabBar.isHidden = isHidden
        
        let tabBarController = self.tabBarController as? TabBarController
        tabBarController?.toPostButton.isHidden = isHidden
    }
    
    // MARK: - Helper
    
    func initSearchVC() {
        self.navigationItem.title = "검색"
        view.backgroundColor = .white
    }
    
    func initView(){
        _ = activityIndicator.then {
            $0.style = .medium
            $0.startAnimating()
        }
        
        _ = searchTextField.then {
            $0.delegate = self
            
            $0.font = .systemFont(ofSize: 15)
            $0.placeholder = "검색어를 입력해주세요"
            $0.addBorder(.bottom, color: .nuteeGreen, thickness: 1)
            $0.tintColor = .nuteeGreen
            
            $0.becomeFirstResponder()
            
            $0.alpha = 0
        }
        _ = deleteAllTextButton.then {
            $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            $0.tintColor = .lightGray
            
            $0.isHidden = true
            
            $0.addTarget(self, action: #selector(didTapDeleteAllTextButton), for: .touchUpInside)
        }
        _ = searchButton.then {
            $0.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.setImage(UIImage(named: "search_fill")?.withRenderingMode(.alwaysTemplate), for: .highlighted)
            
            $0.tintColor = .nuteeGreen
            
            $0.isEnabled = false
            $0.alpha = 0.5
            
            $0.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
            
            $0.alpha = 0
        }
        
//        _ = searchHistoryTableView.then {
//            $0.searchVC = self
//        }
        _ = categoryView.then {
            $0.alpha = 0
        }
        
        _ = categoryLabel.then {
            $0.text = "카테고리"
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textColor = .black
        }
    }
    
    func makeConstraints() {
        view.addSubview(activityIndicator)

        view.addSubview(searchTextField)
        view.addSubview(deleteAllTextButton)
        view.addSubview(searchButton)
        
//        view.addSubview(searchHistoryTableView)
        view.addSubview(categoryView)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(categoryCollectionView)

        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            
            $0.top.equalTo(view.snp.top).offset(10)
            $0.left.equalTo(view.snp.left).offset(15)
            $0.right.equalTo(view.snp.right).inset(15)
        }
        deleteAllTextButton.snp.makeConstraints {
            $0.width.equalTo(searchTextField.snp.height)
            
            $0.centerY.equalTo(searchTextField)
            $0.right.equalTo(searchButton.snp.left).inset(5)
        }
        searchButton.snp.makeConstraints {
            $0.width.equalTo(searchTextField.snp.height)
            
            $0.centerY.equalTo(searchTextField)
            $0.right.equalTo(searchTextField.snp.right)
        }
        
//        searchHistoryTableView.snp.makeConstraints {
//            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
//            $0.left.equalTo(view.snp.left)
//            $0.right.equalTo(view.snp.right)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
//        }
        categoryView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.left.equalTo(searchTextField.snp.left)
            $0.right.equalTo(searchTextField.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.top)
            $0.left.equalTo(categoryView.snp.left)
            $0.right.equalTo(categoryView.snp.right)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(10)
            $0.left.equalTo(categoryView.snp.left)
            $0.right.equalTo(categoryView.snp.right)
            $0.bottom.equalTo(categoryView.snp.bottom)
        }
    }
    
    @objc func didTapDeleteAllTextButton() {
        searchTextField.text = ""
        textFieldDidChangeSelection(searchTextField)
    }
    
    @objc func didTapSearchButton() {
        let searchResultVC = SearchResultVC()
        
        // 입력된 빈칸 감지하기
        let str = searchTextField.text ?? ""
        let removedBlankStr = str.replacingOccurrences(of: " ", with: "")
        
        if removedBlankStr.count != 0 {
            searchResultVC.navigationItem.title = str
            searchResultVC.searchResult = str
            saveSearchKeyword(toSaveKeyword: str)
            
            self.navigationController?.pushViewController(searchResultVC, animated: true)
        }
    }
    
    func getSearchHistory(completion: () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SearchHistory")
        // 키워드 검색 시간 순으로 정렬
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            searchHistoryObjectList = try managedObjectContext.fetch(fetchRequest)
            searchHistoryList = []
            for i in 0..<searchHistoryObjectList.count {
                searchHistoryList.append(searchHistoryObjectList[i].value(forKey: "keyword") as! String)
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
        // 같은 키워드 중복 저장 금지 설정
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // 2. Get Entity by NSManagedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "SearchHistory", in: managedObjectContext) else {
            return
        }

        // 3. Create NSManagedObject
        let managedObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        // 최대 저장 개수 제한
        if searchHistoryObjectList.count == 10 {
            if searchHistoryList.contains(toSaveKeyword) == false {
                managedObjectContext.delete(searchHistoryObjectList[9])
            }
        }
        // 4. Set the Search Keyword
        managedObject.setValue(toSaveKeyword, forKeyPath: "keyword")
        managedObject.setValue(Date(), forKey: "time")
        
        // 5. Save NSManagedObjectContext which modified
        do {
          try managedObjectContext.save()
        } catch {
            print("could not save search keyword")
            print(error.localizedDescription)
        }
    }
    
    func afterFetchCategoryView() {
        categoryCollectionView.reloadData()
        
        activityIndicator.stopAnimating()
        
        searchButton.alpha = 1
        searchTextField.alpha = 1
        categoryView.alpha = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}

// MARK: - TextField Delegate

extension SearchVC : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // 입력된 빈칸 감지하기
        var str = textField.text ?? ""
        
        // deleteAllText button
        if str.count > 0 {
            deleteAllTextButton.isHidden = false
        } else {
            deleteAllTextButton.isHidden = true
        }
        
        // search button
        str = str.replacingOccurrences(of: " ", with: "")
        if str.count == 0 {
            searchButton.isEnabled = false
            searchButton.alpha = 0.5
        } else {
            searchButton.isEnabled = true
            searchButton.alpha = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapSearchButton()
        
        return true
    }
    
}

// MARK: - Server connect

extension SearchVC {
    func getCategoriesService(completionHandler: @escaping () -> Void ) {
        ContentService.shared.getCategories() {
            [weak self]
            data in
            
            guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                self.categoryCollectionView.categoryList = res as! [String]
                self.categoryCollectionView.reloadData()
                completionHandler()
                
            case .requestErr(let message):
                self.simpleNuteeAlertDialogue(title: "카테고리 목록 조회 실패", message: "\(message)")
                
            case .pathErr:
                self.simpleNuteeAlertDialogue(title: "카테고리 목록 조회 실패", message: "서버 연결에 오류가 있습니다")
                
            case .serverErr:
                self.simpleNuteeAlertDialogue(title: "카테고리 목록 조회 실패", message: "서버에 오류가 있습니다")

            case .networkFail:
                self.simpleNuteeAlertDialogue(title: "카테고리 목록 조회 실패", message: "네트워크에 오류가 있습니다")
            }
        }
    }
}
