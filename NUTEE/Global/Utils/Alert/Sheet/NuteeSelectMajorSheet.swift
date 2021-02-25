//
//  NuteeMajorSelectSheet.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/02/25.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

enum SelectMajor {
    case first
    case second
}

class NuteeSelectMajorSheet: NuteeSelectSheet {
    
    // MARK: - UI components
    // MARK: - Variables and Properties

    var majorVC: SignUpMajorVC?
    var selectMajorMode: SelectMajor?
    
    // MARK: - Dummy data
    // MARK: - Life Cycle
}

// MARK: - optionList TableView

extension NuteeSelectMajorSheet {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        switch selectMajorMode {
        case .first:
            majorVC?.firstMajor = optionList[indexPath.row][0] as? String ?? ""
            majorVC?.updateFirstMajorButtonStatus()
        case .second:
            majorVC?.secondMajor = optionList[indexPath.row][0] as? String ?? ""
            majorVC?.updateSecondMajorButtonStatus()
        default:
            break
        }
    }
    
}
