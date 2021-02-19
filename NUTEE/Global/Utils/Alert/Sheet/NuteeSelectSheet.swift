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
    
    // MARK: - Dummy data
    
    // MARK: - Life Cycle
    
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
        super.setCardViewHeight()
        cardViewHeight -= titleHeight
    }
    
}

// MARK: - optionList TableView

extension NuteeSelectSheet {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.SelectOptionListTVCell, for: indexPath) as! SelectOptionListTVCell
        cell.selectionStyle = .none
        
        cell.optionItemLabel.text = optionList[indexPath.row][0] as? String

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch optionList[indexPath.row][2] as? String {
        case "selectFirstMajor":
            majorVC?.firstMajor = optionList[indexPath.row][0] as? String ?? ""
            majorVC?.updateFirstMajorButtonStatus()
            didTapOutsideCardSheet()
        case "selectSecondMajor":
            majorVC?.secondMajor = optionList[indexPath.row][0] as? String ?? ""
            majorVC?.updateSecondMajorButtonStatus()
            didTapOutsideCardSheet()
            
            
            
        case "selectPostCategory":
            postVC?.selectedCategory = optionList[indexPath.row][0] as? String ?? ""
            postVC?.updatePostCategoryButtonStatus()
            didTapOutsideCardSheet()
        case "selectPostMajor":
            postVC?.selectedMajor = optionList[indexPath.row][0] as? String ?? ""
            postVC?.updatePostMajorButtonStatus()
            didTapOutsideCardSheet()
            
            
            
        default:
            simpleNuteeAlertDialogue(title: "Error😵", message: "Error ocurred: cannot find")
        }
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
