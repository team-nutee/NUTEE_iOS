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
    
    // MARK: - Dummy data
     
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchVC()
        setSearchBar()
        
        addSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        searchTextField.becomeFirstResponder()
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
            
//            $0.becomeFirstResponder()
        }
        
        _ = searchButton.then {
            $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            $0.tintColor = .nuteeGreen
            
            $0.isHidden = true
            
            $0.addTarget(self, action: #selector(search), for: .touchUpInside)
        }
    }
    
    func addSubView() {
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
            $0.bottom.equalTo(view.snp.bottom)
        }
        
    }
    
    @objc func search() {
        let searchResultVC = SearchResultVC()
        searchResultVC.navigationItem.title = searchTextField.text

        self.navigationController?.pushViewController(searchResultVC, animated: true)
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
        var str = textField.text
        str = str?.replacingOccurrences(of: " ", with: "")
        
        if str?.count != 0 {
            search()
        }
        return true
    }
    
}
