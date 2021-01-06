//
//  ScholarshipFeedCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/06.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class ScholarshipFeedCVCell: NoticeFeedContainerCVCell {

    override func fetchNoticeFeed() {
        let url = APIConstants.NoticeScholarship
        
        getNoticeService(url: url, completionHandler: { ()-> Void in
            self.noticeFeedTableView.reloadData()
        })
    }
    
}
