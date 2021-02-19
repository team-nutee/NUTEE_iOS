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
    
    @objc func didTapCompleteButton() {
        switch optionList[0][2] as? String {
        case "selectCategory":
            didTapSelectCategoryCompleteButton()
        default:
            didTapOutsideCardSheet()
        }
    }
    
    @objc func didTapSelectCategoryCompleteButton() {
        for selectedOption in optionList {
            if selectedOption[3] as? Bool == false {
                selectedOptionList.append(selectedOption[0] as! String)
            }
        }
        signUpCategoryVC?.selectedCategoryList = selectedOptionList
        
        signUpCategoryVC?.updateSelectedCategoryStatus()
        signUpCategoryVC?.selectCategoryButton.titleLabel?.alpha = 0.5
        UIView.animate(withDuration: signUpCategoryVC?.animationDuration ?? 1.4,
                       delay: 0.2,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1,
                       options: [.curveEaseIn],
                       animations: {
                        self.signUpCategoryVC?.selectCategoryButton.titleLabel?.alpha = 1
        })
        
        didTapOutsideCardSheet()
    }
}

// MARK: - optionList TableView

extension NuteeCheckSheet {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identify.CheckOptionListTVCell, for: indexPath) as! CheckOptionListTVCell
        cell.selectionStyle = .none
        
        cell.optionItemLabel.text = optionList[indexPath.row][0] as? String
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch optionList[indexPath.row][2] as? String {
        case "selectCategory":
            let cell = tableView.cellForRow(at: indexPath) as! CheckOptionListTVCell
            
            let isHidden = cell.selectedOptionImageView.isHidden
            cell.selectedOptionImageView.isHidden = !isHidden
            optionList[indexPath.row][3] = !isHidden
            
        default:
            simpleNuteeAlertDialogue(title: "Error😵", message: "Error ocurred: cannot find")
        }
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

            $0.isHidden = true
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
