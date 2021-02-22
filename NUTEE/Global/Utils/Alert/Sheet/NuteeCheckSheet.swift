//
//  NuteeCheckSheet.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/02/18.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit
import SnapKit

class NuteeCheckSheet: NuteeSelectSheet {
    
    // MARK: - UI components
    
    let completeButton = HighlightedButton()
    
    // MARK: - Variables and Properties
    
    var itemList = [""]
    var itemCheckList = [false]
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
    // MARK: - Helper
    
    override func initView() {
        super.initView()
        
        _ = completeButton.then {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
            
            $0.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        }
        
        _ = optionTableView.then {
            $0.register(CheckOptionListTVCell.self, forCellReuseIdentifier: Identify.CheckOptionListTVCell)
        }
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        // Add SubViews
        cardView.addSubview(completeButton)
        
        completeButton.snp.makeConstraints{
            $0.width.equalTo(70)
            $0.height.equalTo(titleLabel.snp.height)
            
            $0.centerY.equalTo(titleLabel)
            $0.right.equalTo(titleLabel.snp.right)
        }
    }
    
    override func setCardViewHeight() {
        handleArea = 0
        cardViewHeight = safeAreaHeight - handleArea - titleHeight - optionHeight * CGFloat(itemList.count)
    }
    
    @objc func didTapCompleteButton() {
        didTapOutsideCardSheet()
    }
    
}

// MARK: - optionList TableView

extension NuteeCheckSheet {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.CheckOptionListTVCell, for: indexPath) as! CheckOptionListTVCell
        cell.selectionStyle = .none
        
        cell.optionItemLabel.text = itemList[indexPath.row]
//        let isSelected = itemCheckList[indexPath.row]
        cell.selectedOptionImageView.isHidden = !itemCheckList[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CheckOptionListTVCell
        
        let isHidden = cell.selectedOptionImageView.isHidden
        cell.selectedOptionImageView.isHidden = !isHidden
        
        nuteeAlertActionDelegate?.nuteeAlertSheetAction(indexPath: indexPath.row)
    }

}

// MARK: - Setting TableViewCell

class CheckOptionListTVCell: SelectOptionListTVCell {

    // MARK: - UI components
    
    let selectedOptionImageView = UIImageView()

    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Helper
    
    override func initCell() {
        super.initCell()
        
        _ = selectedOptionImageView.then {
            let configuration = UIImage.SymbolConfiguration(weight: .bold)
            $0.image = UIImage(systemName: "checkmark", withConfiguration: configuration)
            $0.tintColor = .gray
        }
    }

    override func addContentView() {
        super.addContentView()
        
        contentView.addSubview(selectedOptionImageView)
        
        selectedOptionImageView.snp.makeConstraints {
            $0.width.equalTo(selectedOptionImageView.snp.height)
            $0.height.equalTo(20)

            $0.centerY.equalTo(optionItemLabel)
            
            $0.right.equalTo(optionItemLabel.snp.right)
        }
    }
    
}
