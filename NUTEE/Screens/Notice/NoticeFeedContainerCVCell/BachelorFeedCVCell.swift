//
//  BachelorFeedCVCell.swift
//  NUTEE
//
//  Created by Hee Jae Kim on 2021/01/06.
//  Copyright © 2021 Nutee. All rights reserved.
//

import UIKit

class BachelorFeedCVCell: NoticeFeedContainerCVCell {
    
    override func fetchNoticeFeed() {
        let url = APIConstants.NoticeBachelor
        
        getNoticeService(url: url, completionHandler: { ()-> Void in
            self.noticeFeedTableView.reloadData()
        })
    }
    
}
