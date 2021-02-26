//
//  NuteeSelectSheet.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/02/18.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import SnapKit

class NuteeSelectSheet: NuteeAlertSheet {
    
    // MARK: - UI components
    
    let titleLabel = UILabel()
    
    // MARK: - Variables and Properties
    
    var titleContent = ""
    var titleHeight: CGFloat = 50
    
    var itemList = [""]
    
    var selectMode: SelectMode = .none
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removePanGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkNumberOfOptionList(targetCount: itemList.count)
    }
    
    // MARK: - Helper
    
    override func initView() {
        super.initView()
        
        _ = handleView.then {
            $0.isHidden = true
        }
        
        _ = titleLabel.then {
            $0.text = titleContent
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 18)
            
            $0.textAlignment = .center
            
            $0.backgroundColor = .white
        }
        
        _ = optionTableView.then {
            $0.register(SelectOptionListTVCell.self, forCellReuseIdentifier: Identify.SelectOptionListTVCell)
        }
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        // Add SubViews
        cardView.addSubview(titleLabel)
        
        // Make Constraints
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(titleHeight)
            
            $0.top.equalTo(cardView.snp.top)
            $0.left.equalTo(cardView.snp.left)
            $0.right.equalTo(cardView.snp.right)
        }
        
        // update optionTableView top constraints
        optionTableView.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.equalTo(cardView.snp.left)
            $0.right.equalTo(cardView.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func setCardViewHeight() {
        handleArea = 0
        cardViewHeight = safeAreaHeight - handleArea - titleHeight - optionHeight * CGFloat(itemList.count)
    }
    
    func removePanGestureRecognizer() {
        view.removeGestureRecognizer(viewPan)
    }
    
}

// MARK: - optionList TableView

extension NuteeSelectSheet {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.SelectOptionListTVCell, for: indexPath) as! SelectOptionListTVCell
        cell.selectionStyle = .none
        
        cell.optionItemLabel.text = itemList[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nuteeAlertActionDelegate?.nuteeSelectSheetAction(selectedOptionItem: itemList[indexPath.row], sheetMode: selectMode)
        
        didTapOutsideCardSheet()
    }

}

// MARK: - Setting TableViewCell

class SelectOptionListTVCell: OptionListTVCell {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Helper

    override func initCell() {
        super.initCell()
        
        _ = optionItemLabel.then {
            $0.textAlignment = .left
            $0.textColor = .gray
        }
    }

    override func addContentView() {
        super.addContentView()
        
        optionItemLabel.snp.remakeConstraints {
            $0.centerY.equalTo(contentView)
            
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.right.equalTo(contentView.snp.right).inset(20)
        }
    }

}
